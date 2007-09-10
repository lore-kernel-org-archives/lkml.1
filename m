Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXIJTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXIJTgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXIJTfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:35:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871AbXIJTfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:35:52 -0400
Date: Mon, 10 Sep 2007 21:35:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] futex_compat: simplify pointer magic
Message-ID: <20070910193516.GB4964@elte.hu>
References: <20070910191324.847651727@arndb.de> <20070910191648.715953031@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910191648.715953031@arndb.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* arnd@arndb.de <arnd@arndb.de> wrote:

> The futex_compat code currently mixes pointers to robust_list and 
> compat_robust_list for no apparent reason other than requiring extra 
> typecasts. It also uses an extra argument to fetch_robust_entry() that 
> is not useful but has caused bugs to be introduced before.
> 
> Clean up the code to get rid of all this and make the compat version 
> look more like the native one.

yeah.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
