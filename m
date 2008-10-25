Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYJYQVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYJYQVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 12:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYJYQVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 12:21:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:38424 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYJYQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 12:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=XeZ0RZiiz1C+xnMAwJF9SP0kDNH5SeRSux5ox2/U488H8obNumrRCwsdGz4UoF61r7
         JA3/cnl10maxk9+xzmLw7Y4QMgbdO74CLWZsSoWvNPL1RyaL9XAQTzBNV1BIUQ+z/pv5
         F/27gC0SvMJzsN9qmWyBq2okMODJxjSBYYRBc=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH]mm/oom_kill.c: cleanup kerneldoc of badness()
Date: Sun, 26 Oct 2008 00:21:08 +0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810260021.08146.qhfeng.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paramter @mem has been removed since v2.6.26, now delete it's comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..460f90e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -38,7 +38,6 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
  * @uptime: current uptime in seconds
- * @mem: target memory controller
  *
  * The formula used is relatively simple and documented inline in the
  * function. The main rationale is that we want to select a good task
