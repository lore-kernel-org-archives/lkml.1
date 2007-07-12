Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXGLOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXGLOtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbXGLOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:49:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3880 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755084AbXGLOte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:49:34 -0400
Date: Thu, 12 Jul 2007 14:49:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Message-ID: <20070712144912.GA4987@ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <4695C096.5080400@goop.org> <Pine.LNX.4.64.0707112319550.28090@asgard.lang.hm> <200707121446.14170.rjw@sisk.pl> <469631FA.2070405@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469631FA.2070405@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And the complexity and difficulty of setup really scares 
> me.
> Right now, we've got a pretty good/fast in-kernel (well, 
> external patch)
> that allows my machines to hibernate very quickly, wake 
> up even faster,
> and not swap like mad afterwards.  Without any external 
> programs,
> initramfs, or extra kernels required.
> 
> And we want to replace this with an ultra-complex setup 
> because.. ????

...freezer does not work with fuse :-). Or more exactly because
freezer is ugly, and we don't know how to get rid of it...

(Not that I advocate kexec-based hibernation. I think it is going to
suck. But it might allow kdump-but-keep-running, so work is not
wasted).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
