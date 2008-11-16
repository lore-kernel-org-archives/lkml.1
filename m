Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYKPAgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYKPAgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYKPAg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:36:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:35461 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbYKPAg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:36:27 -0500
Date: Sun, 16 Nov 2008 01:36:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID updates
Message-ID: <alpine.LNX.1.10.0811160128010.19853@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID layer. This fixes a few rather easy-to-fix bugs 
that were still caused by the conversion of the HID code to proper bus, 
and also adds support for a couple of new devices which was trivial 
enough.

There is currently only one known issue pending -- a lockdep warning 
reported by Alan Stern. It's not completely trivial to solve, but is being 
worked on. I will send the fix separately once it is verified and tested.

Thanks.

 drivers/hid/hid-apple.c       |   11 +++++++++--
 drivers/hid/hid-core.c        |   12 +++++++++---
 drivers/hid/hid-ids.h         |    3 +++
 drivers/hid/hidraw.c          |   30 ++++++++++++++++--------------
 drivers/hid/usbhid/hid-core.c |   25 +++++++++++++++++++------
 include/linux/input.h         |    2 ++
 6 files changed, 58 insertions(+), 25 deletions(-)

Alexey Klimov (2):
      HID: fix kworld fm700 radio hidquirks
      HID: fix radio-mr800 hidquirks

Andi Kleen (1):
      HID: use single threaded work queue for hid_compat

Henrik Rydberg (2):
      HID: support for new unibody macbooks
      HID: map macbook keys for "Expose" and "Dashboard"

Jiri Slaby (2):
      HID: fix start/stop cycle in usbhid driver
      HID: don't grab devices with no input

Oliver Neukum (1):
      HID: fix locking in hidraw_open()
