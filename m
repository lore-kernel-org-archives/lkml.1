Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbZDAPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbZDAPIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764842AbZDAPIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:08:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:40592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762948AbZDAPIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,307,1235980800"; 
   d="scan'208";a="399399435"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 1 Apr 2009 16:08:13 +0100
Subject: RE: [PATCH v3 1/1] dw_dmac: add cyclic API to DW DMA driver
Thread-Topic: [PATCH v3 1/1] dw_dmac: add cyclic API to DW DMA driver
Thread-Index: Acmy0HyGaY4hFcbQQ+6Utu0FL7/JGgACwbYg
Message-ID: <129600E5E5FB004392DDC3FB599660D790FECED0@irsmsx504.ger.corp.intel.com>
References: <20090401153957.6982f050@hskinnemoen-d830>
 <1238593622-17809-1-git-send-email-hans-christian.egtvedt@atmel.com>
In-Reply-To: <1238593622-17809-1-git-send-email-hans-christian.egtvedt@atmel.com>
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

Hans-Christian Egtvedt wrote:
> This patch adds a cyclic DMA interface to the DW DMA driver. This is
> very useful if you want to use the DMA controller in combination with a
> sound device which uses cyclic buffers.
> 
> Using a DMA channel for cyclic DMA will disable the possibility to use
> it as a normal DMA engine until the user calls the cyclic free function
> on the DMA channel. Also a cyclic DMA list can not be prepared if the
> channel is already active.
> 
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> ---
>  drivers/dma/dw_dmac.c      |  332 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/dma/dw_dmac_regs.h |    7 +-
>  include/linux/dw_dmac.h    |   19 +++
>  3 files changed, 356 insertions(+), 2 deletions(-)
> 

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
