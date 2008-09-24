Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYIXAE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYIXAE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYIXADm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:03:42 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:31664 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754745AbYIXADl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:03:41 -0400
Date: Wed, 24 Sep 2008 04:03:40 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] USB: Protect hcd.h from multiple inclusions
Message-ID: <20080924000340.GC29733@oksana.dev.rtsoft.ru>
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080924000255.GA28054@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will let us use this header in other header files.
Will be needed for the FHCI USB Host driver.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/usb/core/hcd.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index e710ce0..66b64d7 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -16,6 +16,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifndef __USB_CORE_HCD_H
+#define __USB_CORE_HCD_H
 
 #ifdef __KERNEL__
 
@@ -483,3 +485,5 @@ static inline void usbmon_urb_complete(struct usb_bus *bus, struct urb *urb,
 extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
 #endif /* __KERNEL__ */
+
+#endif /* __USB_CORE_HCD_H */
-- 
1.5.6.3

