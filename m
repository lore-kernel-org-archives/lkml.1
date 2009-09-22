Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZIVGeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZIVGeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZIVGel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:34:41 -0400
Received: from ozlabs.org ([203.10.76.45]:50128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZIVGej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:34:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: add support for cache flush
Date: Tue, 22 Sep 2009 16:04:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090917175742.GA2416@lst.de>
In-Reply-To: <20090917175742.GA2416@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221604.41838.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 03:27:42 am Christoph Hellwig wrote:
> 
> Recent qemu has added a VIRTIO_BLK_F_FLUSH flag to advertise that the
> virtual disk has a volatile write cache that needs to be flushed.  In case
> we see this feature implement tell the Linux block layer about the fact
> and use the new VIRTIO_BLK_T_FLUSH to flush the cache when required.  This
> allows for an correct and simple implementation of write barriers.

Thanks Christoph, this looks very nice.  Applied, will push soon.

> + *   VIRTIO_BLK_T_OUT may be combinaed with VIRTIO_BLK_T_SCSI_CMD or
> + *   VIRTIO_BLK_T_BARRIER.  VIRTIO_BLK_T_FLUSH is a command of it's own
> + *   and may no be comined with any of the other flags.

I fixed the typos here :)

Thanks!
Rusty.
