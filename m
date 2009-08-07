Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZHGHMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZHGHMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZHGHMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:12:23 -0400
Received: from [222.73.24.84] ([222.73.24.84]:54632 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZHGHMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:12:22 -0400
Message-ID: <4A7BD37E.9060806@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 15:10:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: Fix typos in documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/head/held

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

