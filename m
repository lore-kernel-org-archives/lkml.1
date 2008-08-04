Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYHDP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYHDP5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYHDP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:57:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40723 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYHDP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:57:13 -0400
Date: Mon, 4 Aug 2008 20:01:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] posix-timers: sys_timer_create: fix and cleanups
Message-ID: <20080804160103.GA10515@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of

	[PATCH 1/3] posix-timers: don't switch to ->group_leader if ->it_process dies
	http://marc.info/?l=linux-kernel&m=121778560719812

	[PATCH 2/3] posix-timers: always do get_task_struct(timer->it_process)
	http://marc.info/?l=linux-kernel&m=121778560719816


checkpatch.pl criticizes the first patch (line over 80 characters), but
that line was just moved by this patch. Not sure what should be done in
such a case, but this line is killed by the next patch anyway.

I don't know how to test these changes. Fortunately they are rather simple,
and the first patch obviously fixes the bug.

Oleg.

