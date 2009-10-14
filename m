Return-Path: <linux-kernel-owner+w=401wt.eu-S934497AbZJNPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbZJNPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZJNPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:25:52 -0400
Received: from lo.gmane.org ([80.91.229.12]:35016 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZJNPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:25:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jonathan Hudson <jh+lkm@daria.co.uk>
Subject: Cardbus WLAN on PPC32 DMA error 2.6.30+
Date: Wed, 14 Oct 2009 16:21:12 +0100
Message-ID: <8s6hq6xepq.ln2@roo.daria.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 82-68-140-1.dsl.in-addr.zen.co.uk
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On kernels later than the 2.6.29 series, on inserting a cardbus WLAN
card, I get DMA error messages (from 2.6.31.4)

For a rt2500pci:

[  176.881208] pci 0001:11:00.0: reg 10 32bit mmio: [0xffffe000-0xffffffff]
[  177.040993] rt2500pci 0001:11:00.0: enabling device (0000 -> 0002)
[  177.041019] rt2x00pci -> rt2x00pci_probe: Error - PCI DMA not supported.
[  177.041044] rt2500pci: probe of 0001:11:00.0 failed with error -5

For a Broadcom 4306:

[   45.031787] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   45.226831] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[   45.313161] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[   45.362739] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[   45.527782] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[   45.595983] b43-phy0 ERROR: The machine/kernel does not support the required 30-bit DMA mask
[   46.731628] b43-phy0 ERROR: Microcode not responding
[   46.731642] b43-phy0 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the correct firmware for this driver version. Please carefully read all instructions on this website.

(similar results with b43legacy).

Both these cards work with 2.6.29.6 and earlier. I don't have any
architectures other than PPC32 with cardbus to test the cards.

Any advice welcomed.

-jh





