Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbXAaAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbXAaAFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXAaAFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:05:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:44645 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbXAaAFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:05:31 -0500
Date: Wed, 31 Jan 2007 01:05:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID update for 2.6.20-rc6
Message-ID: <Pine.LNX.4.64.0701310101190.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

could you please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
or
        master.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive trivial fixes for HID core layer for 2.6.20-rc6. Thanks.

 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-input.c      |   13 ++++++++++---
 drivers/usb/input/hid-core.c |   12 ------------
 include/linux/hid.h          |    1 -
 4 files changed, 11 insertions(+), 16 deletions(-)

Jiri Kosina (3):
      HID: fix memleaking of collection
      USB HID: fix hid_blacklist clash for 0x08ca/0x0010
      HID: fix pb_fnmode and move it to generic HID

Simon Bennett (1):
      HID: fix hid-input mapping for Firefly Mini Remote Control

