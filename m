Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXDZXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXDZXaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXDZXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:30:51 -0400
Received: from www.osadl.org ([213.239.205.134]:42699 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223AbXDZXau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:30:50 -0400
Subject: Re: Linux 2.6.21
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070426125802.GL3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	 <20070426040806.GJ3468@stusta.de>  <20070426125802.GL3468@stusta.de>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 01:32:46 +0200
Message-Id: <1177630366.25960.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

On Thu, 2007-04-26 at 14:58 +0200, Adrian Bunk wrote:
> I am aware that my work had some effect, and I am aware that my work 
> gets appreciated - there's no need for everyone to repeat this.

Nevertheless, thanks for your efforts and time spent. You did a great
job and I hope you can convince yourself to carry on.

> The point is: I'm not satisfied with the result.

Nobody is satisfied with pending regressions. I can completely
understand your frustration, but you need to adjust your expectations on
that as well.

Your regression lists are extremly useful, as they point folks like me
to the burning points. I try to follow LKML as far as I can, but I have
to admit that I occasionally go the easy way of marking 10000 mails as
read in one go after a week of travelling. I don't do this to my
personal inbox, so your mails get my attention.

> They have both been fixed through -stable, but I also remember a quite 
> experienced kernel maintainer running into one of them after 2.6.20 was 
> released and spending half a day tracking it down - and my answer was
> "known unfixed regression, first reported more than a month ago".

That happens all the time. I have a dozen of boxen around and I can't do
tests on all of them continously. So trapping into some known regression
is nothing which surprises me.

> There is a conflict between Linus trying to release kernels every
> 2 months and releasing with few regressions.

Yes, it's a conflict, but one that is unresolvable except we want to go
back to the 2.4 model which sucked way more than the current one.

> And a serious delay of the next regression-merge window due to unfixed 
> regressions might even have the positive side effect of more developers 
> becoming interested in fixing the current regressions for getting their 
> shiny new regressions^Wfeatures faster into Linus' tree.

Maybe we need to coordinate changes better. 2.6.21 got three big updates
which affected suspend/resume - one of them is my fault. But fiddling
out which one of those - we had nested problems as well - makes it quite
hard to grok them in time, especially if they happen only on one
reporters system.

Your reports are not invalid, when Linus releases a final. They are
still there and worked on.

I believe we are getting better at that, and one reason for this is your
relentless effort to poke the experts^culprits to actually solve the
problems.

> I'm not satisfied with the result, and the world won't stop turning when 
> I'm not tracking 2.6.22-rc regressions.

Please take a couple of days to reconsider. I personally would welcome
if you carry on.

Thanks,

	tglx


