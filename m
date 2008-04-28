Return-Path: <linux-kernel-owner+w=401wt.eu-S937135AbYD1U0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937135AbYD1U0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbYD1U0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:26:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbYD1U0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:26:09 -0400
Date: Mon, 28 Apr 2008 22:25:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080428202552.GG15840@elte.hu>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481607AF.80803@zytor.com>
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

> Mathieu Desnoyers wrote:
>>
>> Thanks to Peter for the review.
>
> Just in case someone gets the wrong idea...
>
> I still think this is the completely wrong approach.

hm, can it result in a broken kernel? If yes, how? Or are your 
objections more higher level?

i actually like that we end up with something rather NOP-ish, with some 
mild 'ambient' impact due to the extra constraints that state value 
visibility brings with it. The in-source impact of the markers is 
minimal, especially with Peter Zijstra's wrappers. The scheduler markers 
at least are also expected to stay pretty stable as well.

the syscall markers should be done less intrusively - and i think they 
can be done less intrusively.

but we need to get past this current impasse, the optimizations that 
Mathieu has done to markers are pretty impressive so far. The overhead 
is not zero, but it gets quite close to it and the SystemTap and kprobes 
people are happy with it as well.

> I'd use stronger terms, but Al Viro would sue me for copyright 
> infringement.

it would clearly fall under the Fair Use Doctrine and perhaps also under 
the Doctrine of Severe Necessities, so dont be shy!

	Ingo
