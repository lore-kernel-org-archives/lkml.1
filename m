Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0BVNsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:48:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60538 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0BVNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:48:09 -0500
Date: Mon, 22 Feb 2010 14:47:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: tools/perf: libraries must come after objects
Message-ID: <20100222134754.GA8559@elte.hu>
References: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr>
 <20100222105025.GA25661@elte.hu>
 <alpine.LSU.2.01.1002221430440.23762@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002221430440.23762@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@medozas.de> wrote:

> On Monday 2010-02-22 11:50, Ingo Molnar wrote:
> >> 
> >> tools/perf: libraries must come after objects
> >> 
> >> Link order matters, especially now since distributions are
> >> using -Wl,--as-needed.
> >> 
> >> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> >> ---
> >>  tools/perf/Makefile |   16 ++++++++--------
> >>  1 files changed, 8 insertions(+), 8 deletions(-)
> >
> >FYI, this patch doesnt apply to the latest version of perf:
> >
> > patching file tools/perf/Makefile
> > Hunk #1 FAILED at 201.
> > Hunk #2 FAILED at 421.
> > Hunk #3 FAILED at 432.
> > Hunk #4 succeeded at 770 (offset 93 lines).
> > 3 out of 4 hunks FAILED -- rejects in file tools/perf/Makefile
> >
> >you can find the devel tree at:
> >
> >  http://people.redhat.com/mingo/tip.git/README
> 
> Do happen to have that as a faster git:// too?

Yes, the links for the -tip Git tree are in that file.

Thanks,

	Ingo
