Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXEORVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXEORVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXEORVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:21:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20331 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbXEORVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:21:23 -0400
Date: Tue, 15 May 2007 19:20:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070515172001.GB23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk> <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15 2007, Badari Pulavarty wrote:
> On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > Hi,
> > 
> > Updated version of the patch - this time I'll just attach the patch
> > file...
> 
> Missing scatterlist.h inclusions..
> 
> drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> of function ???for_each_sg???
> drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> token
> drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> 
> 
> drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> function ???for_each_sg???
> drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> token

Thanks, will fix those. What arch? I tested it here.

-- 
Jens Axboe

