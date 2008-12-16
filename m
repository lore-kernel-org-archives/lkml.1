Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYLPTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYLPTz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYLPTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:55:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYLPTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:55:19 -0500
Date: Tue, 16 Dec 2008 20:55:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86: Support always running TSC on Intel CPUs
Message-ID: <20081216195505.GC4501@elte.hu>
References: <20081125235751.576792000@intel.com> <20081125235852.402898000@intel.com> <7E82351C108FA840AB1866AC776AEC464338C10B@orsmsx505.amr.corp.intel.com> <4946E05E.9080503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4946E05E.9080503@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Pallipadi, Venkatesh wrote:
>> hpa/Ingo,
>>
>> Haven't seen any comments on the patches here. Can you push it along in case there are no issues.
>>
>
> Hi Venki,
>
> Sorry about that -- I think you know what's up on my end :) Will look at 
> it as soon as I can.

okay - i queued it up in x86/tsc. It looked sane last time too, just the 
'NOSTOP_TSC' name sucked. I changed it to NONSTOP_TSC - hopefully we wont 
ever need a REALLY_NON_STOP_TSC distinction in the future ;-)

	Ingo
