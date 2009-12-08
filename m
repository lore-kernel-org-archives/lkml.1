Return-Path: <linux-kernel-owner+w=401wt.eu-S935789AbZLHDSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935789AbZLHDSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934778AbZLHDSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:18:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57680 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934391AbZLHDSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:18:10 -0500
Message-ID: <4B1DC55F.7060305@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 11:17:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 12/13] tracing/power: Remove two exports
References: <4B1DC476.3030700@cn.fujitsu.com>
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_power_start and trace_power_end are used in
arch/x86/kernel/power.c, and this file can't be compiled
as a module, so these two tracepoints needn't to be
exported.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/trace/power-traces.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index e06c6e3..9f4f565 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -14,7 +14,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
-- 
1.6.3

