Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZFWHM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZFWHM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZFWHMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:12:53 -0400
Received: from ozlabs.org ([203.10.76.45]:59874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZFWHMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:12:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: don't bounce highmem requests
Date: Tue, 23 Jun 2009 16:42:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090619182022.GA10999@lst.de> <20090620183215.GA24936@lst.de>
In-Reply-To: <20090620183215.GA24936@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231642.52848.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009 04:02:15 am Christoph Hellwig wrote:
> Looks like I sent a patch that doesn't actually compile because qui
> decided to apply those fixes to a different one.  Here's the correc
> one:
>
> --
>
> Subject: virtio_blk: don't bounce highmem requests
> From: Christoph Hellwig <hch@lst.de>
>
> By default a block driver bounces highmem requests, but virtio-blk is
> perfectly fine with any request that fit into it's 64 bit addressing
> scheme, mapped in the kernel virtual space or not.

Thanks, applied.

I had no idea we had to set a bounce limit; wonder what else the driver 
doesn't do?

Thanks,
Rusty.
