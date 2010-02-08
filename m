Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0BHLwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:52:17 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:40607 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0BHLwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wyVI0gRmbJwYM1igtwwO3EI8XVNILRmjeV5fWfD+Vnle499h6kPIxElgpeLnV6FfyQ
         L77brV3lXQTySMhfhlBEW2Ovfdz0B3qqhTXlu91PnK4QzsK/wMOcOfaddrLG5Lglp1rQ
         XEPOhBIaB79fIH9N3d/8ExthihqF+pFaFuegw=
MIME-Version: 1.0
In-Reply-To: <1265623245.1853.33.camel@laptop>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
	 <1265623245.1853.33.camel@laptop>
Date: Mon, 8 Feb 2010 12:52:15 +0100
Message-ID: <c76f371a1002080352ta0a2f7jd7945dc8f834c2cd@mail.gmail.com>
Subject: Re: [RFC][PATCH] PERF_COUNT_SW_RUNNABLE_TASKS: measure and act upon 
	parallellism
From: Stijn Devriendt <highguy@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       efault@gmx.de, andrea@suse.de, akpm@linux-foundation.org,
       Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 11:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2010-02-07 at 12:30 +0100, highguy@gmail.com wrote:
>
>> Here's an initial RFC patch for the parallallism
>> events for perf_events.
>
> OK, so you managed to rub me totally the wrong way with posting this
> yesterday:
>  - you send me each patch twice
>  - you used the horrible git sendmail default of --chain-reply-to
>   (some day I'll write a script that will detect and auto-bounce
>    series sent to me like that)
>  - you failed to provide a changelog for any of the patches
>  - some subjects were long enough to be a changelog
>
> Please don't do that again ;-)

Sorry for that. I'm still getting used to the thing called 'git'. Apart
from obviously sharing its name, there's not so
much we have in common so far... VCS experiences currently
don't go far beyond svn and the horrid CVS.
I just used the reply-list from the initial series about this subject,
perhaps you were listed twice in that one as well.

Isn't no longer making --chain-reply-to the default an option?

>
> Anyway, it did get me thinking, how about something like the below?
> <SNIP>

That pretty much looks like what I need at first sight. I'll definately
give it a very close look and test it out.
The perf_event approach would be nice, but the implementations
just seem to collide.

Thanks for taking the time anyway,
Stijn
