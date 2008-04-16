Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYDPTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYDPTIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYDPTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:08:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbYDPTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:08:38 -0400
Date: Wed, 16 Apr 2008 12:07:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: bhutchings@solarflare.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-Id: <20080416120752.eed9657f.akpm@linux-foundation.org>
In-Reply-To: <20080416125133.GA6304@elte.hu>
References: <20080331114412.GH21637@solarflare.com>
	<20080415124231.e22df79e.akpm@linux-foundation.org>
	<20080416125133.GA6304@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 14:51:33 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > This patch:
> > > 
> > > - Adds default definitions of the 4 topology macros to
> > >   include/asm-generic/topology.h.
> > > - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
> > >   unconditionally.
> > > - Changes drivers/base/topology.c to use the topology macros unconditionally
> > >   and to cope with definitions that aren't lvalues.
> > > - Updates documentation accordingly.
> > > 
> > 
> > I ran away in terror when I saw this patch.  It's dark and dirty stuff 
> > you're unearthing there and it looks like a minefield of compilation 
> > problems.  Not aided by the fact that we don't have a topology 
> > maintainer afaik.
> > 
> > We shall see.
> 
> i could pick it up into sched.git

There seem to be multiple sched.gits

> - it's a frequent party to topology 
> patches. We've now got automated cross-build checks as well by virtue of 
> Thomas so common build failures ought to be rare.

OK, whatever.  There's a tangle between this change and the s390 tree which
already has a tangle with one of the sched-gits which is sort-of getting
sorted out.

git-s390 wasn't an appropriate place to host changes to
drivers/base/topology.c.

