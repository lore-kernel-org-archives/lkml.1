Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZGCIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZGCIBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZGCIA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:00:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:54658 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751118AbZGCIA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:00:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/nKlw2yz7ncjtCA5g9zeCl97gUF+sl+PbXan5G6X
	8WVtFYpoze5AvX
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090703072941.GC7943@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
	 <1246524170.7113.20.camel@marge.simson.net> <20090703072941.GC7943@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 10:00:58 +0200
Message-Id: <1246608058.6257.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 09:29 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> > 
> > > After I resurrect (well, try) live annotation in top...
> > 
> > Random thought wrt live top annotation: instead of resurrecting in 
> > the previous form, which could be a bit intrusive display space 
> > wise, what do you think of this idea?
> > 
> > Provide a kbd input snapshot trigger which builds a perf record 
> > (hard?) compatible file for the symbols being displayed.  Start a 
> > background task to annotate the lot, stuffing annotate output into 
> > an output file.
> > 
> > Better ideas highly welcome.
> 
> Hm, is there really a performance problem?

Sort of..

> We need to calculate and cache the objdump annotation output once, 
> but after that it should be pretty fast as we just display updated 
> counts with the same lines over and over again. No repeated objdump 
> runs are needed.

But active files follow symbols, which change on the fly.

Besides, as mentioned previously, while displayed annotation was very
cool, it took a lot of display space.  For me, top with the ability to
emit bic-disposable mini-reports would be my primary perf tools usage.
I'd only use big brothers when I needed their power/detail.

	-Mike

