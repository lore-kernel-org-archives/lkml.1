Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZCTWno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZCTWno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZCTWnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:43:33 -0400
Received: from [213.79.90.228] ([213.79.90.228]:42062 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754535AbZCTWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:43:32 -0400
Date: Sat, 21 Mar 2009 01:43:30 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: yamazaki <yamazaki-seiji@jcom.home.ne.jp>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090320224330.GA23390@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090316211405.GK9375@oksana.dev.rtsoft.ru> <200903192328.AA00740@cj3020122-b.jcom.home.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200903192328.AA00740@cj3020122-b.jcom.home.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Mar 20, 2009 at 08:28:39AM +0900, yamazaki wrote:
> Hi all,
> 
> I am running the Linux kernel 2.6.28.7 on my PPC8347 BRD.
> I have to write the driver of SDHCI driver(using R5C807 RICOH). 

RICOH? It should be a PCI SD/MMC controller, so you even don't
need any patches to make it work in 2.6.28.7. Just make sure your
.config file has following symbols enabled:

CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
