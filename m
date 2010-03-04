Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0CDTEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:04:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39710 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0CDTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:04:52 -0500
Date: Thu, 4 Mar 2010 19:04:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304190450.GA23807@srcf.ucam.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:55:57AM -0800, Linus Torvalds wrote:
> On Thu, 4 Mar 2010, Matthew Garrett wrote:
> >
> > When you asked that nouveau was merged, people explicitly told you that 
> > the reason it hadn't been was because the interface was unstable and 
> > userspace would break. You asked that it be merged anyway, and now 
> > you're unhappy because the interface has changed and userspace has 
> > broken?
> 
> How hard is it to understand basic kernel development rules? 
> 
> Nouveau was in Fedora-12. In fact, it was in Fedora-11 too afaik. People 
> can hide behind all the "staging" and "I asked for it" things they like, 
> but that doesn't change simple basic facts: distros should make sure 
> drivers get merged up-stream, and people end up depending on them.

It takes a long time to work out exactly what kind of userspace 
interface you need when the hardware you're dealing with is entirely 
undocumented. The reason it's been shipped in Fedora is that it needs to 
be in front of actual users in order to get any testing at all, and we 
have the manpower to ensure that the dependencies are consistent. But 
most nouveau development isn't handled inside Red Hat, and we're in no 
position to dictate terms to the volunteers who are spending their spare 
time trying to write a useful driver.

> Btw, I'm hoping some of this pain goes away for me, because I expect to 
> get rid of the shitty nVidia card reasonably soon. The fact that my main 
> box had a power supply that literally _required_ a power-sucking-piece- 
> of-sh*t-graphics card has been painful to me.

You'd have hit similar issues if you'd been using Radeon KMS over the 
past couple of releases...

> But none of that changes my basic objections. I didn't ask for nouveau to 
> be merged as staging - I asked it to be merged because a major distro uses 
> it.

It was merged as staging because the interface is unstable, which is 
consistent with staging's Kconfig:

"Please note that these drivers are under heavy development, may or may 
not work, and may contain userspace interfaces that most likely will be 
changed in the near future."

If you'd made it clear that you wanted the interface to be stable 
before it got merged, I suspect that it simply wouldn't have been merged 
until the interface was stable.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
