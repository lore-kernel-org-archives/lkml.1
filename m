Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZD3OBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZD3OBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbZD3OAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:00:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762449AbZD3OAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:00:42 -0400
Date: Thu, 30 Apr 2009 16:00:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.0904301559140.5012@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID code.

It contains two important fixes (locking fix and possible workqueue 
deadlock), plus it adds/fixes support of two particular devices (just 
simple product ID additions/range adjustments).

Thanks!

 drivers/hid/hid-apple.c       |    2 +-
 drivers/hid/hid-core.c        |    1 +
 drivers/hid/hid-ids.h         |    1 +
 drivers/hid/hid-lg.c          |    2 ++
 drivers/hid/hidraw.c          |   12 ++++++++----
 drivers/hid/usbhid/hid-core.c |    2 +-
 6 files changed, 14 insertions(+), 6 deletions(-)

Christophe Borivant (1):
      HID: Add support for the G25 force feedback wheel in native mode

Dan Carpenter (1):
      HID: hidraw -- fix missing unlocks in unlocked_ioctl

Oliver Neukum (1):
      HID: fix possible deadlock in usbhid_close()

Ulrich Dangel (1):
      HID: Fix the support for apple mini aluminium keyboard

