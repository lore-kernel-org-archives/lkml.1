Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0BABKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:10:13 -0500
Received: from ozlabs.org ([203.10.76.45]:44298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab0BABKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:10:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: add block topology support
Date: Mon, 1 Feb 2010 11:40:05 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au> <20100130201910.GA19811@lst.de>
In-Reply-To: <20100130201910.GA19811@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002011140.05761.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010 06:49:10 am Christoph Hellwig wrote:
> On Sat, Jan 30, 2010 at 03:29:49PM +1030, Rusty Russell wrote:
> > I bow to your expertise on that.  My only query is the __u16 for min_io_size; is that likely to restrict us?
> 
> Looks like you caught me there - I wrote the above odd format about the
> physical_block exponent, but scsi actually does the min_io and opt_io
> size in logical blocks, too.  With that in account the u16 as in scsi
> is perfectly fine.

Thanks, applied.

Rusty.
