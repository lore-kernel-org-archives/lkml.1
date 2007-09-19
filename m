Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbXISTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbXISTVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXISTVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:21:33 -0400
Received: from www.osadl.org ([213.239.205.134]:51464 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027AbXISTVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:21:32 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <200709191944.22383.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709182337.12695.rjw@sisk.pl> <1190185560.2995.129.camel@chaos>
	 <200709191944.22383.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 21:21:30 +0200
Message-Id: <1190229690.2975.4.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 19:44 +0200, Rafael J. Wysocki wrote:
> > > It boots with nohpet alone and suspend/hibernation seem to work (still,
> > > it didn't want to boot right after hibernation, but booted after I'd switched
> > > it off/on manually).
> > 
> > Can you please check, whether
> > 
> > http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch
> > 
> > works for you ?
> 
> Nope.  It's a total disaster. :-(

True. I have instrumented it to the point where the broadcast device is
programmed, but no interrupt comes in for totally unknown reasons.

> Doesn't boot at all, even with "noacpitimer nohpet", and that's with
> NO_HZ and HIGH_RES_TIMERS unset.

> If you have a bisectable patch series, I can try to identify the responsible
> patch.

http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patches.tar.bz2

The first patches in the queue are the mainline fixups.

	tglx


