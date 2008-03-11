Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYCKF5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYCKF5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYCKF5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:57:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9888 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYCKF5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:57:30 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5248"; a="1027100"
From: maxk@qualcomm.com
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: [PATCH 0/2] cpusets: support for irqs
Date: Mon, 10 Mar 2008 22:57:24 -0700
Message-Id: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is an updated patchset that adds support for irqs to the cpusets.
First part if Peter's patch and second part is my fixes extensions for it. 
Ingo mentioned that if this is test booted and stuff he'll included in 
sched-devel. I tested it on a couple of x86-64 boxes and everything 
seems to work just fine. ie Irqs are handled just like tasks. I tested a 
bunch of scenarious (cpu hotplug, child set removal, etc).

btw Ingo, Peters original patches with cpu_system_map are no longer needed.
Can you please nuke them from sched-devel.

Peter, looks like I'll have some time tomorrow. So I'll move on to the 
in kernel 'boot' set. If you have some code for it already send it my way.
I'll test/fix/extend it and send a patchset back.

 b/include/linux/cpuset.h |    8 +
 b/include/linux/irq.h    |    9 +
 b/kernel/cpuset.c        |  160 ++++++++++++++++++++
 b/kernel/irq/chip.c      |    5 
 b/kernel/irq/manage.c    |   20 ++
 include/linux/irq.h      |    2 
 kernel/cpuset.c          |  367 +++++++++++++++++++++++++++++------------------
 kernel/irq/manage.c      |   28 ++-
 8 files changed, 453 insertions(+), 146 deletions(-)

Thanx
Max   
