Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZLARrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZLARrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZLARrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:47:35 -0500
Received: from kroah.org ([198.145.64.141]:58557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZLARrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:47:11 -0500
Date: Tue, 1 Dec 2009 09:43:41 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.32-git
Message-ID: <20091201174341.GB31972@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 tty bugfixs for your kernel tree.  One fixes a regression
from 2.6.30, one fixes a build error, and the last one adds a new device
id.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

Both of these patches have been in the -next and -mm trees for a while.

Both patches will be sent to the linux-kernel mailing list, if anyone
wants to see it.

thanks,

greg k-h

------------

 drivers/char/tty_port.c       |    7 +++++--
 drivers/serial/bcm63xx_uart.c |    4 ++--
 drivers/serial/of_serial.c    |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

---------------

Alan Cox (1):
      tty_port: handle the nonblocking open of a dead port corner case

Maxime Bizon (1):
      bcm63xx_uart: Fix serial driver compile breakage.

Michal Simek (1):
      tty/of_serial: add missing ns16550a id

