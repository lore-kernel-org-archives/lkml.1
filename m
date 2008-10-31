Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbYJaOuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbYJaOuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYJaOuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:50:01 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:54599 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYJaOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=aGwXd86PAhegAfO+46ppTqkN3aDm7EtygVeR7A815LAKBno5HkNWPi1RPhIySiH2KW
         yEkZ4OoPBA1w7Vb2ow+BohGs5jpARZybqWWlSYog4K3ve5C15WLuUC0z9opQGDFIULbN
         jGA6eMpDPlbWwiLSvneeIM0bd4A1ce6jTFeRw=
Date: Fri, 31 Oct 2008 22:49:56 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: Staging: wlan-ng: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081031223057.0F1A.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/staging/wlan-ng/p80211conv.c
  drivers/staging/wlan-ng/p80211req.c
  drivers/staging/wlan-ng/p80211wext.c
  drivers/staging/wlan-ng/prism2mgmt.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 68121b9..a97c5b8 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -55,7 +55,6 @@
 #define __NO_VERSION__		/* prevent the static definition */
 
 
-#include <linux/version.h>
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 0233abe..9c27d38 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -54,7 +54,6 @@
 /* System Includes */
 
 
-#include <linux/version.h>
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..514afec 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -38,7 +38,6 @@
 /* System Includes */
 
 
-#include <linux/version.h>
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index c975025..14939de 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -64,7 +64,6 @@
 #include "version.h"
 
 
-#include <linux/version.h>
 
 #include <linux/if_arp.h>
 #include <linux/module.h>

