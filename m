Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZCEGyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZCEGyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 01:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZCEGy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 01:54:27 -0500
Received: from brick.kernel.dk ([93.163.65.50]:42534 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZCEGy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 01:54:26 -0500
Date: Thu, 5 Mar 2009 07:54:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing
	video RAM as block device
Message-ID: <20090305065423.GK11787@kernel.dk>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <1236209255.6696.75.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236209255.6696.75.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05 2009, Benjamin Herrenschmidt wrote:
> On Wed, 2009-03-04 at 14:57 +0100, Geert Uytterhoeven wrote:
> > 	Hi,
> > 
> > Below is the rewrite of the PS3 Video RAM Storage Driver as a plain block
> > device, as requested by Arnd Bergmann.
> > 
> > The MTD-based PS3 Video RAM Storage Driver was integrated into the mainline
> > kernel in 2.6.29-rc1.
> > 
> > Ideally, we think it would be best if the existing MTD-based ps3vram driver
> > would be replaced by the new block-based ps3vram driver before 2.6.29 is
> > released. This would relieve the burden of supporting two different swap space
> > schemes on PS3 (swap on /dev/mtdblock0 vs. /dev/ps3vram) from the distro
> > maintainer's shoulders, as in that case there would never have been a stable
> > kernel version containing the MTD-based ps3vram driver.
> 
> This is very very very late ... we are at rc7, probably one rc before
> final... as much as I like integrating drivers later, I'll ask Linus
> opinion on this one.
> 
> Linus ? What do you reckon ? Maybe a better option is just to remove
> ps3nvram from .29 and merge the new one in .30 ?

It's an isolated driver for a special purpose platform, I would have
zero problems merging it :-)

-- 
Jens Axboe

