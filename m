Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYK2AVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYK2AVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 19:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYK2AVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 19:21:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYK2AVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 19:21:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm fixes for 2.6.28 final
Date: Sat, 29 Nov 2008 01:20:35 +0100
User-Agent: KMail/1.9.9
Cc: dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
References: <alpine.DEB.2.00.0811280325110.25353@skynet.skynet.ie> <200811272119.54619.jbarnes@virtuousgeek.org>
In-Reply-To: <200811272119.54619.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811290120.35851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of November 2008, Jesse Barnes wrote:
> On Thursday, November 27, 2008 7:26 pm Dave Airlie wrote:
> > Hi Linus,
> >
> > Please pull the 'drm-fixes' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> > drm-fixes
> >
> > This larger than we wished patch, fixes a number of regressions reported.
> >
> > 1. vblank rework causes hangs on VT switch - fixes touches all drivers.
> 
> To clarify here, only one userspace driver was actually silly enough to 
> disable IRQs at VT leave time, xf86-video-intel.  But the DRM fix applies to 
> all drivers just to be on the safe side.  It's a bit invasive, but ultimately 
> a bit safer than leaving things.

The patches from this push fix suspend on the Toshiba Portege R500, but
resume from hibernation is still broken.  It works in the minimal configuration
(init=/bin/bash) 100% of the time.  It also sort of works from the console, but
then the second attempt to hibernate fails because some tasks cannot be
frozen.

2.6.27.7 hibernates and resumes on the same box 100% of the time, from X too.

I'll carry out bisection in the next few days.

Thanks,
Rafael
