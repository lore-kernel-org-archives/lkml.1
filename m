Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711Ab0ATXtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0ATXtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237Ab0ATXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:49:04 -0500
Received: from kroah.org ([198.145.64.141]:33553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0ATXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:48:59 -0500
Date: Wed, 20 Jan 2010 15:47:59 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.33-rc4
Message-ID: <20100120234759.GC32068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big TTY patchset for your .33-rc4 tree.

Lots of bugfixes and a new device id was added.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/nozomi.c        |    2 +-
 drivers/char/tty_io.c        |    2 +-
 drivers/serial/8250_pnp.c    |   10 +----
 drivers/serial/imx.c         |    2 +-
 drivers/serial/serial_core.c |  105 ++++++++++++++++++------------------------
 drivers/serial/serial_cs.c   |    3 +-
 fs/compat_ioctl.c            |    3 +
 7 files changed, 54 insertions(+), 73 deletions(-)

---------------

Alan Cox (2):
      nozomi: quick fix for the close/close bug
      serial: Fix crash if the minimum rate of the device is > 9600 baud

Atsushi Nemoto (1):
      compat_ioctl: Supress "unknown cmd" message on serial /dev/console

Greg Kroah-Hartman (1):
      tty: fix race in tty_fasync

Matthew Garrett (1):
      serial: 8250_pnp: use wildcard for serial Wacom tablets

Pavel Machek (1):
      serial: serial_cs: oxsemi quirk breaks resume

Roel Kluin (1):
      serial: imx: bit &/| confusion

Stanislav Brabec (1):
      serial-core: resume serial hardware with no_console_suspend

