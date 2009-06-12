Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbZFLRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbZFLRyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZFLRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:54:07 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54508 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZFLRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:54:07 -0400
Date: Fri, 12 Jun 2009 19:56:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS requirements
Message-ID: <20090612175624.GA18203@uranus.ravnborg.org>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org> <20090612173031.GA11233@elte.hu> <8bd0f97a0906121032p12710878h14c5013fbec58b91@mail.gmail.com> <20090612173647.GC22015@elte.hu> <8bd0f97a0906121040m5222cd5et77ecc1bd5edb6b89@mail.gmail.com> <4A329322.7030403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A329322.7030403@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:40:50AM -0700, Randy Dunlap wrote:
> Mike Frysinger wrote:
> > On Fri, Jun 12, 2009 at 13:36, Ingo Molnar wrote:
> >> * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >>> On Fri, Jun 12, 2009 at 13:30, Ingo Molnar wrote:
> >>>> * Mike Frysinger <vapier@gentoo.org> wrote:
> >>>>> Help out arch porters who want to support perf counters by listing some
> >>>>> basic requirements.
> >>>>>
> >>>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >>>>> ---
> >>>>> i imagine more details would be good, but this is a starting point and
> >>>>> better than nothing
> >>>>>
> >>>>>  init/Kconfig          |    2 ++
> >>>>>  tools/perf/design.txt |   15 +++++++++++++++
> >>>>>  2 files changed, 17 insertions(+), 0 deletions(-)
> >>>>>
> >>>>> diff --git a/init/Kconfig b/init/Kconfig
> >>>>> index c649657..20f85b1 100644
> >>>>> --- a/init/Kconfig
> >>>>> +++ b/init/Kconfig
> >>>>> @@ -936,6 +936,8 @@ config AIO
> >>>>>
> >>>>>  config HAVE_PERF_COUNTERS
> >>>>>       bool
> >>>>> +     help
> >>>>> +       See end of tools/perf/design.txt
> >>>>>
> >>>>>  menu "Performance Counters"
> >>>> Applied, thanks Mike! I have made a small change: i changed it from
> >>>> help text into a regular comment. We usually use help texts for
> >>>> interactive Kconfig options - but this is not one.
> >>> yes, but i like the help text because when i use the kconfig
> >>> search option, it shows up.  otherwise doing a search for
> >>> HAVE_PERF_COUNTERS shows nothing useful.
> >> When i did this modification i tried that in 'make menuconfig' and
> >> the help didnt show up. Is it only available in certain kconfig
> >> methods?
> 
> There is no prompt string for it, so it's invisible in menuconfig.
> xconfig has View options that can show it.
> 
> > hrm, you're right.  not sure what i was thinking of.  sounds like an
> > enhancement request though for kconfig.
> 
> Could be.  Cc: Sam added.

We do not want to show the invisible symbols.
But the added help text is still fine as it is there when you
grep the Kconfig file.

	Sam
