Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYFNGXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYFNGXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYFNGXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:23:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYFNGXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:23:31 -0400
Date: Sat, 14 Jun 2008 08:23:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: replace shrink pages with remove_active_ranges v2
Message-ID: <20080614062310.GB7340@elte.hu>
References: <200806132005.45836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806132005.45836.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> in case we have kva before ramdisk on node, we still need to use
> those ranges.
> 
> v2: reserve_early kva ram area, in case there are holes in highmem, to avoid
>     those area could be treat as free high pages.

applied to tip/x86/mpprarse - thanks Yinghai.

	Ingo
