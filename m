Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854Ab0A3E7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0A3E7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 23:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194Ab0A3E7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 23:59:52 -0500
Received: from ozlabs.org ([203.10.76.45]:60744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0A3E7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 23:59:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: add block topology support
Date: Sat, 30 Jan 2010 15:29:49 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20100129190158.GA25122@lst.de>
In-Reply-To: <20100129190158.GA25122@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001301529.49848.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 05:31:58 am Christoph Hellwig wrote:
> Allow reading various alignment values from the config page.  This
> allows the guest to much better align I/O requests depending on the
> storage topology.
> 
> Note that the formats for the config values appear a bit messed up,
> but we follow the formats used by ATA and SCSI so they are expected in
> the storage world.

I bow to your expertise on that.  My only query is the __u16 for min_io_size; is that likely to restrict us?

Also, patch seems to be based on a prior one?

>  	/* Use topology information if available */
> -	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_TOPOLOGY,
> +	err = virtio_config_val(vdev, VIRTIO_BLK_F_TOPOLOGY,
> +			offsetof(struct virtio_blk_config, physical_block_exp),
> +			&physical_block_exp);

Thanks,
Rusty.
