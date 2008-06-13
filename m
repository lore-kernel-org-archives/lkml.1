Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbYFMLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbYFMLXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYFMLXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:23:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbYFMLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:23:15 -0400
Date: Fri, 13 Jun 2008 13:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: clean up reserve_bootmem_generic
Message-ID: <20080613112256.GE9867@elte.hu>
References: <200806130200.56822.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806130200.56822.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 1. add reserve_bootmem_generic for 32bit
> 2. change len to unsigned long
> 3. make early_res_to_bootmem to use it

applied to tip/x86/mpparse - thanks Yinghai.

This does properly finish my band-aid:

# x86/mpparse: f245905: x86: unify the reserve_bootmem() behavior of early_res_to_bootmem()

correct?

	Ingo
