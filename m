Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbXEJECS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbXEJECS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXEJECK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:02:10 -0400
Received: from mail10.syd.optusnet.com.au ([211.29.132.191]:36379 "EHLO
	mail10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbXEJECI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:02:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Date: Thu, 10 May 2007 13:58:30 +1000
User-Agent: KMail/1.9.5
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46427BDB.30004@yahoo.com.au> <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>
In-Reply-To: <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101358.31267.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 13:48, Ray Lee wrote:
> On 5/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > You said it helped with the updatedb problem. That says we should look at
> > why it is going bad first, and for example improve use-once algorithms.
> > After we do that, then swap prefetching might still help, which is fine.
>
> Nick, if you're volunteering to do that analysis, then great. If not,
> then you're just providing a airy hope with nothing to back up when or
> if that work would ever occur.
>
> Further, if you or someone else *does* do that work, then guess what,
> we still have the option to rip out the swap prefetching code after
> the hypothetical use-once improvements have been proven and merged.
> Which, by the way, I've watched people talk about since 2.4. That was,
> y'know, a *while* ago.
>
> So enough with the stop energy, okay? You're better than that.
>
> Con? He is right about the last feature to go in needs to work
> gracefully with what's there now. However, it's not unheard of for
> authors of other sections of code to help out with incompatibilities
> by answering politely phrased questions for guidance. Though the
> intersection of users between cpusets and desktop systems seems small
> indeed.

Let's just set the record straight. I actually discussed cpusets over a year 
ago in this nonsense and was told by sgi folk there was no need to get my 
head around cpusets and honouring node placement should be enough which, by 
the way, swap prefetch does. So I by no means ignored this; we just hit an 
impasse on just how much more featured it should be for the sake of a goddamn 
home desktop pc feature.

Anyway why the hell am I resurrecting this thread? The code is declared dead 
already. Leave it be.

-- 
-ck
