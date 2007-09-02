Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXIBE7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXIBE7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXIBE7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:59:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:31025 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXIBE7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=k49M6oB0lwbd7Mv6kl0iaeHB+lOiYSO1scMjqo5XgpZVe9nIauxVT09Y+U3FRep5y8I73qctu70F4RZtDratzgLIOLTnJCesnmlCxcvXhnFYR8/308DDA8dXnkb2JKSO+E95y42X//p5bDHKx62+DEc8NoOSZQK0y3GajlhXSIc=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] net/ipv4/af_inet.c: use ARRAY_SIZE macro from kernel.h instead
Date: Sun,  2 Sep 2007 12:59:07 +0800
Message-Id: <11887091471748-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/ipv4/af_inet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e681034..d5e8b67 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -939,7 +939,7 @@ static struct inet_protosw inetsw_array[] =
        }
 };
 
-#define INETSW_ARRAY_LEN (sizeof(inetsw_array) / sizeof(struct inet_protosw))
+#define INETSW_ARRAY_LEN ARRAY_SIZE(inetsw_array)
 
 void inet_register_protosw(struct inet_protosw *p)
 {
-- 
1.5.3.rc7

