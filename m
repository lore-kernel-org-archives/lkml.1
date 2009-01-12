Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZALWFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZALWFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZALWFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:21 -0500
Received: from relay3.sgi.com ([192.48.171.31]:46112 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751045AbZALWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:21 -0500
Message-Id: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:19 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] irq: update all archs to use new irq_desc cpumask_var_t's.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup, use new cpumask API.

Minor cleanup to use the new affinity and pending_mask cpumask_var_t's
in irq_desc:

	alpha irq: update alpha for new irq_desc
	arm irq: update arm for new irq_desc
	blackfin irq: update blackfin for new irq_desc
	ia64 irq: update ia64 for new irq_desc
	mips irq: update mips for new irq_desc
	parisc irq: update parisc for new irq_desc
	powerpc irq: update powerpc for new irq_desc
	arm irq: update arm for new irq_desc

Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo tree
since that has the relevant changes to irq_desc?  Or by some other means?

Based on tip/cpus4096: v2.6.29-rc1-19-g92296c6

[I'm setting up the cross-compile toolchain and will verify (as much as I
can) that the above builds correctly.]

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <kernel@wantstofly.org>
Cc: <linuxppc-dev@ozlabs.org>
Cc: <linux-ia64@vger.kernel.org>
Cc: <linux-mips@linux-mips.org>
Cc: <linux-parisc@vger.kernel.org>
Cc: <sparclinux@vger.kernel.org>

-- 
