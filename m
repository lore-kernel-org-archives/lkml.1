Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXEYAA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXEYAA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEYAAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:00:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41694 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753519AbXEYAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:00:10 -0400
Date: Fri, 25 May 2007 01:00:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       rmk@arm.linux.kernel.org, spyro@f2s.com, <starvik@axis.com>,
       <ysato@users.sourceforge.jp>, "Luck, Tony" <tony.luck@intel.com>,
       <takata@linux-m32r.org>, chris@zankel.net, <uclinux-v850@lsi.nec.co.jp>,
       kyle@parisc-linux.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
Message-ID: <20070525010028.7ddd3a73@the-village.bc.nu>
In-Reply-To: <20070524134015.e89843db.akpm@linux-foundation.org>
References: <20070523174446.37abfa7a@the-village.bc.nu>
	<Pine.LNX.4.64.0705232117260.10610@anakin>
	<20070523205645.07b03581@the-village.bc.nu>
	<20070524134015.e89843db.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 13:40:15 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Alan, I'm all dazed and confused about these patches:
> 
> arm-enable-arbitary-speed-tty-ioctls-and-split.patch
> arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
> ia64-arbitary-speed-tty-ioctl-support.patch
> xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
> h8300-enable-arbitary-speed-tty-port-setup.patch
> m32r-enable-arbitary-speed-tty-rate-setting.patch
> etrax-enable-arbitary-speed-setting-on-tty-ports.patch
> v850-enable-arbitary-speed-tty-ioctls.patch
> lots-of-architectures-enable-arbitary-speed-tty-support.patch
> 
> are there any interdependencies here, or can the various patches
> go into the various trees in random order without ill effects?

The only ordering requirement is that the patch which adds all the
termios2 structures goes first.

Alan
