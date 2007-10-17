Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXJQTil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXJQTil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXJQTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:38:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:39083 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXJQTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:38:32 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 17 Oct 2007 21:38:29 +0200
In-Reply-To: <471527E5.1050407@s5r6.in-berlin.de> (Stefan Richter's message of "Tue, 16 Oct 2007 23:06:45 +0200")
Message-ID: <m34pgpmszu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> And in case of VT6307, I suspect it's VIA who
> selects the implementation level (based on chip revision), not the card
> vendor.

Can't be, the customers (real ones - board makers) would kill them
at once and then buy a different brand. That's not selling a different
wifi card under the old name.

Anyway, I just connected a programmer to the EEPROM (machine "a" in my
previous mail = EPIA-M 600 MHz), wrote "8" to the 16-bit word at address
0x11 (93c46 EEPROM), and now this VT6307S dated 0239CD (2002, 39th week)
says:
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[12]  MMIO=[de000000-de0007ff]
  Max Packet=[2048]  IR/IT contexts=[4/8]

Unfortunately it's not much good for general consumption, and I haven't
yet found a way to write to the EEPROM using VT6307 registers (one can
easily read it using documented GUID register).


Nobody with a good VIA contact?
I'm not asking for something extraordinary, am I?
-- 
Krzysztof Halasa
