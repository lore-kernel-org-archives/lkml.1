Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYFECiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYFECiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYFEChx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:37:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50183 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYFEChw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:37:52 -0400
Message-ID: <48475117.9070508@cn.fujitsu.com>
Date: Thu, 05 Jun 2008 10:36:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [-mmotm] build failure: undefined reference to `wakeup_preempt_entity'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/built-in.o: In function `pick_next':
/home/lizf/linux-2.6.26-rc4/kernel/sched_fair.c:738: undefined reference to `wakeup_preempt_entity'
kernel/built-in.o: In function `check_preempt_wakeup':
/home/lizf/linux-2.6.26-rc4/kernel/sched_fair.c:1194: undefined reference to `wakeup_preempt_entity'

This patch:
	sched-delete-dead-stuff.patch

	------------------------------------------------
	From: Andrew Morton <akpm@linux-foundation.org>

	kernel/sched_fair.c:1170: warning: 'wakeup_preempt_entity' defined but not used

	Cc: Ingo Molnar <mingo@elte.hu>
	Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

But I can see this function is used in sched_fair.c.
