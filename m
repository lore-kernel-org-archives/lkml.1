Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab0BZPXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:23:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036Ab0BZPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:23:06 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 13/14] hp-wmi: Add support for tablet rotation key
Date: Fri, 26 Feb 2010 10:18:46 -0500
Message-Id: <1267197527-18062-14-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HP touchsmart tablet has a key for rotating the UI from landscape to
portrait. Add support for it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/hp-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ad4c414..3aa57da 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -89,6 +89,7 @@ static struct key_entry hp_wmi_keymap[] = {
 	{KE_KEY, 0x20e6, KEY_PROG1},
 	{KE_KEY, 0x2142, KEY_MEDIA},
 	{KE_KEY, 0x213b, KEY_INFO},
+	{KE_KEY, 0x2169, KEY_DIRECTION},
 	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
-- 
1.6.6.1

