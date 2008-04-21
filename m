Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYDUTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYDUTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYDUTcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:32:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYDUTcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:32:09 -0400
Date: Mon, 21 Apr 2008 21:31:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
	latest -git
Message-ID: <20080421193147.GA8770@elte.hu>
References: <20080419100034.GA9475@elte.hu> <20080419.030337.244502148.davem@davemloft.net> <20080419103942.GA13599@elte.hu> <20080419.040945.13369499.davem@davemloft.net> <20080421082254.GA2522@elte.hu> <480C780C.2030402@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C780C.2030402@trash.net>
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


* Patrick McHardy <kaber@trash.net> wrote:

>> for the last 3 days my own automated bug finding capacity is at 10% 
>> of its normal throughput (it booted only 200 kernels, instead of 2000 
>> kernels) - which is OK in early phases of the merge window, but you 
>> seem to deny that i have any standing to argue development process 
>> issues.
>
> In my perception networking is not doing worse than other subsystems, 
> this (small) accumulation of build-bugs seems more like an unfortunate 
> coincidence caused by two people being sloppy during testing (me and 
> the LED guys).

nah, it's not doing worse at all and my comment was not really about the 
bug itself (bugs happen), but about the most efficient way to report 
that bug - which in hindsight is not an argument i should have gotten 
into. arch/x86 has at least this proportion of build bugs if not more. 
[and the scheduler is a 50 times smaller piece of code so it's not 
really comparable.]

btw., managed to test 755 random kernels today:

  #define UTS_VERSION "#755 SMP PREEMPT Mon Apr 21 21:12:52 CEST 2008"

with no runtime (or build) failure anywhere. [other than in freshly 
added x86.git or scheduler patches that is.]

	Ingo
