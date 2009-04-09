Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZDIDkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZDIDkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZDIDju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:39:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbZDIDjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:39:49 -0400
Message-ID: <49DD6E2B.6090200@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 11:40:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: consolidate documents
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tracepoints.txt, ftrace.txt and ftrace.txt to the new
directory trace/.

I don't find any references to those documents in both source
files and documents, so no extra work needs to be done.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/{ => trace}/ftrace.txt           |    0 
 Documentation/{tracers => trace}/mmiotrace.txt |    0 
 Documentation/{ => trace}/tracepoints.txt      |    0 
 3 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{ => trace}/ftrace.txt (100%)
 rename Documentation/{tracers => trace}/mmiotrace.txt (100%)
 rename Documentation/{ => trace}/tracepoints.txt (100%)

diff --git a/Documentation/ftrace.txt b/Documentation/trace/ftrace.txt
similarity index 100%
rename from Documentation/ftrace.txt
rename to Documentation/trace/ftrace.txt
diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
similarity index 100%
rename from Documentation/tracers/mmiotrace.txt
rename to Documentation/trace/mmiotrace.txt
diff --git a/Documentation/tracepoints.txt b/Documentation/trace/tracepoints.txt
similarity index 100%
rename from Documentation/tracepoints.txt
rename to Documentation/trace/tracepoints.txt
-- 
1.5.4.rc3

