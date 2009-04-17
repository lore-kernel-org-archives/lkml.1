Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZDQN6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZDQN6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZDQN5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:57:51 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:40073 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZDQN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:57:51 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: IMA and fs 
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
In-Reply-To: <OF1283DDC6.0AD2926E-ON8525759B.004938DD-8525759B.004A1887@us.ibm.com>
References: <15909.1239887985@jrobl> <OF1283DDC6.0AD2926E-ON8525759B.004938DD-8525759B.004A1887@us.ibm.com>
Date: Fri, 17 Apr 2009 22:57:46 +0900
Message-ID: <11555.1239976666@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> > xfs_iget() holds spinlock before xfs_iget_cache_hit(), and
> > ima_inode_alloc() cannot use GFP_KERNEL.
> 
> This looks similar to the xfs - IMA problem discussed
> http://lkml.org/lkml/2009/2/20/327.

Yes, the same issue.
I didn't know it was discussed before.
So what is the conclusion? Are you waiting for fixing the spinlock in
xfs?


> > Does nfsd_open() need to to call ima_path_check()?
	:::
> Yes, in order for the open/free to be balanced in ima_file_free().

Then how about putting ima_path_check() into __dentry_open() instead of
may_open()?


J. R. Okajima
