Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYJTNsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYJTNsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYJTNr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:47:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYJTNr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:47:59 -0400
Date: Mon, 20 Oct 2008 15:47:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jike Song <albcamus@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions about rd{msr|tsc|pmc} instruction with x86-64
Message-ID: <20081020134740.GA8007@elte.hu>
References: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com> <48F6E1A7.2070602@zytor.com> <df9815e70810160931s86c9058rc18d426ce278aa30@mail.gmail.com> <48F76FA3.1000602@zytor.com> <48F821B3.2060300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F821B3.2060300@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jike Song <albcamus@gmail.com> wrote:

> H. Peter Anvin wrote:
>>  Jike Song wrote:
>> > Thanks, Peter!  So I misunderstood the gcc constraint 'A' for x86-64,
>> > but seems the comment "while x86_64 returns at rax" still wrong,
>> > should this be fixed?
>>
>>  Yes, feel free to submit a patch.
>>
>>     -hpa
> Here you go... CC trivial@kernel.org as well.
>
> From 6eed2948d41f959dc113eb3ff30927bcacf34d08 Mon Sep 17 00:00:00 2001
> From: Jike Song <albcamus@gmail.com>
> Date: Fri, 17 Oct 2008 10:51:13 +0800
> Subject: [PATCH] x86: correct wrong comment
>
> The rdmsr instruction(et al) for i386 and x86-64 are semantically same.
> The only difference is how gcc interpret constraint "A" for these targets.
>
> Signed-off-by: Jike Song <albcamus@gmail.com>
> ---
> include/asm-x86/msr.h |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)

applied to tip/x86/cleanups, thanks!

	Ingo
