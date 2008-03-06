Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYCFKWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYCFKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYCFKWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:22:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYCFKWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:22:05 -0500
Date: Thu, 6 Mar 2008 11:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: show apicid for cpu in proc
Message-ID: <20080306102148.GB13391@elte.hu>
References: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> +		seq_printf(m, "apicid\t: %02x\n", c->apicid);

thanks, applied.

Note that the number of tabs were off and we generally print these IDs 
in %d, so i committed:

  seq_printf(m, "apicid\t\t: %d\n", c->apicid);

	Ingo
