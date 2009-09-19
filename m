Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZISVyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZISVyC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:54:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZISViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:38:05 -0400
Received: from kroah.org ([198.145.64.141]:50899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZISViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:38:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/79] tty: includecheck fix: drivers/char, vt.c
Date: Sat, 19 Sep 2009 14:36:11 -0700
Message-Id: <1253396244-7885-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  drivers/char/vt.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 6aa88f5..e47a4c8 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2955,7 +2955,6 @@ int __init vty_init(const struct file_operations *console_fops)
 }
 
 #ifndef VT_SINGLE_DRIVER
-#include <linux/device.h>
 
 static struct class *vtconsole_class;
 
-- 
1.6.4.2

