Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbXIJTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbXIJTfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759153AbXIJTfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:35:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbXIJTfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:35:30 -0400
Date: Mon, 10 Sep 2007 21:34:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 1/3] futex_compat: fix list traversal bugs
Message-ID: <20070910193453.GA4964@elte.hu>
References: <20070910191324.847651727@arndb.de> <20070910191648.561256021@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910191648.561256021@arndb.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* arnd@arndb.de <arnd@arndb.de> wrote:

> The futex list traversal on the compat side appears to have a bug.
> 
> It's loop termination condition compares:
> 
>         while (compat_ptr(uentry) != &head->list)
> 
> But that can't be right because "uentry" has the special "pi" 
> indicator bit still potentially set at bit 0.  This is cleared by 
> fetch_robust_entry() into the "entry" return value.

hm. I remember having tested this - not well enough i guess :-/

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
