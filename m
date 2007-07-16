Return-Path: <linux-kernel-owner+w=401wt.eu-S1765534AbXGPPSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765534AbXGPPSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbXGPPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:18:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXGPPSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:18:23 -0400
Date: Mon, 16 Jul 2007 17:18:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716151812.GA25944@elte.hu>
References: <Pine.LNX.4.64.0707161325040.1818@scrub.home> <21003.1184596954@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21003.1184596954@lwn.net>
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


* Jonathan Corbet <corbet@lwn.net> wrote:

> In the end, I did this because I thought msleep() should do what it 
> claims to do, because I thought that getting a known-to-expire timeout 
> off the timer wheel made sense, and to make a tiny baby step in the 
> direction of reducing the use of jiffies in the core code.

yeah, fully agreed.

	Ingo
