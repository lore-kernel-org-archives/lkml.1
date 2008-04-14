Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYDNKuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYDNKuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYDNKuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:50:11 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:53182 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751494AbYDNKuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:50:10 -0400
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] sound: this amplifier only goes up to 7
To: Trivial Kernel Patches <trivial@kernel.org>, perex@perex.cz
Cc: <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Pavel Machek <pavel@suse.cz>
Date: Mon, 14 Apr 2008 20:49:56 +1000
Message-ID: <20080414104913.24603.45227.stgit@marcab.local.tull.net>
In-Reply-To: <s5hej98hh4o.wl%tiwai@suse.de>
References: <s5hej98hh4o.wl%tiwai@suse.de>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound: kernel log levels are 0-7

Kernel log levels are 0-7, not 0-9.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 sound/core/misc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/sound/core/misc.c b/sound/core/misc.c
index 102d1c3..38524f6 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -39,7 +39,7 @@ void snd_verbose_printk(const char *file, int line, const char *format, ...)
 {
 	va_list args;
 	
-	if (format[0] == '<' && format[1] >= '0' && format[1] <= '9' && format[2] == '>') {
+	if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
 		char tmp[] = "<0>";
 		tmp[1] = format[1];
 		printk("%sALSA %s:%d: ", tmp, file, line);
@@ -60,7 +60,7 @@ void snd_verbose_printd(const char *file, int line, const char *format, ...)
 {
 	va_list args;
 	
-	if (format[0] == '<' && format[1] >= '0' && format[1] <= '9' && format[2] == '>') {
+	if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
 		char tmp[] = "<0>";
 		tmp[1] = format[1];
 		printk("%sALSA %s:%d: ", tmp, file, line);

