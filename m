Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYFFKgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYFFKgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYFFKgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:36:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9626 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYFFKgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:36:20 -0400
Date: Fri, 6 Jun 2008 12:36:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anil kumar <anils_r@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: blk_queue_hardsect_size 520-byte sector
Message-ID: <20080606103616.GO5757@kernel.dk>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com> <20080606075432.GH5757@kernel.dk> <20080606111807.44d0be02@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606111807.44d0be02@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06 2008, Alan Cox wrote:
> On Fri, 6 Jun 2008 09:54:33 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Jun 05 2008, Anil kumar wrote:
> > > Hi,
> > > 
> > > Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> > > as hardware sector size.  How does the kernel and block layers take
> > > the request, will it be in multiples of 520-bytes aligned or 512 bytes
> > > aligned?
> > 
> > No, Linux only supports power-of-2 hardware block sizes I'm afraid.
> 
> And only some of those - which is why we can't support CP/M disks and
> also early smartmedia stuff (128/256 byte/sector)

Right, should've made that clearer - Linux only really supports
power-of-2 hw block sizes, where the size is >= 512 and <=
PAGE_CACHE_SIZE.

-- 
Jens Axboe

