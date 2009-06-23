Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZFWHNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZFWHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZFWHNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:13:12 -0400
Received: from ozlabs.org ([203.10.76.45]:59888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbZFWHNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:13:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: ioctl return value fix
Date: Tue, 23 Jun 2009 16:43:10 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090620192941.GA26873@lst.de>
In-Reply-To: <20090620192941.GA26873@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231643.10623.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009 04:59:41 am Christoph Hellwig wrote:
> Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
> they expect the block layer to handle generic ioctls.
>
> This triggered a BLKROSET failure in xfsqa #200.

Applied.

Thanks,
Rusty.
