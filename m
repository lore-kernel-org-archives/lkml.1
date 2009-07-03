Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZGCIyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZGCIyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZGCIxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:53:48 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:36025 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZGCIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b0q8MMQ1I4hx5FoP8G32ZQKhgc8IuSpqbrZcQrXVqcXCBFVrC3uIqRXMW41ZpPVdM0
         +JQdsJ6ysL71sSbEnTWkT8ayThSILgSfVXSKGJPWrY8p0KPLMMyfIeQ5MlsR3XqrNNU1
         GN+MX0GJn2Pg+ngChoTLiJJr5UxY83lWE2e1o=
Date: Fri, 3 Jul 2009 10:53:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703085344.GB4933@nowhere>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246524170.7113.20.camel@marge.simson.net> <20090703072941.GC7943@elte.hu> <1246608058.6257.25.camel@marge.simson.net> <20090703081556.GA21833@elte.hu> <1246609724.6257.28.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246609724.6257.28.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:28:44AM +0200, Mike Galbraith wrote:
> On Fri, 2009-07-03 at 10:15 +0200, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > > We need to calculate and cache the objdump annotation output 
> > > > once, but after that it should be pretty fast as we just display 
> > > > updated counts with the same lines over and over again. No 
> > > > repeated objdump runs are needed.
> > > 
> > > But active files follow symbols, which change on the fly.
> > > 
> > > Besides, as mentioned previously, while displayed annotation was 
> > > very cool, it took a lot of display space.  For me, top with the 
> > > ability to emit bic-disposable mini-reports would be my primary 
> > > perf tools usage. I'd only use big brothers when I needed their 
> > > power/detail.
> > 
> > Ok, then how about putting some sort of interactivity into perf top?
> > 
> > Up and down arrows would allow the walking of the histogram, and 
> > hitting enter on a symbol would show the annotated function? It 
> > would be way cool and more usable and more flexible than some 
> > side-channel for mini-reports.
> > 
> > PowerTop has a lot of good text interactivity code that might be 
> > reused. (assuming it's under a kernel compatible license?)
> > 
> > There's also the 'tig' tool - an interactive tool to walk Git 
> > trees/commits. If it's under a compatible license that would be a 
> > nice place to look for clues too - it has a very mature and 
> > well-thought-out TUI in my opinion.
> 
> Cool.  I love free samples to bend/spindle/mutilate :)
> 
> 	-Mike


The same interactivity could also apply to perf report, by dynamically
expanding callchains, linking to more details with annotate, etc...

