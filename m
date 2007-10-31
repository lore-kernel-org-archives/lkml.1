Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbXJaQiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbXJaQiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXJaQhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:37:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:55953 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753883AbXJaQhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:37:51 -0400
Date: Wed, 31 Oct 2007 17:23:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID fixes for 2.6.24-rc1
Message-ID: <Pine.LNX.4.64.0710311430540.12935@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID code.

 drivers/hid/hid-input.c         |   22 ++++++++++++++++------
 drivers/hid/usbhid/hid-quirks.c |    8 ++++++++
 drivers/hid/usbhid/hiddev.c     |    2 +-
 3 files changed, 25 insertions(+), 7 deletions(-)

Dirk Hohndel (1):
      HID: fix hidinput_connect ignoring retval from input_register_device

Dmitry Torokhov (1):
      HID: Don't access input_dev->private directly

Jerrold Jones (1):
      HID: Add GoTop tablets to blacklist

Jiri Kosina (1):
      HID: hiddev - fix compiler warning

