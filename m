Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbZBETsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbZBETsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762859AbZBETli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:41:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762850AbZBETlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:41:37 -0500
Date: Thu, 5 Feb 2009 20:41:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Lowengrub <lowdanie@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28 1/2] memory: improve find_vma
Message-ID: <20090205194125.GA3129@elte.hu>
References: <8c5a844a0901220851g1c21169al4452825564487b9a@mail.gmail.com> <Pine.LNX.4.64.0901221658550.14302@blonde.anvils> <8c5a844a0901221500m7af8ff45v169b6523ad9d7ad3@mail.gmail.com> <20090122231358.GA27033@elte.hu> <8c5a844a0901230310h7aa1ec83h60817de2b36212d8@mail.gmail.com> <8c5a844a0901281331w4cea7ab2y305d5a1af96e313e@mail.gmail.com> <20090129141929.GP24391@elte.hu> <8c5a844a0902010319t20b853d0t6c156ecc84543f30@mail.gmail.com> <20090201130058.GA486@elte.hu> <8c5a844a0902050326v2155dbeaq5449f1e373f4245d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c5a844a0902050326v2155dbeaq5449f1e373f4245d@mail.gmail.com>
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


* Daniel Lowengrub <lowdanie@gmail.com> wrote:

> On Sun, Feb 1, 2009 at 3:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  you should time it:
> >
> >  time ./mmap-perf
> >
> > and compare the before/after results.
> >
> >        Ingo
> >
> 
> I made a script that runs 'time ./mmap-perf' 100 times and outputs the
> average.  The output on the standard kernel was:
>
>  real: 1.022600
>  user: 0.135900
>  system: 0.852600
>
> The output after the patch was:
>
>  real: 0.815400
>  user: 0.113200
>  system: 0.622200
>
> These results were consistent which isn't surprising considering the
> fact that they themselves are averages.
> What do you think?

Those nymbers look very convincing to me, a cool 25.4% speedup!
mmap-perf is very MM intense - including vma lookup.

	Ingo
