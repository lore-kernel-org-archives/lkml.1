Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYDANgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYDANgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYDANgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:36:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:18374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYDANgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,587,1199692800"; 
   d="scan'208";a="543585493"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] ioat_dca __iomem annotations
Date: Tue, 1 Apr 2008 14:34:51 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101667B1F@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240803310920r5854444fid9022cd705e54847@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ioat_dca __iomem annotations
Thread-Index: AciTS1euFqlFZbiISBW1YxcAppmN7gAsR42A
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <viro@ftp.linux.org.uk>, <torvalds@linux-foundation.org>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Apr 2008 13:34:53.0165 (UTC) FILETIME=[2AA6E9D0:01C893FD]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Mar 29, 2008 5:08 AM
> Subject: [PATCH] ioat_dca __iomem annotations
> To: torvalds@linux-foundation.org
> Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
> 
> 
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/dma/ioat_dca.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
> index 0fa8a98..9e92276 100644
> --- a/drivers/dma/ioat_dca.c
> +++ b/drivers/dma/ioat_dca.c
> @@ -98,7 +98,7 @@ struct ioat_dca_slot {
> 
>  struct ioat_dca_priv {
>        void __iomem            *iobase;
> -       void                    *dca_base;
> +       void __iomem            *dca_base;
>        int                      max_requesters;
>        int                      requester_count;
>        u8                       tag_map[IOAT_TAG_MAP_LEN];
> @@ -338,7 +338,7 @@ static struct dca_ops ioat2_dca_ops = {
>        .get_tag                = ioat2_dca_get_tag,
>  };
> 
> -static int ioat2_dca_count_dca_slots(void *iobase, u16 dca_offset)
> +static int ioat2_dca_count_dca_slots(void __iomem *iobase, u16
dca_offset)
>  {
>        int slots = 0;
>        u32 req;
> --
> 1.5.3.GIT

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

