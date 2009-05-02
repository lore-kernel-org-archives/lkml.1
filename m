Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZEBV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZEBV6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZEBV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:57:51 -0400
Received: from kroah.org ([198.145.64.141]:48476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbZEBV5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:57:50 -0400
Date: Sat, 2 May 2009 14:54:34 -0700
From: Greg KH <greg@kroah.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090502215434.GB17622@kroah.com>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org> <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com> <9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com> <9b2b86520905021441r76ba0b73u1ef02b5aa855a02b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520905021441r76ba0b73u1ef02b5aa855a02b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:41:50PM +0100, Alan Jenkins wrote:
> 
> But is read-only so bad?  You just have to copy it over to a tmpfs and
> then mount that on top of /dev.  That's atomic, so it won't interfere
> with parallel early init.

The copy would not be atomic.

> I sympathize, devtmpfs is a really neat hack that does exactly what
> udev needs.  But you have to admit, it doesn't fit in _quite_ as well
> with the kernel status quo.

I disagree, it mirrors exactly what we are doing today from userspace,
which is quite the "status quo" in that distros have been doing that for
years now :)

thanks,

greg k-h
