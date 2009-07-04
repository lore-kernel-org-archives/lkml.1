Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZGDNz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZGDNz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 09:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZGDNzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 09:55:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZGDNzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 09:55:18 -0400
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
 vectored co-processor support for AMD and Intel Corei7/Nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090704094921.GA2139@elte.hu>
References: <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam>
	 <20090703102953.GF32128@elte.hu>
	 <1246622122.2322.25.camel@jaswinder.satnam> <20090704094921.GA2139@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 19:24:35 +0530
Message-Id: <1246715675.2329.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-04 at 11:49 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Fri, 2009-07-03 at 12:29 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > >  Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':
> > > > 
> > > >        17552264  vec-adds                  (scaled from 66.28%)
> > > >        19715258  vec-muls                  (scaled from 66.63%)
> > > >        15862733  vec-divs                  (scaled from 66.82%)
> > > >     23735187095  vec-idle-cycles           (scaled from 66.89%)
> > > >        11353159  vec-stall-cycles          (scaled from 66.90%)
> > > >        36628571  vec-ops                   (scaled from 66.48%)
> > > 
> > > Is stall-cycles equivalent to busy-cycles? 
> > 
> > 
> > hmm, normally we can use these terms interchangeably. But they can 
> > be different some times.
> > 
> > busy means it is already executing some instructions so it will 
> > not take another instruction.
> > 
> > stall can be busy(executing) or non-executing may be it is waiting 
> > for some operands due to cache miss.
> > 
> > 
> > > I.e. do we have this 
> > > general relationship to the cycle event:
> > > 
> > > 	cycles = vec-stall-cycles + vec-idle-cycles
> > > 
> > > ?
> > 
> > This patch is already big enough, having 206 lines. Do you want 
> > everything in this patch ;-)
> 
> The question i asked is whether the above relationship is true. You 
> can test this by displaying the 'cycles' metric too in your test, 
> alongside vec-stall-cycles and vec-idle-cycles. Do the numbers add 
> up?
> 

But I do not understand why you asked this relationship from me, you can
also do this on your side.

What is the point of blocking the patch and going on another tangent.

I am totally confused on one side your are saying this patch is useful
and another side you are not applying it.

Please let me know what is the problem in this patch so that I can fix
it and so that you can apply this patch and another people can start
taking benefit from this feature.

Thanks,
--
JSR

