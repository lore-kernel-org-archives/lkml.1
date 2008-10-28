Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYJ1Jbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYJ1Jbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYJ1Jbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:31:40 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:53197 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbYJ1Jbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:31:39 -0400
Date: Tue, 28 Oct 2008 16:14:57 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: Remove unused variable warning
Message-ID: <20081028081457.GA19691@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


net: Remove unused variable warning
'min_ds_timeout' and 'max_ds_timeout' are only used when CONFIG_AX25_DAMA_SLAVE is defined.

net/ax25/sysctl_net_ax25.c:27: warning: ‘min_ds_timeout’ defined but not used
net/ax25/sysctl_net_ax25.c:27: warning: ‘max_ds_timeout’ defined but not used


Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 net/ax25/sysctl_net_ax25.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index f288fc4..735ceef 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -24,7 +24,9 @@ static int min_idle[1],			max_idle[] = {65535000};
 static int min_n2[] = {1},		max_n2[] = {31};
 static int min_paclen[] = {1},		max_paclen[] = {512};
 static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
+#ifdef CONFIG_AX25_DAMA_SLAVE
 static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
+#endif
 
 static struct ctl_table_header *ax25_table_header;
 
-- 
1.5.6.3



