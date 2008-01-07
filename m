Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYAGRKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYAGRKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYAGRKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:10:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:55703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbYAGRKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:10:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,254,1196668800"; 
   d="scan'208";a="360939426"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/4] async_tx: replace 'int_en' with operation preparationflags
Date: Mon, 7 Jan 2008 16:59:23 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C1FAED31@swsmsx413.ger.corp.intel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C03BAD67D@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] async_tx: replace 'int_en' with operation preparationflags
thread-index: AchENvNqejPSYO8LReCLBpnUMwmRkQK5ChxAAIxBkRA=
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, <yur@emcraft.com>,
       <hskinnemoen@atmel.com>, <olof@lixom.net>, <wei.zhang@freescale.com>
X-OriginalArrivalTime: 07 Jan 2008 16:59:23.0101 (UTC) FILETIME=[A6FDD0D0:01C8514E]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Williams, Dan J 
>
>Pass a full set of flags to drivers' per-operation 'prep' routines.
>Currently the only flag passed is DMA_PREP_INTERRUPT.  The 
>expectation is
>that arch-specific async_tx_find_channel() implementations can 
>exploit this
>capability to find the best channel for an operation.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> crypto/async_tx/async_memcpy.c         |    3 ++-
> crypto/async_tx/async_memset.c         |    3 ++-
> crypto/async_tx/async_xor.c            |   10 ++++++----
> drivers/dma/ioat_dma.c                 |    4 ++--
> drivers/dma/iop-adma.c                 |   20 ++++++++++----------
> include/asm-arm/arch-iop13xx/adma.h    |   18 ++++++++++--------
> include/asm-arm/hardware/iop3xx-adma.h |   30 
>+++++++++++++++++-------------
> include/linux/dmaengine.h              |   17 +++++++++++++----
> 8 files changed, 62 insertions(+), 43 deletions(-)

As ioat_dma is not using int_en right now, this change does not impact
the driver at the moment and may be definitely useful later.

Maciej Sosnowski

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

