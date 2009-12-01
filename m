Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZLAIXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZLAIXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZLAIXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:23:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZLAIXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:23:43 -0500
Message-ID: <4B14D26A.1040000@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:23:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] trace_syscalls: remove duplications
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trace_syscalls introduces a lot of duplicate functions
to all syscalls. These series patches remove them.

   text    data     bss     dec     hex filename
 630068  152084  531376 1313528  140af8 kernel/built-in.o.old
 593997  151988  531824 1277809  137f71 kernel/built-in.o.new

patch 1~4 is for preparing.
patch 5~6 remove duplications
patch 7 cleanups

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/syscalls.h      |   73 ++++--------------------
 include/trace/syscall.h       |   20 ++----
 kernel/trace/trace_syscalls.c |  124 ++++++++++++------------------------------
 3 files changed, 57 insertions(+), 160 deletions(-)


