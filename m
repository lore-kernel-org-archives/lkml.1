Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYBQXDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYBQXDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYBQXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:03:26 -0500
Received: from www.tglx.de ([62.245.132.106]:44145 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYBQXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:03:25 -0500
Date: Mon, 18 Feb 2008 00:03:12 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080218000312.0b38efd5@dilbert.local>
In-Reply-To: <47B8B0A3.2070005@rtr.ca>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
	<20080217015453.2a4e4142@dilbert.local>
	<20080216182939.061c7246@laptopd505.fenrus.org>
	<20080217133753.661cd98d@bluebox.local>
	<20080217072927.4b6c5964@laptopd505.fenrus.org>
	<20080217174728.76e4231a@bluebox.local>
	<47B8AFAA.30101@rtr.ca>
	<47B8B0A3.2070005@rtr.ca>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 17 Feb 2008 17:09:39 -0500
schrieb Mark Lord <lkml@rtr.ca>:

> Mark Lord wrote:
> > Hans J. Koch wrote:
> ..
> >> Really? Unbelievable what these guys do to make my live harder...
> >> So, they might use some undocumented GPIO to turn the power on, and
> ...
> 
> GPIO lines are not usually very difficult to trace,
> and programming them is pretty easy, too ...

I know :-) I'll do that as soon as I've got some spare time (very rare
ATM).

> 
> If I had an EeePC here, I'd do that for you (and everyone else),
> but I'm waiting for a lower-power (fanless) unit to be introduced
> first.

Admirable. I didn't have that patience ;-)

> 
> >> refuse that if they don't find the original card? Looks like I
> >> can't have WLAN on an EeePC (I won't run a tainted kernel). Stupid
> >> thing to sell a PC with Linux preinstalled but with hardware not
> >> supported in mainline.
> > ..
> > 
> > Try it again with 2.6.25-rc2 and this module option:
> > 
> >    options pciehp pciehp_force=1
> > 
> > Just a thin hope, really, but it might work.

I'll give it a try.

Thanks for your hints,
Hans
