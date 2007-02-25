Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXBYTse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXBYTse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXBYTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:48:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39995 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXBYTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:48:33 -0500
Date: Sun, 25 Feb 2007 20:48:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 12/14] x86_64 irq: Add constants for the reserved IRQ vectors.
Message-ID: <20070225194817.GB1746@elf.ucw.cz>
References: <m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com> <m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com> <m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com> <m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com> <m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com> <m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com> <m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com> <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> <20070225104327.GF2045@elf.ucw.cz> <m1wt26pjxp.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt26pjxp.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-02-25 04:15:30, Eric W. Biederman wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > Hi!
> >
> >> For the ISA irqs we reserve 16 vectors.  This patch adds constants for
> >> those vectors and modifies the code to use them.  Making the code a
> >> little clearer and making it possible to move these vectors in the future.
> >
> >
> >>  /*
> >>   * Vectors 0x20-0x2f are used for ISA interrupts.
> >>   */
> >> +#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR
> >> +#define IRQ1_VECTOR		IRQ0_VECTOR + 1
> >
> > Maybe IRQ_VECTOR(1) would be similary readable, and would avoid 
> >
> >> +#define IRQ2_VECTOR		IRQ0_VECTOR + 2
> >> +#define IRQ3_VECTOR		IRQ0_VECTOR + 3
> >> +#define IRQ4_VECTOR		IRQ0_VECTOR + 4
> >> +#define IRQ5_VECTOR		IRQ0_VECTOR + 5 
> >> +#define IRQ6_VECTOR		IRQ0_VECTOR + 6
> >> +#define IRQ7_VECTOR		IRQ0_VECTOR + 7
> >> +#define IRQ8_VECTOR		IRQ0_VECTOR + 8
> >> +#define IRQ9_VECTOR		IRQ0_VECTOR + 9
> >> +#define IRQ10_VECTOR		IRQ0_VECTOR + 10
> >> +#define IRQ11_VECTOR		IRQ0_VECTOR + 11
> >> +#define IRQ12_VECTOR		IRQ0_VECTOR + 12
> >> +#define IRQ13_VECTOR		IRQ0_VECTOR + 13
> >> +#define IRQ14_VECTOR		IRQ0_VECTOR + 14
> >> +#define IRQ15_VECTOR		IRQ0_VECTOR + 15
> >
> > ...these defines?
> 
> It would, and mostly I like it.  However, of the 1500+ possible irqs
> exactly 16 have a reserved vector.  IRQ_VECTOR(N) does not convey
> that in fact it conveys the opposite impression.
> 
> So I think the code is more maintainable with the distinct
> definitions.

BUILD_BUG_ON(x > 15) ? ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
