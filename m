Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0CDTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:25:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33899 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab0CDTZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:25:26 -0500
Date: Thu, 4 Mar 2010 19:25:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304192524.GA24253@srcf.ucam.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain> <20100304190450.GA23807@srcf.ucam.org> <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:14:11AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 4 Mar 2010, Matthew Garrett wrote:
> > 
> > If you'd made it clear that you wanted the interface to be stable 
> > before it got merged, I suspect that it simply wouldn't have been merged 
> > until the interface was stable.
> 
> What kind of excuse is that? It's "we did bad things, but if we didn't do 
> those bad things, we'd have done _other_ bad things"?
> 
> Two wrong choices don't make a right.
> 
> Nobody has even answered me whether this is _forwards_compatible. It 
> clearly isn't backwards-compatible. IOW, is there _any_ way to move 
> back-and-forth over that commit, even if I can find a new libdrm?

Judging by 
http://cgit.freedesktop.org/mesa/drm/commit/?id=b496c63143e9a4ca02011582329bce2df99d9b7c 
, no. And if you're unhappy with that, don't use the driver. You enabled 
an option that's *documented* as potentially breaking between kernel 
releases, having been told that this was likely to happen, and now 
you're complaining?

> IOW, we know we have a problem here. But what's the solution? I know I can 
> revert it (I tried, I'm running that kernel now, nouveau works). That's 
> not a good solution, I know. But can you offer me a _better_ one? One that 
> doesn't involve "upgrade all the way to rawhide, and lose the ability to 
> bisect anything, or run plain 2.6.33".

Running -nv ought to be an option.

> So yes, I'm complaining. But I at least have mentioned one solution. You, 
> in contast, are just making excuses with no solutions.

You're asking volunteers who didn't ask for their driver to be merged to 
perform more work in order to support users they didn't ask for.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
