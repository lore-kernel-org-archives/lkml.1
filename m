Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZG0NZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZG0NZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZG0NZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:25:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:17879 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbZG0NY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,276,1246863600"; 
   d="scan'208";a="478294527"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Jul 2009 14:24:26 +0100
Subject: RE: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Topic: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Index: AcoMaHeAg+mWIT8WQB2gHpIV4LgaLwCVOUMA
Message-ID: <129600E5E5FB004392DDC3FB599660D7B271F468@irsmsx504.ger.corp.intel.com>
References: <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
	<e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
	<4A696449.7050303@atmel.com>	<20090724.222919.240484146.anemo@mba.ocn.ne.jp>
 <20090724161001.412e0199@siona>
In-Reply-To: <20090724161001.412e0199@siona>
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

Haavard Skinnemoen wrote:
> On Fri, 24 Jul 2009 22:29:19 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
>>> The patches for adaptation of atmel-mci to at_hdmac are coming...
>> 
>> Your atc_chain_complete() calls dma_unmap_xxx unless
>> DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
>> the flag on dma_async_tx_descriptor.  I suppose one of them should be
>> fixed.
> 
> atmel-mci should definitely set that flag.
> 
> Haavard

I agree with Haavard.

Regards,
Maciej