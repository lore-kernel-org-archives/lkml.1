Return-Path: <linux-kernel-owner+w=401wt.eu-S936109AbXJTCoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936109AbXJTCoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXJTCoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:44:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54479 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXJTCoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:44:15 -0400
Date: Fri, 19 Oct 2007 22:44:01 -0400
Message-Id: <200710200244.l9K2i1ik016752@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NFS client fixes for 2.6.23++ 
In-reply-to: Your message of "Fri, 19 Oct 2007 19:32:13 PDT."
             <alpine.LFD.0.999.0710191929340.3794@woody.linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <alpine.LFD.0.999.0710191929340.3794@woody.linux-foundation.org>, Linus Torvalds writes:
> 
> 
> On Fri, 19 Oct 2007, Erez Zadok wrote:
> > 
> > Trond, with Linus's latest tree, you need to #include <linux/sched.h> in
> > fs/nfs/unlink.c, else I get:
> > 
> >   CC [M]  fs/nfs/unlink.o
> > fs/nfs/unlink.c: In function 'nfs_dec_sillycount':
> > fs/nfs/unlink.c:67: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
> ...
> 
> Hmm? Which architecture?

i386

Erez.
