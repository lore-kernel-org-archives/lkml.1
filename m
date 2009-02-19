Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZBSMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZBSMtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZBSMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:49:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:48676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZBSMtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:49:12 -0500
Message-ID: <499D53D9.6090407@suse.de>
Date: Thu, 19 Feb 2009 13:43:05 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com,
       Frank Seidel <fseidel@suse.de>
Subject: [PATCH] hwmon/hdaps: Fix bug 7154 adaption for Thinkpad X41
References: <499569A9.5030202@suse.de>	<499807B4.1050606@suse.de>	<4998120C.3030808@suse.de> <20090215153735.25ee8b05@hyperion.delvare>
In-Reply-To: <20090215153735.25ee8b05@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Fix for kernel.org bug #7154:hdaps inversion of
actual Thinkpad X41's Y-axis.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/hwmon/hdaps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -527,7 +527,7 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
-	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
+	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad X41", HDAPS_Y_AXIS),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),

