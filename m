Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYJ3Uzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYJ3Uzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJ3Uzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:55:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYJ3Uzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:55:43 -0400
Date: Thu, 30 Oct 2008 21:55:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
Message-ID: <20081030205526.GB24626@elte.hu>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com> <20081030195107.GK27407@elte.hu> <20081030202006.GA1255@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030202006.GA1255@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > So please name it something like CONFIG_STANDARD_X86_FEATURES, and 
> > also make it depend on CONFIG_EMBEDDED (only allow it to be turned 
> > off when EMBEDDED is enabled).
> 
> Any chance to introduce a CONFIG_EXPERT option?
> 
> CONFIG_EMBEDDED is supposed to be those features that may decrease 
> performance or functionality but lower the footprint. And not all 
> the crap it covers today.

turning those features off will reduce the kernel's size as well - so 
i think it's appropriate in this specific case.

but i agree with your general point that CONFIG_EMBEDDED is abused in 
a few cases.

	Ingo
