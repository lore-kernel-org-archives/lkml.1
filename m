Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZCUAN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZCUAN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZCUANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:13:49 -0400
Received: from smtp11.m3.home.ne.jp ([220.152.44.17]:48744 "EHLO
	smtp11.m3.home.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZCUANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:13:48 -0400
Message-Id: <200903210015.AA00742@cj3020122-b.jcom.home.ne.jp>
From: yamazaki <yamazaki-seiji@jcom.home.ne.jp>
Date: Sat, 21 Mar 2009 09:15:25 +0900
To: avorontsov@ru.mvista.com
Cc: sdhci-devel@list.drzeus.cx, Arnd Bergmann <arnd@arndb.de>,
       Liu Dave <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Ben Dooks <ben-linux@fluff.org>,
       Pierre Ossman <drzeus-sdhci@drzeus.cx>
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
In-Reply-To: <20090320224330.GA23390@oksana.dev.rtsoft.ru>
References: <20090320224330.GA23390@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.12
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

Thank you for your reply.
I know RICOH has PCI SD/MMC controller. But R5C807 RICOH is not the PCI device
which is probably new product.

I made the "sdhci-of.c" from patch file,then I compiled it.
But is was not succeeded.
I thought the reason is the format of "the struct sdhci_of_data" is defferent from the 
kernel 2.6.28.7,
That is why I sent this question.

>Hi!
>
>On Fri, Mar 20, 2009 at 08:28:39AM +0900, yamazaki wrote:
>> Hi all,
>> 
>> I am running the Linux kernel 2.6.28.7 on my PPC8347 BRD.
>> I have to write the driver of SDHCI driver(using R5C807 RICOH). 
>
>RICOH? It should be a PCI SD/MMC controller, so you even don't
>need any patches to make it work in 2.6.28.7. Just make sure your
>.config file has following symbols enabled:
>
>CONFIG_MMC_SDHCI=y
>CONFIG_MMC_SDHCI_PCI=y
>CONFIG_MMC_RICOH_MMC=y
>
>-- 
>Anton Vorontsov
>email: cbouatmailru@gmail.com
>irc://irc.freenode.net/bd2
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@ozlabs.org
>https://ozlabs.org/mailman/listinfo/linuxppc-dev

----
yamazaki-seiji@jcom.home.ne.jp
