Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYILMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYILMN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYILMNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:13:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:21849 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYILMNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:13:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,389,1217833200"; 
   d="scan'208";a="438667277"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] drivers/dma/ioat_dma.c: Drop code after return
Date: Fri, 12 Sep 2008 13:13:11 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101FEE5B9@swsmsx413.ger.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0809111434100.9593@pc-004.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] drivers/dma/ioat_dma.c: Drop code after return
Thread-Index: AckUCsSgq/fhgLazT7WB6rTNbzcvEAAxfJHA
References: <Pine.LNX.4.64.0809111434100.9593@pc-004.diku.dk>
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Julia Lawall" <julia@diku.dk>
Cc: <linux-kernel@vger.kernel.org>, <vigneshbabu@gmail.com>,
       <richard.genoud@gmail.com>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 12 Sep 2008 12:13:10.0963 (UTC) FILETIME=[EC754030:01C914D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The break after the return serves no purpose.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> 
>  drivers/dma/ioat_dma.c        |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index bc8c6e3..1ef68b3 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -971,11 +971,9 @@ static struct ioat_desc_sw
>  	*ioat_dma_get_next_descriptor( switch
(ioat_chan->device->version) {
>  	case IOAT_VER_1_2:
>  		return ioat1_dma_get_next_descriptor(ioat_chan);
> -		break;
>  	case IOAT_VER_2_0:
>  	case IOAT_VER_3_0:
>  		return ioat2_dma_get_next_descriptor(ioat_chan);
> -		break;
>  	}
>  	return NULL;
>  }

You are right. Thanks for pointing this out.

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
