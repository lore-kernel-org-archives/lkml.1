Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZBQOpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZBQOpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZBQOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:44:56 -0500
Received: from ns.suse.de ([195.135.220.2]:53698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZBQOoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:44:55 -0500
Date: Tue, 17 Feb 2009 15:44:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.29-rc5
Message-ID: <alpine.LNX.1.10.0902171408270.18110@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID fixes that should be present in 2.6.29. It contains some
device-specific additions/changes blacklist/quirklist changes, endianity fix
in hid alias and fixes potential missing unlock in hidraw driver.

Thanks.

 drivers/hid/hid-core.c   |   13 +++++++------
 drivers/hid/hid-ids.h    |    3 +++
 drivers/hid/hidraw.c     |   14 +++++++++-----
 scripts/mod/file2alias.c |    1 +
 4 files changed, 20 insertions(+), 11 deletions(-)

Anssi Hannula (1):
      HID: move tmff and zpff devices from ignore_list to blacklist

Dan Carpenter (1):
      HID: unlock properly on error paths in hidraw_ioctl()

Jiri Slaby (1):
      HID: fix bus endianity in file2alias

Michael Tokarev (1):
      HID: blacklist Powercom USB UPS

