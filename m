Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZELWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZELWxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZELWxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:53:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZELWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:53:07 -0400
Date: Wed, 13 May 2009 00:53:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.30-rc5
Message-ID: <alpine.LNX.2.00.0905130051210.22712@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive hopefully last pile of fixes for HID code before 2.6.30.
It contains fixes that influence only a few particular device IDs.

Thanks!

 drivers/hid/hid-ids.h           |    5 +++++
 drivers/hid/usbhid/hid-core.c   |    2 +-
 drivers/hid/usbhid/hid-quirks.c |    3 +++
 3 files changed, 9 insertions(+), 1 deletions(-)

Alan Stern (1):
      HID: add NOGET quirk for devices from CH Products

Zoltan Karcagi (1):
      HID: fix dropped device-specific quirks

