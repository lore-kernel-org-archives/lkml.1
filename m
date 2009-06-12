Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbZFLNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbZFLNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764843AbZFLNQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:16:44 -0400
Received: from ozlabs.org ([203.10.76.45]:42505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764959AbZFLNQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:16:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/17] cpumask obsolete implementation removal
Date: Fri, 12 Jun 2009 22:46:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122246.42041.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs have already removed their obsolete versions of these functions,
but here's a last xmit of the rest before I push them RSN.

On the chopping block is:
pcibus_to_cpumask (alpha, mips, powerpc, sh)
node_to_cpumask
CPU_MASK_ALL_PTR
&CPU_MASK_ALL (mips)
cpu_mask_all
struct irqaction -> mask
set_cpus_allowed (if CONFIG_CPUMASK_OFFSTACK=y)
smp_call_function_mask
topology_core_siblings/topology_thread_siblings (generic, sparc, s390, 
powerpc, ia64)

Cheers,
Rusty.
