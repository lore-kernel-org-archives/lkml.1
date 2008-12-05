Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYLEGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYLEGzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 01:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYLEGz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 01:55:27 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:50938 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYLEGz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 01:55:27 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 07:55:20 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041459120.3543@nehalem.linux-foundation.org> <200812050045.40928.rjw@sisk.pl>
In-Reply-To: <200812050045.40928.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050755.22183.elendil@planet.nl>
X-OriginalArrivalTime: 05 Dec 2008 06:55:24.0474 (UTC) FILETIME=[72A4E9A0:01C956A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008, Rafael J. Wysocki wrote:
> On Friday, 5 of December 2008, Linus Torvalds wrote:
> > Oh, btw, I thought your and Frans' laptops were identical?
>
> No, they are from different vendors. :-)  Mine is a Toshiba one and the
> Frans' one is from HP.

Also, the CardBus bridge and what's behind them are quite different
(and we use different firewire stacks).

Mine is:
02:06.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev ba)
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket
02:06.1 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832] (rev 04)
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394
02:06.2 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 21)
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci
02:06.3 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller [1180:0843] (rev ff)
        Kernel driver in use: ricoh-mmc
        Kernel modules: ricoh_mmc
(The ricoh_mmc module disables the last one.)

While Rafael has:
03:0b.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket
03:0b.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller (prog-if 10 [OHCI])
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
03:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller (prog-if 01)
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci
