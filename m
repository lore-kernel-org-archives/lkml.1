Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXISXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXISXxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXISXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:53:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbXISXxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:53:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Thu, 20 Sep 2007 02:06:20 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709191944.22383.rjw@sisk.pl> <1190229690.2975.4.camel@chaos>
In-Reply-To: <1190229690.2975.4.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709200206.20992.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 September 2007 21:21, Thomas Gleixner wrote:
> On Wed, 2007-09-19 at 19:44 +0200, Rafael J. Wysocki wrote:
> > > > It boots with nohpet alone and suspend/hibernation seem to work (still,
> > > > it didn't want to boot right after hibernation, but booted after I'd switched
> > > > it off/on manually).
> > > 
> > > Can you please check, whether
> > > 
> > > http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch
> > > 
> > > works for you ?
> > 
> > Nope.  It's a total disaster. :-(
> 
> True. I have instrumented it to the point where the broadcast device is
> programmed, but no interrupt comes in for totally unknown reasons.
> 
> > Doesn't boot at all, even with "noacpitimer nohpet", and that's with
> > NO_HZ and HIGH_RES_TIMERS unset.
> 
> > If you have a bisectable patch series, I can try to identify the responsible
> > patch.
> 
> http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patches.tar.bz2
> 
> The first patches in the queue are the mainline fixups.

It's x86_64-convert-to-clockevents.patch (ie. after applying it the box stops
to boot).

I haven't had the time to check if any special command line arguments help.
Will check tomorrow.

Greetings,
Rafael
