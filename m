Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187Ab0AYDJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0AYDJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866Ab0AYDJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:09:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab0AYDJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:09:31 -0500
Message-ID: <4B5D0BA8.20106@cn.fujitsu.com>
Date: Mon, 25 Jan 2010 11:10:32 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]ftrace:fix a typo in ftrace.txt
References: <4B5D0AC8.5060307@cn.fujitsu.com>
In-Reply-To: <4B5D0AC8.5060307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,please ignore prev patch,the character Encoding was bad.
=========================================================

'echo ftrace' no longer supported in current kernel,
use 'echo function' instead.

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>

---
 Documentation/trace/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 8179692..bab3040 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1625,7 +1625,7 @@ If I am only interested in sys_nanosleep and hrtimer_interrupt:
 
  # echo sys_nanosleep hrtimer_interrupt \
 		> set_ftrace_filter
- # echo ftrace > current_tracer
+ # echo function > current_tracer
  # echo 1 > tracing_enabled
  # usleep 1
  # echo 0 > tracing_enabled
-- 
1.6.5.2

-- 
Regards
Yang Hongyang
