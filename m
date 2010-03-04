Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0CDTB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:01:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab0CDTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:01:25 -0500
Date: Thu, 4 Mar 2010 11:01:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003041056400.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org>
 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Linus Torvalds wrote:
> 
> But none of that changes my basic objections. I didn't ask for nouveau to 
> be merged as staging - I asked it to be merged because a major distro uses 
> it.

Put another way: the issue of whether _I_ happen to see this personally or 
not is kind of irrelevant. We need testers for development kernels. And 
any time we make that hard, we lose. That's really fundamental.

The reason distributions should push their drivers upstream, and have a 
"upstream first" model in the first place is not because of _my_ hardware. 
It's because of the fundamental fact that if people can't test upstream 
kernels (because they don't work like the distro kernel does), we end up 
in a situations where people can't sanely test current git.

And that model simply doesn't work from a development standpoint. If you 
make it basically impossible for people to upgrade kernels, and if you 
take away their ability to bisect bugs, you're going to cause the quality 
of development to go down.

			Linus
