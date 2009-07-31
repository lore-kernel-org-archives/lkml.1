Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZGaM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZGaM5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZGaM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:57:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:61036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZGaM5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:57:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,302,1246863600"; 
   d="scan'208";a="712787712"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Pierre Ossman <pierre@ossman.eu>
Date: Fri, 31 Jul 2009 13:56:58 +0100
Subject: RE: [PATCH] dmaengine: Move all map_sg/unmap_sg for slave channel
 to its client
Thread-Topic: [PATCH] dmaengine: Move all map_sg/unmap_sg for slave channel
 to its client
Thread-Index: AcoRlBKYeMW+skqnSIKvPDuM9LofQgAShZ1g
Message-ID: <129600E5E5FB004392DDC3FB599660D7B298123F@irsmsx504.ger.corp.intel.com>
References: <1249012788-965-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1249012788-965-1-git-send-email-anemo@mba.ocn.ne.jp>
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
> Dan Williams wrote:
> ... DMA-slave clients request specific channels and know the hardware
> details at a low level, so it should not be too high an expectation to
> push dma mapping responsibility to the client.
> 
> Also this patch includes DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE support for
> dw_dmac driver.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

The patch looks fine to me.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
