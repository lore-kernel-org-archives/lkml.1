Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbYFIKPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbYFIKPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYFIKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:15:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305AbYFIKP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:15:29 -0400
Date: Mon, 9 Jun 2008 12:15:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: shrink pages should check all v2
Message-ID: <20080609101515.GB23873@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com> <200806081939.16577.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806081939.16577.yhlu.kernel@gmail.com>
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

> we are uing register_e820_active_regions instead of add_active_range 
> directly. so end_pfn could be different between the value in 
> early_node_map to node_end_pfn.
> 
> need to make shrink_active_range more smart.
> 
> shrink_active_range is only used x86 32 bit, or need to move back in 
> some file in arch/x86?
> 
> v2: use memcpy instead

applied, thanks.

	Ingo
