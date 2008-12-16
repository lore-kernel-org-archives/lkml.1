Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYLPSJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYLPSJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYLPSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:39 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:37188 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYLPSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:38 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [w1] Move w1 commands from defines to enum.
Date: Tue, 16 Dec 2008 21:08:00 +0300
Message-Id: <1229450882-745-3-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1229450882-745-2-git-send-email-zbr@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
 <1229450882-745-2-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_netlink.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 99dd21b..01d86a7 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -52,11 +52,14 @@ struct w1_netlink_msg
 	__u8				data[0];
 };
 
-#define W1_CMD_READ		0x0
-#define W1_CMD_WRITE		0x1
-#define W1_CMD_SEARCH		0x2
-#define W1_CMD_ALARM_SEARCH	0x3
-#define W1_CMD_TOUCH		0x4
+enum w1_commands {
+	W1_CMD_READ = 0,
+	W1_CMD_WRITE,
+	W1_CMD_SEARCH,
+	W1_CMD_ALARM_SEARCH,
+	W1_CMD_TOUCH,
+	W1_CMD_MAX,
+};
 
 struct w1_netlink_cmd
 {
-- 
1.5.6.3

