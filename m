Return-Path: <linux-kernel-owner+w=401wt.eu-S2992516AbXDEMNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992516AbXDEMNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766964AbXDEMNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:13:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992577AbXDEMNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:13:00 -0400
Date: Thu, 5 Apr 2007 14:12:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: [test] sched: SD-latest versus Mike's latest
Message-ID: <20070405121234.GA30314@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200703290944.45888.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net> <200704031237.21946.kernel@kolivas.org> <1175578270.6342.12.camel@Homer.simpson.net> <20070403060109.GA6708@elte.hu> <1175770950.6609.16.camel@Homer.simpson.net> <20070405115447.GA24138@elte.hu> <1175775012.6609.31.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175775012.6609.31.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > re-testing the weak points of the vanilla scheduler + Mike's:
> > 
> >  - thud.c:    this workload has almost unnoticeable effect
> >  - fiftyp.c:  noticeable, but alot better than previously!
> 
> Hmm.  Here fiftyp.c is utterly harmless.  If you have a second, can 
> you send me a top snapshot?  If you're running many of them, it can 
> take a bit for the throttle to catch them all.

ah, indeed - i ran 10 of them and letting them run for a bit smoothes 
things out.

	Ingo
