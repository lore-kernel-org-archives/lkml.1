Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXIXMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXIXMsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXIXMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:48:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47272 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbXIXMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:48:09 -0400
Message-ID: <46F7B1F9.4070501@fr.ibm.com>
Date: Mon, 24 Sep 2007 14:47:53 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c: In function `dasd_eckd_build_cp':
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1181: error: syntax error before "struct"
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `iter' undeclared (first use in this function)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: (Each undeclared identifier is reported only once
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: for each function it appears in.)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `bv' undeclared (first use in this function)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
make[3]: *** [drivers/s390/block/dasd_eckd.o] Error 1
make[2]: *** [drivers/s390/block] Error 2

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 drivers/s390/block/dasd_eckd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c
===================================================================
--- 2.6.23-rc7-mm1.orig/drivers/s390/block/dasd_eckd.c
+++ 2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c
@@ -1176,7 +1176,7 @@ dasd_eckd_build_cp(struct dasd_device * 
        struct LO_eckd_data *LO_data;
        struct dasd_ccw_req *cqr;
        struct ccw1 *ccw;
-       struct req_iterator iter
+       struct req_iterator iter;
        struct bio_vec *bv;
        char *dst;
        unsigned int blksize, blk_per_trk, off;
