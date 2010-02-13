Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0BMCuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:50:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64076 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0BMCuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:50:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 12 Feb 2010 18:49:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat
 clean up
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------spareirq radix tree related ----------------
94007e8: irq: remove not need bootmem code
4b0d3fa: radix: move radix init early
56af1a9: sparseirq: change irq_desc_ptrs to static
b236235: sparseirq: use radix_tree instead of ptrs array
5918787: x86: remove arch_probe_nr_irqs

so could reduce nr_irqs limitation for bunch ixgbe...

---------------x86 logical flat related -----------
f5954c4: use nr_cpus= to set nr_cpu_ids early
7b8d6a9: x86: use num_processors for possible cpus
d79d1de: x86: make 32bit apic flat to physflat switch like 64bit

Thanks

Yinghai
