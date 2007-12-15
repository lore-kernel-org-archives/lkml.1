Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbXLOU7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbXLOU7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 15:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbXLOU6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 15:58:52 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33494 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbXLOU6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 15:58:51 -0500
Date: Sat, 15 Dec 2007 14:58:30 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: New question on that sata controller
In-reply-to: <fa.JX5deKXb3TDJ1pV6ig+xHviNfRI@ifi.uio.no>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47643FF6.7030701@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.JX5deKXb3TDJ1pV6ig+xHviNfRI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> When I asked about a sata controller earlier this week, I gave a link to it.  
> Unforch (maybe) when it actually arrived, the cards box showed a silicon 
> image chip, and the card had a via.  So much for getting what I ordered...
> 
> The required module then was sata_via, not sata_uli, and it seems to be 
> working ok.  However, this one claims its a raid controller according to an 
> lspci -v:
> 
> 01:0a.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID Controller 
> (rev 50)
>         Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
>         Flags: bus master, medium devsel, latency 32, IRQ 19
>         I/O ports at 9400 [size=16]
>         I/O ports at 9800 [size=16]
>         I/O ports at 9c00 [size=16]
>         I/O ports at a000 [size=16]
>         I/O ports at a400 [size=32]
>         I/O ports at a800 [size=256]
>         [virtual] Expansion ROM at e9000000 [disabled] [size=64K]
>         Capabilities: [e0] Power Management version 2
> 
> I just noted that the Expansion ROM is disabled, but I didn't see any jumpers 
> to enable it on the card prior to installing it.  Does anyone know how this 
> is supposed to work?  I would like to make it directly bootable but I believe 
> this has to be 'enabled' for that.

It's usually normal for it to be disabled after boot, I believe. Are you 
getting anything showing up on boot indicating its BIOS is active?

> 
> I cannot find any references to this particular chip in a 'make xconfig' for 
> 2.6.24-rc5.
> 
> Should this be a concern, or is this one a 'Just Works(TM)' chipset?  This 
> card has 3 sata port connectors and one ide fitted.
> 
> Two rather pleasant side effects of going to the Biostar.tw site and finding a 
> newer bios and installing it on an M7NCD Pro mobo are:
> 
> 1: FSB now running at 400MHZ, was 333 before as it was not at all stable at 
> 400 and I have been told the XP-2800 Athlon only supports 333 and AMD's site 
> agrees.
> 
> 2: CPU temps are down around 13F.  CPU speed still the same at 2079MHZ 
> according to dmesg.
> 
> The reduced temps at a higher FSB indicates better interface timing, and if it 
> runs the rest of the night at 400 without a self reboot or crash, I'll leave 
> it there.
> 


-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

