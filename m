Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZBITeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZBITeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZBITdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:33:41 -0500
Received: from kroah.org ([198.145.64.141]:44445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752568AbZBITdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:33:40 -0500
Date: Mon, 9 Feb 2009 11:32:01 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20090209193201.GB2194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tiny staging patches fixing some build errors and Kconfig
problems that people have reported.

And there's also a big patch in here that is a revert of a patch that
went into 2.6.29-rc1 for the at76_usb driver.  The linux-wireless
developers asked that I revert it as it is conflicting with some work
that they are currently doing.  The revert wasn't a straight git-revert
due to patches that had been made afterward, hence the by-hand revert.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these have been in the -next releases with no known build errors.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

--------------

 drivers/staging/android/Kconfig       |    1 +
 drivers/staging/android/ram_console.c |   14 +
 drivers/staging/android/timed_gpio.c  |    2 +-
 drivers/staging/at76_usb/Kconfig      |    2 +-
 drivers/staging/at76_usb/at76_usb.c   | 4620 ++++++++++++++++++++++++++-------
 drivers/staging/at76_usb/at76_usb.h   |  227 ++-
 drivers/staging/panel/panel.c         |   10 +-
 7 files changed, 3903 insertions(+), 973 deletions(-)

---------------

Arve Hjønnevåg (1):
      Staging: android: ram_console: Disable ECC when early init is enabled and validate buffer size

Greg Kroah-Hartman (2):
      Revert Staging: at76_usb: update drivers/staging/at76_usb w/ mac80211 port
      Staging: android: fix up units in timed_gpio

Jamie Lentin (1):
      Staging: at76_usb: Add support for OQO Model 01+

Jason Andryuk (1):
      Staging: at76_usb: fix bugs introduced by "Staging: at76_usb: cleanup dma on stack issues"

Sachin P. Sant (1):
      Staging: panel: fix lcd panel driver build failure

