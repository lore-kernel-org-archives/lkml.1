Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZK1LkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZK1LkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 06:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZK1LkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 06:40:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZK1LkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 06:40:08 -0500
Date: Sat, 28 Nov 2009 10:14:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       anton@samba.org, hch@infradead.org
Subject: Re: [RFC][PATCH 0/7] perf trace: general-purpose scripting support,
 v2
Message-ID: <20091128091430.GA22737@elte.hu>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Hi,
> 
> Here's a belated update to v1 of the trace stream scripting support 
> patches I posted last month; I had meant to get this out sooner but 
> got too busy with other things...

Excellent progress!

I wanted to try it so i took the patches and applied them with some 
conflicts (they interacted with some other recent changes in perf), but 
the Perl engine wouldnt build on Fedora 11 - see the errors attached 
below.

I've pushed the merge out to this temporary branch:

  git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tmp.perf/scripting

Mind having a look at it?

Thanks,

	Ingo

    CC util/trace-event-perl.o
cc1: warnings being treated as errors
util/trace-event-perl.c: In function 'define_symbolic_value':
util/trace-event-perl.c:70: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c:85: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c: In function 'define_symbolic_field':
util/trace-event-perl.c:102: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c:115: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c: In function 'define_flag_value':
util/trace-event-perl.c:128: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c:143: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c: In function 'define_flag_field':
util/trace-event-perl.c:161: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c:175: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c: In function 'perl_process_event':
util/trace-event-perl.c:301: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
util/trace-event-perl.c:350: error: declaration of 'my_perl' shadows a global declaration
util/trace-event-perl.c:48: error: shadowed declaration is here
make: *** [util/trace-event-perl.o] Error 1
