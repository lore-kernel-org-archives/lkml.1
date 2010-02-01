Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0BAQvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:51:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51743 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0BAQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:51:14 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 2/3] trace-cmd: fix printf compile warnings
Date: Mon,  1 Feb 2010 08:50:25 -0800
Message-Id: <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 trace-read.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/trace-read.c b/trace-read.c
index a04c85b..5befaba 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -216,7 +216,7 @@ static void read_rest(void)
 		r = read(input_fd, buf, BUFSIZ);
 		if (r > 0) {
 			buf[r] = 0;
-			printf(buf);
+			printf("%s", buf);
 		}
 	} while (r > 0);
 }
-- 
1.6.3.3

