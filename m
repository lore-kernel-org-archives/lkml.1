Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZGHQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZGHQDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbZGHQDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:03:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059AbZGHQC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:02:59 -0400
Subject: [PATCH 22/44] includecheck fix: drivers/char, vt.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:40:38 +0530
Message-Id: <1247065838.4382.56.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/char/vt.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/char/vt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d9113b4..4330980 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2963,7 +2963,6 @@ int __init vty_init(const struct file_operations *console_fops)
 }
 
 #ifndef VT_SINGLE_DRIVER
-#include <linux/device.h>
 
 static struct class *vtconsole_class;
 
-- 
1.6.0.6



