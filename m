Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZD3XiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZD3XiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZD3Xh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:37:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZD3Xh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:37:57 -0400
Message-Id: <20090430233642.333097165@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 19:36:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: [PATCH 0/2] kconfig: updates to streamline_config.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Alan Jenkins for suggesting these cleanups/fixes/enhancements.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: kconfig


Steven Rostedt (2):
      kconfig: unset IKCONFIG_PROC and clean up nesting
      kconfig: test for /boot/config-uname after /proc/config.gz in localconfig

----
 scripts/kconfig/streamline_config.pl |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)
-- 
