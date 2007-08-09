Return-Path: <linux-kernel-owner+w=401wt.eu-S938745AbXHIMXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938745AbXHIMXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXHIMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:22:56 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:46843 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbXHIMWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:22:55 -0400
Date: Thu, 9 Aug 2007 08:21:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 5/5 -v2] Move the lguest files that are i386 specific
In-Reply-To: <20070809154221.2175efd4.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.58.0708090820120.29847@gandalf.stny.rr.com>
References: <20070809043626.830486783@goodmis.org> <20070809044125.610944971@goodmis.org>
 <20070809154221.2175efd4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Thu, 9 Aug 2007, Stephen Rothwell wrote:

> Hi Steven,
>
> On Thu, 09 Aug 2007 00:36:31 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >
> > Well, some may be merged with x86_64 later, but for now we move them
> > out of the way.  Later on we can start seeing how we can combine
> > some of these files to be arch generic.
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  drivers/lguest/Makefile                    |    7 +-
> >  drivers/lguest/core.c                      |  771 -------------------
> >  drivers/lguest/hypercalls.c                |  300 --------
> >  drivers/lguest/i386/Makefile               |    7 +
> >  drivers/lguest/i386/core.c                 |  771 +++++++++++++++++++
> >  drivers/lguest/i386/hypercalls.c           |  300 ++++++++
> >  drivers/lguest/i386/interrupts_and_traps.c |  440 +++++++++++
> >  drivers/lguest/i386/lguest.c               | 1097 ++++++++++++++++++++++++++++
> >  drivers/lguest/i386/lguest_asm.S           |   93 +++
> >  drivers/lguest/i386/lguest_user.c          |  382 ++++++++++
> >  drivers/lguest/i386/page_tables.c          |  680 +++++++++++++++++
> >  drivers/lguest/i386/segments.c             |  229 ++++++
> >  drivers/lguest/i386/switcher.S             |  347 +++++++++
> >  drivers/lguest/interrupts_and_traps.c      |  440 -----------
> >  drivers/lguest/lguest.c                    | 1097 ----------------------------
> >  drivers/lguest/lguest_asm.S                |   93 ---
> >  drivers/lguest/lguest_user.c               |  382 ----------
> >  drivers/lguest/page_tables.c               |  680 -----------------
> >  drivers/lguest/segments.c                  |  229 ------
> >  drivers/lguest/switcher.S                  |  347 ---------
> >  20 files changed, 4348 insertions(+), 4344 deletions(-)
>
> if you add -C or -M to "git diff --stat" this looks much better:
>
> $ git diff --stat -C HEAD^
>  drivers/lguest/Makefile                          |    7 ++-----
>  drivers/lguest/i386/Makefile                     |    7 +++++++
>  drivers/lguest/{ => i386}/core.c                 |    0
>  drivers/lguest/{ => i386}/hypercalls.c           |    0
>  drivers/lguest/{ => i386}/interrupts_and_traps.c |    0
>  drivers/lguest/{ => i386}/lguest.c               |    0
>  drivers/lguest/{ => i386}/lguest_asm.S           |    0
>  drivers/lguest/{ => i386}/lguest_user.c          |    0
>  drivers/lguest/{ => i386}/page_tables.c          |    0
>  drivers/lguest/{ => i386}/segments.c             |    0
>  drivers/lguest/{ => i386}/switcher.S             |    0
>  11 files changed, 9 insertions(+), 5 deletions(-)
>

/me should read the man pages.

Thanks, that's the options I was looking for.  I was using the
git-format-patch, and thought it would do that automatically.  I
definitely add those options the next time around!

Thanks,

-- Steve

