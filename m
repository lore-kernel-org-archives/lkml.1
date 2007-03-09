Return-Path: <linux-kernel-owner+w=401wt.eu-S1767281AbXCINWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767281AbXCINWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767278AbXCINWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:22:45 -0500
Received: from [212.12.190.136] ([212.12.190.136]:32874 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767280AbXCINWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:22:44 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Date: Fri, 9 Mar 2007 16:25:55 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703091625.55361.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Thu, Mar 08, 2007 at 10:31:48PM -0800, Linus Torvalds wrote:
> > No. Really.
> > I absolutely *detest* pluggable schedulers. They have a huge downside:
> > they allow people to think that it's ok to make special-case schedulers.
> > And I simply very fundamentally disagree.
> > If you want to play with a scheduler of your own, go wild. It's easy
> > (well, you'll find out that getting good results isn't, but that's a
> > different thing). But actual pluggable schedulers just cause people to
> > think that "oh, the scheduler performs badly under circumstance X, so
> > let's tell people to use special scheduler Y for that case".
> > And CPU scheduling really isn't that complicated. It's *way* simpler
> > than IO scheduling. There simply is *no*excuse* for not trying to do it
> > well enough for all cases, or for having special-case stuff.
> > But even IO scheduling actually ends up being largely the same. Yes, we
> > have pluggable schedulers, and we even allow switching them, but in the
> > end, we don't want people to actually do it. It's much better to have a
> > scheduler that is "good enough" than it is to have five that are
> > "perfect" for five particular cases.
>
> For the most part I was trying to assist development, but ran out of
> patience and interest before getting much of anywhere. The basic idea
> was to be able to fork over a kernel to a benchmark team and have them
> run head-to-head comparisons, switching schedulers on the fly,
> particularly on machines that took a very long time to boot. The
> concept ideally involved making observations and loading fresh
> schedulers based on them as kernel modules on the fly. I was more
> interested in rapid incremental changes than total rewrites, though I
> considered total rewrites to be tests of adequacy, since somewhere in
> the back of my mind I had thoughts about experimenting with gang
> scheduling policies on those machines taking very long times to boot.
>
> What actually got written, the result of it being picked up by others,
> and how it's getting used are all rather far from what I had in mind,
> not that I'm offended in the least by any of it. I also had little or
> no interest in mainline for it. The intention was more on the order of
> an elaborate instrumentation patch for systems where the time required
> to reboot is prohibitive and the duration of access strictly limited.
> (In fact, downward-revised estimates of the likelihood of such access
> also factored into the abandonment of the codebase.)
>
> I consider policy issues to be hopeless political quagmires and
> therefore stick to mechanism. So even though I may have started the
> code in question, I have little or nothing to say about that sort of
> use for it.
>
> There's my longwinded excuse for having originated that tidbit of code.

I've no idea what both of you are talking about.

How can giving people the freedom of choice be in any way counter-productive?


Thanks!

--
Al

