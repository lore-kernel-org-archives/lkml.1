Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYLOOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYLOOOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLOOOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:14:08 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:59557 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751383AbYLOOOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:14:07 -0500
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 09:14:07 EST
Message-ID: <4946636B.50409@pardus.org.tr>
Date: Mon, 15 Dec 2008 16:02:19 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.18 (X11/20071115)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Input: i8042 - add Gigabyte M912 netbook to noloop exception
 table
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ozan Çağlayan <ozan@pardus.org.tr>
Date:   Mon Dec 15 13:53:08 2008 +0200

    Input: i8042 - add Gigabyte M912 netbook to noloop exception table

    Gigabyte M912's touchpad needs i8042.noloop for working.

    Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
    Tested-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/input/serio/i8042-x86ia64io.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 29e6863..e196bf2 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -143,6 +143,14 @@ static struct dmi_system_id __initdata i8042_dmi_noloop_table[] = {
                        DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
                },
        },
+       {
+               .ident = "Gigabyte M912",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "M912"),
+                       DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
+               },
+       },
        { }
 };


-- 
Ozan Çağlayan

