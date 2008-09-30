Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYI3CVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYI3CVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYI3CVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYI3CVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:21:08 -0400
Date: Mon, 29 Sep 2008 19:21:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>  <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>  <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Dave Airlie wrote:
> 
> If it is X related then its both a kernel + X server issue, the e1000e
> driver opens the barn door, the X server drives the horses through it.

Are you sure? There was a mandriva report abou NVM corruption on an e100 
too (that one apparently just caused PXE failure, the networking worked 
fine).

So I wonder if it's _purely_ X-server-related, adn the reason people blame 
2.6.27-rc1 is just timing of some X update and then people just look at 
the kernel beceuse the 'network card failed' looks so kernel-related.

The reason I mention that is right now it looks like the distros are just 
running around disabling the e1000e module, or perhaps downgrading it. 
Which may not even work!

The discussions in some of the bug-trackers seem to be full of people who 
have no actual information, but are perfectly willing to flail around 
wildly saying obviously crazy things.

The Ubuntu people are some of the crazier ones (should I be surprised?), 
but that one also has Ben Collins claiming they use the same e1000e driver 
for the 2.6.26/27 kernels (from intels sf.net project). That may be bogus, 
but if true it would indicate that it's possibly not so kernel-related, or 
at least not so e1000e-driver-related.

		Linus
