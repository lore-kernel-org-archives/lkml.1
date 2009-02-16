Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZBPHRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZBPHRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZBPHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:17:26 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:41744 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZBPHRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:17:25 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       benh@kernel.crashing.org
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.p4D.L20jJB@chimera>
	<878wognj00.fsf@burly.wgtn.ondioline.org>
	<200902142342.59186.rjw@sisk.pl>
Date: Mon, 16 Feb 2009 20:17:22 +1300
In-Reply-To: <200902142342.59186.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 14 Feb 2009 23:42:58 +0100")
Message-ID: <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday 09 February 2009, Paul Collins wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
>> > Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
>> > Submitter	: Paul Collins <paul@burly.ondioline.org>
>> > Date		: 2009-01-21 7:15 (19 days old)
>> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
>> > References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
>> 
>> I've just done ten suspend/resume cycles with 2.6.29-rc4 and this
>> message was not logged, so it's either gone away or else become much
>> more difficult to reproduce.
>
> Thanks, I've closed the bug.

It turns out I didn't test this properly.  The warning is only triggered
when I close and open the lid, not when I run 'snooze' to suspend and
hit Return to resume, as I did for my so-called testing of 2.6.29-rc4.

Whatever is triggering the warning is still present in 2.6.29-rc5.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
