Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZCNRFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZCNRFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 13:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZCNRFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 13:05:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbZCNRFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 13:05:18 -0400
Date: Sat, 14 Mar 2009 18:04:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
Message-ID: <20090314170445.GF31930@elte.hu>
References: <1237034492.4546.1.camel@ht.satnam> <20090314131142.GA29582@uranus.ravnborg.org> <20090314132004.GD17727@elte.hu> <1237037822.4546.8.camel@ht.satnam> <19f34abd0903140700r6c23da9aq6747fbcce7bcc4b2@mail.gmail.com> <20090314153138.GA19459@elte.hu> <1237046650.4546.30.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237046650.4546.30.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-03-14 at 16:31 +0100, Ingo Molnar wrote:
> > > 
> > > I don't really like this change (last hunk). Doesn't it seem a 
> > > bit pointless? It breaks the symmetry with the masked CPUID 
> > > levels at the beginning of the function. If somebody wants to 
> > > add something else to this function, it might have to be 
> > > reindented again. Or is there a problem with too long lines 
> > > here?
> > 
> > yes, it would be cleaner to put the whole family 15 branch into 
> > a helper inline function instead.
> > 
> 
> OK, better I keep it unchanged :-)

Why not implement the cleanup i suggested?

	Ingo
