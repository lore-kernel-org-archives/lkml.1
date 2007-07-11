Return-Path: <linux-kernel-owner+w=401wt.eu-S1765825AbXGKXDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765825AbXGKXDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXGKXDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:03:44 -0400
Received: from www.osadl.org ([213.239.205.134]:58170 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757409AbXGKXDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:03:44 -0400
Subject: generic clockevents/ (hr)time(r) patches was Re: -mm merge plans
	for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 01:03:28 +0200
Message-Id: <1184195008.12353.182.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Linus, 

On Tue, 2007-07-10 at 01:31 -0700, Andrew Morton wrote:
> When replying, please rewrite the subject suitably and try to Cc: the
> appropriate developer(s).

> i386-hpet-check-if-the-counter-works.patch
> nohz-fix-nohz-x86-dyntick-idle-handling.patch
> acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
> clockevents-fix-typo-in-acpi_pmc.patch
> timekeeping-fixup-shadow-variable-argument.patch
> timerc-cleanup-recently-introduced-whitespace-damage.patch
> clockevents-remove-prototypes-of-removed-functions.patch
> clockevents-fix-resume-logic.patch
> clockevents-fix-device-replacement.patch
> tick-management-spread-timer-interrupt.patch
> highres-improve-debug-output.patch
> hrtimer-speedup-hrtimer_enqueue.patch
> pcspkr-use-the-global-pit-lock.patch
> ntp-move-the-cmos-update-code-into-ntpc.patch
> i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
> i386-remove-volatile-in-apicc.patch
> i386-hpet-assumes-boot-cpu-is-0.patch
> i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch

These got sent to Andi as well, but the patches are independent of the
x86_64 conversion.

These are bugfixes (nohz-fix-nohz-x86-dyntick-idle-handling.patch) and
general improvements of the core code and the existing i386 code.

Can we please merge the above now ?

I can resend them or setup a git repo if you want.

Andi, any objections against the above i386 fixlets ?

Thanks,

	tglx


