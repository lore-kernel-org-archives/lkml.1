Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbXJ3Rny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbXJ3Rny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXJ3Rnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:43:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38542 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXJ3Rno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:43:44 -0400
Date: Tue, 30 Oct 2007 13:43:23 -0400
Message-Id: <200710301743.l9UHhNdQ032336@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names 
In-reply-to: Your message of "Tue, 30 Oct 2007 17:14:36 -0000."
             <20071030171436.GA15922@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071030171436.GA15922@infradead.org>, Christoph Hellwig writes:
> On Tue, Oct 30, 2007 at 08:22:40AM -0700, Randy Dunlap wrote:
> > They are just treated as part of the parameter explanation text.
> > I don't see any problem with them.
> 
> Well, it's completely inconsistant with any other kerneldoc..

If it doesn't hurt, and kerneldoc will present it as such, then I'd leave
the [in/out] in place.  Ioctls are the few places where you can have
variables used as both input and output; so _somehow_ we need to capture
that behavior.

Erez.
