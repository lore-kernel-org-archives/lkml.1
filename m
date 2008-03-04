Return-Path: <linux-kernel-owner+w=401wt.eu-S1763821AbYCDKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763821AbYCDKeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYCDKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:34:04 -0500
Received: from the.earth.li ([217.147.81.2]:53884 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbYCDKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:34:03 -0500
Date: Tue, 4 Mar 2008 10:33:55 +0000
From: Jonathan McDowell <noodles@earth.li>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, xorg-driver-ati@lists.x.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Message-ID: <20080304103355.GY9009@earth.li>
References: <20080301193511.GP9009@earth.li> <20080303224830.28e98b2b.akpm@linux-foundation.org> <alpine.DEB.0.82.0803040816180.24971@skynet.skynet.ie> <20080304085155.GX9009@earth.li> <20080304011332.639a0551.akpm@linux-foundation.org> <alpine.DEB.0.82.0803040919370.22945@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0803040919370.22945@skynet.skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 09:24:08AM +0000, Dave Airlie wrote:
> > > results in a machine that boots to GDM successfully. Likewise if I
> > > disable CONFIG_DRM_RADEON in 2.6.25-rc3 the machine boots to GDM
> > > ok.
> > 
> > is what we wanted to know, thanks.  Surely it's a plain old
> > regression?
> 
> Nope, its a userspace driver problem.. we have not released
> non-experimental code for that chipset, so its not surprising it fails
> when the kernel code gets run, but the fix most likely is in userspace
> not in the kernel.
> 
> I could disable the userspace DRI code but then where would I find my
> testers .. if he reads his Xorg log it says DRI is experimental on
> rs690 and not to come crying..

If you accuse your testers of coming crying when they report issues then
you'll find less of them bother coming forward. I've worked round the
problem locally by disabling the kernel DRM support and was reporting
the issue:

*) So that other people would know there was a problem and might be able
   to avoid it.

and 

*) In case there was anything I could try out that might help to get the
   problem fixed going forward.

I understand the support for the RS690 is experimental; I'm very pleased
to see it at all in the Free xorg driver. I've also been able to ditch
the fglrx driver on my work machine (which has an X1300 running dual
head). Please don't think I'm unappreciative of your work; if I was I
wouldn't have bothered trying to improve things by reporting my issue.

(I can make the X server crash by trying to use Xv as well; I assume
there's no point in reporting that somewhere?)
 
> this is the problem with adding new chipsets, I either wait for 6
> months for all the bugs to get kicked out so nobody wins, or I push it
> upstream so most people win, I could back this out of the kernel, but
> experimental userspace code isn't a reason for this..

Perhaps rather than just automatically enabling the new experimental
support in the kernel there needs to be a CONFIG_DRM_RADEON_EXPERIMENTAL
option or similar to enable support for chipsets that aren't believed to
be stable?

J.

-- 
/-\                             |  I'm from the government. I'm here
|@/  Debian GNU/Linux Developer |            to help you.
\-                              |
