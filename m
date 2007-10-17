Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbXJQUMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbXJQUMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXJQUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:11:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXJQUL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:11:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47166C83.2050207@s5r6.in-berlin.de>
Date: Wed, 17 Oct 2007 22:11:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de> <m34pgpmszu.fsf@maximus.localdomain>
In-Reply-To: <m34pgpmszu.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
>> And in case of VT6307, I suspect it's VIA who
>> selects the implementation level (based on chip revision), not the card
>> vendor.
> 
> Can't be, the customers (real ones - board makers) would kill them
> at once and then buy a different brand. That's not selling a different

What I meant was:  First revisions may have had incomplete OHCI 1.1
support and were sold as OHCI 1.0 chips, and as soon as they stabilized
it they sold them as OHCI 1.1 chips.  But that's mere speculation on my
part.  I can't think of any other reason though why anybody would hide
OHCI 1.1 compatibility.

> Anyway, I just connected a programmer to the EEPROM (machine "a" in my
> previous mail = EPIA-M 600 MHz), wrote "8" to the 16-bit word at address
> 0x11 (93c46 EEPROM), and now this VT6307S dated 0239CD (2002, 39th week)
> says:
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[12]  MMIO=[de000000-de0007ff]
>   Max Packet=[2048]  IR/IT contexts=[4/8]

And are you going to test if and how stable OHCI 1.1 features work?
(Which features are these?  Right now only dual buffer reception comes
to my mind.)
-- 
Stefan Richter
-=====-=-=== =-=- =---=
http://arcgraph.de/sr/
