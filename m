Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbZLFUf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbZLFUf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbZLFUfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:35:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1079 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbZLFUfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:35:24 -0500
Subject: [PATCH 2/2] include/linux/if_ether.h: Remove unused defines
 MAC_BUF_SIZE and DECLARE_MAC_BUF
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1260131563.11126.124.camel@Joe-Laptop.home>
References: <1260131563.11126.124.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 12:35:30 -0800
Message-ID: <1260131730.11126.127.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 005e152..299b412 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -137,8 +137,6 @@ extern struct ctl_table ether_table[];
 extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
 
 #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-#define MAC_BUF_SIZE	18
-#define DECLARE_MAC_BUF(var) char var[MAC_BUF_SIZE]
 
 #endif
 


