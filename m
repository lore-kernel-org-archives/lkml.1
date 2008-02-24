Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYBXIIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYBXIIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 03:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYBXIHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 03:07:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYBXIHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 03:07:49 -0500
Date: Sun, 24 Feb 2008 09:07:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Priit Laes <plaes@plaes.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix build on non-C locales.
Message-ID: <20080224080737.GG9052@elte.hu>
References: <1203807950.12128.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203807950.12128.4.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Priit Laes <plaes@plaes.org> wrote:

> x86: fix build on some non-C locales[1].
> 
> For some locales regex range [a-zA-Z] does not work as it is supposed 
> to so we have to specify LANG=C to make it work as intended.

thanks, applied.

	Ingo
