Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZHYOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZHYOTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZHYOTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:19:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:56667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbZHYOTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:19:22 -0400
Date: Tue, 25 Aug 2009 14:18:38 GMT
From: tip-bot for Anirban Sinha <ASinha@zeugmasystems.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, asinha@zeugmasystems.com, ASinha@zeugmasystems.com,
       oleg@tv-sign.ru, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       asinha@zeugmasystems.com, lizf@cn.fujitsu.com, ASinha@zeugmasystems.com,
       oleg@tv-sign.ru, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA9047@exchange.ZeugmaSystems.local>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9047@exchange.ZeugmaSystems.local>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Eliminate code duplication in kernel/tracepoint.c
Message-ID: <tip-d88cb582325830698de5071fa8b8c9e933dbbcad@git.kernel.org>
Git-Commit-ID: d88cb582325830698de5071fa8b8c9e933dbbcad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 14:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d88cb582325830698de5071fa8b8c9e933dbbcad
Gitweb:     http://git.kernel.org/tip/d88cb582325830698de5071fa8b8c9e933dbbcad
Author:     Anirban Sinha <ASinha@zeugmasystems.com>
AuthorDate: Tue, 25 Aug 2009 07:00:02 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 16:15:12 +0200

tracing: Eliminate code duplication in kernel/tracepoint.c

Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>
LKML-Reference: <DDFD17CC94A9BD49A82147DDF7D545C501EA9047@exchange.ZeugmaSystems.local>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/tracepoint.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 35dd27a..06f165a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -555,9 +555,6 @@ int tracepoint_module_notify(struct notifier_block *self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
-		break;
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
