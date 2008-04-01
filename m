Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYDANjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYDANjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYDANjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:39:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:48944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbYDANjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,587,1199692800"; 
   d="scan'208";a="225931086"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] dma_page_list ->base_address is a userland pointer
Date: Tue, 1 Apr 2008 14:34:59 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101667B20@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240803310922i628ab6c6r44e89f6b841fdf79@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] dma_page_list ->base_address is a userland pointer
Thread-Index: AciTS15zUMMVIKdwRte4qTrNVRKD2AAsYCPw
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <viro@ftp.linux.org.uk>, <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Apr 2008 13:35:01.0319 (UTC) FILETIME=[2F831D70:01C893FD]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Mar 29, 2008 5:09 AM
> Subject: [PATCH] dma_page_list ->base_address is a userland pointer
> To: torvalds@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> 
> 
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/linux/dmaengine.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 261e43a..34d4406 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -423,7 +423,7 @@ void dma_async_device_unregister(struct dma_device
>  *device); /* --- Helper iov-locking functions --- */
> 
>  struct dma_page_list {
> -       char *base_address;
> +       char __user *base_address;
>        int nr_pages;
>        struct page **pages;
>  };
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

