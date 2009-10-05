Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZJEA6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZJEA6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZJEA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:58:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42076 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbZJEAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:24 -0400
Date: Sun, 4 Oct 2009 20:54:41 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 3/3] extend get/setrlimit to support setting rlimits
	external to a process (v4)
Message-ID: <20091005005441.GC7180@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091005002617.GA5736@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005002617.GA5736@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.5 (----)
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
