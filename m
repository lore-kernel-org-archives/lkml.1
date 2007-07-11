Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbXGKU7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbXGKU7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXGKU7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:59:04 -0400
Received: from xenotime.net ([66.160.160.81]:46136 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933590AbXGKU7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:01 -0400
Date: Wed, 11 Jul 2007 14:02:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-Id: <20070711140244.b08ae4d9.rdunlap@xenotime.net>
In-Reply-To: <20070711174252.GA16793@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<p734pkbyuu4.fsf@bingen.suse.de>
	<20070711174252.GA16793@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 19:42:52 +0200 Ingo Molnar wrote:

> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > clockevents-fix-typo-in-acpi_pmc.patch
> > > timekeeping-fixup-shadow-variable-argument.patch
> > > timerc-cleanup-recently-introduced-whitespace-damage.patch
> > > clockevents-remove-prototypes-of-removed-functions.patch
> > > clockevents-fix-resume-logic.patch
> > > clockevents-fix-device-replacement.patch
> > > tick-management-spread-timer-interrupt.patch
> > > highres-improve-debug-output.patch
> > > hrtimer-speedup-hrtimer_enqueue.patch
> > > pcspkr-use-the-global-pit-lock.patch
> > > ntp-move-the-cmos-update-code-into-ntpc.patch
> > > i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
> > > i386-remove-volatile-in-apicc.patch
> > > i386-hpet-assumes-boot-cpu-is-0.patch
> > > i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
> > > x86_64-untangle-asm-hpeth-from-asm-timexh.patch
> > > x86_64-use-generic-cmos-update.patch
> > > x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
> > > x86_64-fix-apic-typo.patch
> > > x86_64-convert-to-cleckevents.patch
> > > acpi-remove-the-useless-ifdef-code.patch
> > > x86_64-hpet-restore-vread.patch
> > > x86_64-restore-restore-nohpet-cmdline.patch
> > > x86_64-block-irq-balancing-for-timer.patch
> > > x86_64-prep-idle-loop-for-dynticks.patch
> > > x86_64-enable-high-resolution-timers-and-dynticks.patch
> > > x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
> > 
> > I'm sceptical about the dynticks code. It just rips out the x86-64 
> > timing code completely, which needs a lot more review and testing. 
> > Probably not .23
> 
> What you just did here is a slap in the face to a lot of contributors 
> who worked hard on this code :(
> 
> Let me tell you about the history of this project first.

... [lwn.net articles and other quotes snipped]

> But what is curiously absent from all this positive and dynamic activity 
> around these patches on lkml? There is not a single email from Andi 
> Kleen, the official maintainer of the x86_64 tree directly reacting to 
> this submission in any way, shape or form. Not a single email from you 
> thanking Arjan, Chris and Thomas for this amount of cleanup to the 
> architecture you are maintaining:
> 
>    31 files changed, 698 insertions(+), 1367 deletions(-)

Hm, I don't usually get thanks emails.  Do other people?

> Not a single email from you reviewing the patchset in any meaningful 
> way. Not a single email from you to indicate that you even did so much 
> as boot into this patchset.
> 
> What contribution do we have from you instead? A week before the .23 
> merge window is closed, in the very last possible moment, we finally get 
> your first reaction to this patchset, albeit in the form of three terse 
> sentences:
> 
>   > I'm sceptical about the dynticks code. It just rips out the x86-64 
>   > timing code completely, which needs a lot more review and testing. 
>   > Probably not .23
> 
> In the past 3+ months there was not a single email from you indicating 
> that you are "doubtful" about this submission, and that you think that 
> it needs "lot more review and testing". You dont offer any alternative, 
> you dont offer any feedback, no review, no testing, no support, just a 
> simple rejection on lkml that prevents this project from going upstream.
> 
> Yes, maintainers have veto power and often have to make hard decisions,
> but, and let me stress this properly:
> 
>    Only if they actually act as honest maintainers!
> 
> Altogether 197 emails on lkml discussed these patches, and you were 
> Cc:-ed to every one of them. Over a dozen kernel developers reviewed it 
> or reacted to the patchset in one way or another. And your only reaction 
> to this is silence and a rejection claiming that it needs "lot more 
> review"? I'm utterly speechless.

I can understand being disappointed, but not quite as upset as you
appear to be.

so have you (Ingo) reviewed the ext4 patches?  or reiser4 patches?
or lumpy reclaim?  or anti-fragmentation?

I certainly haven't.  I can barely keep up with reading about 1/2
of lkml emails.  And in my non-scientific method, I think that we
are suffering from both (a) more patch submittals and (b) fewer
qualified reviewers (per kernel KLOC) than we had 3-5 years ago.

I don't see how you can expect Andrew to review these or any other
specific patchset.  Do you have some suggestions on how to clone
Andrew?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
