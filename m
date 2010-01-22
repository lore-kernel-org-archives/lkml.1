Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789Ab0AVQvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0AVQvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117Ab0AVQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:51:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:35015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab0AVQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:51:10 -0500
Date: Fri, 22 Jan 2010 14:51:02 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: perf regression testing. was Re: [PATCH 1/2] perf symbols: Fix
	inverted logic for showing kallsyms as the source of symbols
Message-ID: <20100122165101.GA2689@ghostprotocols.net>
References: <1264178102-4203-1-git-send-email-acme@infradead.org> <1264178608.5935.0.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264178608.5935.0.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 22, 2010 at 05:43:28PM +0100, Mike Galbraith escreveu:
> On Fri, 2010-01-22 at 14:35 -0200, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Only if we parsed /proc/kallsyms (or a copy found in the buildid cache)
> > we should set the dso long name to "[kernel.kallsyms]".
> 
> Yup, works just as well as my busted one :)

yeah :-)

I'll soon start working on 'perf regtest', to start accumulating
regression tests a la 'perf bench', as these silly bugs are worrying
me...

Some will require more than one machine, and of different archs, so that
we can properly test 'perf archive' and the buildid machinery, etc. Some
need to compare what we get from kallsyms with what we get from vmlinux
of same buildid, etc.

We'll use this when developing new tools or changing the core code, and
a subset of it can also be used by users to sanity test their
environment.

If not I'll have to continue relying on you as my regression test ;-)

- Arnaldo
