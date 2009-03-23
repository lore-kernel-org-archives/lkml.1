Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZCWHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZCWHGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZCWHGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:06:40 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:62974 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZCWHGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:06:40 -0400
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 03:06:39 EDT
Date: Mon, 23 Mar 2009 15:34:45 +0900
From: =?ISO-2022-JP?B?GyRCOzM6aiEhQDpGcxsoQg==?= 
	<yamazaki.seiji@kk.jp.panasonic.com>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Cc: yamazaki <yamazaki-seiji@jcom.home.ne.jp>, sdhci-devel@list.drzeus.cx,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus-sdhci@drzeus.cx>
In-Reply-To: <20090321004506.GA13031@oksana.dev.rtsoft.ru>
References: <200903210015.AA00742@cj3020122-b.jcom.home.ne.jp> <20090321004506.GA13031@oksana.dev.rtsoft.ru>
Message-Id: <20090323152051.D2F9.YAMAZAKI.SEIJI@kk.jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.25.02 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

I downloaded linux-2.6.29-rc8.tar.bz2,and I patched .
I was succeeded. Thank you very match.
But I have the other problem.

Compile was not succeeded.

Message is ...

 CALL    arch/powerpc/kernel/prom_init_check.sh
  CC      drivers/mmc/host/sdhci-of.o
drivers/mmc/host/sdhci-of.c:163: error: 'SDHCI_QUIRK_FORCE_BLK_SZ_2048' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:164: error: 'SDHCI_QUIRK_BROKEN_CARD_DETECTION' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:165: error: 'SDHCI_QUIRK_INVERTED_WRITE_PROTECT' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:167: error: 'SDHCI_QUIRK_NONSTANDARD_CLOCK' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:168: error: 'SDHCI_QUIRK_PIO_NEEDS_DELAY' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:169: error: 'SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET' undeclared here (not in a function)
drivers/mmc/host/sdhci-of.c:172: error: unknown field 'readl' specified in initializer
drivers/mmc/host/sdhci-of.c:172: warning: initialization from incompatible pointer type
drivers/mmc/host/sdhci-of.c:173: error: unknown field 'readw' specified in initializer
drivers/mmc/host/sdhci-of.c:173: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:173: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:174: error: unknown field 'readb' specified in initializer
drivers/mmc/host/sdhci-of.c:174: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:174: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:175: error: unknown field 'writel' specified in initializer
drivers/mmc/host/sdhci-of.c:175: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:175: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:176: error: unknown field 'writew' specified in initializer
drivers/mmc/host/sdhci-of.c:176: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:176: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:177: error: unknown field 'writeb' specified in initializer
drivers/mmc/host/sdhci-of.c:177: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:177: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:178: error: unknown field 'set_clock' specified in initializer
drivers/mmc/host/sdhci-of.c:178: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:178: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:180: error: unknown field 'get_max_clock' specified in initializer
drivers/mmc/host/sdhci-of.c:180: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:180: warning: (near initialization for 'sdhci_esdhc.ops')
drivers/mmc/host/sdhci-of.c:181: error: unknown field 'get_timeout_clock' specified in initializer
drivers/mmc/host/sdhci-of.c:181: warning: excess elements in struct initializer
drivers/mmc/host/sdhci-of.c:181: warning: (near initialization for 'sdhci_esdhc.ops')
make[3]: *** [drivers/mmc/host/sdhci-of.o] Error 1
make[2]: *** [drivers/mmc/host] Error 2
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

I do not know why. Could you please tell us why.
Thanks.

On Sat, 21 Mar 2009 03:45:06 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Sat, Mar 21, 2009 at 09:15:25AM +0900, yamazaki wrote:
> > Hi 
> > 
> > Thank you for your reply.
> > I know RICOH has PCI SD/MMC controller. But R5C807 RICOH is not the PCI device
> > which is probably new product.
> 
> Ah, then it must be connected via MPC8347's localbus.
> 
> Well, then you need 2.6.29-rcX kernels, for example
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
> is suitable.
> 
> Untar it and apply the patches (they'll apply fine on that
> kernel). Then you'll need some device tree additions for
> your MPC8347 board, something like this:
> 
>         localbus@e0005000 {
>                 #address-cells = <2>;
>                 #size-cells = <1>;
>                 compatible = "fsl,mpc8347-localbus",
>                              "fsl,pq2pro-localbus";
>                 reg = <0xe0005000 0xd8>;
>                 ranges = <0x1 0x0 0xf0000000 0x1000>;
> 		// ^^ change the 0xf0000000 to the actual address
>                 sdhci@1,0 {
>                         compatible = "ricoh,r5c807", "generic-sdhci";
>                         reg = <0x1 0x0 0x1000>;
>                         interrupts = <ricoh-interrupt-here 0x8>;
>                         interrupt-parent = <&ipic>;
>                         // if needed, clock-frequency = <freq-in-HZ-here>;
>                 };
>         };
> 
> Note that I'm not sure what endiannes you'll get when connecting
> the ricoh chip to the big-endinan host...
> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2

-- 
山崎　精二 <yamazaki.seiji@kk.jp.panasonic.com>

