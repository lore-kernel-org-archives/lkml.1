Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbXKOMt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbXKOMt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbXKOMtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:49:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbXKOMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:49:19 -0500
Date: Thu, 15 Nov 2007 13:48:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] slob: fix memory corruption
Message-ID: <20071115124844.GA6606@elte.hu>
References: <20071114225335.GV19691@waste.org> <20071114.154143.112110604.davem@davemloft.net> <20071115104331.GA11390@elte.hu> <200711152157.59409.nickpiggin@yahoo.com.au> <20071115112820.GA18228@elte.hu> <20071115113204.GA24463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115113204.GA24463@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Nick Piggin <npiggin@suse.de>

> -		if (free_slob_pages.next != prev->next)
> +		if (prev != free_slob_pages.prev &&
> +				free_slob_pages.next != prev->next)
>  			list_move_tail(&free_slob_pages, prev->next);

btw., exactly how did you find this bug? User-space simulation of SLOB?

	Ingo
