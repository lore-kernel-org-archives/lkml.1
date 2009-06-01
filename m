Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZFATwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZFATwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZFATwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:52:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbZFATwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:52:33 -0400
Date: Mon, 1 Jun 2009 21:51:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix floppy hibernation
Message-ID: <20090601195159.GC29610@elte.hu>
References: <200905301804.26762.linux@rainbow-software.org> <20090601114342.GA2454@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601114342.GA2454@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On Sat 2009-05-30 18:04:25, Ondrej Zary wrote:
> > Hello,
> > floppy driver was always missing hibernation support. After resume, floppy did
> > not work (until a couple of disk reinserts and retries), producing errors like
> > this:
> > end_request: I/O error, dev fd0, sector 0
> > 
> > Ingo Molnar tried to fix it in 2006: http://lkml.org/lkml/2006/11/12/92
> > 
> > 
> > 
> > 
> > Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> > resume from hibernation, at least on my machine.
> > 
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>

nice patch ... thanks for picking up what i left unfinished.

	Ingo
