Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYGWPGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYGWPGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYGWPG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:06:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:34709 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753292AbYGWPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:06:18 -0400
Date: Wed, 23 Jul 2008 17:06:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID patches for 2.6.27
Message-ID: <alpine.LNX.1.10.0807231618500.3037@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following patches for HID code.

  drivers/hid/hid-core.c          |   10 ++++----
  drivers/hid/hid-input-quirks.c  |   40 ++++++++++++++++++++++++++++++++
  drivers/hid/hid-input.c         |    3 ++
  drivers/hid/hidraw.c            |   48 +++++++++++++++++++++-----------------
  drivers/hid/usbhid/hid-quirks.c |   20 +++++++++++++++-
  drivers/hid/usbhid/hiddev.c     |   14 ++++++++---
  drivers/hid/usbhid/usbkbd.c     |   10 +-------
  drivers/hid/usbhid/usbmouse.c   |    8 ------
  include/linux/hid.h             |    2 +-
  9 files changed, 105 insertions(+), 50 deletions(-)

Alan Cox (2):
       HID: Switch hiddev to unlocked_ioctl
       HID: Push down BKL into ioctl handler in hidraw

Alexandre Karpenko (1):
       HID: add fn key support on Macbook Pro 4,1 and Macbook Air

Dan Nicholson (1):
       HID: Invert HWHEEL mappings for some Logitech mice

Daniel Walker (1):
       HID: gyration remote support

Dmitry Torokhov (1):
       HID: Add mapping of new KEY_MEDIA_REPEAT keycode

Harvey Harrison (1):
       HID: use get/put_unaligned_* helpers

Henrik Rydberg (1):
       HID: apple_fn_keys F5 and F6

Jiri Kosina (6):
       HID: fix compile issue in hiddev ioctl
       HID: remove unused variable from hiddev compat ioctl
       HID: fix memory leak in hidraw_release
       HID: add quirk for Logitech DiNovo desktop
       HID: gyration sleep button quirk
       HID: remove quirk lookup from usbkbd/usbmouse

Jiri Slaby (1):
       HID: fix quirk handling in usbmouse/kbd

Ming Lei (1):
       HID:usbkbd:mark usb_kbd_keycode array as const

Rafi Rubin (1):
       HID: add n-trig digitizer usage

