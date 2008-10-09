Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYJIMcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYJIMcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbYJIMch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:32:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:38695 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753170AbYJIMcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:32:36 -0400
Date: Thu, 9 Oct 2008 14:32:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: HID merge plans for 2.6.28
Message-ID: <alpine.LNX.1.10.0810091420250.26779@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a shortlog what is currently brewing in HID tree for 2.6.28. The 
most notable change is a conversion of the whole HID core code into bus, 
and conversion of all the quirks to specialized separate drivers. Over 
years, the quirks have been added in order to support broken devices all 
over the code, and turned it into total unmaintainable mess. The HID bus 
provides easy means for drivers for quirky devices to use as much of the 
common code as possible, and really implement only the quirky part.

Besides that, handling of some new devices has been added, plus some other 
random easy fixes.

Alex Chiang (1):
      HID: fix grammo in HID_COMPAT Kconfig help text

Anssi Hannula (1):
      HID: fix a lockup regression when using force feedback on a PID device

Antonio Ospite (2):
      HID: hiddev.h: Fix mixed space and tabs in example code.
      HID: hiddev.h: Fix example code.

Harvey Harrison (1):
      HID: make compat functions static

Jiri Kosina (3):
      HID: introduce list for hiddev creation forcing
      HID: add support for Super Dual Box Pro USB PS2/PS2 adapter
      HID: fix incorrent length condition in hidraw_write()

Jiri Slaby (35):
      modpost: add support for hid
      HID: make a bus from hid code
      HID: hid, make parsing event driven
      HID: move ids into separate file
      HID: move usage input mapping to hid.h
      HID: move logitech quirks
      HID: move ignore quirks
      HID: move apple quirks
      HID: add compat support
      HID: indent switches/cases
      HID: move microsoft quirks
      HID: move sunplus quirks
      HID: move cypress quirks
      HID: move a4tech quirks
      HID: move cherry quirks
      HID: move ezkey quirks
      HID: move chicony quirks
      HID: move belkin quirks
      HID: move petalynx quirks
      HID: move monterey quirks
      HID: move gyration quirks
      HID: move samsung quirks
      HID: remove hid-input-quirks
      HID: remove rdesc quirk support
      HID: move sony quirks
      HID: move dell quirks
      HID: move connect quirks
      HID: move reset leds quirk
      HID: move logitech FF processing
      HID: fix tty<->hid deadlock
      HID: move pantherlord FF processing
      HID: move thrustmaster FF processing
      HID: move zeroplus FF processing
      HID: remove hid-ff
      HID: convert to dev_* prints

Peter Korsgaard (1):
      HID: add appletv IR receiver quirk

Randy Dunlap (1):
      HID: fix gyration build error

Remi Cattiau (1):
      HID: ignore iBuddy devices

Richard Hughes (1):
      HID: remove ignore quirk for MGE UPS devices

Sergey Belyashov (1):
      HID: Autocentering support for Logitech MOMO Racing Wheel

Tomoya Adachi (1):
      HID: report descriptor fix for remaining MacBook JIS keyboards

