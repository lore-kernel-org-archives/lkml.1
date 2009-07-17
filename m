Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbZGQMZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbZGQMZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 08:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934477AbZGQMZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 08:25:29 -0400
Received: from www.tglx.de ([62.245.132.106]:57920 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934464AbZGQMZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 08:25:29 -0400
Message-Id: <20090717121545.489258927@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 17 Jul 2009 12:24:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/2] fix load average accounting
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes two problems in the load average
accounting:

1) a thinko in the new load average code vs. CPU hotplug

2) the complete accounting wreckage caused by a braindamaged attempt
   to fix the freezer accounting of nr_uninterruptible.

Thanks,

	tglx

