Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZL1UvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZL1UvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZL1UvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:51:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZL1UvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:51:24 -0500
Date: Mon, 28 Dec 2009 21:51:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Tmem [PATCH 0/5] (Take 3): Transcendent memory
Message-ID: <20091228205102.GC1637@ucw.cz>
References: <20091225191848.GB8438@elf.ucw.cz> <f4ab13eb-daaa-40be-82ad-691505b1f169@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4ab13eb-daaa-40be-82ad-691505b1f169@default>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > achive this using
> > > > some existing infrastructure in kernel.
> > > 
> > > Hi Nitin --
> > > 
> > > Sorry if I sounded overly negative... too busy around the holidays.
> > > 
> > > I'm definitely OK with exploring alternatives.  I just think that
> > > existing kernel mechanisms are very firmly rooted in the notion
> > > that either the kernel owns the memory/cache or an asynchronous
> > > device owns it.  Tmem falls somewhere in between and is very
> > 
> > Well... compcache seems to be very similar to preswap: in preswap case
> > you don't know if hypervisor will have space, in ramzswap you don't
> > know if data are compressible.
> 
> Hi Pavel --
> 
> Yes there are definitely similarities too.  In fact, I started
> prototyping preswap (now called frontswap) with Nitin's
> compcache code.  IIRC I ran into some problems with compcache's
> difficulties in dealing with failed "puts" due to dynamic
> changes in size of hypervisor-available-memory.
> 
> Nitin may have addressed this in later versions of ramzswap.

That would be cool to find out.

> One feature of frontswap which is different than ramzswap is
> that frontswap acts as a "fronting store" for all configured
> swap devices, including SAN/NAS swap devices.  It doesn't
> need to be separately configured as a "highest priority" swap
> device.  In many installations and depending on how ramzswap

Ok, I'd call it a bug, not a feature :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
