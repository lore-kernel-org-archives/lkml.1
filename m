Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbXCHKIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbXCHKIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXCHKIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:08:12 -0500
Received: from mail08.syd.optusnet.com.au ([211.29.132.189]:44167 "EHLO
	mail08.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471AbXCHKIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:08:11 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Thu, 8 Mar 2007 21:07:49 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200703041800.53360.kernel@kolivas.org> <20070308085302.GA18245@elte.hu>
In-Reply-To: <20070308085302.GA18245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082107.50369.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 19:53, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > This message is to announce the first general public release of the
> > "Rotating Staircase DeadLine" cpu scheduler.
> >
> > Based on previous work from the staircase cpu scheduler I set out to
> > design, from scratch, a new scheduling policy design which satisfies
> > every requirement for SCHED_NORMAL (otherwise known as SCHED_OTHER)
> > task management.
>
> cool! I like this even more than i liked your original staircase
> scheduler from 2 years ago :) Lets try what we did back then: put it
> into -mm and see what breaks (if anything). But in general, it is
> becoming increasingly clear that the interactivity estimator is a more
> fragile concept than the built-in quota mechanism of the staircase
> scheduler, so if it works in practice i'm quite in favor of it, even if
> it regresses /some/ workloads.

Great! Thanks for your support. 

After futzing around for all that time I've become sure that an approach 
without an interactive estimator is our only way forward. So far the 
throughput benchmarks are encouraging too so I suspect the estimator may be 
causing harm there too.

Ensuring the different arches and cpuidle work properly I likely will need 
help with, though, so I'd appreciate any help from people if they see 
something obvious and can get a grip of my code.

Thanks!

-- 
-ck
