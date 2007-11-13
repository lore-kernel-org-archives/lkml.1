Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbXKMWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbXKMWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763120AbXKMWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:23:27 -0500
Received: from hpsmtp-eml11.KPNXCHANGE.COM ([213.75.38.111]:45746 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763114AbXKMWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:23:26 -0500
From: Frans Pop <elendil@planet.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH revised] enable make ARCH=x86 (and stay backward compatible)
Date: Tue, 13 Nov 2007 23:23:22 +0100
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, david@lang.hm,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
In-Reply-To: <20071112205451.GA22528@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132323.23835.elendil@planet.nl>
X-OriginalArrivalTime: 13 Nov 2007 22:23:24.0121 (UTC) FILETIME=[CE05CC90:01C82643]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007, Sam Ravnborg wrote:
> This revised patchset does the followings things:
> o unify the i386 and x86_64 Kconfig files
> o introduce support for K64BIT to set CONFIG_64BIT on command line
> o introdue support for "make ARCH=x86"
> o degraded ARCH={i386,x86_64} to select between 32/64 for all*targets
>   and otherwise just selecting the x86 architecture
>
> Based on feedback from previous submissions the following have changed:
> - The backwards compatibility links are kept
> - The backwards compatibility ARCH={i386,x86_64} are kept but degraded
>   to select 32/64 bit during configuration for all*config targets.
> - ARCH={i386,x86_64} are not broken by any patches so bisect will
>   not choke

Great! Thanks for being so responsive to comments Sam.

I've just built v2.6.24-rc2-409-g9418d5d + your patchset for both amd64 and 
i386 using Debian's kernel-package and both went without problems.

One (minor) issue. If I start out with a .config for i386, the first make 
oldconfig will ask to set 64-BIT:
    64-bit kernel (64BIT) [N/y/?] (NEW)
It would be nice if that could be avoided somehow.

I'm compiling the 32-bit kernel in an i386 chroot on an x86_64 system.

Cheers,
FJP
