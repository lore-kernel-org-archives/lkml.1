Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXJIWfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXJIWfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXJIWe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:34:59 -0400
Received: from khc.piap.pl ([195.187.100.11]:41508 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXJIWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:34:59 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Timur Tabi <timur@freescale.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
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
	<470BD266.8020302@goop.org> <m33awkcc2j.fsf@maximus.localdomain>
	<470BF566.6010204@goop.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 10 Oct 2007 00:34:56 +0200
In-Reply-To: <470BF566.6010204@goop.org> (Jeremy Fitzhardinge's message of "Tue, 09 Oct 2007 14:40:54 -0700")
Message-ID: <m34pgzdii7.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> but the gist is that IBM has
> traditionally bit 0 for MSB and x for LSB.  It's a pain to work with:
> for one, bits in the same place in a word (say, control register) are
> renumbered in 32 vs 64.

I wasn't aware of that, but it doesn't really change the bit order,
only bit names (numbers actually). Extremely weird BTW but I guess
these things weren't that obvious to everyone some 50 years ago.

> And I've worked on at least one piece of
> hardware in which the hardware designer had a brain-fart and first board
> had bit 0 on the CPU wired to bit 0 on the northbridge - should have
> been 31 -> 0, 30 -> 1, etc...

I suspect the board wasn't able to run any OS, was it? :-)
Would make a real example of the different order of bits, though.
-- 
Krzysztof Halasa
