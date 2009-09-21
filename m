Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZIUOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZIUOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZIUOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:40:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZIUOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:40:45 -0400
Date: Mon, 21 Sep 2009 16:40:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes
Message-ID: <alpine.LNX.2.00.0909211506130.17028@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive second round of updates for .32 merge window. Thanks!

 drivers/hid/Kconfig           |    7 -------
 drivers/hid/hid-core.c        |   14 ++++++++++++--
 drivers/hid/usbhid/hid-core.c |   16 +++++-----------
 include/linux/hid.h           |    3 +++
 net/bluetooth/hidp/core.c     |    7 -------
 5 files changed, 20 insertions(+), 27 deletions(-)

Alessandro Guido (1):
      HID: Remove duplicate Kconfig entry

Jiri Kosina (2):
      HID: fix non-atomic allocation in hid_input_report
      HID: consolidate connect and disconnect into core code

