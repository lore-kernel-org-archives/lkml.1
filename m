Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZG0NXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZG0NXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZG0NXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:23:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:32229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZG0NXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,276,1246863600"; 
   d="scan'208";a="478294259"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>
Date: Mon, 27 Jul 2009 14:22:45 +0100
Subject: RE: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Topic: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Index: AcoK7f96fYHYiT8wRRyrEP3y7K5mlwDzyBCw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B271F463@irsmsx504.ger.corp.intel.com>
References: <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
 <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> This patch for at_hdmac adds the slave transfers capability to the Atmel DMA
> controller available on some AT91 SOCs. This allow peripheral to memory and
> memory to peripheral transfers with hardware handshaking.
> 
> Slave structure for controller specific information is passed through channel
> private data. This at_dma_slave structure is defined in at_hdmac.h header file
> and relative hardware definition are moved to this file from at_hdmac_regs.h.
> Doing this we allow the channel configuration from platform definition code.
> 
> This work is intensively based on dw_dmac and several slave implementations.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>