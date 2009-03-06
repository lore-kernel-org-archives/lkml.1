Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZCFLwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZCFLwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZCFLv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:51:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:57366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZCFLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:51:56 -0500
Date: Fri, 6 Mar 2009 11:51:23 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090306104106.GF31042@elte.hu>
References: <20090306104106.GF31042@elte.hu>
Subject: [tip:tracing/ftrace] tracing, power-trace: make it build even if the power-tracer is turned off
Message-ID: <tip-af438c0f114b6f731b923b5c07150f6159471502@git.kernel.org>
Git-Commit-ID: af438c0f114b6f731b923b5c07150f6159471502
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 11:51:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af438c0f114b6f731b923b5c07150f6159471502
Gitweb:     http://git.kernel.org/tip/af438c0f114b6f731b923b5c07150f6159471502
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Fri, 6 Mar 2009 12:47:08 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 12:47:08 +0100

tracing, power-trace: make it build even if the power-tracer is turned off

Impact: build fix

The 'struct power_trace' definition is needed (for the event tracer) even if
the power-tracer plugin is turned off in the .config.

Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <20090306104106.GF31042@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/power.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/trace/power.h b/include/trace/power.h
index 2c733e5..38aca53 100644
--- a/include/trace/power.h
+++ b/include/trace/power.h
@@ -11,12 +11,10 @@ enum {
 };
 
 struct power_trace {
-#ifdef CONFIG_POWER_TRACER
 	ktime_t			stamp;
 	ktime_t			end;
 	int			type;
 	int			state;
-#endif
 };
 
 DECLARE_TRACE(power_start,
