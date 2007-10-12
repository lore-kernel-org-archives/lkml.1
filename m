Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXJLJef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXJLJef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXJLJe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:34:26 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4157 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXJLJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:34:25 -0400
Date: Fri, 12 Oct 2007 04:34:11 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain debug sysctl fixes
Message-Id: <mm-sched-0@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following 5 patches provide fixes for the sysctl code added under
CONFIG_DEBUG_SCHED.   After debugging a boot failure dereferencing
not per-cpu data for an impossible cpu, I found the other issues by
inspection.

Following these fixes, /proc/sysctl/kernel/sched_debug/ should work with
exclusive cpusets, cpu hotplug, offline and not present cpus, and will
show all 11 files.

milton
