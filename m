Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbXEHIfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbXEHIfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934592AbXEHIfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:35:12 -0400
Received: from www.osadl.org ([213.239.205.134]:38266 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934665AbXEHIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:35:10 -0400
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705080421540.13343@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
	 <1178612519.3042.294.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705080421540.13343@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 08 May 2007 10:37:57 +0200
Message-Id: <1178613477.3042.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 04:27 -0400, Robert P. J. Day wrote:
> On Tue, 8 May 2007, Thomas Gleixner wrote:
> 
> > On Tue, 2007-05-08 at 04:06 -0400, Robert P. J. Day wrote:
> > >   i've always hated that lower-level menu under "General setup":
> >
> > Good reason to break everything which depends on CONFIG_EMBEDDED.
> >
> > 	tglx
> >
> > > -menuconfig EMBEDDED
> > > -	bool "Configure standard kernel features (for small systems)"
> 
>   i don't know what you're getting at here.  are you saying this is a
> bad idea because it will make a mess of the current usage of
> CONFIG_EMBEDDED in the source tree?
> 
> $ grep -rw CONFIG_EMBEDDED *
> ... lots of irrelevant defconfig output deleted ...
> drivers/pci/setup-res.c:#ifdef CONFIG_EMBEDDED
> include/linux/ide.h:#if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
> $

# find -iname Kconfig | xargs grep EMBEDDED

>   i don't see a whole lot of impact here.

But there _IS_ impact. It does not matter whether it is a lot or not.

>   more to the point, though,
> the word "EMBEDDED" in this context is just wrong.  people might have
> *other* reasons to de-activate some of those features rather than just
> for an embedded system.
> 
>   granted, that's probably where it will *mostly* happen, but i prefer
> the idea of labelling those selections for what they really are -- for
> *saving* *space*, because that's exactly what they represent.

I prefer patches, which do not break things all over the place.

	tglx


