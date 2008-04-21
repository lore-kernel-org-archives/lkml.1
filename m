Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYDUTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYDUTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYDUTgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:36:06 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:49634 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYDUTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:36:05 -0400
Date: Mon, 21 Apr 2008 14:35:43 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 2/3] IPMI: Make alloc_recv_msg static
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080421193542.GB13900@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ipmi_alloc_recv_msg() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_msghandler.c
@@ -3934,7 +3934,7 @@ static void free_recv_msg(struct ipmi_re
 	kfree(msg);
 }
 
-struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
+static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
 {
 	struct ipmi_recv_msg *rv;
 
