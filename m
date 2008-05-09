Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYEIKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYEIKXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYEIKXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:23:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYEIKXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:23:13 -0400
Date: Fri, 9 May 2008 12:22:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       rientjes@google.com
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch
Message-ID: <20080509102237.GE19617@elte.hu>
References: <48210101.1070205@google.com> <20080506183138.546f42d9.akpm@linux-foundation.org> <20080506204054.564fff32.pj@sgi.com> <20080506223859.0b4fa876.pj@sgi.com> <20080506204444.f4c38d0a.akpm@linux-foundation.org> <20080506225228.d42630cf.pj@sgi.com> <1210142681.13978.166.camel@twins> <48233EEB.1010807@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48233EEB.1010807@qualcomm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> > No problem, I've been meaning to redo this whole series but somehow 
> > stuff got in the way and I never got around to it :-/
> 
> I'm actually totally surprised that it got in. Ingo applied Peter's 
> initial patch to his sched-devel tree but then ignored follow up 
> patches with fixes and stuff from me (I'm assuming that was because we 
> started discussion alternative options).

yes, there's been a lot of back and forth.

Paul/Peter/Max, what's the current agreed-upon approach to merge these 
physical resource isolation features into cpusets intelligently while 
still keeping the whole thing as usable and practical to down-to-earth 
sysadmins as possible? That is the issue that is blocking this whole 
topic from progressing.

> Anyway, my vote goes for reverting these series.

none of this is upstream yet (nor is any of this even near to being 
ready for upstream), so there's nothing to revert.

	Ingo
