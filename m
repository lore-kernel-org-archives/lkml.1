Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbXISRc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbXISRc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762017AbXISRcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:32:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761983AbXISRcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:32:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Wed, 19 Sep 2007 19:44:21 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709182337.12695.rjw@sisk.pl> <1190185560.2995.129.camel@chaos>
In-Reply-To: <1190185560.2995.129.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191944.22383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 September 2007 09:06, Thomas Gleixner wrote:
> On Tue, 2007-09-18 at 23:37 +0200, Rafael J. Wysocki wrote:
> > > > > - The Vaio also hangs during resume-from-RAM, due to git-acpi.patch
> > > > > 
> > > > > - And it hangs during suspend-to-RAM, due to git-acpi.patch
> > > 
> > > Sorry, I was wrong.
> > > 
> > > > On my HP nx6325 it only boots with "noacpitimer nohpet" on the command line,
> > > > but then it works.
> > > 
> > > It _sometimes_ boots with "noacpitimer nohpet" and that's if I press the power
> > > button for a couple of times during boot (before any messages appear on the
> > > console).
> > > 
> > > > Suspend-to-RAM and hibernation work too. :-) 
> > > 
> > > No, they don't (I must have booted -rc6 instead of it by mistake, sigh).
> > > 
> > > > Since 2.6.23-rc4-mm1 only booted with nohpet because of
> > > > 
> > > > x86_64-convert-to-clockevents.patch
> > > > 
> > > > I guess that the boot problems with this one result from the same patch.
> > > 
> > > Not sure any more ...
> > > 
> > > I'll try to compile it with NO_HZ and HIGH_RES_TIMERS unset.
> > 
> > OK, in that configuration it's much better.
> > 
> > It boots with nohpet alone and suspend/hibernation seem to work (still,
> > it didn't want to boot right after hibernation, but booted after I'd switched
> > it off/on manually).
> 
> Can you please check, whether
> 
> http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch
> 
> works for you ?

Nope.  It's a total disaster. :-(

Doesn't boot at all, even with "noacpitimer nohpet", and that's with
NO_HZ and HIGH_RES_TIMERS unset.

If you have a bisectable patch series, I can try to identify the responsible
patch.

Greetings,
Rafael
