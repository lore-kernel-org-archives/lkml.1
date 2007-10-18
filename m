Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXJRP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXJRP2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXJRP0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:26:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24587 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703AbXJRP0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:26:50 -0400
Date: Thu, 18 Oct 2007 17:26:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Emil Medve <Emilian.Medve@Freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] Fix a build error when BLOCK=n
Message-ID: <20071018152645.GC10674@kernel.dk>
References: <1192719329-32066-1-git-send-email-Emilian.Medve@Freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192719329-32066-1-git-send-email-Emilian.Medve@Freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Emil Medve wrote:
> mm/filemap.c: In function '__filemap_fdatawrite_range':
> mm/filemap.c:200: error: implicit declaration of function 'mapping_cap_writeback_dirty'
> 
> This happens when we don't use/have any block devices and a NFS root filesystem
> is used
> 
> mapping_cap_writeback_dirty() is defined in linux/backing-dev.h which used to be
> provided in mm/filemap.c by linux/blkdev.h until commit
> f5ff8422bbdd59f8c1f699df248e1b7a11073027
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

