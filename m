Return-Path: <linux-kernel-owner+w=401wt.eu-S1765736AbXLMWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765736AbXLMWSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763795AbXLMWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:18:16 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:49562 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761159AbXLMWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:18:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGw+YUdMROHU/2dsb2JhbACBWqhm
Date: Thu, 13 Dec 2007 17:18:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Next patches for the 2.6.25 queue
Message-ID: <20071213221805.GA27960@Krystal>
References: <20071213144642.GA7800@Krystal> <20071213133202.11374f54.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071213133202.11374f54.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:11:56 up 40 days,  3:17,  4 users,  load average: 0.85, 1.63,
	1.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 13 Dec 2007 09:46:42 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Andrew,
> > 
> > I would like to post my next patches in a way that would make it as
> > easy for you and the community to review them. Currently, the patches
> > that have really settled down are :
> > 
> > * For 2.6.25
> > 
> > - Text Edit Lock
> >   - Looks-good-to Ingo Molnar.
> > - Immediate Values
> >   - Redux version, asked by Rusty
> > 
> > * For 2.6.25 ?
> > 
> > Another patchset that is technically ok (however Rusty dislikes the
> > complexity inherent to the algorithms required to be reentrant wrt NMI
> > and MCE, although it's been reviewed by the community for months). I
> > have also replyed to Ingo's concerns about effeciency of my approach
> > compared to dtrace by providing numbers, but he has not replyed yet.
> > http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg238317.html
> > 
> > - Markers use Immediate Values
> > 
> > * Maybe for 2.6.26 ...
> > 
> > Once we have this, and the instrumentation (submitted as RFC in the past
> > weeks), in the kernel, the only architecture dependent element that will
> > be left is the LTTng timestamping code.
> > 
> > And then, from that point, the following patchset is mostly
> > self-contained and stops modifying code all over the kernel tree. It
> > is the LTTng tracer.
> > 
> > Trying to improve my approach : I guess that submitting at most 15
> > patches at a time (each 1-2 days), against the -mmotm tree, would be the
> > way to do it ?
> > 
> 
> Just for some context, I have...
> 
> - 1,400-odd open bugzilla reports
> 
> - 719 emails saved away in my emailed-bug-reports folder, all of which
>   need to be gone through, asking originators to retest and
>   re-report-if-unfixed.
> 
> - A big ugly email titled "2.6.24-rc5-git1: Reported regressions from
>   2.6.23" in my inbox.
> 
> All of which makes it a bit inappropriate to be thinking about
> intrusive-looking new features.
> 
> Ho hum.  Just send me the whole lot against rc5-mm1 and I'll stick it in
> there and we'll see what breaks.
> 

Ok,

Hum, the "whole lot" : including or excluding
- instrumentation
- the LTTng tracer ?

I realise that you have a lot of other things on your mind. One of my
goals would be to get LTTng in the -mm tree so it could help you resolve
these bugs. But on the other hand, I don't want to rush things. The
LTTng tracer could benefit of another round of RFC before it is ready
for prime time, but it would definitely be useful as-is in the mm tree.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
