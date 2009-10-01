Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZJARW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZJARW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZJARWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:22:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbZJARWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:22:24 -0400
Date: Thu, 1 Oct 2009 13:22:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 3/3] extend get/setrlimit to support setting rlimits
	external to a process (v3)
Message-ID: <20091001172227.GE2456@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001171538.GB2456@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __NR_getprlimit and __NR_setprlimit syscalls for asm-generic
    
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 unistd.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 1125e5a..3321e4f 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -623,8 +623,13 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_counter_open 241
 __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 
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
