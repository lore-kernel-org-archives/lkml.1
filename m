Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbZLJHRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbZLJHRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZLJHQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:16:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbZLJHQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:16:51 -0500
Date: Thu, 10 Dec 2009 08:16:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David T. L. Wong" <davidtlwong@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.33] V4L/DVB updates
Message-ID: <20091210071649.GC16874@elte.hu>
References: <20091209021639.14f08856@pedra>
 <20091210062015.GA29594@elte.hu>
 <4B209D90.6080404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B209D90.6080404@gmail.com>
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


* David T. L. Wong <davidtlwong@gmail.com> wrote:

> Ingo Molnar wrote:
> >Hi,
> >
> >FYI, there's a new build failure on 32-bit x86 caused by the new
> >max2165 tuner driver:
> >
> >drivers/built-in.o: In function `max2165_set_params':
> >max2165.c:(.text+0x486293): undefined reference to `__floatunsidf'
> >max2165.c:(.text+0x4862bc): undefined reference to `__floatunsidf'
> >max2165.c:(.text+0x4862c5): undefined reference to `__adddf3'
> >max2165.c:(.text+0x4862cf): undefined reference to `__fixunsdfsi'
> >
> >	Ingo
> 
> 
> A patch is already submitted to v4l mailing list:
> http://patchwork.kernel.org/patch/64538/

That patch you posted a week ago solves the build problem, thanks.

	Ingo
