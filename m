Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbXLNSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbXLNSzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXLNSyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:54:12 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26841 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXLNSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:54:07 -0500
From: Francisco Alecrim <francisco.alecrim@indt.org.br>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dbrownell@users.sourceforge.net,
       kyle@parisc-linux.org, dmitry.torokhov@gmail.com, hcegtvedt@atmel.com,
       Francisco Alecrim <francisco.alecrim@indt.org.br>
Subject: [PATCH 3/6] drivers/char/keyboard.c: clean up remove duplicated headers
Date: Fri, 14 Dec 2007 14:56:47 -0400
Message-Id: <1197658610-4558-4-git-send-email-francisco.alecrim@indt.org.br>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
References: "Francisco Alecrim <francisco.alecrim@indt.org.br>"
 <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
X-OriginalArrivalTime: 14 Dec 2007 18:53:24.0925 (UTC) FILETIME=[9B1F4ED0:01C83E82]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated headers in drivers/char/keyboard.c:
drivers/char/keyboard.c: linux/consolemap.h is included more than once.

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
---
 drivers/char/keyboard.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index fc54d23..2c21fb1 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -38,7 +38,6 @@
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <linux/vt_kern.h>
-#include <linux/consolemap.h>
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
-- 
1.5.3.7

