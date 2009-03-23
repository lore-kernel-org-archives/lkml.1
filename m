Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbZCWQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbZCWQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZCWQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:16:59 -0400
Received: from [213.79.90.228] ([213.79.90.228]:47743 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754220AbZCWQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:16:58 -0400
Date: Mon, 23 Mar 2009 19:16:55 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: =?utf8?B?5bGx5bSO44CA57K+5LqM?= 
	<yamazaki.seiji@kk.jp.panasonic.com>
Cc: yamazaki <yamazaki-seiji@jcom.home.ne.jp>, sdhci-devel@list.drzeus.cx,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus-sdhci@drzeus.cx>,
       justinmattock@gmail.com
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090323161655.GA30262@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <200903210015.AA00742@cj3020122-b.jcom.home.ne.jp> <20090321004506.GA13031@oksana.dev.rtsoft.ru> <20090323152051.D2F9.YAMAZAKI.SEIJI@kk.jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090323152051.D2F9.YAMAZAKI.SEIJI@kk.jp.panasonic.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:34:45PM +0900, 山崎　精二 wrote:
> Hi 
> 
> I downloaded linux-2.6.29-rc8.tar.bz2,and I patched .
> I was succeeded. Thank you very match.
> But I have the other problem.
> 
> Compile was not succeeded.
> 
> Message is ...
> 
>  CALL    arch/powerpc/kernel/prom_init_check.sh
>   CC      drivers/mmc/host/sdhci-of.o
> drivers/mmc/host/sdhci-of.c:163: error: 'SDHCI_QUIRK_FORCE_BLK_SZ_2048' undeclared here (not in a function)
> drivers/mmc/host/sdhci-of.c:164: error: 'SDHCI_QUIRK_BROKEN_CARD_DETECTION' undeclared here (not in a function)
> drivers/mmc/host/sdhci-of.c:165: error: 'SDHCI_QUIRK_INVERTED_WRITE_PROTECT' undeclared here (not in a function)
> drivers/mmc/host/sdhci-of.c:167: error: 'SDHCI_QUIRK_NONSTANDARD_CLOCK' undeclared here (not in a function)
> drivers/mmc/host/sdhci-of.c:168: error: 'SDHCI_QUIRK_PIO_NEEDS_DELAY' undeclared here (not in a function)
> drivers/mmc/host/sdhci-of.c:169: error: 'SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET' undeclared here (not in a function)
[...]
> drivers/mmc/host/sdhci-of.c:181: warning: excess elements in struct initializer
> drivers/mmc/host/sdhci-of.c:181: warning: (near initialization for 'sdhci_esdhc.ops')
> make[3]: *** [drivers/mmc/host/sdhci-of.o] Error 1
> make[2]: *** [drivers/mmc/host] Error 2
> make[1]: *** [drivers/mmc] Error 2

All these errors indicate that you didn't apply all the patches.
You'll need all 11 patches from this series, not only the last
one.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
