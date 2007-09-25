Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXIYNCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXIYNCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXIYNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:02:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbXIYNCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:02:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Tue, 25 Sep 2007 15:16:57 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709242111.07806.rjw@sisk.pl> <1190661212.4035.242.camel@chaos>
In-Reply-To: <1190661212.4035.242.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251516.58405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 September 2007 21:13, Thomas Gleixner wrote:
> On Mon, 2007-09-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> > > /me scratches head
> > 
> > Retested.
> > 
> > > We know, that
> > > - disabling local apic timers work
> > 
> > This works reproducibly accross the board.
> 
> Ok
> 
> > > - local apic timers (which turn off PIT) work. when noacpiFSCKEDPARSING
> > 
> > This stopped working, although it evidently worked yesterday (wtf?).
> > 
> > There seems to be a history effect in the box, to make things more
> > "interesting".
> 
> Did you connect this box to Andrews VAIO during KS ?

No, but it's famous for being interestingly broken nevertheless.

> > I think the only solid data point so far is that "noapictimer" makes the box
> > boot.
> 
> Ok. Can you add "nmi_watchdog=1" to the command line please. This runs
> through the calibration of APIC, but registers it as a dummy clock
> source (the PIT must run to make the watchdog work).
> 
> If it boots, please provide the output of /proc/timer_list

No, it doesn't.

Greetings,
Rafael
