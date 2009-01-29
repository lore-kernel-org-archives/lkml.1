Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZA2RjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZA2RjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZA2Riw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:38:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZA2Riw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:38:52 -0500
Message-ID: <4981E99F.30001@zytor.com>
Date: Thu, 29 Jan 2009 09:38:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jonathan Campbell <jon@nerdgrounds.com>
CC: "Peter W. Morreale" <pmorreale@novell.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com>	 <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site> <4981E7BD.3040507@nerdgrounds.com>
In-Reply-To: <4981E7BD.3040507@nerdgrounds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell wrote:
> Every VGA device connected to the PCI bus has resources that are known
> to the Linux kernel. One of the memory resources is the video RAM
> (always the largest prefetchable resource listed), with the base and
> length known to the PCI subsystem. So, all vramfs needs on mount is the
> PCI device, and the mountpoint, and it can dole it out to userspace.
> Reading and writing is handled with ioremap(). mmap() is handled by
> directly mmaping() that VRAM into user-space (just like /dev/fb0). Files
> are recorded in system memory as a list of entities with a starting
> block and length, so no fragmentation is possible.
> 
> No communication with the GPU is needed to do this, it's possible to use
> VRAM this way even on devices that nobody in the system knows how to
> talk to.

There still seems to be quite a bit of overlap between this and the MTD
subsystem...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

