Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYJTREX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYJTREX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYJTRDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:03:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753389AbYJTRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:23 -0400
Message-Id: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Redesign cpumask API to explicitly declare struct cpumask pointers to
the cpumask_* operators and add functions to make it easier to support
struct cpumask pointers on the stack.

This patchset supplies the infrastructure going forward to implement
this new struct cpumask API.  Patches have been written and tested
to verify the functionality of this API.  These are still in review
between Rusty and myself.

Question: what's the status of the sparse-irqs?  (I have two patches
to replace the static cpumask fields in the irq_desc and irq_cfg
arrays which depend on sparse irqs.)


Compiled and tested on x86_64.

Based on tip/master @ v2.6.27-5807-g03da394

-- 
