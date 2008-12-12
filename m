Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYLLJAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYLLJAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYLLJAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:00:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYLLJAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:00:42 -0500
Date: Fri, 12 Dec 2008 10:00:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "eranian@googlemail.com" <eranian@googlemail.com>
Subject: Re: [PATCH] x86, bts: fix build error
Message-ID: <20081212090023.GC25106@elte.hu>
References: <20081211134959.A13599@sedona.ch.intel.com> <20081212070932.GB7589@elte.hu> <20081212072324.GA10705@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E0CB57BC4@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E0CB57BC4@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu] 
> >Sent: Freitag, 12. Dezember 2008 08:23
> >To: Metzger, Markus T
> 
> > i fixed a build failure via the commit below - but the recursion in 
> > that code is really nasty. Could you please clean it all up to plain 
> > flat code?
> 
> Sure.
> 
> How could I find those things myself? Gcc 4.3.0 does not even give a 
> warning for a defconfig build. Is there a config option I should set?

Gcc 4.3.0 is too new for that build failure ;-) -tip testing involves 
testing with a couple of older compilers as well. This failure was with 
4.2.2 iirc.

You generally shouldnt worry about that too much, as long as it built 
fine on your config and the code is reasonably clean.

	Ingo
