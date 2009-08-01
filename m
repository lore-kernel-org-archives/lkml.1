Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZHABSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZHABSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 21:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZHABSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 21:18:09 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35798 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZHABSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 21:18:08 -0400
Date: Sat, 1 Aug 2009 11:14:29 +1000
From: Anton Blanchard <anton@samba.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, Ingo Molnar <mingo@elte.hu>,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com,
       acme@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090801011429.GA4685@kryten>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729192814.GT4148@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> > Building the perf tool is somewhat involved on sparc64
> > though, since 64-bit versions of zlib/libelf/bfd aren't
> > directly available (at least on debian 5.x). But once you
> > get there, it runs :-). Would it be easier/functional
> > to build 32-bit userland perf instead?
> 
> Same is true on ppc64, btw. How are others handling this?

The requirement for libz was removed, so up until recently we only needed
a 64bit version of elfutils which is easy to build.

It looks like we now have a requirement on binutils which is considerably
more painful to build. One option is to make the bfd requirement optional, all
you lose would be the ability to see c++ demangled names I think.

Anton
