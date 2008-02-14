Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbYBNN5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbYBNN5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYBNN5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:57:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:46461 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954AbYBNN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:57:20 -0500
Date: Thu, 14 Feb 2008 14:57:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID updates for 2.6.25-rc2
Message-ID: <Pine.LNX.4.64.0802141455530.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID layer.

There is one important fix for hid <-> input mapping processing. The rest 
are just addidions of new device ids that came after the merge window.
Thanks.

 drivers/hid/hid-input-quirks.c  |   17 +++++++++--------
 drivers/hid/hid-input.c         |    8 +++++++-
 drivers/hid/usbhid/hid-quirks.c |   38 +++++++++++++++++++++++++++++++++++++-
 include/linux/hid.h             |    2 +-
 4 files changed, 54 insertions(+), 11 deletions(-)

Jeremy Roberson (1):
      HID: Blacklist new GTCO CalComp USB device PIDs

Jiri Kosina (2):
      HID: fix processing of event quirks
      HID: add LCSPEC from VERNIER to quirk list

Tobias Mueller (1):
      HID: add USB IDs for MacBook 3rd generation

