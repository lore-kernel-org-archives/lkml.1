Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYHKUQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYHKUQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbYHKUNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56434 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbYHKUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Cliff Wickman <cpw@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu>
	<48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
	<20080811195102.GL12788@elte.hu>
Date: Mon, 11 Aug 2008 13:10:16 -0700
In-Reply-To: <20080811195102.GL12788@elte.hu> (Ingo Molnar's message of "Mon,
	11 Aug 2008 21:51:02 +0200")
Message-ID: <m1hc9rmhxz.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1341]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_64:  (NEW) Dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Alan Mayer <ajm@sgi.com> writes:
>> 
>> > Okay, here it is as an attachment.  I think my email client is munging it.
>> > I haven't been able to fix it, apparently.
>> >
>> > I, too, would like to know what Eric thinks.
>> 
>> I think arch/x86 is about to fall over from accidental complexity of 
>> the irq handling. [...]
>
> it was in that state for many years already ;-) Unification, cleanups of 
> other historic messes and the constant push for new hw support just made 
> it stand out more visibly. IRQ and APIC code unification is definitely 
> the final (and by far hardest) major step of x86 unification.

Well I think we are looking at the final couple of straws...

Yes unification (aka porting the infrastructure improvements
to x86_32) and then sharing the code is a piece of it.

>> [...]  Looking at your problem and the problem of killing NR_IRQS I 
>> spent way to much time playing with it this weekend then I should 
>> have, but I think I have found a path that works and is fairly easily 
>> verifiable.
>
> cool :-)
>
>> I have a patch series that gets me 90% of the way there, and the rest 
>> appears easy but I don't have any time to mess with it right now.  I 
>> will try and post it something in the next couple of days.
>
> i'm very interested in it, even if it's incomplete and wont build/boot 
> at all. So please consider posting your existing incomplete series as an 
> RFC right now, maybe we can help finish it sooner than you will find the 
> time? We can put it into a new tip/x86/irq-unification branch, without 
> merging it into tip/master just yet.

Sure. Mostly I just need to allocate a few minutes to post it, later today
or tomorrow hopefully.

Eric


