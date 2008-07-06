Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYGFPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYGFPTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYGFPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:19:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48088 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYGFPTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:19:23 -0400
Date: Sun, 6 Jul 2008 19:22:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] coredump: introduce struct core_state.
Message-ID: <20080706152220.GA2813@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3rd resend.

Please drop

	ptrace-never-sleep-in-task_traced-if-sigkilled.patch
	ptrace-kill-may_ptrace_stop.patch

, these patches add a user-visible change and shouldn't be
merged unless blessed by Roland.

I think this series makes sense by itself, but it is also preparation
for the further changes.

Oleg.

