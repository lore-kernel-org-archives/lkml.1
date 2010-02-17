Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab0BQADH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:03:07 -0500
Received: from kroah.org ([198.145.64.141]:38515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644Ab0BQACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:02:43 -0500
Date: Tue, 16 Feb 2010 16:02:17 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fix for 2.6.33-rc8
Message-ID: <20100217000217.GC31137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one serial bugfix for your .33-rc8 tree.  It fixes an
oft-reported problem with the 8250 driver.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

This patch has been in the linux-next and -mm releases for a number of
weeks now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/serial/8250.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

---------------

Dick Hollenbeck (1):
      serial: 8250: add serial transmitter fully empty test

