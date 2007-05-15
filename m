Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXEORPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXEORPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXEOROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:14:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36027 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbXEOROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:14:53 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070511135108.GF4629@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
Content-Type: text/plain; charset=utf-8
Date: Tue, 15 May 2007 10:15:37 -0700
Message-Id: <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> Hi,
> 
> Updated version of the patch - this time I'll just attach the patch
> file...

Missing scatterlist.h inclusions..

drivers/scsi/sym53c8xx_2/sym_glue.c: In function ‘sym_scatter’:
drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
of function ‘for_each_sg’
drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ‘;’ before ‘{’
token
drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ‘tp’
make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1


drivers/scsi/qla2xxx/qla_iocb.c: In function ‘qla24xx_build_scsi_iocbs’:
drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
function ‘for_each_sg’
drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ‘;’ before ‘{’
token



Thanks,
Badari

