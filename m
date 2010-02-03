Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab0BCQZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:25:31 -0500
Received: from smtp.nokia.com ([192.100.122.230]:23773 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0BCQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:25:27 -0500
Subject: Re: [PATCH] mtd: hot spin and code duplication in
 nand_bcm_umi_bch_read_oobEcc()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Leo Chen <leochen@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
       linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B5A172C.2010609@gmail.com>
References: <4B5A172C.2010609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 18:22:55 +0200
Message-ID: <1265214175.7343.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Feb 2010 16:24:39.0678 (UTC) FILETIME=[624B31E0:01CAA4ED]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 22:22 +0100, Roel Kluin wrote:
> In the branch where pagesize equalled NAND_DATA_ACCESS_SIZE, NumToRead
> wasn't decremented in the `while (numToRead > 11)' loop.
> Also the first and last while loops were duplicated in both branches.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/mtd/nand/nand_bcm_umi.h |   71 ++++++++++++++-------------------------
>  1 files changed, 25 insertions(+), 46 deletions(-)

Taken to l2-mtd-2.6.git / dunno

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

