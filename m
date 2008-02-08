Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYBHVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYBHVLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYBHVLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:11:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYBHVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:11:11 -0500
Date: Fri, 8 Feb 2008 13:10:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: g.liakhovetski@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/scatterlist.o needed by a module only - link it in
  unconditionally
Message-Id: <20080208131020.7086ce1d.akpm@linux-foundation.org>
In-Reply-To: <20080208204611.GE23197@kernel.dk>
References: <Pine.LNX.4.64.0802081930590.8364@axis700.grange>
	<20080208204611.GE23197@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 21:46:11 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Feb 08 2008, Guennadi Liakhovetski wrote:
> > lib/scatterlist.c is needed by drivers/media/video/videobuf-dma-sg.c, and 
> > we would like to be able to use the latter without PCI too, for example, 
> > on PXA270 ARM CPU. It is then possible to create a configuration with 
> > CONFIG_BLOCK=n, where only module code will need scatterlist.c. Therefore 
> > it must be in obj-y.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Andrew, can I ask you to take care of this?

sure..
