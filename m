Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0BBVya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:54:30 -0500
Received: from kroah.org ([198.145.64.141]:58854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0BBVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:54:28 -0500
Date: Tue, 2 Feb 2010 13:18:09 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20100202211809.GB8755@kroah.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.iAC.TwhOLB@chimera>
 <20091229163512.GA4958@ioremap.net>
 <200912292237.54182.rjw@sisk.pl>
 <20091230091433.GU4489@kernel.dk>
 <20100202205743.GA26703@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202205743.GA26703@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 11:57:43PM +0300, Evgeniy Polyakov wrote:
> Hi.
> 
> Sorry, it took really long to catch all the things around, but it is
> better than never.
> 
> History says that commit which introduced per-bdi writeback broke
> pohmelfs, since it does not have backing store device and did not fill
> appropriate superblock entry, which lead to crash on umoount.
> 
> Jens provided a patch below, which I tested to fix the problem.
> There is a problem though, when all writes happend before umount,
> but did net yet written back to storage, get lost. I can not say whether
> this happens because of per-bdi writeback (it should not I think), but
> that's what happens.
> 
> Albeit being a bug, it will not be fixed :)
> The reason is simple, new backing storage for POHMELFS (a distributed
> hash table called elliptics network) is essentially ready and I start
> working on porting POHMELFS to it, which means all its bugs will be
> fixed there^W^Werased and written from scratch.
> 
> Jens, thanks a lot for you patch, Greg please pull it up.
> If you did not find it or can not extract from the reply, I will resend.

Please resend it with a signed-off-by line so that I can apply it.

thanks,

greg k-h
