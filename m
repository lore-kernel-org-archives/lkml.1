Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbYEEU1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbYEEU1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYEEU1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:27:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59562 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYEEU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:27:46 -0400
Date: Mon, 5 May 2008 22:27:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505202729.GA1199@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <20080505184235.GD22332@elte.hu> <20080505125620.219c4bb6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505125620.219c4bb6@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 5 May 2008 20:42:35 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > In practice distro maintainers will pick the upstream default 99% of 
> > the time,
> 
> actually.. not quite. They don't tend to look at "default" in Kconfig; 
> they tend to say "m" if possible, and otherwise read the help text to 
> see if it makes sense...

yeah, that's what i meant mostly - to new drivers we unfortunately 
default to 'n'. And most of the time (i hope!) our defaults for new core 
kernel and architectural features otherwise make sense.

	Ingo
