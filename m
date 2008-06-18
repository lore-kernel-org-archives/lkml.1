Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYFROH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYFROH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYFROHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:07:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYFROHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:07:48 -0400
Date: Wed, 18 Jun 2008 16:07:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Jan Engelhardt <jengelh@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC [PATCH] x86: try to remove arch_get_ram_range
Message-ID: <20080618140726.GF11501@elte.hu>
References: <200806162010.55495.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806162010.55495.yhlu.kernel@gmail.com>
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

> want to remove arch_get_ram_range, and use early_node_map instead.

(small request: please include diffstat output in your patches in the 
future if possible: "quilt refresh --diffstat" will do that - this way 
people will know why they were Cc:-ed)

this touches the MM:

 arch/x86/mm/init_32.c     |    6 +++--
 drivers/pci/intel-iommu.c |   51 +++++++++++++++++++++++++++++++++-------------
 include/linux/mm.h        |    2 -
 mm/page_alloc.c           |   10 ++++++---
 4 files changed, 49 insertions(+), 20 deletions(-)

but has many dependencies on ongoing arch/x86 work. Andrew, is this 
change fine with with you?

	Ingo
