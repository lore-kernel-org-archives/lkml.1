Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbZB0Wsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbZB0Wsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZB0Wr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:47:59 -0500
Received: from kroah.org ([198.145.64.141]:50782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871AbZB0Wr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:47:57 -0500
Date: Fri, 27 Feb 2009 14:45:55 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20090227224555.GB19545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tiny staging patches that fix some bugs and oopses that
people have reported, as well as a Kconfig dependancy fix that is
needed.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these have been in the -next releases with no known build errors.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

--------------


 drivers/staging/panel/panel.c                      |   23 ++++++++++---------
 drivers/staging/rtl8187se/Kconfig                  |    1 +
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |   19 ++++++++-------
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 drivers/staging/winbond/wbusb.c                    |   20 +++++++++++------
 5 files changed, 37 insertions(+), 28 deletions(-)

---------------

Costantino Leandro (1):
      Staging: panel: fix oops on panel_cleanup_module

Pavel Machek (1):
      Staging: w35und: fix registration with wlan stack

Pekka Enberg (1):
      Staging: w35und: fix usb_control_msg() error handling in wb35_probe()

Randy Dunlap (1):
      Staging: rtl8187se: fix Kconfig dependencies

leandro Costantino (1):
      Staging: rtl8187se: Fix oops and memory poison caused by builtin ieee80211.

