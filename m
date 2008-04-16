Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbYDPMv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbYDPMv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbYDPMvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:51:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745AbYDPMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:51:47 -0400
Date: Wed, 16 Apr 2008 14:51:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-ID: <20080416125133.GA6304@elte.hu>
References: <20080331114412.GH21637@solarflare.com> <20080415124231.e22df79e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415124231.e22df79e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > This patch:
> > 
> > - Adds default definitions of the 4 topology macros to
> >   include/asm-generic/topology.h.
> > - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
> >   unconditionally.
> > - Changes drivers/base/topology.c to use the topology macros unconditionally
> >   and to cope with definitions that aren't lvalues.
> > - Updates documentation accordingly.
> > 
> 
> I ran away in terror when I saw this patch.  It's dark and dirty stuff 
> you're unearthing there and it looks like a minefield of compilation 
> problems.  Not aided by the fact that we don't have a topology 
> maintainer afaik.
> 
> We shall see.

i could pick it up into sched.git - it's a frequent party to topology 
patches. We've now got automated cross-build checks as well by virtue of 
Thomas so common build failures ought to be rare.

	Ingo
