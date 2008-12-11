Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYLKL2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYLKL2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYLKL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:28:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55205 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755120AbYLKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:28:11 -0500
Message-Id: <20081211112806.499831000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Dec 2008 03:28:06 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cpumask: fixups and additions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are included:

  * x86: fix assign_irq_vector boot up problem.
	Fix boot up problem on Intel SATA AHCI disks.

  * x86: fix cpu_mask_to_apicid_and to include cpu_online_mask.
	Fix potential problem with offline cpus.

  * cpumask: use maxcpus=NUM to extend the cpu limit as well as restrict
    the limit.
	Allow adding additional cpus with maxcpus kernel start parameter.

  * cpumask: add sysfs displays for configured and disabled cpu maps
	Display both the configured kernel_max cpus (NR_CPUS-1) as well
	as the cpus in the system that are disabled because they exceed
	the NR_CPUS limit.

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git/cpus4096
+ git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

