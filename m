Return-Path: <linux-kernel-owner+w=401wt.eu-S1161678AbXDXHMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161678AbXDXHMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161677AbXDXHMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:12:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:5896 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161678AbXDXHM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YmTJbLnDjYcST3sp4EB8/k70FYf7XsK1ZfcGPUUtb5rS1mxPwO6p0/bRkcQx6+pQVsTQGJPIVd1I3uYXWZiQqt6T2Fn9pwfVYyDUHEyHokvYiTr3P/Zr2NlrHDhQCSdSkc/Cga4SjUCfTS1j/1bK51TNdjtxH+9esMVN0N5fHrI=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 03:12:24 -0400
User-Agent: KMail/1.9.6
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
References: <200704220959.34978.kernel@kolivas.org> <200704240300.07689.gene.heskett@gmail.com> <20070424070800.GA23463@elte.hu>
In-Reply-To: <20070424070800.GA23463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240312.25015.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> > Gene has done some testing under CFS with X reniced to +10 and the
>> > desktop still worked smoothly for him.
>>
>> As a data point here, and probably nothing to do with X, but I did
>> manage to lock it up, solid, reset button time tonight, by wanting
>> 'smart' to get done with an update session after amanda had started.
>> I took both smart processes I could see in htop all the way to -19,
>> but when it was about done about 3 minutes later, everything came to
>> an instant, frozen, reset button required lockup.  I should have
>> stopped at -17 I guess. :(
>
>yeah, i guess this has little to do with X. I think in your scenario it
>might have been smarter to either stop, or to renice the workloads that
>took away CPU power from others to _positive_ nice levels. Negative nice
>levels can indeed be dangerous.
>
>(Btw., to protect against such mishaps in the future i have changed the
>SysRq-N [SysRq-Nice] implementation in my tree to not only change
>real-time tasks to SCHED_OTHER, but to also renice negative nice levels
>back to 0 - this will show up in -v6. That way you'd only have had to
>hit SysRq-N to get the system out of the wedge.)
>
>	Ingo

That sounds handy, particularly with idiots like me at the wheel...


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
When a Banker jumps out of a window, jump after him--that's where the money 
is.
		-- Robespierre
