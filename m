Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXDHXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXDHXKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 19:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXDHXKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 19:10:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXDHXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 19:10:23 -0400
Date: Sun, 8 Apr 2007 16:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.21-rc6
Message-Id: <20070408160954.edd248d1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 19:50:11 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Ok,
>  I don't think there really is anything very interesting here, but we're 
> hopefully whittling down the list of regressions, and fixing various 
> random other small issues while at it.
> 
> Some smallish MIPS updates, networking (and network driver) fixes, removal 
> of a long obsolete framebuffer driver, etc etc. The shortlog really tells 
> the story.
> 
> We should be getting close to a 2.6.21 release, so please update any 
> regression reports you've done,
> 

I'm sitting on five patches which look like 2.6.21 material, but which
would normally go through subsystem maintainers:

pcmcia:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/fix-hotplug-for-legacy-platform-drivers.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/fix-hotplug-for-legacy-platform-drivers-update.patch

driver core:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/update-documentation-driver-model-platformtxt.patch

netdev:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/forcedeth-work-around-null-skb-dereference-crash.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/depcac-fix-handling-of-platorm_device_add-failure.patch

net:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/pktgen-add-try_to_freeze.patch

please send acks, nacks or smacks asap, thanks.
