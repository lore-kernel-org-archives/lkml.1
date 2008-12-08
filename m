Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYLHXZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYLHXZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYLHXZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:25:40 -0500
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:24272 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbYLHXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:25:40 -0500
From: Frans Pop <elendil@planet.nl>
To: david@hardeman.nu
Subject: Re: Is the Ricoh R5C822 documentation available?
Date: Tue, 9 Dec 2008 00:25:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, drzeus-list@drzeus.cx,
       linux-kernel@vger.kernel.org, tbm@cyrius.com
References: <20081208215458.GI14254@hardeman.nu>
In-reply-To: <20081208215458.GI14254@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812090025.37114.elendil@planet.nl>
X-OriginalArrivalTime: 08 Dec 2008 23:25:38.0333 (UTC) FILETIME=[474D94D0:01C9598C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> The Ricoh R5C822 card reader in my laptop includes a smart card reader
> (http://www.ricoh.com/LSI/product_pcif/pcc/5c821/index.html) but it
> doesn't seem supported by the kernel.

Weird. My laptop has the same device and I've successfully installed 
Debian to it [1]...

02:06.2 SD Host controller [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 21)
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci
02:06.3 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller 
[1180:0843] (rev ff)
        Kernel driver in use: ricoh-mmc
        Kernel modules: ricoh_mmc

The function of the ricoh_mmc module is to disable the last (proprietary) 
controller in favor of the first (generic) one.

Cheers,
FJP

[1] Installing to SD/MMC card is supported as of D-I Lenny RC1 for i386 
and amd64.
