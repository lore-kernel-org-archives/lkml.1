Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZEHPJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZEHPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZEHPJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:09:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZEHPJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:09:18 -0400
Date: Fri, 8 May 2009 17:08:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090508150841.GB29974@elte.hu>
References: <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com> <20090506081225.GD8098@elte.hu> <20090506082300.GA16989@infradead.org> <20090506090512.GB24692@elte.hu> <20090506091115.GA24332@infradead.org> <20090506093740.GA7156@elte.hu> <20090507061343.9A986FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507061343.9A986FC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > It is far more efficient if Roland, Oleg (or you, if you are 
> > interested in this stuff - which you seem to be) did RFC patches and 
> > asked for maintainer acks, than to depend on maintainers to do it.
> 
> This has been on offer since the first user_regset stuff went into 
> 2.6.25, and I think I reiterated that on linux-arch when 
> CONFIG_HAVE_ARCH_TRACEHOOK went in.
> 
> What it does require is some arch person to at least show interest 
> in seeing the patches, test-build them and/or point to usable 
> cross compiler setups, etc.  It doesn't have to be arch 
> maintainers, but someone at all who uses the arch and is prepared 
> to build kernels for it.
> 
> In the case of arm, the fine Fedora/ARM folks had already made it 
> easy enough for me to do two web searches and find the cross 
> compilers, qemu settings, and system images I could get going 
> lickety-split without even asking anyone for pointers.  But as hch 
> noted, even doing 95% of the work myself up front (built and 
> tested!) hasn't yet helped get any feedback.
> 
> For any arch where there is anyone out there but the crickets, 
> it's easy for me to help with the actual code.  I just need a 
> little direction on arch build setups and maybe some specific arch 
> details questions, and a little feedback.  But where the only 
> people you can find who've heard of an arch say, "We haven't 
> looked what's upstream since 2.6.22 or so," I don't want to waste 
> my time on untried patches that will just go stale without ever 
> being compiled.

that's OK. If you went so far, if you were proactive and did due 
diligence, and nobody bothered, just push the changes into 
linux-next and there's no valid basis for future objections against 
those patches.

	Ingo
