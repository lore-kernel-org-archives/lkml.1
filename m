Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbZJFUKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbZJFUKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbZJFUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:10:14 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:45954 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951AbZJFUKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:10:12 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: improving tracepoints.txt
Date: Tue,  6 Oct 2009 17:09:31 -0300
Message-Id: <1254859771-8873-1-git-send-email-leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reading the tracepoints.txt documentation, I tried to
follow the instructions to run the sample, but just assigning
CONFIG_SAMPLE_TRACEPOINTS=m wasn't enough to generate the tracepoints
samples. I also need to set CONFIG_SAMPLES=y, otherwise nothing
happens.

So, this silly patch explicit says that CONFIG_SAMPLES should be set to
compile those files.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 Documentation/trace/tracepoints.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
index c0e1cee..d380250 100644
--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -106,7 +106,7 @@ used to export the defined tracepoints.
 See the example provided in samples/tracepoints
 
 Compile them with your kernel.  They are built during 'make' (not
-'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
+'make modules') when CONFIG_SAMPLE=y and CONFIG_SAMPLE_TRACEPOINTS=m.
 
 Run, as root :
 modprobe tracepoint-sample (insmod order is not important)
-- 
1.6.0.4

