Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXGBPUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXGBPUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbXGBPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:20:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:54584 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753982AbXGBPUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:20:04 -0400
Date: Mon, 2 Jul 2007 17:20:44 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20070702152044.GA24665@suse.cz>
References: <20070609084800.GR6362@aehallh.com> <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com> <200706120135.06428.dtor@insightbb.com> <20070612054031.GY6362@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612054031.GY6362@aehallh.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 01:40:31AM -0400, Zephaniah E. Hull wrote:
> On Tue, Jun 12, 2007 at 01:35:05AM -0400, Dmitry Torokhov wrote:
> > On Tuesday 12 June 2007 01:23, Zephaniah E. Hull wrote:
> > > On Tue, Jun 12, 2007 at 01:19:59AM -0400, Dmitry Torokhov wrote:
> > > > 
> > > > Like I said I would love if xf86-input-evdev did not grab the
> > > > device at all.
> > > 
> > > We have to disable the legacy input handlers somehow, not doing so
> > > simply isn't an option.
> > 
> > I do not follow. If user's xorg.conf does not use /dev/input/mice and
> > does not use "kbd" driver then grabbing is not required, is it? Now,
> > as far as I understand, lack of hotplug support in X is the main
> > obstacle for removing "mouse" and "kbd" drivers, correct?
> 
> Sadly, not quite.
> 
> The problem is that if the user is not using the mouse and kbd drivers
> at all, but is instead using xf86-input-evdev, and no grabbing is done,
> then all key presses end up going to the console.

X still switches to its own VT, so those keys go to the X server via the
console, and GPM also knows about console switching ...

That is a sane way how to prevent the regular console from getting
keypresses/mouse movements.

-- 
Vojtech Pavlik
Director SuSE Labs
