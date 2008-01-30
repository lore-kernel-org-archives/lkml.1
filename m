Return-Path: <linux-kernel-owner+w=401wt.eu-S1765929AbYA3UJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765929AbYA3UJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760418AbYA3UC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:28 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37621 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235AbYA3UCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:25 -0500
Date: Wed, 30 Jan 2008 22:02:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make nf_ct_path[] static
Message-ID: <20080130200259.GE29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global nf_ct_path[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6396fbcebe3eb61f7e6eb1a671920a515912b005 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 696074a..5bd38a6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -380,7 +380,7 @@ static ctl_table nf_ct_netfilter_table[] = {
 	{ .ctl_name = 0 }
 };
 
-struct ctl_path nf_ct_path[] = {
+static struct ctl_path nf_ct_path[] = {
 	{ .procname = "net", .ctl_name = CTL_NET, },
 	{ }
 };

