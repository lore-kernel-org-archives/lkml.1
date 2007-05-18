Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbXERLK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbXERLK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXERLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:10:51 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50804 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbXERLKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:10:50 -0400
Date: Fri, 18 May 2007 13:12:45 +0200
From: DervishD <lkml@dervishd.net>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-storage nice value
Message-ID: <20070518111245.GB4871@DervishD>
Mail-Followup-To: Heikki Orsila <shdl@zakalwe.fi>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070517100308.GA14667@DervishD> <20070518094632.GF10873@zakalwe.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070518094632.GF10873@zakalwe.fi>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Heikki :)

 * Heikki Orsila <shdl@zakalwe.fi> dixit:
> On Thu, May 17, 2007 at 12:03:08PM +0200, DervishD wrote:
> >     I'm having problems when reading/writing to external USB
> >     harddisks: my *internal* harddisk stalls from time to time, so
> >     watching a movie while copying data is a PITA (well, if the
> >     movie is bad, the leaps help a bit...).
> 
> I've had a similar problem that is caused due to USB write caching.
> When a process rapidly writes to a USB device, the whole memory gets
> filled with write cache. When the memory is full of write cache for
> USB, it is very slow to get clean pages as the USB device is slow.
> This stalls the entire system performance.

    I'm not sure if this is my problem, since the external USB disks
seem to be at least as fast as the internal one (I've not noticed the
device to be slow at all). I'm going to use the same sets of disks in
another system that doesn't have an old VIA chipset, to see if the
problem is the PCI-fill one.

    BTW, using "sync" mount option doesn't help: it just makes the data
copying slower, but when the data is burst-written, the internal hard
disk stalls for a bit. The stalls are shorter, though.

> Would it be possible to limit per device write caching to N pages from 
> userspace? Having just 128 MiB of write cache for a USB device would be 
> sufficient for high performance, but yet have plenty of clean pages for 
> other purposes.

    Probably the "dirty_ratio" setting will help, I'm going to test it
this weekend. I don't know if there are a per-device setting to tell how
many pages can be used as cache.

    Thanks for answering :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
