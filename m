Return-Path: <linux-kernel-owner+w=401wt.eu-S940192AbXHIMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940192AbXHIMr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939649AbXHIMmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:42:21 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:53616 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939621AbXHIMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:42:19 -0400
Date: Thu, 9 Aug 2007 08:40:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jes Sorensen <jes@sgi.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 4/7] Moved the io struct up to the generic lg.h
In-Reply-To: <46BB080F.4040905@sgi.com>
Message-ID: <Pine.LNX.4.58.0708090839460.29847@gandalf.stny.rr.com>
References: <20070809003211.373543702@goodmis.org> <20070809003343.664528532@goodmis.org>
 <20070809115156.ef5fdc6c.sfr@canb.auug.org.au> <46BB080F.4040905@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 9 Aug 2007, Jes Sorensen wrote:

> Stephen Rothwell wrote:
> > On Wed, 08 Aug 2007 20:32:15 -0400 Steven Rostedt <rostedt@goodmis.org>
> > wrote:
> >> diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
> >> index 64f0abe..c5ea14c 100644
> >> --- a/drivers/lguest/i386/lg.h
> >> +++ b/drivers/lguest/i386/lg.h
> >> @@ -20,6 +20,8 @@
> >>  #include <linux/err.h>
> >>  #include <asm/semaphore.h>
> >>  #include "irq_vectors.h"
> >> +/* some files include this, some include the parent */
> >> +#include "../lg.h"
> >
> > Surely everything should just include the parent which allows for easier
> > consolidation over time. (as you are doing here)
>
> Whats wrong with introducing an include/asm-<arch>/lg.h and have the
> parent do #include <asm/lg.h> ? Seems much cleaner to me.

Seems cleaner to me to!  I think I'll do that.

Oh, wait! I did.  ;-)

-- Steve

P.S. Sorry, couldn't resist.

