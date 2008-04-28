Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbYD1VJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbYD1VJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935554AbYD1VJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:09:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54617 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935272AbYD1VJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:09:07 -0400
Message-Id: <20080428210906.348866000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 14:09:06 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86: fix remove cpu_pda table patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Ingo - please replace "PATCH 07/11" with this one.]

    *	Remove 544k bytes from the kernel by removing the boot_cpu_pda
	array from the data section and allocating it during startup.

	Fixed panic in setup_per_cpu_areas when HOTPLUG_CPU not set.

For inclusion into sched-devel/latest tree.

Based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
