Return-Path: <linux-kernel-owner+w=401wt.eu-S965535AbXCFSSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535AbXCFSSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965524AbXCFSSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:18:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:46635 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965538AbXCFSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:18:35 -0500
Date: Tue, 6 Mar 2007 19:20:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID and USB HID updates for 2.6.21-rc2
Message-ID: <Pine.LNX.4.64.0703061916550.10121@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID core layer and USB HID layer. 

This update is needed to make the IOWarrior device driver (that got merged 
during merge 2.6.21 merge window) to work, as it is needed to blacklist it 
from being claimed by generic HID driver.

Thanks.

 drivers/usb/input/hid-core.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

Robert Marquardt (1):
      HID blacklisting of all Code Mercenaries IOWarrior devices
