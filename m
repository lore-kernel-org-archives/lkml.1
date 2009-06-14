Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZFNLSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZFNLSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZFNLSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:18:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48465 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbZFNLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:18:05 -0400
Date: Sun, 14 Jun 2009 13:20:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, akpm <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open when supported
Message-ID: <20090614112022.GA27686@uranus.ravnborg.org>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> <20090614093725.GD832@linux-sh.org> <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com> <20090614101111.GG832@linux-sh.org> <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:55:45AM -0400, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 06:11, Paul Mundt wrote:
> > On Sun, Jun 14, 2009 at 05:55:44AM -0400, Mike Frysinger wrote:
> >> On Sun, Jun 14, 2009 at 05:37, Paul Mundt wrote:
> >> >> On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
> >> >> If the port does not support HAVE_PERF_COUNTERS, then they can't support
> >> >> the perf_counter_open syscall either. ??Rather than forcing everyone to add
> >> >> an ignore (or suffer the warning until they get around to implementing
> >> >> support), only whine about the syscall when applicable.
> >> >
> >> > I fail to see why this is necessary? cond_syscall() takes care of this in
> >> > the not implemented case, the same as every other syscall backing some
> >> > feature that has yet to be implemented.
> >>
> >> i dont think we should go hassling every arch maintainer when a new
> >> syscall is added that requires arch-specific support for optional
> >> features (especially when said features are debug in nature).  if
> >> wiring up the syscall is the only work because the code is all common
> >> (like the pread/pwrite functions), then np of course.
> >
> > Perhaps not, but I do prefer to have the script whine at me when a new
> > syscall pops up, just so I know when I have to start caring about a new
> > feature.
> 
> assuming you can find any useful info about said feature ;)
> 
> > If a generic implementation becomes available, then it can be
> > supported without having to backtrack and update place-holders.
> 
> this is a good convincing point.  Sam: please drop this patch if you
> did get a chance to queue it up.

OK - dropped.

	Sam
