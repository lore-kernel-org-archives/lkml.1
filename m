Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYIFRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYIFRZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYIFRZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:25:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYIFRZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:25:42 -0400
Date: Sat, 6 Sep 2008 19:25:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
	- lockdep related?]
Message-ID: <20080906172523.GL4856@elte.hu>
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com> <1220642738.11202.21.camel@twins.programming.kicks-ass.net> <48C19415.9060108@kernel.org> <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com> <20080906145122.GA7693@elte.hu> <68676e00809061020y440d4c14ye76413d1e0e57e38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00809061020y440d4c14ye76413d1e0e57e38@mail.gmail.com>
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


* Luca Tettamanti <kronos.it@gmail.com> wrote:

> > or perhaps something made your v2.6.27 bzImage larger so that the 
> > overlap happens - while it didnt before.
> 
> The compressed image (bzImage) is roughly the same size as older
> kernels (2MB), the uncompressed vmlinux is slightly bigger, but not
> much (~100k)

hm, that doesnt seem to match the ranges that got printed:

| Kernel is loaded at the standard 2MB physical, and goes up to 13.6MB 
| physical. That's a tad large at 11.6 MB but still valid.

so how come a ~2MB vmlinux takes 11.6 MB? Is the bss that large for some 
reason perhaps?

	Ingo
