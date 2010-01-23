Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299Ab0AWAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0AWAYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270Ab0AWAYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:24:01 -0500
Received: from kroah.org ([198.145.64.141]:35068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab0AWASy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:12 2010
Message-Id: <20100123001112.274799336@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: [16/29] USB: add speed values for USB 3.0 and wireless controllers
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit b132b04e193908a94d95065d0628f8fb0159cc55 upstream.

These controllers say "unknown" for their speed in sysfs, which
obviously isn't correct.

Reported-by: Kurt Garloff <garloff@novell.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -115,6 +115,12 @@ show_speed(struct device *dev, struct de
 	case USB_SPEED_HIGH:
 		speed = "480";
 		break;
+	case USB_SPEED_VARIABLE:
+		speed = "480";
+		break;
+	case USB_SPEED_SUPER:
+		speed = "5000";
+		break;
 	default:
 		speed = "unknown";
 	}


