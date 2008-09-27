Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYI0RL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYI0RL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYI0RLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:11:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYI0RLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:11:51 -0400
Date: Sat, 27 Sep 2008 19:11:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 -tip 0/4] x86: signal handler improvement
Message-ID: <20080927171135.GA31552@elte.hu>
References: <48DBD396.5020103@ct.jp.nec.com> <48DBD519.6030204@zytor.com> <48DBD8A6.8060900@ct.jp.nec.com> <48DBD96F.6090309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DBD96F.6090309@zytor.com>
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

> Hiroshi Shimamoto wrote:
>>>>
>>> This is a gcc failure, and should be reported to the gcc people.
>>
>> Does this gcc failure mean unnecessary storing into stack?
>
> Yes, it should be able to process this in a register, instead of 
> storing to the stack and then merging later.
>
> It's possible it's trying to do that to hide latency, but that's 
> clearly a lose in this case.
>
> I'd hate to obfuscate the code, and I'd *really* hate to obfuscate the 
> code to work around gcc brokenness, and then not even bothering to 
> tell the gcc folks.

assuming it's reported to the gcc folks too, do you have any objections 
against including this in tip/x86/signal? The 1% improvement in lmbench 
is quite nice.

	Ingo
