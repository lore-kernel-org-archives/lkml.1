Return-Path: <linux-kernel-owner+w=401wt.eu-S936034AbXJSUlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936034AbXJSUlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934783AbXJSUky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:40:54 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33785 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765293AbXJSUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:40:53 -0400
Date: Fri, 19 Oct 2007 16:37:28 -0400
Message-Id: <200710192037.l9JKbSsh018946@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [BLOCK2MTD] WARNING: at kernel/lockdep.c:2331 lockdep_init_map() 
In-reply-to: Your message of "Fri, 19 Oct 2007 21:14:33 +0200."
             <20071019191433.GK26913@lazybastard.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071019191433.GK26913@lazybastard.org>, =?utf-8?B?SsO2cm4=?= Engel writes:
> On Fri, 19 October 2007 13:53:40 -0400, Erez Zadok wrote:
> >
> > I've been having this problem for some time with mtd, which I use to mount
> > jffs2 images (for unionfs testing).  I've seen it in several recent major
> > kernels, including 2.6.24.  Here's the sequence of ops I perform:
> 
> Since when roughly?  2.6.20ish?  Before?

I was able to verify that the same lockdep warning comes up in every major
kernel all the way back to 2.6.18.  Of course the line number in lockdep.c
that causes the warning is slightly different from kernel to kernel, but the
stack trace is the same.

Hope this helps.

Erez.
