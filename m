Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbXJPOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbXJPOzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934202AbXJPOzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:55:36 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:54341 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196AbXJPOzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:55:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/block/cpqarray,cciss: kill unused var
Date: Tue, 16 Oct 2007 14:55:11 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C0229390C@G3W0639.americas.hpqcorp.net>
In-Reply-To: <20071013190348.GA19992@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/block/cpqarray,cciss: kill unused var
Thread-Index: AcgNy8u6qgvBbWODTWW2UowhqslaswCOKiGw
References: <20071013190348.GA19992@havoc.gtf.org>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       "ISS StorageDev" <iss_storagedev@hp.com>
X-OriginalArrivalTime: 16 Oct 2007 14:55:13.0942 (UTC) FILETIME=[8EA91B60:01C81004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Jeff Garzik [mailto:jeff@garzik.org] 
> Sent: Saturday, October 13, 2007 2:04 PM
> To: Andrew Morton; Linus Torvalds
> Cc: LKML; jens.axboe@oracle.com; ISS StorageDev
> Subject: [PATCH] drivers/block/cpqarray,cciss: kill unused var
> 
> The recent bio work and subsequent fixups created unused variables.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c    |    1 -
>  drivers/block/cpqarray.c |    3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index 28d1457..27401d6 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1191,7 +1191,6 @@ static inline void 
> complete_buffers(struct bio *bio, int status)  {
>  	while (bio) {
>  		struct bio *xbh = bio->bi_next;
> -		int nr_sectors = bio_sectors(bio);
>  
>  		bio->bi_next = NULL;
>  		bio_endio(bio, status ? 0 : -EIO);
> diff --git a/drivers/block/cpqarray.c 
> b/drivers/block/cpqarray.c index 3853c9a..568603d 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -981,9 +981,8 @@ static void start_io(ctlr_info_t *h)  
> static inline void complete_buffers(struct bio *bio, int ok)  {
>  	struct bio *xbh;
> -	while(bio) {
> -		int nr_sectors = bio_sectors(bio);
>  
> +	while (bio) {
>  		xbh = bio->bi_next;
>  		bio->bi_next = NULL;
>  		
> 
