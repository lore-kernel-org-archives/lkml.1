Return-Path: <linux-kernel-owner+w=401wt.eu-S1763849AbXESR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763849AbXESR21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXESR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:28:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35452 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXESR2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:28:20 -0400
Date: Sat, 19 May 2007 19:28:05 +0200 (MEST)
Message-Id: <200705191728.l4JHS5A9026303@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: segher@kernel.crashing.org
Subject: Re: gcc-4.2.0 breakage on powerpc?
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 18:11:20 +0200, Segher Boessenkool wrote:
> >>>> and we'll end up
> >>>> having major kernel releases which don't build on i386 with major 
> >>>> gcc
> >>>> releases, which isn't altogether desirable.
> >>>
> >>> Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(
> >>
> >> Details please. What exactly are the gcc-4.2.0 problems on powerpc?
> >
> > http://gcc.gnu.org/PR31490 .  Most stuff using named
> > sections won't build; that includes CONFIG_MODULES.
> > There is no viable workaround.  The problem is being
> > handled.  I'll post a patch for the kernel refusing
> > to build with this combination soon.
> 
> [Cc:ing the PowerPC list]
> 
> Oh btw, most likely this is a problem on 64-bit only.

I believe so too. PR31490 mostly talks about ppc64,
and I've built both ppc32 kernels and complex ppc32
user-space programs with gcc-4.2.0 without noticing
any regressions.

/Mikael
