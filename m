Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbXGXTPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbXGXTPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXGXTPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:15:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbXGXTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:15:23 -0400
Date: Tue, 24 Jul 2007 21:15:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -rt] Preemption problem in kernel RT Patch
Message-ID: <20070724191515.GC13268@elte.hu>
References: <1182608766.20203.208.camel@chaos> <77B279EC7347F341A6AE891AA6AD68E931429B@ranchero.sycamorenet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E931429B@ranchero.sycamorenet.com>
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


* Beauchemin, Mark <Mark.Beauchemin@sycamorenet.com> wrote:

> I'm not sure why the check for recursion has been removed.  In the 
> backtrace below, I think it would be caught by this check and not 
> recursively call the spinlock code.

ah ... i think i did it like that because i didnt realize that there 
would be a recursive call sequence, i was concentrating on recursive 
locking.

incidentally, this code got cleaned up in .23-rc1-rt0, and now it looks 
quite similar to your suggested fix. Could you double-check that it 
solves your problem?

	Ingo
