Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYLAMV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYLAMV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYLAMVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:21:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:37099 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbYLAMVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:21:19 -0500
Date: Mon, 1 Dec 2008 13:21:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes
Message-ID: <alpine.LNX.1.10.0812011047550.21911@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID fixes that should go into 2.6.28. Apart from some specific
product IDs additions/fixups, possible deadlock (reported by lockdep via
Alan Stern) is fixed.

Thanks.

 drivers/hid/hid-apple.c       |    6 +++---
 drivers/hid/hid-core.c        |   14 ++++++--------
 drivers/hid/hid-ids.h         |    1 +
 drivers/hid/hid-pl.c          |    2 ++
 drivers/hid/usbhid/hid-core.c |   18 ++----------------
 drivers/hid/usbhid/usbhid.h   |    1 -
 6 files changed, 14 insertions(+), 28 deletions(-)

Jan Scholz (1):
      HID: Apple ALU wireless keyboards are bluetooth devices

Jiri Kosina (3):
      HID: fix blacklist entries for greenasia/pantherlord
      HID: unignore mouse on unibody macbooks
      HID: add USB ID for another dual gameron adapter

Jiri Slaby (1):
      HID: remove setup mutex, fix possible deadlock

