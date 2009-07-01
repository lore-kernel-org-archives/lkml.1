Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZGALlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZGALlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZGALld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:41:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:51157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZGALlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:41:32 -0400
Subject: Re: [PATCH 3/6 -tip] perf_counter: Add Generalized Hardware
 vectored co-processor support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090701112704.GF15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 17:10:41 +0530
Message-Id: <1246448441.6940.3.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 13:27 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':
> > > 
> > >     20177177044  vec-adds                  (scaled from 66.63%)
> > >     34101687027  vec-muls                  (scaled from 66.64%)
> > >      3984060862  vec-divs                  (scaled from 66.71%)
> > >     26349684710  vec-idle-cycles           (scaled from 66.65%)
> > >      9052001905  vec-stall-cycles          (scaled from 66.66%)
> > >     76440734242  vec-ops                   (scaled from 66.71%)
> > > 
> > >   272.523058097  seconds time elapsed
> 
> btw., the 'perf list' bits are missing - any new counter added 
> should be listed by 'perf list' as well - otherwise people wont know 
> what we have and what to use.
> 

Even cache is not available for 'perf list'. Should I also resend patch
for adding cache along with vector and interrupt.

Thanks,
--
JSR

