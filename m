Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYCYLBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYCYLBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYCYLAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:00:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYCYLAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:00:53 -0400
Date: Tue, 25 Mar 2008 12:00:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080325110040.GC3729@elte.hu>
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu> <86802c440803211704u4fb07074w934f32d2f95bf6a7@mail.gmail.com> <20080322120400.GE13264@elte.hu> <86802c440803220959r4515e2a0n6de2d8d201545a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803220959r4515e2a0n6de2d8d201545a3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sat, Mar 22, 2008 at 5:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >  > >  one structural observation: please make this unified functionality,
> >  > >  so that 32-bit kernels can make use of it too.
> >  >
> >  > that will need to use PAE to switch 2G windows ....
> >
> >  well, please try some non-PAE, checks-direct-mappings approach - if 
> >  someone wants to extend it to the highmem bits i'm sure it will be 
> >  done.
> 
> OK, First need to move some early_res code from e820_64.c to e820_32.c

yeah, please do that.

> or we can start to merge them. anyone is working on that?

not that i know of - feel free.

	Ingo
