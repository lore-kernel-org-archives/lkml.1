Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXEOH7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXEOH7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXEOH7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:59:36 -0400
Received: from edony.tuxfamily.net ([212.85.158.10]:46430 "EHLO
	edony.tuxfamily.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbXEOH7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:59:35 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 03:59:35 EDT
MIME-Version: 1.0
Date: Tue, 15 May 2007 09:34:34 +0200
From: =?UTF-8?Q?Wald_S=C3=A9bastien?= <sebastw@tuxfamily.org>
To: linux-kernel@vger.kernel.org
Subject: Bug : support for Texas Instrument Card Reader 4 in 1 - Failed to allocate
 ressources
Organization: AFUL
Reply-To: sebastw@tuxfamily.org
Message-ID: <fb7d894a62f05c67fdb3c9d9f3cdfdf8@tuxfamily.org>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

i havve a problem to support Texas Instrument Card Reader 4 in 1. The device can not be active on linux kernel version 2.6.20 (Feisty Ubuntu). The module tifm_7xx1, tifm_core and tifm_sd was loaded successfully but it don't solve my problem.

Dmesg was printed :
[   67.932557] PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.0
[   67.932572] PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.1

And a 'lspci -v|grep Texas' :
02:00.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
02:04.0 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
02:04.1 CardBus bridge: Texas Instruments PCI1620 PC Card Controller (rev 01)
02:04.2 System peripheral: Texas Instruments PCI1620 Firmware Loading Function (rev 01)

Can problem be a bad ACPI support ? I have a HP ZV 5000 and it is not support ACPI correctly.

Thanks for your help
-- 
Wald Sébastien
06.83.06.11.82
Informaticien
Contact IM : sebastw@jabber.org


