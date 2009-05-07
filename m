Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZEGGTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZEGGTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZEGGTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:19:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZEGGTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:19:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
In-Reply-To: Ingo Molnar's message of  Wednesday, 6 May 2009 11:37:40 +0200 <20090506093740.GA7156@elte.hu>
References: <20090503185537.GA17071@redhat.com>
	<20090504184951.623CEFC32F@magilla.sf.frob.com>
	<20090504193016.GA17076@redhat.com>
	<20090504194348.BC0EBFC32F@magilla.sf.frob.com>
	<20090504163154.f3672a83.akpm@linux-foundation.org>
	<20090505230642.GA980@redhat.com>
	<20090506081225.GD8098@elte.hu>
	<20090506082300.GA16989@infradead.org>
	<20090506090512.GB24692@elte.hu>
	<20090506091115.GA24332@infradead.org>
	<20090506093740.GA7156@elte.hu>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090507061343.9A986FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 23:13:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is far more efficient if Roland, Oleg (or you, if you are 
> interested in this stuff - which you seem to be) did RFC patches and 
> asked for maintainer acks, than to depend on maintainers to do it.

This has been on offer since the first user_regset stuff went into 2.6.25,
and I think I reiterated that on linux-arch when CONFIG_HAVE_ARCH_TRACEHOOK
went in.

What it does require is some arch person to at least show interest in
seeing the patches, test-build them and/or point to usable cross compiler
setups, etc.  It doesn't have to be arch maintainers, but someone at all
who uses the arch and is prepared to build kernels for it.

In the case of arm, the fine Fedora/ARM folks had already made it easy
enough for me to do two web searches and find the cross compilers, qemu
settings, and system images I could get going lickety-split without even
asking anyone for pointers.  But as hch noted, even doing 95% of the work
myself up front (built and tested!) hasn't yet helped get any feedback.

For any arch where there is anyone out there but the crickets, it's easy
for me to help with the actual code.  I just need a little direction on
arch build setups and maybe some specific arch details questions, and a
little feedback.  But where the only people you can find who've heard of an
arch say, "We haven't looked what's upstream since 2.6.22 or so," I don't
want to waste my time on untried patches that will just go stale without
ever being compiled.


Thanks,
Roland
