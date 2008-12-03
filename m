Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYLCM3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYLCM3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYLCM3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:29:09 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:57255 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLCM3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:29:09 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Char: n_tty, include module.h
Date: Wed,  3 Dec 2008 13:28:58 +0100
Message-Id: <1228307338-18467-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are using EXPORT_SYMBOL, we should include linux/module.h

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/n_tty.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index b441c09..8e6c591 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -41,6 +41,7 @@
 #include <linux/timer.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-- 
1.6.0.4

