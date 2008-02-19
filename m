Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYBSOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYBSOn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYBSOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:43:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYBSOnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:43:49 -0500
Date: Tue, 19 Feb 2008 15:43:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Brownell <david-b@pacbell.net>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080219144328.GD21176@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net> <20080218130914.GC17697@elte.hu> <200802181216.25350.david-b@pacbell.net> <20080219101116.GA2202@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219101116.GA2202@elf.ucw.cz>
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

> > Thing is, this will catch not just regressions ... but cases where 
> > STR never worked in the first place.  Video problems, etc.  Also 
> > various system startup races, as in the PCMCIA and MMC/SD/SDIO cases 
> > I noted.
> 
> David is right here. At minimum, s2ram needs acpi_sleep=... options to 
> tell it how to set up the video. That is not issue for you, but it 
> means we should not be doing it by default.

nowhere did i suggest that it should be default-enabled ...

i just suggest the obvious: please make it a trivial, 2 seconds flip of 
a switch, instead of a 60 minutes hunting which i had to do to enable 
the S2RAM self-test: which also meant i had to write a few patches to 
print out what the code does and why it does not work, to finally enable 
this critical test infrastructure.

damn, with that kind of attitude towards people who _want to help_, no 
wonder s2ram still sucks ;-)

	Ingo
