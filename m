Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbYBZJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbYBZJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYBZJr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:47:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbYBZJr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:47:57 -0500
Date: Tue, 26 Feb 2008 10:47:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for
	intel cpu
Message-ID: <20080226094742.GM9857@elte.hu>
References: <200802252320.01534.yinghai.lu@sun.com> <20080226072035.GB24820@elte.hu> <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com> <47C3C0D1.1020304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C3C0D1.1020304@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Yinghai Lu wrote:
>>>  which is the same. set_cpu_cap() is indeed the cleaner form to do this
>>>  so your patch is correct as a cleanup.
>> set_cpu_cap is right
>> ==
>> set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability); ===> is wrong
>> should be
>> set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
>>
>> x86_capability is a array ...
>
> For an array, the & is optional and has no effect.
>
> So they mean the same thing.

yeah. It's unnecessary entropy nevertheless and i've cleaned it all up 
in x86.git.

	Ingo
