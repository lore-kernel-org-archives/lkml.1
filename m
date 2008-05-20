Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbYETOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbYETOa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYETOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:30:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:54140 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbYETOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:30:22 -0400
Date: Tue, 20 May 2008 16:30:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.26-rc4
Message-ID: <Pine.LNX.4.64.0805201628330.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for 2.6.26-rc4. It contains a few blacklist additions, 
comment cleanup patch from Adrian and regression fix for numlock on 
apple_pb. Thanks.

 drivers/hid/hid-debug.c         |    2 -
 drivers/hid/hid-input.c         |    7 ++---
 drivers/hid/usbhid/hid-quirks.c |   49 +++++++++++++++++++++++---------------
 drivers/hid/usbhid/usbkbd.c     |    2 -
 drivers/hid/usbhid/usbmouse.c   |    2 -
 include/linux/hid.h             |    3 +-
 include/linux/hiddev.h          |    2 -
 7 files changed, 34 insertions(+), 33 deletions(-)

Adrian Bunk (1):
      HID: remove CVS keywords

Diego 'Flameeyes' Petteno (1):
      HID: split Numlock emulation quirk from HID_QUIRK_APPLE_HAS_FN.

Dylan R Semler (1):
      HID: Add iMON LCDs to blacklist

Xiaofan Chen (1):
      HID: add Microchip PICKit 1 and PICkit 2 to blacklist
