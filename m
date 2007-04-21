Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXDUIgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXDUIgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXDUIgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:36:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXDUIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:36:20 -0400
Date: Sat, 21 Apr 2007 10:36:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: caglar@pardus.org.tr, Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070421083608.GC29800@elte.hu>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu> <200704190008.19262.caglar@pardus.org.tr> <4629152C.7020801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4629152C.7020801@tmr.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> > Instead of that one, i tried CFSv3 and i cannot reproduce the hang 
> > anymore, Thanks!...
>
> And that explains why CFS-v3 on 21-rc7-git3 wouldn't show me the hang. 
> As a matter of fact, nothing I did showed any bad behavior! Note that 
> I was doing actual badly behaved things which do sometimes glitch the 
> standard scheduler, not running benchmarks.
> 
> This scheduler is boring, everything works. [...]

hehe :) Having a 'boring' scheduler in the end is the main goal :)

> [...] I am going to try some tests on a uniprocessor, though, I have 
> been running everything on either SMP or HT CPUs. But so far it looks 
> fine.

yeah, please do - while i do test UP frequently, most of my CFS testing 
was on SMP.

	Ingo
