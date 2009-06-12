Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbZFLRhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbZFLRhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZFLRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:36:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZFLRgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:36:53 -0400
Date: Fri, 12 Jun 2009 19:36:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS
	requirements
Message-ID: <20090612173647.GC22015@elte.hu>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org> <20090612173031.GA11233@elte.hu> <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jun 12, 2009 at 13:30, Ingo Molnar wrote:
> > * Mike Frysinger <vapier@gentoo.org> wrote:
> >> Help out arch porters who want to support perf counters by listing some
> >> basic requirements.
> >>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >> ---
> >> i imagine more details would be good, but this is a starting point and
> >> better than nothing
> >>
> >>  init/Kconfig          |    2 ++
> >>  tools/perf/design.txt |   15 +++++++++++++++
> >>  2 files changed, 17 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index c649657..20f85b1 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -936,6 +936,8 @@ config AIO
> >>
> >>  config HAVE_PERF_COUNTERS
> >>       bool
> >> +     help
> >> +       See end of tools/perf/design.txt
> >>
> >>  menu "Performance Counters"
> >
> > Applied, thanks Mike! I have made a small change: i changed it from
> > help text into a regular comment. We usually use help texts for
> > interactive Kconfig options - but this is not one.
> 
> yes, but i like the help text because when i use the kconfig 
> search option, it shows up.  otherwise doing a search for 
> HAVE_PERF_COUNTERS shows nothing useful.

When i did this modification i tried that in 'make menuconfig' and 
the help didnt show up. Is it only available in certain kconfig 
methods?

	Ingo
