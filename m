Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827Ab0AWPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0AWPxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0AWPxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:53:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:56706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0AWPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:53:11 -0500
Date: Sat, 23 Jan 2010 13:52:54 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf regression testing. was Re: [PATCH 1/2] perf symbols: Fix
 inverted logic for showing kallsyms as the source of symbols
Message-ID: <20100123155254.GB24418@ghostprotocols.net>
References: <1264178102-4203-1-git-send-email-acme@infradead.org>
 <1264178608.5935.0.camel@marge.simson.net>
 <20100122165101.GA2689@ghostprotocols.net>
 <20100123070451.GC15774@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123070451.GC15774@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 23, 2010 at 08:04:51AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Em Fri, Jan 22, 2010 at 05:43:28PM +0100, Mike Galbraith escreveu:
> > > On Fri, 2010-01-22 at 14:35 -0200, Arnaldo Carvalho de Melo wrote:
> > > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > > 
> > > > Only if we parsed /proc/kallsyms (or a copy found in the buildid cache)
> > > > we should set the dso long name to "[kernel.kallsyms]".
> > > 
> > > Yup, works just as well as my busted one :)
> > 
> > yeah :-)
> > 
> > I'll soon start working on 'perf regtest', to start accumulating regression 
> > tests a la 'perf bench', as these silly bugs are worrying me...
> 
> Excellent, it's much needed!
> 
> The best example i know about is KVM: they have built an impressive regression 
> test suite and add testcases for new regressions all the time.
> 
> The key is to have something simple to run, which developers (and 
> maintainers) can run after every new perf commit or so.

Yes, that is the idea, I'm finishing the first test (/proc/kallsyms
versus what we get from a auto-located vmlinux symtab) and will submit
it soon:

[acme@doppio linux-2.6-tip]$ perf regtest
 1: vmlinux symtab matches kallsyms... 
Segmentation fault
[acme@doppio linux-2.6-tip]$

Not quite working yet, tho :o)

- Arnaldo
