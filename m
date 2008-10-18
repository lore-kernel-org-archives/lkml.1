Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYJRDxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYJRDxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYJRDxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:53:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:41111 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYJRDxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=JYM2+gMDo4mT30iHVEfhsb6/MkHut2mfWVFMR7kog+uPfFkXe3rAIZU12aOP3pybdQ
         U2uJzcXPXc2HKrN/eqxR4ZVQAblP2YZnkqxO6VIzE7p6dUUWF9LXYhx9sO2bl9xuNsiK
         zNHAOfkV3mOSTzxTbLeEVUKfc4OJMClmL73Go=
Date: Sat, 18 Oct 2008 11:53:05 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: wlan-ng: prism2: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018114433.61C0.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include "wlan_compat.h" in
drivers/staging/wlan-ng/prism2mib.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism
index 268fd9b..eac06f7 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -90,8 +90,6 @@
 #include <linux/usb.h>
 //#endif

-#include "wlan_compat.h"
-
 /*================================================================*/
 /* Project Includes */

