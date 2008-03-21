Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYCUKZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYCUKZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYCUKYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:24:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYCUKYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:24:53 -0400
Date: Fri, 21 Mar 2008 11:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: remove the write-only timer_uses_ioapic_pin_0
Message-ID: <20080321102439.GJ20420@elte.hu>
References: <20080317202932.GD9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317202932.GD9550@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0504]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the write-only timer_uses_ioapic_pin_0 (gsi can't 
> be <= 15 in the line of it's fake usage in mpparse_32.c).

thanks, applied.

> Spotted by the GNU C compiler.

:-)

	Ingo
