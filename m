Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZCJE50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZCJE50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZCJE5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:57:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53384 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZCJE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:57:18 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: add trace_buf_size description to kernel-parameters.txt
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090310135200.A48B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 13:57:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from early boot tracing view, trace_buf_size parameter is important.
it should be documented.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd35cb7..8869faa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2349,6 +2349,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tp720=		[HW,PS2]
 
+	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
+
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
-- 
1.6.1.2



