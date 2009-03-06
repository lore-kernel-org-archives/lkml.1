Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZCFNCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZCFNCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZCFNCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:02:15 -0500
Received: from smtp.nokia.com ([192.100.122.233]:30106 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZCFNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:02:14 -0500
Message-ID: <49B11EB0.30809@nokia.com>
Date: Fri, 06 Mar 2009 15:01:36 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: lrg@slimlogic.co.uk
CC: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 13:01:16.0960 (UTC) FILETIME=[A2EFB200:01C99E5B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL4030 and TWL5030 support 3.0V on VAUX3.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---



According to TI:
http://community.ti.com/forums/t/3777.aspx



 drivers/regulator/twl4030-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 8655443..1755026 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -224,7 +224,7 @@ static const u16 VAUX2_VSEL_table[] = {
 };
 static const u16 VAUX3_VSEL_table[] = {
 	1500, 1800, 2500, 2800,
-	UNSUP(3000), UNSUP(3000), UNSUP(3000), UNSUP(3000),
+	3000, 3000, 3000, 3000,
 };
 static const u16 VAUX4_VSEL_table[] = {
 	700, 1000, 1200, UNSUP(1300),
-- 
1.5.6.3
