Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXIZIcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXIZIcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXIZIbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:31:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbXIZIbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:31:51 -0400
Date: Wed, 26 Sep 2007 10:31:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: [PATCH] x86-64: Disable local APIC timer use on AMD systems
	with C1E
Message-ID: <20070926083107.GB10713@elte.hu>
References: <1190749021.17409.35.camel@chaos> <200709252255.06039.rjw@sisk.pl> <1190753706.17409.64.camel@chaos> <200709252332.41710.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709252332.41710.rjw@sisk.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Tuesday, 25 September 2007 22:55, Thomas Gleixner wrote:
> > On Tue, 2007-09-25 at 22:55 +0200, Rafael J. Wysocki wrote:
> > > I have reworked the patch a bit so that it applies on top of 2.6.23-rc8-mm1
> > > and compiles (my version is attached).
> > > 
> > > With this patch applied, the kernel boots correctly on the nx6325.
> > 
> > I know. It's basically enforced "noapictimer". 
> > 
> > But this still does not explain why your nasty box booted current
> > mainline with "apicmaintimer" on the kernel command line.
> 
> Now it doesn't do that any more.
> 
> As I wrote in the other thread, I think that _sometimes_ the CPU 
> doesn't enter the C1E state (or how it's called) and then the box 
> boots and works.

Can you see any correlation between being on AC or on battery and this 
bug occuring? Sometimes the BIOS might even do C states depending on 
whether the box was booted up on AC or on battery. (and sometimes the 
kernel calibrates things differently when booting up on battery [lower 
speed] - so this can have an effect too.)

	Ingo
