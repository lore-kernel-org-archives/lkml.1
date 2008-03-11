Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYCKRRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYCKRRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYCKRQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:16:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:1609 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYCKRQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:16:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,481,1199692800"; 
   d="scan'208";a="305346243"
Content-class: urn:content-classes:message
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] [DMA ENGINE] typo fixes
Date: Tue, 11 Mar 2008 17:15:16 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C10145C8BA@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240803110712m46902d0t8b45c7658e02cfbe@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [DMA ENGINE] typo fixes
Thread-Index: AciDgzuWeB1Q2eWpSF2WzZSLSGwUEQAF8QpA
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <bigeasy@linutronix.de>, <trivial@kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 11 Mar 2008 17:15:17.0944 (UTC) FILETIME=[7A8F4B80:01C8839B]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Sebastian Siewior <bigeasy@tglx.de>
> Date: Mar 11, 2008 10:44 AM
> Subject: [PATCH] [DMA ENGINE] typo fixes
> To: Jesper Juhl <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> 
> 
> Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
> ---
>  drivers/dma/dmaengine.c   |    6 +++---
>  include/linux/dmaengine.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 2996523..1299d43 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -42,9 +42,9 @@
>  *
>  * Each device has a kref, which is initialized to 1 when the device
is
>  * registered. A kref_get is done for each device registered.  When
the
> - * device is released, the coresponding kref_put is done in the
release
> + * device is released, the corresponding kref_put is done in the
release
>  * method. Every time one of the device's channels is allocated to a
client,
> - * a kref_get occurs.  When the channel is freed, the coresponding
kref_put
> + * a kref_get occurs.  When the channel is freed, the corresponding
kref_put
>  * happens. The device's release function does a completion, so
>  * unregister_device does a remove event, device_unregister, a
kref_put
>  * for the first reference, then waits on the completion for all other
> @@ -53,7 +53,7 @@
>  * Each channel has an open-coded implementation of Rusty Russell's
"bigref,"
>  * with a kref and a per_cpu local_t.  A dma_chan_get is called when a
client
>  * signals that it wants to use a channel, and dma_chan_put is called
when
> - * a channel is removed or a client using it is unregesitered.  A
client can
> + * a channel is removed or a client using it is unregistered.  A
client can
>  * take extra references per outstanding transaction, as is the case
with
>  * the NET DMA client.  The release function does a kref_put on the
device.
>  *     -ChrisL, DanW
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 261e43a..8b2481f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -398,7 +398,7 @@ static inline enum dma_status
> dma_async_is_tx_complete(struct dma_chan *chan,
>  * @last_used: last cookie value handed out
>  *
>  * dma_async_is_complete() is used in dma_async_memcpy_complete()
> - * the test logic is seperated for lightweight testing of multiple
cookies
> + * the test logic is separated for lightweight testing of multiple
cookies
>  */
>  static inline enum dma_status dma_async_is_complete(dma_cookie_t
cookie,
>                        dma_cookie_t last_complete, dma_cookie_t
last_used)
> --
> 1.5.4.3

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
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

