Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZHAIUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZHAIUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZHAIUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:20:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43278 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZHAIUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:20:48 -0400
Date: Sat, 1 Aug 2009 10:20:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, Ingo Molnar <mingo@elte.hu>,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com,
       acme@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090801082048.GX12579@kernel.dk>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801011429.GA4685@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01 2009, Anton Blanchard wrote:
> 
> Hi,
> 
> > > Building the perf tool is somewhat involved on sparc64
> > > though, since 64-bit versions of zlib/libelf/bfd aren't
> > > directly available (at least on debian 5.x). But once you
> > > get there, it runs :-). Would it be easier/functional
> > > to build 32-bit userland perf instead?
> > 
> > Same is true on ppc64, btw. How are others handling this?
> 
> The requirement for libz was removed, so up until recently we only needed
> a 64bit version of elfutils which is easy to build.
> 
> It looks like we now have a requirement on binutils which is considerably
> more painful to build. One option is to make the bfd requirement optional, all
> you lose would be the ability to see c++ demangled names I think.

Right, binutils is the ugly one. I got a libbfd.so built for both ppc
and sparc, but it wasn't just a make && make install job. Personally I
could not care less about losing c++ demangled name support, so that
approach sounds fine to me :-)

-- 
Jens Axboe

