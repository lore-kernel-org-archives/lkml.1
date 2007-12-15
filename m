Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbXLOWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbXLOWRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbXLOWRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:17:32 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:51622 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXLOWRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:17:32 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New question on that sata controller
Date: Sat, 15 Dec 2007 22:17:28 +0000
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fa.JX5deKXb3TDJ1pV6ig+xHviNfRI@ifi.uio.no> <47643FF6.7030701@shaw.ca> <200712151624.09115.gene.heskett@gmail.com>
In-Reply-To: <200712151624.09115.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712152217.28865.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 December 2007 21:24:09 Gene Heskett wrote:
> On Saturday 15 December 2007, Robert Hancock wrote:
> >Gene Heskett wrote:
> >> Greetings;
> >>
> >> When I asked about a sata controller earlier this week, I gave a link to
> >> it. Unforch (maybe) when it actually arrived, the cards box showed a
> >> silicon image chip, and the card had a via.  So much for getting what I
> >> ordered...
> >>
> >> The required module then was sata_via, not sata_uli, and it seems to be
> >> working ok.  However, this one claims its a raid controller according to
> >> an lspci -v:
> >>
> >> 01:0a.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID
> >> Controller (rev 50)
> >>         Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
> >>         Flags: bus master, medium devsel, latency 32, IRQ 19
> >>         I/O ports at 9400 [size=16]
> >>         I/O ports at 9800 [size=16]
> >>         I/O ports at 9c00 [size=16]
> >>         I/O ports at a000 [size=16]
> >>         I/O ports at a400 [size=32]
> >>         I/O ports at a800 [size=256]
> >>         [virtual] Expansion ROM at e9000000 [disabled] [size=64K]
> >>         Capabilities: [e0] Power Management version 2
> >>
> >> I just noted that the Expansion ROM is disabled, but I didn't see any
> >> jumpers to enable it on the card prior to installing it.  Does anyone
> >> know how this is supposed to work?  I would like to make it directly
> >> bootable but I believe this has to be 'enabled' for that.
> >
> >It's usually normal for it to be disabled after boot, I believe. Are you
> >getting anything showing up on boot indicating its BIOS is active?
>
> No, not a thing.  Also invisible in the mainboards bios config AFAICT.

Normally this option is called "Enable Option ROM" or enable "INT 13/19h 
hook". See if you have such an option. It's surprising this isn't enabled by 
default.

However, the BIOS still might not support directly booting off the controller, 
I'm afraid.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
