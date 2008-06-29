Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYF2HI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYF2HI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYF2HIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:08:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYF2HIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:08:49 -0400
Date: Sun, 29 Jun 2008 09:08:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v4
Message-ID: <20080629070833.GA4898@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <200806281749.02000.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806281749.02000.yhlu.kernel@gmail.com>
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

> some end boundary is only page alignment, instead of 2M alignment,
> so call ker_phycial_mapping_init three times.
> then don't overmap above the max_low_pfn
> 
> v2: make init_memory_mapping more solid: start could be any value other than 0
> v3: fix NON PAE by handling left over in kernel_physical_mapping
> v4: revert back to v2, and use PMD_SHIFT to calculate boundary
>     also adjust size for pre-allocated table size

i've got v3 applied to tip/master and it worked well in testing - on the 
old, 512m RAM problem laptop too. So could you send v4 as a delta patch 
instead please, against tip/master?

	Ingo
