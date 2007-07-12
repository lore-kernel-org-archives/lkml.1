Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbXGLOQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbXGLOQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXGLOQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:16:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4627 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763731AbXGLOQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:16:22 -0400
Date: Thu, 12 Jul 2007 14:06:59 +0000
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec	base	hibernation
Message-ID: <20070712140658.GA3881@ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <20070711172243.ab44c4d4.akpm@linux-foundation.org> <1184251423.9346.55.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm> <1184260683.9346.91.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Maybe my usage of terminology has some problem. But, 
> >the "device
> >hibernate" here means put device into quiescent state 
> >and save the
> >device state, but do not put device into low power 
> >state.
> 
> is there really enough savings (in time or otherwise) to 
> make it worth splitting this into two steps? for 

Yep.

> but I suspect that the number of drivers where this is 
> worth doing is relativly small, and it may be a better 
> approach to start off with just putting everything into 
> the low-power state until some drive shows up that makes 
> it worth adding the intermediate state to the system 

We have had this flamewar before, and linus decided 'snapshot' and
'suspend' are different operations - and he's right. Disk takes 10
seconds to suspend/resume (spindown).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
