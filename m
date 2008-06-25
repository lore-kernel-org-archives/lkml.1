Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYFYPmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYFYPmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYFYPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:41:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYFYPl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:41:57 -0400
Date: Wed, 25 Jun 2008 17:41:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: remove end_pfn in 64bit
Message-ID: <20080625154138.GC18796@elte.hu>
References: <200806242213.15310.yhlu.kernel@gmail.com> <200806242214.09503.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806242214.09503.yhlu.kernel@gmail.com>
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

> and use max_pfn directly.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/setup-memory - thanks Yinghai. I have picked up these 
patches:

Ingo Molnar (1):
      Merge branch 'x86/setup-memory'

Yinghai Lu (6):
      x86: fix e820_update_range size when overlapping
      x86: get max_pfn_mapped in init_memory_mapping
      x86: add table_top check for alloc_low_page in 64 bit
      x86: change size if e820_update/remove_range
      x86: numa 32 using apicid_2_node to get node for logical_apicid
      x86: remove end_pfn in 64bit

	Ingo
