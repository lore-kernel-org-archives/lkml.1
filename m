Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYJ3Aof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYJ3Aof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYJ3Ao1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:44:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:36297 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbYJ3Ao0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:44:26 -0400
Date: Thu, 30 Oct 2008 01:44:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID updates
Message-ID: <alpine.LNX.1.10.0810290101510.12928@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID layer. This, most importantly, fixes an oops on
systems that have devices driven by appletouch driver (or generally any
device that is not claimed at all by HID subsystem due to blacklist
entry).

There are currently no other critical bugreports pending against the new 
HID infrastructure.

Thanks.

 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-dell.c          |    1 +
 drivers/hid/hid-ids.h           |    3 ++
 drivers/hid/usbhid/hid-core.c   |   60 +++++++++++++++++++++++++++-----------
 drivers/hid/usbhid/usbhid.h     |    2 +
 include/linux/hid.h             |    1 +
 include/linux/mod_devicetable.h |    1 +
 7 files changed, 51 insertions(+), 18 deletions(-)

Alan Stern (1):
      HID: add quirk entry for no-name keyboard (0x13ba/0x0017)

Andreas Schwab (1):
      HID: fix hid_device_id for cross compiling

Jiri Slaby (2):
      HID: fix oops during suspend of unbound HID devices
      HID: sync on deleted io_retry timer in usbhid driver

