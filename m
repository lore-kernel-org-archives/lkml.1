Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZHGKLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZHGKLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZHGKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:10:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:58455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbZHGKK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:10:56 -0400
Date: Fri, 7 Aug 2009 10:10:18 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A7BD37E.9060806@cn.fujitsu.com>
References: <4A7BD37E.9060806@cn.fujitsu.com>
Subject: [tip:core/urgent] lockdep: Fix typos in documentation
Message-ID: <tip-0e692a94e378628b7d527260ad939894454bcca8@git.kernel.org>
Git-Commit-ID: 0e692a94e378628b7d527260ad939894454bcca8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 10:10:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e692a94e378628b7d527260ad939894454bcca8
Gitweb:     http://git.kernel.org/tip/0e692a94e378628b7d527260ad939894454bcca8
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 7 Aug 2009 15:10:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 12:03:46 +0200

lockdep: Fix typos in documentation

s/head/held

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A7BD37E.9060806@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/lockdep-design.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index e20d913..abf768c 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -30,9 +30,9 @@ State
 The validator tracks lock-class usage history into 4n + 1 separate state bits:
 
 - 'ever held in STATE context'
-- 'ever head as readlock in STATE context'
-- 'ever head with STATE enabled'
-- 'ever head as readlock with STATE enabled'
+- 'ever held as readlock in STATE context'
+- 'ever held with STATE enabled'
+- 'ever held as readlock with STATE enabled'
 
 Where STATE can be either one of (kernel/lockdep_states.h)
  - hardirq
