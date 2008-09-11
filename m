Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYIKNu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYIKNu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYIKNub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:50:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:58128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYIKNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:50:31 -0400
Date: Thu, 11 Sep 2008 06:40:42 -0700
From: Greg KH <greg@kroah.com>
To: Thierry Vignaud <tvignaud@mandriva.com>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911134042.GB3293@kroah.com>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <m27i9i9az9.fsf@vador.mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m27i9i9az9.fsf@vador.mandriva.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 01:29:46PM +0200, Thierry Vignaud wrote:
> David Miller <davem@davemloft.net> writes:
> 
> > > This isn't compatible with the version of udev that people actually have
> > > installed, today. And it's also the _wrong_ thing to do.
> > > 
> > > Firmware really _isn't_ version-specific.
> > 
> > Tell that to every Debian and Debian derived system on the planet.
> > 
> > To my knowledge, it is only fedora and possibly one or two other dists
> > that put the firmware files in a unary /lib/firmware location, rather
> > than a versioned /lib/firmware/$KERNELRELASE one.
> 
> We (Mandriva Linux) do too.
> Why other distro cannot package firmware separatly for all their kernel
> flavors?
> 
> Firmware are not version-specific.

Yes it is, when it is bundled with the kernel source tree itself.

Why do people not realize this?

This is a real problem for distros, and for anyone who wants to have
multiple kernel versions on a single machine.  Jeff's patch fixes this.

thanks,

greg k-h
