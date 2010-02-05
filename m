Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0BEBo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:44:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0BEBoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:55 -0500
Message-ID: <4B6B7826.9010003@cn.fujitsu.com>
Date: Fri, 05 Feb 2010 09:45:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 02/13] net: add a wrapper sk_entry()
References: <4B6B77FE.5000104@cn.fujitsu.com>
In-Reply-To: <4B6B77FE.5000104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/net/sock.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3f1a480..c8d4000 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -317,6 +317,11 @@ struct sock {
 /*
  * Hashed lists helper routines
  */
+static inline struct sock *sk_entry(const struct hlist_node *node)
+{
+	return hlist_entry(node, struct sock, sk_node);
+}
+
 static inline struct sock *__sk_head(const struct hlist_head *head)
 {
 	return hlist_entry(head->first, struct sock, sk_node);
-- 
1.6.3

