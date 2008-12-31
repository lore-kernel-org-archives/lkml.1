Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbYLaEIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbYLaEIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYLaEIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:08:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:32611 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYLaEIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:08:13 -0500
Message-ID: <495AF01D.5070505@oracle.com>
Date: Tue, 30 Dec 2008 20:07:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH mmotm] input: fix function arg list
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.495AF020.00D2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function args build warning:

mmotm-2008-1230-1605/drivers/input/input.c:1661: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2008-1230-1605.orig/drivers/input/input.c
+++ mmotm-2008-1230-1605/drivers/input/input.c
@@ -1657,7 +1657,7 @@ static const struct file_operations inpu
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass()
+static void __init input_init_abs_bypass(void)
 {
 	const unsigned int *p;
 	for (p = input_abs_bypass_init_data; *p; p++)
