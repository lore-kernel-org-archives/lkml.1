Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbYAaQFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbYAaQFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbYAaQEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:04:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbYAaQEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:04:54 -0500
Date: Thu, 31 Jan 2008 17:04:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131160437.GA12013@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131160033.GA11501@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Note that all known breakages are fixed in current -git, except for 
> the s390 problem that Martin/Nick posted the fix.

find below the s390 fix.

	Ingo

Index: linux/arch/s390/Kconfig
===================================================================
--- linux.orig/arch/s390/Kconfig
+++ linux/arch/s390/Kconfig
@@ -22,6 +22,9 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	def_bool y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
