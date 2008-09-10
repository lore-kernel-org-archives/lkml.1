Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYIJMEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYIJMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIJMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:04:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbYIJMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:04:34 -0400
Date: Wed, 10 Sep 2008 14:04:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/x86/kernel/kdebugfs.c: introduce missing kfree
Message-ID: <20080910120414.GC4970@elte.hu>
References: <Pine.LNX.4.64.0809101357210.15308@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809101357210.15308@pc-004.diku.dk>
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


* Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kmalloc should free the allocated 
> data. Note that at the point of the change, node has not yet been 
> stored in d, so it is not affected by the existing cleanup code.

applied to tip/x86/urgent, thanks Julia.

> The semantic match that finds the problem is as follows: 
> (http://www.emn.fr/x-info/coccinelle/)

cool stuff!

	Ingo
