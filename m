Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZGCI3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZGCI3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGCI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:28:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:50469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751742AbZGCI2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:28:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18t7QR/tVAtpbWPKyK5VL9yFyQqnirbe3yxlI9gJb
	Kgq/0Jjx2QySPc
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090703081556.GA21833@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
	 <1246524170.7113.20.camel@marge.simson.net> <20090703072941.GC7943@elte.hu>
	 <1246608058.6257.25.camel@marge.simson.net>
	 <20090703081556.GA21833@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 10:28:44 +0200
Message-Id: <1246609724.6257.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 10:15 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > We need to calculate and cache the objdump annotation output 
> > > once, but after that it should be pretty fast as we just display 
> > > updated counts with the same lines over and over again. No 
> > > repeated objdump runs are needed.
> > 
> > But active files follow symbols, which change on the fly.
> > 
> > Besides, as mentioned previously, while displayed annotation was 
> > very cool, it took a lot of display space.  For me, top with the 
> > ability to emit bic-disposable mini-reports would be my primary 
> > perf tools usage. I'd only use big brothers when I needed their 
> > power/detail.
> 
> Ok, then how about putting some sort of interactivity into perf top?
> 
> Up and down arrows would allow the walking of the histogram, and 
> hitting enter on a symbol would show the annotated function? It 
> would be way cool and more usable and more flexible than some 
> side-channel for mini-reports.
> 
> PowerTop has a lot of good text interactivity code that might be 
> reused. (assuming it's under a kernel compatible license?)
> 
> There's also the 'tig' tool - an interactive tool to walk Git 
> trees/commits. If it's under a compatible license that would be a 
> nice place to look for clues too - it has a very mature and 
> well-thought-out TUI in my opinion.

Cool.  I love free samples to bend/spindle/mutilate :)

	-Mike

