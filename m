Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYBKMQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYBKMQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYBKMQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:16:14 -0500
Received: from babylon.websiteactive.com ([61.14.187.155]:52374 "EHLO
	babylon.websiteactive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYBKMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:16:13 -0500
Message-ID: <9989.59.167.46.164.1202732183.squirrel@babylon.websiteactive.com>
Date: Mon, 11 Feb 2008 23:16:23 +1100 (EST)
Subject: [PATCH] Include kernel.h from configfs.h
From: bn@niasdigital.com
To: joel.becker@oracle.com
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - babylon.websiteactive.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - niasdigital.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


configfs.h uses the container_of macro and as such should include kernel.h.

Signed-Off-By: Ben Nizette <bn@niasdigital.com>
---
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 8c6967f..4b287ad 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -37,6 +37,7 @@

 #ifdef __KERNEL__

+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>


