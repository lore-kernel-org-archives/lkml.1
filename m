Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYBQMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYBQMiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYBQMiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:38:07 -0500
Received: from www.tglx.de ([62.245.132.106]:37795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444AbYBQMiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:38:05 -0500
Date: Sun, 17 Feb 2008 13:37:53 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080217133753.661cd98d@bluebox.local>
In-Reply-To: <20080216182939.061c7246@laptopd505.fenrus.org>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
	<20080217015453.2a4e4142@dilbert.local>
	<20080216182939.061c7246@laptopd505.fenrus.org>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat, 16 Feb 2008 18:29:39 -0800
schrieb Arjan van de Ven <arjan@infradead.org>:

> On Sun, 17 Feb 2008 01:54:53 +0100
> Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> 
> > Am Sat, 16 Feb 2008 14:39:46 -0800
> > schrieb Arjan van de Ven <arjan@infradead.org>:
> > 
> > > On Sat, 16 Feb 2008 22:59:32 +0100
> > > Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> > > 
> > > > I'm playing around with a vanilla 2.6.25-rc1, adding patches to
> > > > make it work on an Asus EeePC. That one has the problem that its
> > > > Mini PCIe WLAN module doesn't show up in lspci. That brought up
> > > > a few questions that I couldn't answer yet:
> > > > 
> > > > How can they "hide" a PCIe card?
> > > > What could be their motive to do that?
> > > > How can I make it appear?
> > > 
> > > 
> > > go to the bios, enable the wireless card. 
> > > 
> > > that did it for me ;)
> > 
> > It didn't for me. I tried all combinations (booting with/without
> > WLAN enabled, enabling WLAN through /proc with/without pciehp
> > loaded and so on). What kernel did you use, and which patches did
> > you apply?
> > 
> 
> I used a pretty much stock Fedora 8 kernel..

Hm, interesting. My guess was that enabling the card in BIOS simply
switches the power of the WLAN card on. But I really don't understand
why it's not detected then with my vanilla kernel. My naive thought was
that the kernel scans all possible PCI[e] slots a chipset offers and
finds all cards there. Seems to be a bit more subtle...

> no magic patches at all.

Well, they've at least added atl2 support, otherwise you had no
wired LAN either.

> Of course there's no driver for the wlan, but that's a different
> story ;)

I replaced that unsupported Atheros 5007 card with an ipw3945, so I
haven't got that problem.

Thanks,
Hans

