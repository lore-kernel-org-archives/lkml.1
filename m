Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZDQSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZDQSUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZDQSUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:20:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51544 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZDQSUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:20:24 -0400
In-Reply-To: <11555.1239976666@jrobl>
References: <15909.1239887985@jrobl> <OF1283DDC6.0AD2926E-ON8525759B.004938DD-8525759B.004A1887@us.ibm.com> <11555.1239976666@jrobl>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com,
       david safford <safford@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: IMA and fs
X-KeepSent: AE6426B8:ECBED7A5-8525759B:00640328;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFAE6426B8.ECBED7A5-ON8525759B.00640328-8525759B.0064BD10@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 17 Apr 2009 14:20:20 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 04/17/2009 14:20:20,
	Serialize complete at 04/17/2009 14:20:20
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote on 04/17/2009 09:57:46 AM:

> Mimi Zohar:
> > > xfs_iget() holds spinlock before xfs_iget_cache_hit(), and
> > > ima_inode_alloc() cannot use GFP_KERNEL.
> > 
> > This looks similar to the xfs - IMA problem discussed
> > http://lkml.org/lkml/2009/2/20/327.
> 
> Yes, the same issue.
> I didn't know it was discussed before.
> So what is the conclusion? Are you waiting for fixing the spinlock in
> xfs?

Yes. I just assumed, incorrectly, the xfs maintainer was notified.
Am copying the xfs maintainer now.

> > > Does nfsd_open() need to to call ima_path_check()?
>    :::
> > Yes, in order for the open/free to be balanced in ima_file_free().
> 
> Then how about putting ima_path_check() into __dentry_open() instead of
> may_open()?
> 
> 
> J. R. Okajima

Interesting.  Am looking into it.

Thanks!

Mimi Zohar
