Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXDTFez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXDTFez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422916AbXDTFez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:34:55 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:47463
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422889AbXDTFey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:34:54 -0400
Date: Thu, 19 Apr 2007 22:34:12 -0700
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070420053412.GA628@gnuppy.monkey.org>
References: <20070417062621.GL2986@holomorphy.com> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com> <200704200856.06387.kernel@kolivas.org> <f2b55d220704191720k761ffce2qa8cdb4cb58cc8c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220704191720k761ffce2qa8cdb4cb58cc8c79@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 05:20:53PM -0700, Michael K. Edwards wrote:
> Embedded systems are already in 2007, and the mainline Linux scheduler
> frankly sucks on them, because it thinks it's back in the 1960's with
> a fixed supply and captive demand, pissing away "CPU bandwidth" as
> waste heat.  Not to say it's an easy problem; even academics with a
> dozen publications in this area don't seem to be able to model energy
> usage to the nearest big O, let alone design a stable economic
> dispatch engine.  But it helps to acknowledge what the problem is:
> even in a 1960's raised-floor screaming-air-conditioners
> screw-the-power-bill machine room, you can't actually run a
> half-decent CPU flat out any more without burning it to a crisp.
> stupid.  What's your excuse?  ;-)

It's now possible to QoS significant parts of the kernel since we now
have a deadline mechanism in place. In the original 2.4 kernel, TimeSys's
irq-thread allowed for the processing of skbuffs in a thread under a CPU
reservation run category which was use to provide QoS I believe. This
basic mechanish can now be generalized to many place in the kernel and
put it under scheduler control.

It's just a matter of who and when somebody is going take on this task.

bill

