Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXIXQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXIXQ4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXIXQzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:55:36 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7247 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbXIXQzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:55:35 -0400
Date: Mon, 24 Sep 2007 18:56:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070924165649.GF2367@kernel.dk>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B1F9.4070501@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7B1F9.4070501@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24 2007, Cedric Le Goater wrote:
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> 
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c: In function `dasd_eckd_build_cp':
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1181: error: syntax error before "struct"
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `iter' undeclared (first use in this function)
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: (Each undeclared identifier is reported only once
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: for each function it appears in.)
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `bv' undeclared (first use in this function)
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
> /home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
> make[3]: *** [drivers/s390/block/dasd_eckd.o] Error 1
> make[2]: *** [drivers/s390/block] Error 2
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> ---
>  drivers/s390/block/dasd_eckd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: 2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c
> ===================================================================
> --- 2.6.23-rc7-mm1.orig/drivers/s390/block/dasd_eckd.c
> +++ 2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c
> @@ -1176,7 +1176,7 @@ dasd_eckd_build_cp(struct dasd_device * 
>         struct LO_eckd_data *LO_data;
>         struct dasd_ccw_req *cqr;
>         struct ccw1 *ccw;
> -       struct req_iterator iter
> +       struct req_iterator iter;
>         struct bio_vec *bv;
>         char *dst;
>         unsigned int blksize, blk_per_trk, off;

Oops, looks like neither Neil nor I cross compiled this on s390. Thanks,
I'll apply it.

-- 
Jens Axboe

