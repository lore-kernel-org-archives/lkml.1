Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0BOFae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 00:30:34 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49279 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0BOFad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 00:30:33 -0500
Date: Mon, 15 Feb 2010 14:30:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc9
Message-ID: <20100215053021.GE18636@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simply hooks up TIF_SINGLESTEP around the hardware single-step
enable/disable in addition to punting the step state down to
tracehook_report_syscall_exit()/tracehook_signal_handler() in order to
get the ptrace_notify() logic right, as reported by Mike Frysinger.

With any luck, this should it for 2.6.33.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Paul Mundt (1):
      sh64: fix tracing of signals.

 arch/sh/kernel/ptrace_64.c |   11 +++++++++--
 arch/sh/kernel/signal_64.c |    4 +++-
 2 files changed, 12 insertions(+), 3 deletions(-)
