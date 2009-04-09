Return-Path: <linux-kernel-owner+w=401wt.eu-S1765889AbZDIM0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765889AbZDIM0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDIM0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:26:43 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:60928 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZDIM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:26:43 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 08:26:42 EDT
Message-ID: <49DDE69B.6050504@seas.upenn.edu>
Date: Thu, 09 Apr 2009 08:14:19 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
CC: Matthew Garrett <mjg@redhat.com>, mjg59@srcf.ucam.org,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Comments for additional keys for dell-wmi
References: <200904082116.n38LG4Df012420@ampersand.seas.upenn.edu> <49DDB053.4010809@tremplin-utc.net>
In-Reply-To: <49DDB053.4010809@tremplin-utc.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commenting rotation events, in lieu of appropriate self commenting key names in input.h.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
 drivers/platform/x86/dell-wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index b76ef49..2d4f718 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -50,8 +50,8 @@ enum { KE_KEY, KE_SW, KE_END };

 static struct key_entry dell_wmi_keymap[] = {
        {KE_KEY, 0xe045, KEY_PROG1},
-       {KE_KEY, 0xe046, KEY_PROG2},
-       {KE_KEY, 0xe047, KEY_PROG3},
+       {KE_KEY, 0xe046, KEY_PROG2},     /* Going to tablet mode */
+       {KE_KEY, 0xe047, KEY_PROG3},     /* Coming from tablet mode */
        {KE_END, 0}
 };

-- 
1.6.2.1

`
