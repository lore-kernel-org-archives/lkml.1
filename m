Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbZLUG1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbZLUG1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 01:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZLUG1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 01:27:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZLUG1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 01:27:39 -0500
Message-ID: <4B2F154C.2060503@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 14:27:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] tracing: Make the documentation clear on trace_event boot
 option
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it clear that event-list is a comma separated list of events.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/trace/events.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 02ac6ed..778ddf3 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -90,7 +90,8 @@ In order to facilitate early boot debugging, use boot option:
 
 	trace_event=[event-list]
 
-The format of this boot option is the same as described in section 2.1.
+event-list is a comma separated list of events. See section 2.1 for event
+format.
 
 3. Defining an event-enabled tracepoint
 =======================================
-- 
1.6.3

