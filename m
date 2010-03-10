Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0CJTss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:48:48 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:23825 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0CJTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:48:46 -0500
Date: Wed, 10 Mar 2010 11:47:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH] driver-core: fix missing kernel-doc in firmware_class
Message-Id: <20100310114758.622bfff2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B97F79A.00A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning in firmware_class.c:

Warning(drivers/base/firmware_class.c:94): No description found for parameter 'attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/firmware_class.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2634-rc1.orig/drivers/base/firmware_class.c
+++ lnx-2634-rc1/drivers/base/firmware_class.c
@@ -78,6 +78,7 @@ firmware_timeout_show(struct class *clas
 /**
  * firmware_timeout_store - set number of seconds to wait for firmware
  * @class: device class pointer
+ * @attr: device attribute pointer
  * @buf: buffer to scan for timeout value
  * @count: number of bytes in @buf
  *
