Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZCXEtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZCXEtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 00:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZCXEtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 00:49:09 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:46389 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZCXEtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 00:49:08 -0400
Date: Tue, 24 Mar 2009 13:46:11 +0900
From: =?ISO-2022-JP?B?GyRCOzM6aiEhQDpGcxsoQg==?= 
	<yamazaki.seiji@kk.jp.panasonic.com>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Cc: yamazaki <yamazaki-seiji@jcom.home.ne.jp>, sdhci-devel@list.drzeus.cx,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus-sdhci@drzeus.cx>,
       justinmattock@gmail.com
In-Reply-To: <20090323161655.GA30262@oksana.dev.rtsoft.ru>
References: <20090323152051.D2F9.YAMAZAKI.SEIJI@kk.jp.panasonic.com> <20090323161655.GA30262@oksana.dev.rtsoft.ru>
Message-Id: <20090324131210.9BFF.YAMAZAKI.SEIJI@kk.jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.25.02 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 
> All these errors indicate that you didn't apply all the patches.
> You'll need all 11 patches from this series, not only the last
> one.
> 

I applyed all the patches,then Compile was succeeded.

Thank you for your advice.

regards,

-- Seiji Yamazaki


On Mon, 23 Mar 2009 19:16:55 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Mon, Mar 23, 2009 at 03:34:45PM +0900, $Bj3%"j6<e(B??$Bn4%;h<7(Bwrote:
> > Hi 
> > 
> > I downloaded linux-2.6.29-rc8.tar.bz2,and I patched .
> > I was succeeded. Thank you very match.
> > But I have the other problem.
> > 
> > Compile was not succeeded.
> > 
> > Message is ...
> > 
> >  CALL    arch/powerpc/kernel/prom_init_check.sh
> >   CC      drivers/mmc/host/sdhci-of.o
> > drivers/mmc/host/sdhci-of.c:163: error: 'SDHCI_QUIRK_FORCE_BLK_SZ_2048' undeclared here (not in a function)
> > drivers/mmc/host/sdhci-of.c:164: error: 'SDHCI_QUIRK_BROKEN_CARD_DETECTION' undeclared here (not in a function)
> > drivers/mmc/host/sdhci-of.c:165: error: 'SDHCI_QUIRK_INVERTED_WRITE_PROTECT' undeclared here (not in a function)
> > drivers/mmc/host/sdhci-of.c:167: error: 'SDHCI_QUIRK_NONSTANDARD_CLOCK' undeclared here (not in a function)
> > drivers/mmc/host/sdhci-of.c:168: error: 'SDHCI_QUIRK_PIO_NEEDS_DELAY' undeclared here (not in a function)
> > drivers/mmc/host/sdhci-of.c:169: error: 'SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET' undeclared here (not in a function)
> [...]
> > drivers/mmc/host/sdhci-of.c:181: warning: excess elements in struct initializer
> > drivers/mmc/host/sdhci-of.c:181: warning: (near initialization for 'sdhci_esdhc.ops')
> > make[3]: *** [drivers/mmc/host/sdhci-of.o] Error 1
> > make[2]: *** [drivers/mmc/host] Error 2
> > make[1]: *** [drivers/mmc] Error 2
> 
> All these errors indicate that you didn't apply all the patches.
> You'll need all 11 patches from this series, not only the last
> one.
> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2

-- 
yamazaki seiji <yamazaki.seiji@kk.jp.panasonic.com>

