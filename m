Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZHYJ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZHYJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZHYJ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:57:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46172 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbZHYJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:57:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.46451.893720.573893@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 19:57:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090825082612.GA17692@elte.hu>
References: <20090814134811.013873340@de.ibm.com>
	<tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
	<20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
	<19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
	<19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	<20090825082612.GA17692@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> If you suggest that each and every subsystem maintainer who touches 
> code that can be built on non-x86 architectures has to cross-build 
> to 20+ architectures to be able to push out a tree, all the time, 
> and has to rebase if this ever gets omitted, you are really defying 
> reality and are hurting Linux.

Nice straw man, but I never said or even suggested anything like
that. :)

I do think that it's reasonable to expect that a patch which touches
the architecture-specific code for some architecture gets compiled
for that architecture at least once before it gets set in stone.  As
far as I can tell, this didn't happen in the case of Martin's patch
that triggered this debate.

Patches which touch multiple architecture's arch-specific code should
also get sent to the maintainers of the affected architectures and the
linux-arch mailing list.  I don't recall seeing this patch on
linux-arch, though I may have missed it (and anyway that would be
Martin's responsibility not yours, but it does contribute to the sense
of being blindsided).

More generally - if you don't have the resources to do regular build
testing for powerpc or other architectures, then publish a testing
branch and we'll get kisskb (http://kisskb.ellerman.id.au/) to build a
selection of configs and architectures automatically.

Paul.
