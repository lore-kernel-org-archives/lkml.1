Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYKWTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYKWTYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKWTYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:24:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYKWTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:24:03 -0500
Date: Sun, 23 Nov 2008 20:23:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86: HPET: fix sparse warning
Message-ID: <20081123192355.GA904@elte.hu>
References: <154e089b0811231119s2c91de2md3144ff9ed2d73f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811231119s2c91de2md3144ff9ed2d73f7@mail.gmail.com>
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

> Fix this sparse warning:
> 
> arch/x86/kernel/hpet.c:36:18: warning: symbol 'hpet_num_timers' was
> not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/kernel/hpet.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/x86/sparse-fixes, thanks!

	Ingo
