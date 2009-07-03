Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZGCKa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZGCKa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZGCKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:30:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZGCKaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:30:18 -0400
Date: Fri, 3 Jul 2009 12:29:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
	vectored co-processor support for AMD and Intel Corei7/Nehalem
Message-ID: <20090703102953.GF32128@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu> <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam> <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246527872.13659.2.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

>  Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':
> 
>        17552264  vec-adds                  (scaled from 66.28%)
>        19715258  vec-muls                  (scaled from 66.63%)
>        15862733  vec-divs                  (scaled from 66.82%)
>     23735187095  vec-idle-cycles           (scaled from 66.89%)
>        11353159  vec-stall-cycles          (scaled from 66.90%)
>        36628571  vec-ops                   (scaled from 66.48%)

Is stall-cycles equivalent to busy-cycles? I.e. do we have this 
general relationship to the cycle event:

	cycles = vec-stall-cycles + vec-idle-cycles

?

	Ingo
