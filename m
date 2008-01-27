Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYA0WBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYA0WBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYA0WBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:01:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbYA0WBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:01:14 -0500
Date: Sun, 27 Jan 2008 23:01:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c
Message-ID: <20080127220104.GA3503@elte.hu>
References: <20080127223451.79718183@paolo-desktop> <479CFB62.1010808@gmail.com> <4d8e3fd30801271351p44818f64p27ca4ae897efbb81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801271351p44818f64p27ca4ae897efbb81@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> On Jan 27, 2008 10:45 PM, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> > > -  math_abort(FPU_info,SIGILL);
> > > +  math_abort(FPU_info , SIGILL);
> >
> > Looks like you're trading bad for worse here.
> 
> Should I make it read like math_abort(FPU_info, SIGILL); ?

yeah, that's the correct one.

> > While you're at it, please think about adding proper KERN_ facility to these printk() calls.
> 
> Yes, basically all the warnings are about missing KERN_. Do you want 
> me to add KERN_ERR to all the above printk?

Do that in a separate patch though, as it changes strings. (and hence 
the checking for 'did the object md5 change' misfires)

	Ingo
