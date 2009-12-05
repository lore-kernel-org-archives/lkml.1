Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZLEHC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZLEHC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZLEHC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:02:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZLEHC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:02:57 -0500
Date: Sat, 5 Dec 2009 08:02:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: What is the performance when using frame pointers in the kernel?
Message-ID: <20091205070249.GA23330@elte.hu>
References: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan>
 <1259868529.3977.1300.camel@laptop>
 <alpine.LRH.2.00.0912041422360.9567@twin.jikos.cz>
 <alpine.DEB.2.00.0912041024500.16957@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912041024500.16957@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> On Fri, 4 Dec 2009, Jiri Kosina wrote:
> 
> >On Thu, 3 Dec 2009, Peter Zijlstra wrote:
> >
> >>>What is the performance hit when the kernel is compiled with frame
> >>>pointers?
> >>
> >>build both kernels and run your favourite workload to find out.
> >
> >But generally speaking, frame pointers impose quite some performance
> >penalty indeed. lmbench syscall microbenchmark can give you some hint. I
> >expect you'll see approx. 10% performance increase for various syscalls if
> >you disable them, as that's what we have measured lately.
> >
> >-- 
> >Jiri Kosina
> >SUSE Labs, Novell Inc.
> >
> 
> Thanks for the response.. Good to know.

I dont buy the 10% without seeing precise measurement results. 1-2% 
maybe, in some cases.

	Ingo
