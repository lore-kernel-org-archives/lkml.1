Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZC2Eyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZC2Eyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZC2Eyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:54:44 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48612 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZC2Eyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:54:43 -0400
Date: Sat, 28 Mar 2009 21:50:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] maple: fix Error in kernel-doc notation
Message-Id: <20090328215017.1ae9b798.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49CEFEBD.0110:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc error in maple (it's not kernel-doc):

Error(drivers/sh/maple/maple.c:782): cannot understand prototype: 'struct bus_type maple_bus_type = '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Paul Mundt <lethal@linux-sh.org>
---
 drivers/sh/maple/maple.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.29-git4.orig/drivers/sh/maple/maple.c
+++ linux-2.6.29-git4/drivers/sh/maple/maple.c
@@ -776,7 +776,7 @@ static struct maple_driver maple_unsuppo
 		.bus = &maple_bus_type,
 	},
 };
-/**
+/*
  * maple_bus_type - core maple bus structure
  */
 struct bus_type maple_bus_type = {
