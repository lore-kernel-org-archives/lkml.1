Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYHZJpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYHZJpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYHZJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:44:54 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37222 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750755AbYHZJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:44:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3GO/2ATwSDN09RPc+hKLQHY5rbTYKIRKPIhJnCh2S1LCklivBYVzx90pmIGGc+UHwFiWI+Khr5BORW9dg6OrClnr80e0/fvIfe9QFUxejMXAWgEidI1PxEpflkSlNEqwgjMNpFDbpa2qrLTDr+tyl/PPMujywtnR5JBe7ChU4fc=  ;
X-YMail-OSG: yxYwAQMVM1mGxeEXjL4hc0xj4RSfKGUd.RN5jKNMVeYeEZFv0GAVp7OPzYzaRKhmdXg2IbxBuWh6oR3l3tcKKZuusuG14enkpIrh4Xym.FiZ1pbyiW9HmDo9iG7.6npFWeKQgu1xQ4lBvc8vE2vGo1Fm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Tue, 26 Aug 2008 19:44:46 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu>
In-Reply-To: <20080826093059.GA471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261944.47176.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > So... no reply to this? I'm really wondering how it's OK to break
> > documented standards and previous Linux behaviour by default for
> > something that it is trivial to solve in userspace? [...]
>
> I disagree 

Disagree with what? That it's a problem to basically break the guarantee
realtime SCHED_ policies have previously provided?


> and what do you mean by "trivial to solve in user-space"? 

I mean that if some distro has turned on the RT scheduling ulimit by
default and now finds themselves with a local DoS for unpriviliged users
as a result, then either that distro should just make their init scripts
set the throttle and break the API themselves, or they should start a
watchdog at a higher priority than unprivileged user can set.
