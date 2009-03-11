Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZCKIfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZCKIfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZCKIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:34:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:50257 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZCKIeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,341,1233561600"; 
   d="scan'208";a="437965856"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Mar 2009 08:34:42 +0000
Subject: RE: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
Thread-Topic: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
Thread-Index: AcmeS7+8wQn4TPLHTlS6Leg274njIQD19Ozg
Message-ID: <129600E5E5FB004392DDC3FB599660D749993718@irsmsx504.ger.corp.intel.com>
References: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
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

Atsushi Nemoto wrote:
> Currently dma_request_channel() set DMA_PRIVATE capability but never
> clear it.  So if a public channel was once grabbed by
> dma_request_channel(), the device stay PRIVATE forever.  Add
> privatecnt member to dma_device to correctly revert it.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

I think it's a good idea and the patch looks fine to me.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
