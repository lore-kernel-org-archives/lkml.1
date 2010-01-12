Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580Ab0ALXTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0ALXTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122Ab0ALXTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:19:12 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39081 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0ALXTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:19:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 12 Jan 2010 15:17:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/5] clean up logical flat apic mode using
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. instroduce nr_cpus=x, to enumlate that only one x cpus are installed
2. nur nr_cpu_ids for checking
3. make default_setup_irq_routing of 32but more like 64 bit
4. amd cpu useing logical flat even one of 8 scpu apicid >= 8
5. use dmi table to decide if we need to disabled cpus as hotplug cpus.

need to apply after putting Suresh patch back.

todo:
1. seperate probe_32.c to probe_32.c and apic_default_32.c
2. merge probe_32.c and probe_64.c or create probe.c to share dmi table

Thanks

Yinghai Lu
