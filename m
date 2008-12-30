Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYL3WiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYL3WiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYL3WiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:38:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:60729 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbYL3WiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=ND8kKyUfndbPIqnd74zRsgo/MsO3XCN0Z5/yzrLGicsPEY/gbf+6LHOBmH7pT5XfNc
         2xImBbIEJ+6cRl9BmF5qkcak/VBeLjsptP1/ocNhYAagWGNw9555clRFAs0uS4phCQc/
         R5kLmnEb+XRzFpQlIQUNKPFJ0kTZa5mcA6Its=
Date: Wed, 31 Dec 2008 06:38:06 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Subject: tracing: removed duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081231063255.E8C8.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include in kernel/trace/trace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f4bb380..94a592a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,7 +30,6 @@
 #include <linux/gfp.h>
 #include <linux/fs.h>
 #include <linux/kprobes.h>
-#include <linux/seq_file.h>
 #include <linux/writeback.h>

 #include <linux/stacktrace.h>

