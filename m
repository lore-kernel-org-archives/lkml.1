Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZKRBEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZKRBEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZKRBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:03:59 -0500
Received: from kroah.org ([198.145.64.141]:38454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZKRBD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:03:58 -0500
Date: Tue, 17 Nov 2009 17:00:47 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.32-git
Message-ID: <20091118010047.GA16719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 tty bugfixs for your kernel tree.  It fixes a regression that
showed up in 2.6.31 with the cp210x driver.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

Both of these patches have been in the -next and -mm trees for a while.

Both patches will be sent to the linux-kernel mailing list, if anyone
wants to see it.

thanks,

greg k-h

------------

 drivers/char/tty_port.c     |    3 +++
 drivers/usb/serial/cp210x.c |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

---------------

Alan Cox (2):
      tty_port: If we are opened non blocking we still need to raise the carrier
      tty: cp210x: Fix carrier handling

