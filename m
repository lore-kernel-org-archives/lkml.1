Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbZCZRx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbZCZRx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZCZRxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:53:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284AbZCZRxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:53:20 -0400
Date: Thu, 26 Mar 2009 10:51:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3 0/3] new memory_accessor interface and usage
Message-Id: <20090326105137.5bf765e5.akpm@linux-foundation.org>
In-Reply-To: <874oxgi4hp.fsf@deeprootsystems.com>
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
	<200903161610.06469.david-b@pacbell.net>
	<874oxgi4hp.fsf@deeprootsystems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 10:22:10 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:

> David Brownell <david-b@pacbell.net> writes:
> 
> > On Monday 16 March 2009, Kevin Hilman wrote:
> >> This series adds an interface by which other kernel code can read/write
> >> persistent memory such as I2C or SPI EEPROMs, or devices which provide
> >> NVRAM. __Use cases include storage of board-specific configuration data
> >> like Ethernet addresses and sensor calibrations, etc.
> >
> > Looks OK to me.  Once this goes in (with support for I2C and SPI EEPROMs)
> > then various RTC's NVRAM support can be updated too ... at a quick count,
> > that makes nine more drivers that can easily support this.
> >
> > I kind of like letting Linux have the option of using this kind of
> > persistent storage, instead of keeping it so that only bootloaders
> > (and maybe some userspace code) ever touch it.
> 
> Andrew,
> 
> What's the next step for this series?  It's one of those areas that
> doesn't seem to have clear ownership so this seems to be falling
> through the cracks.

I've been mostly-awol for a couple of weeks, sorry.  It's presently
stuck in my backlog queue along with everything else.  I'll start
chewing on that queue next week.

As the patch "is pretty much a blocking issue for merging more complete
DaVinci platform support" I guess we'll be wanting it in 2.6.30, yes?

