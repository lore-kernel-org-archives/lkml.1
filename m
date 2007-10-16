Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbXJPQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbXJPQ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXJPQ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:58:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14012 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbXJPQ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:58:37 -0400
Date: Tue, 16 Oct 2007 18:58:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: ioctl32: Unknown cmd
Message-ID: <20071016165833.GB9942@kernel.dk>
References: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Geert Uytterhoeven wrote:
> 	Hi Arnd, Jens,
> 
> The recent (post 2.6.23) changes to compat_ioctl made the reporting of
> unsupported ioctls more verbose. E.g. on the PS3 I get:
> 
> | ioctl32(cdrom_id:608): Unknown cmd fd(3) cmd(00005331){t:'S';sz:0} arg(00000000) on /dev/.tmp-11-0
> | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> 
> The first one is triggered by the detection of the CD/DVD/BD-ROM driver,
> The others are triggered by me running hdparm.
> 
> Was this intentional?

Nope, not intential to me at least. I'll check up on it.

-- 
Jens Axboe

