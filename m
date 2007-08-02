Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbXHBQUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbXHBQUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXHBQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:20:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:47210 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755962AbXHBQU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:20:27 -0400
Date: Thu, 2 Aug 2007 18:20:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID fixes for 2.6.23-rc2
Message-ID: <Pine.LNX.4.64.0708021414120.1779@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID layer (memory leak, NULL ptr dereference on error 
path and several blacklist quirk updates).

 MAINTAINERS                     |    2 +-
 drivers/hid/usbhid/hid-core.c   |    5 +-
 drivers/hid/usbhid/hid-quirks.c |  138 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 141 insertions(+), 4 deletions(-)

Christian Lamparter (1):
      USB HID: add ASUS LCM to the blacklist

Jesper Juhl (1):
      USB HID: fix a possible NULL pointer dereference when we fail to allocate memory

Jiri Kosina (3):
      USB HID: update description of USBHID in MAINTAINERS
      USB HID: fix memory leak of usbhid_device
      HID: Never call hid_free_buffers() when usbhid_device has been freed

Phil Dibowitz (1):
      USB HID: Add all Logitech Harmonies to blacklist

Tino Keitel (1):
      HID: remove the Applie IR sensor from the hid_blacklist

