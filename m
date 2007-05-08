Return-Path: <linux-kernel-owner+w=401wt.eu-S934632AbXEHI1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbXEHI1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEHI1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:27:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40435 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXEHI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:27:47 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 8 May 2007 04:27:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <1178612519.3042.294.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705080421540.13343@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <1178612519.3042.294.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_GL 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Thomas Gleixner wrote:

> On Tue, 2007-05-08 at 04:06 -0400, Robert P. J. Day wrote:
> >   i've always hated that lower-level menu under "General setup":
>
> Good reason to break everything which depends on CONFIG_EMBEDDED.
>
> 	tglx
>
> > -menuconfig EMBEDDED
> > -	bool "Configure standard kernel features (for small systems)"

  i don't know what you're getting at here.  are you saying this is a
bad idea because it will make a mess of the current usage of
CONFIG_EMBEDDED in the source tree?

$ grep -rw CONFIG_EMBEDDED *
... lots of irrelevant defconfig output deleted ...
drivers/pci/setup-res.c:#ifdef CONFIG_EMBEDDED
include/linux/ide.h:#if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
$

  i don't see a whole lot of impact here.  more to the point, though,
the word "EMBEDDED" in this context is just wrong.  people might have
*other* reasons to de-activate some of those features rather than just
for an embedded system.

  granted, that's probably where it will *mostly* happen, but i prefer
the idea of labelling those selections for what they really are -- for
*saving* *space*, because that's exactly what they represent.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
