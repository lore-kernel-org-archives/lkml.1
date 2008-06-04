Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbYFDK0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbYFDK0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFDK0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:26:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYFDK03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:26:29 -0400
Date: Wed, 4 Jun 2008 12:26:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: numa32 make sure get kva space
Message-ID: <20080604102614.GC22971@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031932.31376.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806031932.31376.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> when 1/3 user/kernel is used, and less memory is installed, or have big hole
> below 4g, max_low_pfn is still using 3g-128m
> 
> try to go down from max_low_pfn until get it. otherwise will panic.
> 
> need to make 32bit code to use register_e820_active_regions...later
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks.

	Ingo
