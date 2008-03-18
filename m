Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYCRNHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYCRNHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCRNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:07:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:48435 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752581AbYCRNHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:07:03 -0400
Date: Tue, 18 Mar 2008 14:07:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID updates for 2.6.25-rc6
Message-ID: <Pine.LNX.4.64.0803181149450.30831@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive a few simple fixes for 2.6.25-rc6 HID code. Michael's one is 
important to have before 2.6.25, so that we don't have to confuse users in 
the future.
Thanks.

 drivers/hid/hid-core.c          |    2 +-
 drivers/hid/hid-input.c         |   22 ++++++++++------------
 drivers/hid/usbhid/hid-core.c   |    2 +-
 drivers/hid/usbhid/hid-quirks.c |    6 +++++-
 4 files changed, 17 insertions(+), 15 deletions(-)

Andrew Burton (1):
      HID: BADPAD entry for NATSU Playstation USB adapter

Jiri Kosina (1):
      HID: fix comment in hid_input_report()

Julia Lawall (1):
      HID: Use DIV_ROUND_UP

Michael Hanselmann (1):
      HID: update key codes for Apple aluminium

Tobias Mueller (1):
      HID: remove HID_QUIRK_APPLE_ISO_KEYBOARD for 4th generation macbook
