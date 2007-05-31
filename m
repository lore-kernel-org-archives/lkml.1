Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbXEaJuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbXEaJuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXEaJun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:50:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbXEaJum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:50:42 -0400
Date: Thu, 31 May 2007 11:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeff@garzik.org, zach.brown@oracle.com, arjan@infradead.org,
       hch@infradead.org, drepper@redhat.com, akpm@zip.com.au,
       alan@lxorguk.ukuu.org.uk
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070531095018.GA6307@elte.hu>
References: <787b0d920705310115n13b4dd3bk59e1072dea147724@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920705310115n13b4dd3bk59e1072dea147724@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Albert Cahalan <acahalan@gmail.com> wrote:

> Ingo Molnar writes:
> 
> >looking over the list of our new generic APIs (see further below) i
> >think there are three important things that are needed for an API to
> >become widely used:
> >
> > 1) it should solve a real problem (ha ;-), it should be intuitive to
> >    humans and it should fit into existing things naturally.
> >
> > 2) it should be ubiquitous. (if it's about IO it should cover block IO,
> >    network IO, timers, signals and everything) Even if it might look
> >    silly in some of the cases, having complete, utter, no compromises,
> >    100% coverage for everything massively helps the uptake of an API,
> >    because it allows the user-space coder to pick just one paradigm
> >    that is closest to his application and stick to it and only to it.
> >
> > 3) it should be end-to-end supported by glibc.
> 
> 4) At least slightly portable.
> 
> Anything supported by any similar OS is already ahead, even if it 
> isn't the perfect API of our dreams. [...]

it might have been so a few years ago but it's changing slowly but 
surely - BSD is becoming more and more irrelevant. What matters mostly 
to app writers these days: "is it in most Linux distros" - and the key 
to that is upstream kernel support and glibc support. The days of BSD 
(and UNIX) are pretty much numbered. (I'm not against standardizing APIs 
in POSIX of course - the BSDs tend to follow the Linux APIs in that area 
with a few years lag.)

	Ingo
