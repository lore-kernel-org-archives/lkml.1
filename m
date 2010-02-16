Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0BPJLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:11:05 -0500
Received: from smtp.nokia.com ([192.100.122.233]:56207 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab0BPJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:10:56 -0500
Subject: Re: [PATCH] mtd: misplaced parenthesis in find_boot_record()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B79C444.8090402@gmail.com>
References: <4B79C344.60908@gmail.com>  <4B79C444.8090402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 11:09:29 +0200
Message-ID: <1266311369.11659.201.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Feb 2010 09:10:33.0554 (UTC) FILETIME=[E4F6D320:01CAAEE7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 23:01 +0100, Roel Kluin wrote:
> The parenthesis was misplaced
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Not sure if you care about this one, it is between #if 0 ... #endif 
> 
> diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
> index 8b22b18..1ae6a02 100644
> --- a/drivers/mtd/nftlmount.c
> +++ b/drivers/mtd/nftlmount.c
> @@ -109,7 +109,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
>  
>  		/* Finally reread to check ECC */
>  		if ((ret = mtd->read(mtd, block * nftl->EraseSize, SECTORSIZE,
> -				     &retlen, buf) < 0)) {
> +				     &retlen, buf)) < 0) {
>  			printk(KERN_NOTICE "ANAND header found at 0x%x in mtd%d, but ECC read failed (err %d)\n",
>  			       block * nftl->EraseSize, nftl->mbd.mtd->index, ret);
>  			continue;

Pushed both patches to my l2-mtd-2.6.git / master.
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

