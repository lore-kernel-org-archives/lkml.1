Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYGGOqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYGGOqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYGGOqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:46:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:21754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYGGOqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,316,1212390000"; 
   d="scan'208";a="7962945"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 2.6.26-rc8] dma: fix platform driver hotplug/coldplug
Date: Mon, 7 Jul 2008 15:46:36 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101C4D9AC@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200807020022.35486.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 2.6.26-rc8] dma: fix platform driver hotplug/coldplug
thread-index: AcjcFGv3dd7V7xm3Rby9Gcm8Yv2QHwEK5UUw
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 07 Jul 2008 14:46:35.0059 (UTC) FILETIME=[40D99830:01C8E040]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> modalias is prefixed with "platform:". Add MODULE_ALIAS() to most
> of the hotpluggable platform drivers, to re-enable auto loading.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/dma/iop-adma.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/dma/iop-adma.c	2008-07-01 23:58:22.000000000 -0700
> +++ b/drivers/dma/iop-adma.c	2008-07-02 00:00:19.000000000 -0700
> @@ -1387,6 +1387,8 @@ static void iop_chan_start_null_xor(stru
>  	spin_unlock_bh(&iop_chan->lock);
>  }
> 
> +MODULE_ALIAS("platform:iop-adma");
> +
>  static struct platform_driver iop_adma_driver = {
>  	.probe		= iop_adma_probe,
>  	.remove		= iop_adma_remove,

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
