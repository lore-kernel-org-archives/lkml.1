Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZAZXhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZAZXhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZAZXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:37:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZAZXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:37:04 -0500
Message-ID: <497E4919.60907@zytor.com>
Date: Mon, 26 Jan 2009 15:36:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Campbell <jon@nerdgrounds.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com>
In-Reply-To: <497E4531.20800@nerdgrounds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell wrote:
> 
> So far I've tested it against 2.6.25.17 and 2.6.28 on both x86 and 
> x86_64 with reads, writes, directory creation, symlink creation, and 
> mmap() and it seems to work fine.
> Just give it a range of memory on the bus, or the 
> domain:bus:device:function numbers of a VGA PCI device, and it will 
> mount the VGA video RAM and allow files to exist there.
> As a special hack: you can also specify the size of the active 
> framebuffer console so that fbcon doesn't collide with this driver 
> (unless you want to see what your files look like splattered across your 
> screen, ha). The active VRAM area becomes a "sentinel" file named 
> "framebuffer".
> 
> What do you guys think?
> 

How is this different from the MTD driver we already have?

	-hpa
