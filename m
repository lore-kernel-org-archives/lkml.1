Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbZGIMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbZGIMs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbZGIMsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:48:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbZGIMsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:48:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: ioctl return value fix
Date: Thu, 9 Jul 2009 22:18:38 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090620192941.GA26873@lst.de> <200906231643.10623.rusty@rustcorp.com.au> <20090708181220.GB10552@lst.de>
In-Reply-To: <20090708181220.GB10552@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907092218.39209.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 03:42:20 am Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 04:43:10PM +0930, Rusty Russell wrote:
> > On Sun, 21 Jun 2009 04:59:41 am Christoph Hellwig wrote:
> > > Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
> > > they expect the block layer to handle generic ioctls.
> > >
> > > This triggered a BLKROSET failure in xfsqa #200.
> >
> > Applied.
>
> Can you send on this fix to Linus?  It fixes a regression introduced in
> Linux 2.6.30.

Yep, I've been away, but they'll both be pushed soon with other (minor) 
lguest/virtio fixes.  I'm holding on a final lguest regression which I need to 
track down.

Thanks,
Rusty.
