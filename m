Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYCULSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYCULSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYCULSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:18:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYCULSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:18:43 -0400
Date: Fri, 21 Mar 2008 12:18:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify sync_test_bit()
Message-ID: <20080321111826.GC20420@elte.hu>
References: <47DA3DC0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA3DC0.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3464]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> There really is no need for a redundant implementation here, just keep 
> the alternative name for allowing consumers to use consistent naming.

> -	__asm__ __volatile__("btl %2,%1\n\tsbbl %0,%0"
> -			     :"=r" (oldbit)
> -			     :"m" (ADDR),"Ir" (nr));

> +#define sync_test_bit test_bit

thanks, applied.

	Ingo
