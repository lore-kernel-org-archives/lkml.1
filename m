Return-Path: <linux-kernel-owner+w=401wt.eu-S936502AbXGLAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936502AbXGLAKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936776AbXGKX6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:58:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936774AbXGKX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:58:37 -0400
Date: Wed, 11 Jul 2007 16:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: generic clockevents/ (hr)time(r) patches was Re: -mm merge
 plans for 2.6.23
Message-Id: <20070711165751.b703f003.akpm@linux-foundation.org>
In-Reply-To: <1184195008.12353.182.camel@chaos>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<1184195008.12353.182.camel@chaos>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 01:03:28 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> Andrew, Linus, 
> 
> On Tue, 2007-07-10 at 01:31 -0700, Andrew Morton wrote:
> > When replying, please rewrite the subject suitably and try to Cc: the
> > appropriate developer(s).
> 
> > i386-hpet-check-if-the-counter-works.patch
> > nohz-fix-nohz-x86-dyntick-idle-handling.patch
> > acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
> > clockevents-fix-typo-in-acpi_pmc.patch
> > timekeeping-fixup-shadow-variable-argument.patch
> > timerc-cleanup-recently-introduced-whitespace-damage.patch
> > clockevents-remove-prototypes-of-removed-functions.patch
> > clockevents-fix-resume-logic.patch
> > clockevents-fix-device-replacement.patch
> > tick-management-spread-timer-interrupt.patch
> > highres-improve-debug-output.patch
> > hrtimer-speedup-hrtimer_enqueue.patch
> > pcspkr-use-the-global-pit-lock.patch
> > ntp-move-the-cmos-update-code-into-ntpc.patch
> > i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
> > i386-remove-volatile-in-apicc.patch
> > i386-hpet-assumes-boot-cpu-is-0.patch
> > i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
> 
> These got sent to Andi as well, but the patches are independent of the
> x86_64 conversion.
> 
> These are bugfixes (nohz-fix-nohz-x86-dyntick-idle-handling.patch) and
> general improvements of the core code and the existing i386 code.
> 
> Can we please merge the above now ?
> 
> I can resend them or setup a git repo if you want.
> 
> Andi, any objections against the above i386 fixlets ?
> 

They all look pretty innocuous to me.

Could you please take a second look, decide if any of them should also be
in 2.6.22.x and let me know?
