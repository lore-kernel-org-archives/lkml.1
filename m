Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYFWLZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYFWLZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYFWLZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:25:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33271 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114AbYFWLZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:25:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] tty_driver: Update required method documentation
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2008 12:06:52 +0100
Message-ID: <20080623110625.24976.17776.stgit@localhost.localdomain>
In-Reply-To: <20080623110455.24976.32969.stgit@localhost.localdomain>
References: <20080623110455.24976.32969.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the requirement rules are now more relaxed. Also correct a
contradiction in the previous update

Signed-off-by: Alan Cox <alan@redhat.com>
---

 include/linux/tty_driver.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 59f1c0b..d2a0035 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -27,8 +27,7 @@
  * 	This routine is called by the kernel to write a series of
  * 	characters to the tty device.  The characters may come from
  * 	user space or kernel space.  This routine will return the
- *	number of characters actually accepted for writing.  This
- *	routine is mandatory.
+ *	number of characters actually accepted for writing.
  *
  *	Optional: Required for writable devices.
  *
@@ -134,7 +133,7 @@
  * 	This routine notifies the tty driver that it should hangup the
  * 	tty device.
  *
- *	Required:
+ *	Optional:
  *
  * void (*break_ctl)(struct tty_stuct *tty, int state);
  *

