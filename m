Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbYA0SBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbYA0SBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYA0SBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:01:32 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:59923 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbYA0SBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:01:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUoAKpVnEdV5CFwRmdsb2JhbACBWIYNiDkBAQE3mW+CAQ
Date: Sun, 27 Jan 2008 19:01:29 +0100
From: Martin Samuelsson <sam.linux.kernel@gmail.com>
To: rbultje@ronald.bitfreak.net
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch] drivers/media/video/zoran_card.c: en/decoder loading
Message-Id: <20080127190129.6a1554ef.sam.linux.kernel@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the avs6eyes to load the bt866 and ks0127 drivers automatically.

Signed-off-by: Martin Samuelsson <sam.linux.kernel@gmail.com>
---
 zoran_card.c |    6 ++++++
 1 file changed, 6 insertions(+)
--- linux-2.6.24-ori/drivers/media/video/zoran_card.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-sam/drivers/media/video/zoran_card.c	2008-01-27 17:16:51.000000000 +0100
@@ -366,6 +366,12 @@ i2cid_to_modulename (u16 i2c_id)
 	case I2C_DRIVERID_MSE3000:
 		name = "mse3000";
 		break;*/
+	case I2C_DRIVERID_BT866:
+		name = "bt866";
+		break;
+	case I2C_DRIVERID_KS0127:
+		name = "ks0127";
+		break;
 	default:
 		break;
 	}

-- 
Martin Samuelsson (formerly known as sam@home.se)
