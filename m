Return-Path: <linux-kernel-owner+w=401wt.eu-S938413AbXHIMTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938413AbXHIMTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763730AbXHIMTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:19:46 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:62318 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762849AbXHIMTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:19:44 -0400
Date: Thu, 9 Aug 2007 08:19:11 -0400 (EDT)
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
Subject: Re: [PATCH 4/5 -v2] Added generic lg.h in the include/linux directory
In-Reply-To: <20070809153133.d5dff7b6.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.58.0708090817360.29847@gandalf.stny.rr.com>
References: <20070809043626.830486783@goodmis.org> <20070809044125.459178259@goodmis.org>
 <20070809153133.d5dff7b6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Thu, 9 Aug 2007, Stephen Rothwell wrote:

> Hi Steven,
>
> I am just being pedantic here (and I should have beaten up on Rusty
> before now ...  :-)
>
> On Thu, 09 Aug 2007 00:36:30 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >
> > --- a/include/asm-i386/lg.h
> > +++ b/include/asm-i386/lg.h
> > @@ -1,5 +1,5 @@
> > -#ifndef _LGUEST_H
> > -#define _LGUEST_H
> > +#ifndef _I386_LGUEST_H
> > +#define _I386_LGUEST_H
>
> Maybe _ASM_LG_H or _I386_LG_H ? And there is a comment on the #endif at
> the end of the file that should match.
>
> > +++ b/include/linux/lg.h
> > @@ -0,0 +1,30 @@
> > +#ifndef _LINUX_LGUEST_H
> > +#define _LINUX_LGUEST_H
>
> Maybe _LINUX_LG_H ?
>
> Also (this is for Rusty) include/linux/lguest.h is protected by
> _ASM_LGUEST_H ...

Hah! in my lguest64 tree, I fixed all these. But I forgot to do the
changes when making the patches for upstream.  I'll make note and fix them
in my next patch series (unless Rusty can pull my stuff in now and then I
can apply on top of them ;-)

Thanks,

-- Steve

