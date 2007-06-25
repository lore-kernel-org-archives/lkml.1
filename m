Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbXFYHBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbXFYHBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXFYHBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:01:41 -0400
Received: from [157.181.1.138] ([157.181.1.138]:38424 "EHLO mx3.mail.elte.hu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380AbXFYHBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:01:41 -0400
Date: Mon, 25 Jun 2007 08:59:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 nmi watchdog hang
Message-ID: <20070625065956.GA31725@elte.hu>
References: <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625061819.GA21874@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hm, restoring nmi.c to the v2.6.21 state does not fix the nmi_watchdog=2 
hang. I'll do a bisection run.

	Ingo

