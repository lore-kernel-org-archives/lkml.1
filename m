Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZHYNEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZHYNEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZHYNEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:04:47 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:27862
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbZHYNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:04:46 -0400
X-IronPort-AV: E=Sophos;i="4.44,272,1249250400"; 
   d="scan'208";a="45259272"
Message-ID: <4A93E192.9000109@inria.fr>
Date: Tue, 25 Aug 2009 15:05:22 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: how to get a DMA channel near a process?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am playing with DMA engine on a Nehalem box with two X58 chipsets
(Supermicro X8DAH). My understanding is that there are 8 DMA channels on
each chipset, so 8 channels near each processor. Unfortunately, my BIOS
and 2.6.31-rc still wrongly reports the physical location of my devices
(it claims all PCI devices are near the first processor) but I worked
around the problem manually.

The offloaded copy performance changes a lot depending on whether the
process memory is allocated near the DMA device. So first I would like
to know if DMA channels are allocated near the requesting
processor/process. Then I guess it's possible to read the cpu mask near
a given chan by following chan->dev.device up to the pci device, right?
But is there any way to request a DMA channel near a specific socket or
NUMA node or cpu mask?

Thanks,
Brice


