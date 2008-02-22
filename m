Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYBVUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYBVUph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYBVUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:45:28 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:22430 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbYBVUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:45:27 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>, chrisw@sous-sol.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080222195829.GH1409@cs181133002.pp.htv.fi>
References: <20080222195829.GH1409@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 20:44:59 +0000
Message-Id: <1203713099.28436.20.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2.6 patch] make xen-blkfront.c:blkif_getgeo() static
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=cExetjfr-RMA:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=ArjF5IA-KiUmphTZQnYA:9 a=a0yYay3rOJD7XIhjB6gA:7 a=_fmPZyw25pn0lamX99NbMGRIM_AA:4 a=LI9Vle30uBYA:10 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 21:58 +0200, Adrian Bunk wrote:
> This patch makes the needlessly global blkif_getgeo() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Ian Campbell <ijc@hellion.org.uk>

> 
> ---
> 6f34bfdbb8c24e06d982ccaccd24c25dba5b1956 diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9c6f3f9..ae7ee16 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -136,7 +136,7 @@ static void blkif_restart_queue_callback(void *arg)
>  	schedule_work(&info->work);
>  }
>  
> -int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
> +static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
>  {
>  	/* We don't have real geometry info, but let's at least return
>  	   values consistent with the size of the device */
> 
> 
-- 
Ian Campbell

WHERE CAN THE MATTER BE
	Oh, dear, where can the matter be
	When it's converted to energy?
	There is a slight loss of parity.
	Johnny's so long at the fair.

