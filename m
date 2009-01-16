Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZAPHmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZAPHmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZAPHmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:42:42 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:40728 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZAPHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:42:41 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] ecryptfs: some inode attrs, and a question 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mhalcrow@us.ibm.com, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <20090115150332.f72ad0f8.akpm@linux-foundation.org>
References: <7471.1231827621@jrobl> <20090115150332.f72ad0f8.akpm@linux-foundation.org>
Date: Fri, 16 Jan 2009 16:42:31 +0900
Message-ID: <9845.1232091751@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton:
> > +	atomic_inc_return(&lower_dentry->d_inode->i_count);
> > +	atomic_inc_return(&lower_inode->i_count);
> 
> atomic_inc() would suffice here, yes?

I thought that ..._return() is smp safe and necessary here.
Because lower_inode may be touched by lower fs (outside of ecryptfs).

Anyway my original patch seemed to be already dropped.


J. R. Okajima
