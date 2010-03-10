Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0CJLcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:32:48 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58749 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab0CJLco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:32:44 -0500
Date: Wed, 10 Mar 2010 12:33:11 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Jeremy Katz <katzj@redhat.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>,
       Jan Dumon <j.dumon@option.com>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] rest of USB_BERRY_CHARGE
Message-ID: <20100310113311.GA2824@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	This seems to just be a random leftover from a recent driver
removal [1] that showed up on my most recent vamos run.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/
[1] a8d4211f33a9573f7b1bdcfd9c9c48631d1515ee

----
>From 8584032b1060535d573cf68d77dd0ea39f2df0b5 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 10 Mar 2010 12:25:51 +0100
Subject: [PATCH] Remove last bit of CONFIG_USB_BERRY_CHARGE

One last bit was missed while removing the USB_BERRY_CHARGE config
option in a8d4211f33a9573f7b1bdcfd9c9c48631d1515ee which gets dropped
by this patch.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/usb/storage/unusual_devs.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 98b549b..266287a 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1380,20 +1380,6 @@ UNUSUAL_DEV(  0x0f19, 0x0105, 0x0100, 0x0100,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
-/* Jeremy Katz <katzj@redhat.com>:
- * The Blackberry Pearl can run in two modes; a usb-storage only mode
- * and a mode that allows access via mass storage and to its database.
- * The berry_charge module will set the device to dual mode and thus we
- * should ignore its native mode if that module is built
- */
-#ifdef CONFIG_USB_BERRY_CHARGE
-UNUSUAL_DEV(  0x0fca, 0x0006, 0x0001, 0x0001,
-		"RIM",
-		"Blackberry Pearl",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_IGNORE_DEVICE ),
-#endif
-
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
-- 
1.6.3.3







