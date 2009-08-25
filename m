Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZHYOLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZHYOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZHYOLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:11:42 -0400
Received: from ozlabs.org ([203.10.76.45]:50207 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZHYOLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:11:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Date: Tue, 25 Aug 2009 23:41:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090820205616.GA5503@lst.de>
In-Reply-To: <20090820205616.GA5503@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908252341.38356.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 06:26:16 am Christoph Hellwig wrote:
> Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
> means it does not allow filesystems to use barriers.  But the typical use
> case for virtio-blk is to use a backed that uses synchronous I/O

Really?  Does qemu open with O_SYNC?

I'm definitely no block expert, but this seems strange...
Rusty.
