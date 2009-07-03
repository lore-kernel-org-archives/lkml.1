Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZGCRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZGCRq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZGCRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:46:51 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:56368 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZGCRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:46:50 -0400
Date: Fri, 3 Jul 2009 10:46:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH -mmotm] gpio.h: fix warning for GENERIC_GPIO=n
Message-Id: <20090703104640.07b26b28.randy.dunlap@oracle.com>
In-Reply-To: <200907030300.n6330BgL015030@imap1.linux-foundation.org>
References: <200907030300.n6330BgL015030@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A4E4402.01E1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for CONFIG_GENERIC_GPIO=n, which causes this warning:

include/linux/gpio.h:93: warning: 'struct device' declared inside parameter list
include/linux/gpio.h:93: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/gpio.h |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm-2009-0702-1957.orig/include/linux/gpio.h
+++ mmotm-2009-0702-1957/include/linux/gpio.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 
+struct device;
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
