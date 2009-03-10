Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZCJJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZCJJR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZCJJQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:16:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:52138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbZCJJQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:16:57 -0400
Date: Tue, 10 Mar 2009 09:16:23 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090310135200.A48B.A69D9226@jp.fujitsu.com>
References: <20090310135200.A48B.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] doc: add trace_buf_size description to kernel-parameters.txt
Message-ID: <tip-631595fbf4aeac260e664a8a002897e4db6a50dd@git.kernel.org>
Git-Commit-ID: 631595fbf4aeac260e664a8a002897e4db6a50dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 09:16:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  631595fbf4aeac260e664a8a002897e4db6a50dd
Gitweb:     http://git.kernel.org/tip/631595fbf4aeac260e664a8a002897e4db6a50dd
Author:     "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Tue, 10 Mar 2009 13:57:10 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 10:11:49 +0100

doc: add trace_buf_size description to kernel-parameters.txt

from early boot tracing view, trace_buf_size parameter is important.
it should be documented.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20090310135200.A48B.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 454f42b..7643483 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2344,6 +2344,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tp720=		[HW,PS2]
 
+	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
+
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
