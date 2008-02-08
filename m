Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYBHUqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYBHUqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYBHUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:46:17 -0500
Received: from brick.kernel.dk ([87.55.233.238]:28301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYBHUqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:46:16 -0500
Date: Fri, 8 Feb 2008 21:46:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/scatterlist.o needed by a module only - link it in  unconditionally
Message-ID: <20080208204611.GE23197@kernel.dk>
References: <Pine.LNX.4.64.0802081930590.8364@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802081930590.8364@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2008, Guennadi Liakhovetski wrote:
> lib/scatterlist.c is needed by drivers/media/video/videobuf-dma-sg.c, and 
> we would like to be able to use the latter without PCI too, for example, 
> on PXA270 ARM CPU. It is then possible to create a configuration with 
> CONFIG_BLOCK=n, where only module code will need scatterlist.c. Therefore 
> it must be in obj-y.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

Andrew, can I ask you to take care of this?

-- 
Jens Axboe

