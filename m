Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab0BQNbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:31:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38589 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933561Ab0BQNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:31:03 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] tty: kill request_room for USB ACM class
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Date: Wed, 17 Feb 2010 13:07:05 +0000
Message-ID: <20100217130703.16008.47232.stgit@localhost.localdomain>
In-Reply-To: <20100217130604.16008.86393.stgit@localhost.localdomain>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/class/cdc-acm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 5155ff2..95a18e5 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -428,7 +428,6 @@ next_buffer:
 		throttled = acm->throttle;
 		spin_unlock_irqrestore(&acm->throttle_lock, flags);
 		if (!throttled) {
-			tty_buffer_request_room(tty, buf->size);
 			tty_insert_flip_string(tty, buf->base, buf->size);
 			tty_flip_buffer_push(tty);
 		} else {

