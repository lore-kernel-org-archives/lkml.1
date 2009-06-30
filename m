Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbZF3X3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbZF3X3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760151AbZF3X2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:60496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760060AbZF3X2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:28:30 -0400
Date: Tue, 30 Jun 2009 23:27:58 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230140.802078956@samba.org>
References: <20090630230140.802078956@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter tools: Remove zlib dependency
Message-ID: <tip-6717534ddc328ae5cdf89f1ef802db83fc451f19@git.kernel.org>
Git-Commit-ID: 6717534ddc328ae5cdf89f1ef802db83fc451f19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6717534ddc328ae5cdf89f1ef802db83fc451f19
Gitweb:     http://git.kernel.org/tip/6717534ddc328ae5cdf89f1ef802db83fc451f19
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:45 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:18 +0200

perf_counter tools: Remove zlib dependency

The zlib devel libraries may not be installed and since we aren't
using zlib we may as well remove it.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230140.802078956@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9c6d0ae..f572c90 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -381,12 +381,6 @@ ifndef CC_LD_DYNPATH
 	endif
 endif
 
-ifdef ZLIB_PATH
-	BASIC_CFLAGS += -I$(ZLIB_PATH)/include
-	EXTLIBS += -L$(ZLIB_PATH)/$(lib) $(CC_LD_DYNPATH)$(ZLIB_PATH)/$(lib)
-endif
-EXTLIBS += -lz
-
 ifdef NEEDS_SOCKET
 	EXTLIBS += -lsocket
 endif
