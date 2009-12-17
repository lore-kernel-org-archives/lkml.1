Return-Path: <linux-kernel-owner+w=401wt.eu-S1764671AbZLQMTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764671AbZLQMTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbZLQMTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:19:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:47313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764603AbZLQMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:18:50 -0500
Message-Id: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] a perf and some sched patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an issue with the per-task-per-cpu counters, reported by acme.
Fixes an false positive in the set_task_cpu() debug check, reported by Ingo.
Fixes up the task->state to char bits, gumbled at by tglx.

