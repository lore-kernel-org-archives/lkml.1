Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYGKI4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYGKI4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYGKI4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:56:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYGKI4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:56:11 -0400
Date: Fri, 11 Jul 2008 10:55:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Milton Miller <miltonm@bga.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next-20080709] fixup stop_machine use cpu mask vs
	ftrace
Message-ID: <20080711085533.GA22390@elte.hu>
References: <200807081756.47140.rusty@rustcorp.com.au> <for-27-patch0-1@bga.com> <20080711074602.GB27849@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711074602.GB27849@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Milton Miller <miltonm@bga.com> wrote:
> 
> > Hi Rusty, Ingo.
> > 
> > Rusty's patch [PATCH 3/3] stop_machine: use cpu mask rather than magic 
> > numbers didn't find kernel/trace/ftrace.c in -next, causing an 
> > immediate almost NULL pointer dereference in ftrace_dynamic_init.
> 
> Rusty - what's going on here? Please do not change APIs like that, 
> which cause code to crash. Either do a compatible API change, or 
> change it over in a way that causes clear build failures, not crashes.

ah, i see it from Rusty's other reply that there's going to be another 
version of this. Good :-)

	Ingo
