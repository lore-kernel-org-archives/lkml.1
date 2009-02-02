Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZBBJOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZBBJOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZBBJNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:13:55 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:54002 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZBBJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:13:54 -0500
Message-ID: <4986B86E.3030604@oracle.com>
Date: Mon, 02 Feb 2009 17:10:06 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix the warning of uninitialized value in driver/serial/8250.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4986B94E.0044:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to remove the the warning of uninitialized i in 
driver/serial/8250.c

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>

diff -Nurh drivers/serial/8250.c.Orig drivers/serial/8250.c
--- drivers/serial/8250.c.Orig  2009-02-02 14:02:47.000000000 -0500
+++ drivers/serial/8250.c       2009-02-02 14:03:30.000000000 -0500
@@ -1678,7 +1678,7 @@

  static void serial_unlink_irq_chain(struct uart_8250_port *up)
  {
-       struct irq_info *i;
+       struct irq_info *i = NULL;
         struct hlist_node *n;
         struct hlist_head *h;


