Return-Path: <linux-kernel-owner+w=401wt.eu-S1751337AbXCEBFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbXCEBFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXCEBFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:05:08 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49877 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751126AbXCEBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:05:07 -0500
Date: Mon, 5 Mar 2007 02:05:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Johannes Berg <johannes@sipsolutions.net>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-ID: <20070305010508.GK3441@stusta.de>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070304164525.349f9589.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070304164525.349f9589.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 04:45:25PM -0800, Andrew Morton wrote:
> On Sun, 4 Mar 2007 18:25:50 -0600 Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Mon, Mar 05, 2007 at 12:39:24AM +0100, Johannes Berg wrote:
> > > [adding linux-wireless to CC]
> > > 
> > > On Sun, 2007-03-04 at 16:08 -0600, Matt Mackall wrote:
> > > > Recent kernels are having troubles with wireless for me. Two seemingly
> > > > related problems:
> > > 
> > > I don't think they are related actually.
> > > 
> > > > a) NetworkManager seems oblivious to the existence of my IPW2200
> > > 
> > > This is due to the recent sysfs restructuring I think. IIRC the fix is
> > > to upgrade hal to a current git version.
> > 
> > If that's the cause, the fix is to back out whatever was done to break
> > userspace. Breaking userspace is not ok. Upgrading from 2.6.x to
> > 2.6.x+1 should not entail replacing substantial parts of userspace,
> > especially with NOT-EVEN-FRAKKING-RELEASED-YET CODE. 
> 
> yep.  Adrian, I think we should track this as a blocking regression, at
> least until we've fully understood the implications and had the usual
> arguments.

I'm currently tracking it as one of the 31 2.6.21-rc regressions that 
are not yet fixed in Linus' tree, and for me each of them is a blocker
until proven otherwise.

Whether Linus releases 2.6.21 despite blocking regressions is a 
different question...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

