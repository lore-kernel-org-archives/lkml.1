Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYECWkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYECWkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYECWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:40:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYECWkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:40:37 -0400
Date: Sun, 4 May 2008 00:40:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       linux-next@vger.kernel.org
Subject: Re: Strange linux-next build error
Message-ID: <20080503224018.GB18344@elte.hu>
References: <200805030121.39831.dhazelton@enter.net> <20080503155252.0dc9c4d7.sfr@canb.auug.org.au> <20080503064057.GA12546@uranus.ravnborg.org> <200805031825.50914.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805031825.50914.dhazelton@enter.net>
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


* Daniel Hazelton <dhazelton@enter.net> wrote:

> > Can you try to do a:
> > make V=1 and post the output a few screen fulls before and until
> > the bug triggers.
> > They I will see if I can work out what is happening.
> >
> > Thanks,
> > 	Sam
> 
> I've been unable to trigger it with "make V=1 bzImage" - does the 
> verbosity change, somehow, the default number of makes that get run ?
> 
> If it does, I could try adding -j2 or similar to see if that causes it 
> to trigger.

try something like:

   make -j2 V=1 bzImage >log.txt 2>&1

and see whether the error shows up in log.txt. Console output caused by 
the increased verbosity (especially if it's a slower console like an 
xterm) can hide build races.

	Ingo
