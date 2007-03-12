Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXCLUpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXCLUpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXCLUpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:45:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:55201 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752888AbXCLUps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:45:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19dRZ4AVmRd3Ut8yL/QIJchgA0uVUiWnZ69VgPuFs
	K1y83E8vUx6sVy
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703130738.19034.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 21:45:44 +0100
Message-Id: <1173732344.6431.54.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 07:38 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 07:11, Mike Galbraith wrote:
> >
> > Killing the known corner case starvation scenarios is wonderful, but
> > let's not just pretend that interactive tasks don't have any special
> > requirements.
> 
> Now you're really making a stretch of things. Where on earth did I say that 
> interactive tasks don't have special requirements? It's a fundamental feature 
> of this scheduler that I go to great pains to get them as low latency as 
> possible and their fair share of cpu despite having a completely fair cpu 
> distribution.

As soon as your cpu is fully utilized, fairness looses or interactivity
loses.  Pick one.

	-Mike

