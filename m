Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXIXTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXIXTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbXIXTNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:13:37 -0400
Received: from www.osadl.org ([213.239.205.134]:55908 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752148AbXIXTNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:13:36 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709242111.07806.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709241718.23526.rjw@sisk.pl> <1190652380.4035.236.camel@chaos>
	 <200709242111.07806.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 21:13:32 +0200
Message-Id: <1190661212.4035.242.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> > /me scratches head
> 
> Retested.
> 
> > We know, that
> > - disabling local apic timers work
> 
> This works reproducibly accross the board.

Ok

> > - local apic timers (which turn off PIT) work. when noacpiFSCKEDPARSING
> 
> This stopped working, although it evidently worked yesterday (wtf?).
> 
> There seems to be a history effect in the box, to make things more
> "interesting".

Did you connect this box to Andrews VAIO during KS ?

> I think the only solid data point so far is that "noapictimer" makes the box
> boot.

Ok. Can you add "nmi_watchdog=1" to the command line please. This runs
through the calibration of APIC, but registers it as a dummy clock
source (the PIT must run to make the watchdog work).

If it boots, please provide the output of /proc/timer_list

Thanks,	

	tlgx


