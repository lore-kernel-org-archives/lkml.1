Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXGQMLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXGQMLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXGQMKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:10:53 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1142 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbXGQMKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:10:52 -0400
Date: Tue, 17 Jul 2007 14:10:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Don't define empty struct bsg_class_device if
	!CONFIG_BLK_DEV_BSG  (was: Re: block/bsg.c)
Message-ID: <20070717121017.GS5195@kernel.dk>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org> <Pine.LNX.4.62.0707171359110.29326@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707171359110.29326@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17 2007, Geert Uytterhoeven wrote:
> Don't define an empty struct bsg_class_device if !CONFIG_BLK_DEV_BSG.
> 
> It's embedded in struct request_queue, but there we have
> 
> #if defined(CONFIG_BLK_DEV_BSG)
> 	struct bsg_class_device bsg_dev;
> #endif
> 
> anyway.

Thanks, applied.

-- 
Jens Axboe

