Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXDRMF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXDRMF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422897AbXDRMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:05:26 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41777 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888AbXDRMFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:05:25 -0400
Message-ID: <4626097A.9040307@bx.jp.nec.com>
Date: Wed, 18 Apr 2007 21:05:14 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: mpm@selenic.com
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC][PATCH -mm take4 1/6] marking __init
References: <462605DC.2080804@bx.jp.nec.com>
In-Reply-To: <462605DC.2080804@bx.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi KII <k-keiichi@bx.jp.nec.com>

This patch contains the following cleanups.
 - add __init for initialization functions(option_setup() and
   init_netconsole()).

Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Keiichi KII <k-keiichi@bx.jp.nec.com>
Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
---
Index: linux-mm/drivers/net/netconsole.c
===================================================================
--- linux-mm.orig/drivers/net/netconsole.c
+++ linux-mm/drivers/net/netconsole.c
@@ -91,7 +91,7 @@ static struct console netconsole = {
 	.write = write_msg
 };
 
-static int option_setup(char *opt)
+static int __init option_setup(char *opt)
 {
 	configured = !netpoll_parse_options(&np, opt);
 	return 1;
@@ -99,7 +99,7 @@ static int option_setup(char *opt)
 
 __setup("netconsole=", option_setup);
 
-static int init_netconsole(void)
+static int __init init_netconsole(void)
 {
 	int err;
 

-- 


