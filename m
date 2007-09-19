Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbXISHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbXISHGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXISHGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:06:09 -0400
Received: from www.osadl.org ([213.239.205.134]:52745 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044AbXISHGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:06:08 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <200709182337.12695.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709182221.53513.rjw@sisk.pl> <200709182254.55409.rjw@sisk.pl>
	 <200709182337.12695.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 09:06:00 +0200
Message-Id: <1190185560.2995.129.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 23:37 +0200, Rafael J. Wysocki wrote:
> > > > - The Vaio also hangs during resume-from-RAM, due to git-acpi.patch
> > > > 
> > > > - And it hangs during suspend-to-RAM, due to git-acpi.patch
> > 
> > Sorry, I was wrong.
> > 
> > > On my HP nx6325 it only boots with "noacpitimer nohpet" on the command line,
> > > but then it works.
> > 
> > It _sometimes_ boots with "noacpitimer nohpet" and that's if I press the power
> > button for a couple of times during boot (before any messages appear on the
> > console).
> > 
> > > Suspend-to-RAM and hibernation work too. :-) 
> > 
> > No, they don't (I must have booted -rc6 instead of it by mistake, sigh).
> > 
> > > Since 2.6.23-rc4-mm1 only booted with nohpet because of
> > > 
> > > x86_64-convert-to-clockevents.patch
> > > 
> > > I guess that the boot problems with this one result from the same patch.
> > 
> > Not sure any more ...
> > 
> > I'll try to compile it with NO_HZ and HIGH_RES_TIMERS unset.
> 
> OK, in that configuration it's much better.
> 
> It boots with nohpet alone and suspend/hibernation seem to work (still,
> it didn't want to boot right after hibernation, but booted after I'd switched
> it off/on manually).

Can you please check, whether

http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch

works for you ?

	tglx



