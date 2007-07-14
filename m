Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbXGNOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbXGNOnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 10:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXGNOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 10:43:16 -0400
Received: from khc.piap.pl ([195.187.100.11]:43980 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXGNOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 10:43:15 -0400
To: William Montgomery <william@opinicus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 14 Jul 2007 16:43:13 +0200
In-Reply-To: <4697B85B.4040902@opinicus.com> (William Montgomery's message of "Fri, 13 Jul 2007 13:37:31 -0400")
Message-ID: <m33azrt5a6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Montgomery <william@opinicus.com> writes:

> In an earlier post to the list I described a hard lockup condition
> that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
> a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
> and occurs on 2 out of 3 computers.
>
> Further testing has revealed that the lockup can be prevented on all
> computers by making sure the card is installed on the primary PCI bus.
> If the card is installed in a slot on the secondary PCI bus (behind a
> PCI to PCI bridge) the lockup occurs.

Does the machine #3 have a PCI slot connected to a "secondary" bus?
Have you tried with any other machine with a secondary bus?

> Are there any PCI tuning registers that I can tweak to get around
> this problem?  Any changes I could make to the e100 driver to fix this?

Could be a hardware/BIOS problem on machines #1 and #2. Could be
a Linux bug as well, though similar configurations are known to work
fine. I don't think it has anything to do with IRQs.

Perhaps it doesn't like a bridge (on the card) behind a bridge
(on the motherboard). I would test with another multiport card
such as old DLink DFE-570TX (using a DEC 21150 bridge and four
21143 Ethernet chips).

I'd probably use some PCI analyzer or, at least, I'd check
the bus state with a multimeter.
-- 
Krzysztof Halasa
