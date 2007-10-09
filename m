Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbXJITiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbXJITiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXJIThz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:37:55 -0400
Received: from khc.piap.pl ([195.187.100.11]:58382 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJIThy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:37:54 -0400
To: Timur Tabi <timur@freescale.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
	<4706A842.9030507@freescale.com>
	<20071009174623.GC4003@csclub.uwaterloo.ca>
	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>
	<470BCEFC.9060302@freescale.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Oct 2007 21:37:52 +0200
In-Reply-To: <470BCEFC.9060302@freescale.com> (Timur Tabi's message of "Tue, 09 Oct 2007 13:57:00 -0500")
Message-ID: <m37ilwcc4v.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

>> There is no such thing as bit-order.
>
> Yes, there is.  You need to read the article at
> http://www.linuxjournal.com/article/6788.  Explains what it means for
> bits to be in one order versus another.  This is from the perspective
> of external devices, not the CPU (which is always consistent with
> regards to bit order)

Have you ever seen a device or platform with the bits reversed?
I.e. one on which 0x01 from CPU POV is 0x80 or 0x80000000 etc.
from device's POV?

Perhaps I was too brief, I should've written "there is no such
thing WRT the CPU-device connections" because the bit order
actually exists on things like serial lines, though it's totally
independent from big/little endianness of the CPU and/or
peripheral devices, and one can't assume anything matches there.

On parallel bus, all bits (at least of an 8-bit byte) are stored
and transmitted at the same time and address, so no bit can be
first or last.

Once again, you shift left (towards MSBit), you multiply, shifting
right divides. At least as long as you limit it to a single byte.

Perhaps if you tell us what are you exactly trying to achieve...
-- 
Krzysztof Halasa
