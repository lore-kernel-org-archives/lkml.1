Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbXJIVly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbXJIVly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXJIVlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:41:44 -0400
Received: from gw.goop.org ([64.81.55.164]:34707 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbXJIVln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:41:43 -0400
Message-ID: <470BF566.6010204@goop.org>
Date: Tue, 09 Oct 2007 14:40:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Timur Tabi <timur@freescale.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>	<470691EB.7020209@freescale.com>	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>	<4706A842.9030507@freescale.com>	<20071009174623.GC4003@csclub.uwaterloo.ca>	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>	<470BD266.8020302@goop.org> <m33awkcc2j.fsf@maximus.localdomain>
In-Reply-To: <m33awkcc2j.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Some pointer maybe?
>   

Erm, a bit of googling will turn one up, but the gist is that IBM has
traditionally bit 0 for MSB and x for LSB.  It's a pain to work with:
for one, bits in the same place in a word (say, control register) are
renumbered in 32 vs 64.  And I've worked on at least one piece of
hardware in which the hardware designer had a brain-fart and first board
had bit 0 on the CPU wired to bit 0 on the northbridge - should have
been 31 -> 0, 30 -> 1, etc...

    J

