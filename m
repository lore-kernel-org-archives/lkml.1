Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbXLMRSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbXLMRSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765022AbXLMRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:17:59 -0500
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:57876 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765010AbXLMRR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:17:58 -0500
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 12:17:58 EST
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jerome Marchand <jmarchan@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Date: Thu, 13 Dec 2007 16:55:06 +0000
Subject: RE: [Patch 4/8] Enhanced partition statistics: cciss fix
Thread-Topic: [Patch 4/8] Enhanced partition statistics: cciss fix
Thread-Index: Acg9o9xMLGN/qUxSREm6+GRnB0t83wABMtRw
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE157ACB37@G6W0268.americas.hpqcorp.net>
References: <47615B2E.1040608@redhat.com>
In-Reply-To: <47615B2E.1040608@redhat.com>
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

>
> Updates the enhanced partition statistics in cciss driver.
>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  cciss.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-) diff -urNp -X
> linux-2.6/Documentation/dontdiff
> linux-2.6.orig/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
> --- linux-2.6.orig/drivers/block/cciss.c        2007-12-04
> 17:37:13.000000000 +0100
> +++ linux-2.6/drivers/block/cciss.c     2007-12-05
> 13:46:29.000000000 +0100
> @@ -1268,7 +1268,8 @@ static void cciss_softirq_done(struct re
>         if (blk_fs_request(rq)) {
>                 const int rw = rq_data_dir(rq);
>
> -               disk_stat_add(rq->rq_disk, sectors[rw],
> rq->nr_sectors);
> +               all_stat_add(rq->rq_disk, sectors[rw],
> +                            rq->nr_sectors, rq->sector);
>         }

How does this mesh with the changes submitted by Kiyoshi Ueda? Any conflicts?

-- mikem
