Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXFURE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXFURE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbXFUREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:04:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbXFUREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:04:48 -0400
Message-ID: <4683EA26.6030306@anagramm.de>
Date: Thu, 28 Jun 2007 19:04:38 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Robert Hancock <hancockr@shaw.ca>, pharon@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no> <467A89D4.6080607@shaw.ca> <4683D4A0.3000100@anagramm.de> <20070621162654.GA10008@csclub.uwaterloo.ca>
In-Reply-To: <20070621162654.GA10008@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19gKYhucN723ZeaU9dlMn0Wm09iM/hezQ5Dy7f
 A1Yf0FdqKxWoYQIaqe65LF4eH+v4xpCR6JXfccqy1RFgbDwN4Q
 j+g/KxyO/khnSAAb4XPKw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lennart!

Lennart Sorensen schrieb:
> On Thu, Jun 28, 2007 at 05:32:48PM +0200, Clemens Koller wrote:
>> Robert Hancock schrieb:
>>> Islam Amer wrote:
>>>> I am trying to build a settop box with two cards, a PVR-150 and a DVB
>>>> card. The mini-ITX motherboard has only one PCI slot, so I bought an
>>>> active PCI riser.
>> Please define "active". Is there a PCI bridge chip on the riser card?
>> Or better: Tell us manufacturer and type of this PCI riser card and the
>> mini-ITX board.
> 
> Certainly many riser cards only have jumpers to change the irq for the
> second slot, or some default built in remapping.  And they may have id
> select pins to pick which slots they should pretend to be.  From what I
> have read, via mini itx boards require a very specific design for riser
> boards, which isn't what most riser boards do.  Other mini itx boards
> are probably different.

The main problem is the unknown BIOS support for the PCI configuration.
Maybe the manufacturer is at least willing to publish the default
configuration, so the PCI riser can be modified/fixed to the same
config. (Just call him and ask for the board designer... YMMV)

However, AFAIK this (re-)configuration can be done by the kernel, too.
(on embedded ppc platforms, the PCI mapping is done in the kernel)

At least from the electrical engineer's point of view it's not
difficult to modify a dumb passive PCI riser card to have the IRQ's and
REQ/GNTs routed and have the IDSEL soldered with 220 Ohms to the
proper AD line pin. (been there, done that)
(If somebody want's to mess around with that stuff, contact
me off list, it's getting OT here.)

> Certainly the simplest is a riser card with a proper pci bridge that
> creates a secondary pci bus with it's own device ids and maps the
> interrupts correctly.  Then all that really matters is that the bios on
> the board supports pci bridges (a few companies actually manage to fail
> to support pci bridges at all in their bioses).

True. It might be more easy to get that running, hoping that
the BIOS enumerates the bridge right.
Kernel support shouldn't be an issue here as long as the
chip is supported.

Best greets,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
