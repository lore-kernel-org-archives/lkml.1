Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYAEJHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYAEJHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYAEJHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:07:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYAEJHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:07:00 -0500
Date: Sat, 5 Jan 2008 10:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
Message-ID: <20080105090642.GA3369@elte.hu>
References: <1198745736.4235.23.camel@homer.simson.net> <1198779574.4425.50.camel@homer.simson.net> <20071230140456.GJ16946@elte.hu> <20071230140815.GA27858@elte.hu> <20080104163914.GA27447@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104163914.GA27447@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2007-12-30 15:08:15, Ingo Molnar wrote:
> > 
> > > ok, i prefer this fix a bit more. (we dont want to set last_tsc 
> > > outside of the sync_lock - which your initial patch does)
> > 
> > i've added your patch to x86.git - thanks Mike! (patch below) I 
> > think this would be too dangerous for v2.6.24 though - we can put it 
> > back into -stable for 2.6.24.1, once it had more testing?
> 
> If it is too dangerous for -final, I guess it is bad idea to push it 
> into -stable.

we regularly delay bugs to the .1 release, if a fix is a bit complex and 
just needs a bit of time to be fully trusted for a stable release.

> Plus it does not fix really bad bug.

yeah, granted.

	Ingo
