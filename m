Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZLNAZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZLNAZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZLNAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:24:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZLMX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:29 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com, mjg59@srcf.ucam.org,
       alan-jenkins@tuffmail.co.uk, torvalds@linux-foundation.org
Subject: [PATCH 07/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:59 +0100
Message-Id: <f968a9faf674d812c7ed82ff2b1d5e9e164e9fd9.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..e1ac2ba 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -305,7 +305,7 @@ static int dell_get_intensity(struct backlight_device *bd)
 	return buffer.output[1];
 }
 
-static struct backlight_ops dell_ops = {
+static const struct backlight_ops dell_ops = {
 	.get_brightness = dell_get_intensity,
 	.update_status  = dell_send_intensity,
 };
-- 
1.6.5.3

