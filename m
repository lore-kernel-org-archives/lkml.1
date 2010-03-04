Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0CDTOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:14:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab0CDTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:14:50 -0500
Date: Thu, 4 Mar 2010 11:14:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304190450.GA23807@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
 <20100304190450.GA23807@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Matthew Garrett wrote:
> 
> If you'd made it clear that you wanted the interface to be stable 
> before it got merged, I suspect that it simply wouldn't have been merged 
> until the interface was stable.

What kind of excuse is that? It's "we did bad things, but if we didn't do 
those bad things, we'd have done _other_ bad things"?

Two wrong choices don't make a right.

Nobody has even answered me whether this is _forwards_compatible. It 
clearly isn't backwards-compatible. IOW, is there _any_ way to move 
back-and-forth over that commit, even if I can find a new libdrm?

IOW, we know we have a problem here. But what's the solution? I know I can 
revert it (I tried, I'm running that kernel now, nouveau works). That's 
not a good solution, I know. But can you offer me a _better_ one? One that 
doesn't involve "upgrade all the way to rawhide, and lose the ability to 
bisect anything, or run plain 2.6.33".

So yes, I'm complaining. But I at least have mentioned one solution. You, 
in contast, are just making excuses with no solutions.

			Linus
