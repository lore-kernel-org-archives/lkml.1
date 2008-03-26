Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYCZGH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYCZGH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYCZGHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:07:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYCZGHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:07:14 -0400
Date: Wed, 26 Mar 2008 07:06:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, H Peter Anvin <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ian Molton <spyro@f2s.com>, Alain L Knaff <Alain.Knaff@lll.lu>,
       David C Niemi <niemi@tux.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 floppy: kill off the 'register' keyword from header
Message-ID: <20080326060643.GA18301@elte.hu>
References: <alpine.LNX.1.00.0803260214551.1901@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0803260214551.1901@dragon.funnycrock.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Juhl <jesper.juhl@gmail.com> wrote:

> -	register unsigned char st;
> +	unsigned char st;

> -		register int lcount;
> -		register char *lptr;
> +		int lcount;
> +		char *lptr;

thanks, applied.

	Ingo
