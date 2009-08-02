Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZHBUBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZHBUBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZHBUA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:00:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZHBUA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:00:59 -0400
Date: Sun, 2 Aug 2009 22:00:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] perf tools: allow top users to switch between weighted
	and individual counter display
Message-ID: <20090802200049.GF24486@elte.hu>
References: <1248422990.28486.3.camel@marge.simson.net> <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248431821.9722.4.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2009-07-24 at 10:58 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-07-24 at 10:09 +0200, Mike Galbraith wrote:
> > > (depends on last resurrect annotation patch)
> > > 
> > > perf_counter tools: allow top users to switch between weighted and individual counter display.
> > > 
> > > Add [w]eighted hotkey.  Pressing [w] toggles between displaying weighted total of all counters,
> > > and the counter selected via [E]vent select key.
> > 
> > /me stuck it next to that other one, let see what happens ;-)
> 
> (plugs in Bitwolf-9000 charger)

seems to work well here.

A few minor comments:

 - I had to guess that '?' gets me a help screen. Might make sense 
   to display a line at the bottom (?) to give some hints.

 - Once i was on the help screen, i expected either <Enter> or '?' 
   to make it vanish. Only setting an option got rid of it - i 
   suspect this should be improved. (Also, a line in the help screen 
   that tells us how to go back without changing anything would be 
   helpful as well.)

 - I randomly tried the 's' option to do annotation. But it didnt do 
   anything. Probably because i didnt start perf top via --vmlinux, 
   right? This behavior is not intuitive in any case - it should 
   probably display an error message at minimum - but if possible it 
   should try to guess the position of the vmlinux file.

	Ingo
