Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXJWT1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXJWT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXJWT1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:27:41 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:61785 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJWT1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:27:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] Fix a build error when BLOCK=n
Date: Tue, 23 Oct 2007 12:27:26 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27016E5644@az33exm24.fsl.freescale.net>
In-Reply-To: <20071018152645.GC10674@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] Fix a build error when BLOCK=n
Thread-Index: AcgRm1gfH8/A0Ua7R6efVREHR3YufwED1B1g
References: <1192719329-32066-1-git-send-email-Emilian.Medve@Freescale.com> <20071018152645.GC10674@kernel.dk>
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,


In who's tree would this go?


Thanks,
Emil.


> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Thursday, October 18, 2007 10:27 AM
> To: Medve Emilian-EMMEDVE1
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; 
> torvalds@linux-foundation.org
> Subject: Re: [PATCH v2] Fix a build error when BLOCK=n
> 
> On Thu, Oct 18 2007, Emil Medve wrote:
> > mm/filemap.c: In function '__filemap_fdatawrite_range':
> > mm/filemap.c:200: error: implicit declaration of function 
> 'mapping_cap_writeback_dirty'
> > 
> > This happens when we don't use/have any block devices and a 
> NFS root filesystem
> > is used
> > 
> > mapping_cap_writeback_dirty() is defined in 
> linux/backing-dev.h which used to be
> > provided in mm/filemap.c by linux/blkdev.h until commit
> > f5ff8422bbdd59f8c1f699df248e1b7a11073027
> > 
> > Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 
> -- 
> Jens Axboe
