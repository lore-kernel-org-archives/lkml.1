Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYDRHsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYDRHsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYDRHr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:47:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbYDRHr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:47:57 -0400
Date: Fri, 18 Apr 2008 09:47:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418074736.GA27579@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417232747.4c04f413.akpm@linux-foundation.org> <20080417.233856.238029159.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417.233856.238029159.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 17 Apr 2008 23:27:47 -0700
> 
> > On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Arjan van de Ven (6):
> > >	...
> > >       x86: mark init_mm deprecated
> > 
> > Why can't I find this patch on the mailing list?
> > 
> > It's an MM patch which touches sched.h.  It should not be in 
> > git-x86. It generates over a megabyte of warnings on sparc64.
> 
> If you're going to touch generic code, test build on other platforms 
> or get it into a tree where such build testing is done for you.

we do an automatic build test (of both vmlinux and of modules) of over 
80 non-x86 architecture configs, amongst them are sparc64 and sparc 
configs:

  http://www.tglx.de/autoqa-cgi/index?run=86&tree=1

for the latest version of our trees all the 80 non-x86 configs (and all 
96 configs in total) built successfully.

if in the sparc64 row you click on the green "OK" button (which signals 
that the build was successful) you can get the build log and see all 7 
warnings that get triggered on the sparc64 defconfig with 
sched-devel/latest [which embedds x86/latest].

so i'm not sure where those "over a megabyte of warnings" come from.

	Ingo
