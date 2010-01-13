Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847Ab0AMMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0AMMw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0AMMw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:52:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0AMMw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:52:27 -0500
Date: Wed, 13 Jan 2010 13:52:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1001131347061.30977@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following fixes for the HID subssytem. Mostly device ID 
changes and small fixes affecting small set of particular devices.

Thanks!

Christian Schuerer-Waldheim (1):
      HID: add device IDs for new model of Apple Wireless Keyboard

Petr ¦tetiar (1):
      HID: blacklist ET&T TC5UH touchscreen controller

Przemo Firszt (2):
      HID: fix pad button definition in hid-wacom
      HID: wacom: Add BTN_TOOL_FINGER for pad button reporting

Robert Schedel (1):
      HID: Support 171 byte variant of Samsung USB IR receiver

 drivers/hid/hid-apple.c   |    7 +++++++
 drivers/hid/hid-core.c    |    4 ++++
 drivers/hid/hid-ids.h     |    6 ++++++
 drivers/hid/hid-samsung.c |   25 +++++++++++++++++++------
 drivers/hid/hid-wacom.c   |    4 ++++
 5 files changed, 40 insertions(+), 6 deletions(-)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
