Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYIKQjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYIKQjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIKQi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:38:57 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40939 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIKQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:38:57 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080911134042.GB3293@kroah.com>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com>  <20080911134042.GB3293@kroah.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:39:25 +0200
Message-Id: <1221151165.6309.55.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > > > This isn't compatible with the version of udev that people actually have
> > > > installed, today. And it's also the _wrong_ thing to do.
> > > > 
> > > > Firmware really _isn't_ version-specific.
> > > 
> > > Tell that to every Debian and Debian derived system on the planet.
> > > 
> > > To my knowledge, it is only fedora and possibly one or two other dists
> > > that put the firmware files in a unary /lib/firmware location, rather
> > > than a versioned /lib/firmware/$KERNELRELASE one.
> > 
> > We (Mandriva Linux) do too.
> > Why other distro cannot package firmware separatly for all their kernel
> > flavors?
> > 
> > Firmware are not version-specific.
> 
> Yes it is, when it is bundled with the kernel source tree itself.
> 
> Why do people not realize this?
> 
> This is a real problem for distros, and for anyone who wants to have
> multiple kernel versions on a single machine.  Jeff's patch fixes this.

once you move the firmware into its own package built from a separate
source tree (and not the kernel) this is no longer a problem.

Nobody ever made the claim that the firmware depends on the kernel
version. It might depend on a specific version of the firmware, but that
is different from the kernel version. If you break the firmware or if a
driver requires a specific firmware version it should indicate this.

And yes, the in-kernel firmware versions should follow here at some
point, since the external firmware versions had to do it already for
quite some time, because otherwise more people would have complained
loudly when installing their own kernels.

What is wrong with moving the firmware into its own package with its own
version number?

Regards

Marcel


