Return-Path: <linux-kernel-owner+w=401wt.eu-S1765682AbYEESu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765682AbYEESu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbYEESqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:46:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761231AbYEESqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:46:05 -0400
Date: Mon, 5 May 2008 20:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sergio Luis <sergio@uece.br>
Cc: Sam Ravnborg <sam@ravnborg.org>, Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505184538.GE22332@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com>
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


* Sergio Luis <sergio@uece.br> wrote:

> >  In latest kbuild.git I've added a new feature.
> >
> >         make K=.config alldefconfig
> >
> >  would give you eaxtly what you request here.
> >  K= is used to say where to locate the base-configuration.

> Can I specify /proc/config.gz (gzipped) in the K parameter?
> -sergio

i think the 'natural' script behavior would be for this to do the right 
thing:

   zcat /proc/config.gz | make K=- alldefconfig

or something like that - so that it can be scripted in a pipe.

Kbuild might in addition also have specials for .gz files as you 
suggest, that would only make it all more usable and more flexible.

	Ingo
