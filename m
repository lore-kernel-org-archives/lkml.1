Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYBKKMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYBKKMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYBKKMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:12:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYBKKMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:12:20 -0500
Date: Mon, 11 Feb 2008 11:12:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/8] CPA: Fix gbpages support in
	try_preserve_lage_page
Message-ID: <20080211101208.GA32181@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093429.CD9D31B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802111043340.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802111043340.12988@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 11 Feb 2008, Andi Kleen wrote:
> 
> > Use correct page sizes and masks for GB pages in 
> > try_preserve_large_page()
> > 
> > This prevents a boot hang on a GB capable system with 
> > CONFIG_DIRECT_GBPAGES enabled.
> 
> Doh, yes. Applied.

btw., v2.6.25-rc1 is not affected by this. Gbpages support is a "still 
cooking" feature only available in x86.git#mm, destined for .26, and 
even there it's default disabled and only available on Barcelona class 
hardware. (Some of these bits are upstream already to make maintenance 
easier, but they are inactive code.)

	Ingo
