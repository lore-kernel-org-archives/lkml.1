Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXJSFu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXJSFu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXJSFuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:50:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33469 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbXJSFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:50:18 -0400
Date: Fri, 19 Oct 2007 01:49:49 -0400
Message-Id: <200710190549.l9J5nnX8007119@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bfields@fieldses.org, nfs@lists.sourceforge.net, neilb@suse.de,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: nfsv2 ref leak in 2.6.24?
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing unionfs on top of nfsv2/3/4, using 2.6.24 as of linus's commit
4fa4d23fa20de67df919030c1216295664866ad7.  A lot of my unionfs regression
tests are failing on nfs2, b/c files that should be deleted, aren't.  It
feels like there may be a ref leak that prevents the files from being
deleted, or maybe an unlink issue.  It doesn't happen in all of my previous
kernels w/ identical unionfs (code 2.6.9--2.6.23).  And in 2.6.24 it happens
only w/ nfs2 -- nfs3/4 are fine.

I'm not sure if this is a client or server issue, and I'm only starting to
dig deeper.  But I thought I'd ask you in case this is a known problem and
you have a fix.  If this is the first you hear of this problem, let me know
and I'll try to narrow it down further.

Thanks,
Erez.
