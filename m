Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZHFR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZHFR7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbZHFR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:59:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbZHFR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:59:20 -0400
Subject: Re: [perf] howto switch from pfmon
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Ingo Molnar <mingo@elte.hu>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A7B175B.8030000@inria.fr>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>
	 <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr>
	 <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr>
	 <20090629192913.GA29295@elte.hu>  <4A7B0C02.7060704@inria.fr>
	 <1249580428.4975.14.camel@laptop>  <4A7B175B.8030000@inria.fr>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 19:59:09 +0200
Message-Id: <1249581549.4975.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 19:48 +0200, Brice Goglin wrote:
> Peter Zijlstra wrote:
> > On Thu, 2009-08-06 at 18:59 +0200, Brice Goglin wrote:
> >
> >   
> >> I can easily sort them by thread id, but I don't know how to match my 4
> >> events with each group of 4 line.
> >>
> >> Maybe perf report earned some better way to show per-thread statistics
> >> in the meantime?
> >>     
> >
> > Nah, it needs some love..
> >
> > The below might be a starting point, it compiles, didn't check the
> > result. builtin-stat might be a nice place to look for more bits..
> >   
> 
> Thanks, now I get for each thread:
> 
> 0x8fc0 [0x30]: PERF_EVENT_READ: 6268 6268 FAIL 209113
> 0x9698 [0x30]: PERF_EVENT_READ: 6268 6268 FAIL 307215
> 0x9cf8 [0x30]: PERF_EVENT_READ: 6268 6268 FAIL 9203221
> 0x8bb8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000001e0 494628
> 
> Looks like it fails to stringified my raw events except the first one.

/me mumbles intelligble

I'll try and sort that out after dinner, unless you beat me to it :-)

