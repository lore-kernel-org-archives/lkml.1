Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYKWMjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYKWMjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYKWMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:39:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYKWMjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:39:11 -0500
Date: Sun, 23 Nov 2008 13:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86: Remove duplicate #define from 'cpufeature.h'
Message-ID: <20081123123907.GJ29663@elte.hu>
References: <154e089b0811230435m5d3182feyff0babb8c55cec72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811230435m5d3182feyff0babb8c55cec72@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Hannes Eder <hannes@hanneseder.net> wrote:

> Remove duplicate #define from 'cpufeature.h'.
> 
> This also fixes the following sparse warning:
> 
> arch/x86/kernel/cpu/capflags.c:54:3: warning: Initializer entry defined twice
> arch/x86/kernel/cpu/capflags.c:58:3:   also defined here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/include/asm/cpufeature.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

applied to tip/x86/cpufeature, thanks Hannes!

	Ingo
