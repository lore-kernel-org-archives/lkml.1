Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbZD3Swe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbZD3Swe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763815AbZD3SwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:52:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762683AbZD3SwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:52:19 -0400
Message-Id: <20090430185022.122124349@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 14:50:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 0/7] kconfig: more featured minimum module configs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds on top of my previous post.

It fixes CONFIG_IKCONFIG when CONFIG_IKCONFIG_PROC is not set.
 (gcc optimizes the config out!)

As a request from Ingo, it now enables IKCONFIG and will also
use various locations to find a config to base against.

Have fun,

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: kconfig


Steven Rostedt (7):
      kconfig: streamline_config.pl do not stop with no depends
      kconfig: do not warn about modules built in
      kconfig: enable CONFIG_IKCONFIG from streamline_config.pl
      kconfig: add check if end exists in extract-ikconfig
      kconfig: have extract-ikconfig read ELF files
      kconfig: keep config.gz around even if CONFIG_IKCONFIG_PROC is not set
      kconfig: search for a config to base the local(mod|yes)config on

----
 kernel/Makefile                      |    2 +-
 scripts/extract-ikconfig             |   14 +++++
 scripts/kconfig/streamline_config.pl |  102 +++++++++++++++++++++++++++++-----
 3 files changed, 103 insertions(+), 15 deletions(-)
-- 
