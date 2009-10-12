Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbZJLU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbZJLU0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZJLU0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:26:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbZJLU0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:26:08 -0400
Date: Mon, 12 Oct 2009 16:25:26 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 3/3] extend get/setrlimit to support setting rlimits
	external to a process (v6)
Message-ID: <20091012202526.GJ32088@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012201304.GG32088@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __NR_getprlimit and __NR_setprlimit syscalls for asm-generic

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 unistd.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..4912f71 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -623,8 +623,13 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 241
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 
+#define __NR_getprlimit 242
+__SYSCALL(__NR_getprlimit, sys_getprlimit)
+#define __NR_setprlimit 243
+__SYSCALL(__NR_setprlimit, sys_setprlimit)
+
 #undef __NR_syscalls
-#define __NR_syscalls 242
+#define __NR_syscalls 244
 
 /*
  * All syscalls below here should go away really,
