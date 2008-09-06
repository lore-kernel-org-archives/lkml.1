Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYIFRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYIFRxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYIFRxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:53:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYIFRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:53:15 -0400
Date: Sat, 6 Sep 2008 19:52:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: slightly stream-line 32-bit syscall entry code
Message-ID: <20080906175255.GW4856@elte.hu>
References: <48B805D7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B805D7.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Avoid updating registers or memory twice as well as needlessly loading
> or copying registers.

applied to tip/x86/core, thanks Jan - this should give a small speedup 
too.

	Ingo
