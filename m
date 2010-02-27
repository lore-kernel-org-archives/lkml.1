Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968235Ab0B0Mwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:52:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:36106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968208Ab0B0Mwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:52:50 -0500
Date: Sat, 27 Feb 2010 12:52:22 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, vapier.adi@gmail.com,
       davem@davemloft.net, fweisbec@gmail.com, rostedt@goodmis.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, vapier.adi@gmail.com,
       davem@davemloft.net, fweisbec@gmail.com, rostedt@goodmis.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mhiramat@redhat.com
In-Reply-To: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
References: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API
Message-ID: <tip-e01292b1fd68ff2abe234d584b06e64344d2c1de@git.kernel.org>
Git-Commit-ID: e01292b1fd68ff2abe234d584b06e64344d2c1de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:52:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e01292b1fd68ff2abe234d584b06e64344d2c1de
Gitweb:     http://git.kernel.org/tip/e01292b1fd68ff2abe234d584b06e64344d2c1de
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 18 Feb 2010 14:25:21 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 22 Feb 2010 17:05:51 +0100

tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API

So that arch developers know how to implement it without the
need to dig into changelogs.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
[added reference to ptrace.h in the config help]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 04e3aa7..50877ef 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -123,6 +123,11 @@ config USE_GENERIC_SMP_HELPERS
 
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
+	help
+	  This symbol should be selected by an architecure if it supports
+	  the API needed to access registers and stack entries from pt_regs,
+	  declared in asm/ptrace.h
+	  For example the kprobes-based event tracer needs this API.
 
 config HAVE_CLK
 	bool
