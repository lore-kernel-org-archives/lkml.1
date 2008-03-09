Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYCIUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYCIUMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYCIUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:12:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYCIUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:12:04 -0400
Date: Sun, 9 Mar 2008 21:11:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080309201152.GB28454@elte.hu>
References: <20080309200103.GA895@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309200103.GA895@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> --- a/lib/find_next_bit.c
> +++ b/lib/find_next_bit.c
> @@ -15,6 +15,8 @@
>  #include <asm/byteorder.h>
>  
>  #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
> +#undef find_next_bit
> +#undef find_next_zero_bit

this bit looks weird - did you need it for testing?

	Ingo
