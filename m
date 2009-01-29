Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZA2NV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZA2NV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZA2NVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:21:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:55905 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569AbZA2NVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:21:50 -0500
Date: Thu, 29 Jan 2009 14:21:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.28-rc4
Message-ID: <alpine.LNX.1.10.0901291139340.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID code. It contains two patches/fixes for specific 
devices and an important hiddev fix.

Thanks.

 drivers/hid/hid-core.c      |    4 ++++
 drivers/hid/hid-ids.h       |    2 ++
 drivers/hid/hid-microsoft.c |   13 ++++---------
 drivers/hid/usbhid/hiddev.c |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

Jarod Wilson (1):
      HID: add antec-branded soundgraph imon devices to blacklist

Jiri Kosina (2):
      HID: adjust report descriptor fixup for MS 1028 receiver
      HID: document difference between hid_blacklist and hid_ignore_list

Oliver Neukum (1):
      HID: fix reversed logic in disconnect testing of hiddev

