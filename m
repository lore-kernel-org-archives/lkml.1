Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbZFKI3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbZFKI3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbZFKI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:28:46 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:32784 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbZFKI2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AJChrLmaNxGdReY7+WPEf7W48Syc42fsdMbPWOCqvcdLy5GsTxwXwEzCJXeHGeu1Wm
         D0IEfVeWl8X4lF1adj6aeIJVqp+w4Kg9iYXKL4Cgof9L+34eLhNI5eif44bX8W7iOSAa
         OkP1X0b2d/rvCbKY5l7SJZZjlO/Ael6PFcVYk=
From: Florian Fainelli <florian@openwrt.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Date: Thu, 11 Jun 2009 10:28:39 +0200
User-Agent: KMail/1.9.9
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
References: <200906041622.47591.florian@openwrt.org> <20090604222020.GA14843@alpha.franken.de>
In-Reply-To: <20090604222020.GA14843@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906111028.41222.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Friday 05 June 2009 00:20:20 Thomas Bogendoerfer, vous avez écrit :
> On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> > We discussed that in private, there are a couple of things
> > to fix in order to get 8250 working properly with TI AR7 HW.
> > If you can still merge that bit, this would ease future work, thanks !
>
> I still have a tree here, which works without any changes to the 8250
> serial driver on a TNETD7300 device.

Could you show me how you register the 8250 driver ? Without the 8250-specific 
patch, here is the kind of output that I get:

[snip]
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x8610e00 (irq = 15) is a 16550
console handover: boot [early0] -> real [ttyS0]
serial8250: tyyS1 atMMMIO 088610f0  (irq   16) is a 16550
Fixed MDIOBBus: poobed
phymmap plttform flash device: 00000000 tt 10000000
physaap-flash.0: Found 1 x1  devicss at 000 in 1--bit bnnk
[/snip]
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
