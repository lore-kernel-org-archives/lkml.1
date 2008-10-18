Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYJRDxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYJRDxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJRDxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:53:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:40187 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYJRDxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=Sje7CNWADGFiB1n3jll1OT2atFYDcstuxXS0FV0LletMwy6/4szGHSKTaudDB0wKQR
         nNCXNiabadFCibC40uvKegetio7be5Ctz+IVav2SI+HrYrRY+0UTkMK2rzvYfy0VSR1J
         /YZc5PT22gPjWPbhOYF6x68vtJX8D+ym9zGLk=
Date: Sat, 18 Oct 2008 11:53:07 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: wlan-ng: prism2: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018114621.61C3.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include "version.h" in
drivers/staging/wlan-ng/p80211wep.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/wlan-ng/p80211wep.c b/drivers/staging/wlan-ng/p8021
index 53fe298..11a50c7 100644
--- a/drivers/staging/wlan-ng/p80211wep.c
+++ b/drivers/staging/wlan-ng/p80211wep.c
@@ -64,7 +64,6 @@
 /*================================================================*/
 /* Project Includes */

-#include "version.h"
 #include "p80211hdr.h"
 #include "p80211types.h"
 #include "p80211msg.h"


