Return-Path: <linux-kernel-owner+w=401wt.eu-S1766609AbXDFJ3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766609AbXDFJ3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 05:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767552AbXDFJ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 05:29:04 -0400
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:57882 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766609AbXDFJ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 05:29:01 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Ten percent test
Date: Fri, 6 Apr 2007 19:28:38 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <200704061103.34489.kernel@kolivas.org> <1175850471.22272.8.camel@Homer.simpson.net>
In-Reply-To: <1175850471.22272.8.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061928.39155.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 19:07, Mike Galbraith wrote:
> On Fri, 2007-04-06 at 11:03 +1000, Con Kolivas wrote:
> > On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
> > >  - fiftyp.c:  noticeable, but alot better than previously!
> >
> > fiftyp.c seems to have been stumbled across by accident as having an
> > effect when Xenofon was trying to recreate Mike's 50% x 3 test case. I
> > suggest a ten percent version like the following would be more useful as
> > a test for the harmful effect discovered in fiftyp.c. (/me throws in
> > obligatory code style change).
> >
> > Starts 15 processes that sleep ten times longer than they run. Change
> > forks to 15 times the number of cpus you have and it should work on any
> > size hardware.
>
> I was more focused on the general case, but all I should have to do to
> de-claw all of these sleep exploits is account rr time (only a couple of
> lines, done and building now).  It's only a couple of lines.

The more you try to "de-claw" these sleep exploits the less effective you make 
your precious interactive estimator. Feel free to keep adding endless tweaks 
to undo the other tweaks in order to try and achieve what SD has by design. 
You'll end up with an incresingly complex state machine design of 
interactivity tweaks and interactivity throttlers all fighting each other to 
the point where the intearactivity estimator doesn't do anything. What's the 
point in that? Eventually you'll have an estimator throttled to the point it 
does nothing and you end up with something far less interactive than SD which 
is as interactive as fairness allows, unlike mainline.

-- 
-ck
