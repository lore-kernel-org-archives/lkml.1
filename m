Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbZHDVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbZHDVJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZHDVJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:09:31 -0400
Received: from kroah.org ([198.145.64.141]:46656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZHDVJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:09:29 -0400
Date: Tue, 4 Aug 2009 14:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.31-rc5-git
Message-ID: <20090804210829.GA26166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some the TTY ldisc patches for your kernel tree.

As you wrote these, I think you know what they fix :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

The full patches will be sent to the linux-kernel mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/char/tty_ldisc.c  |  152 ++++++++++++++++-----------------------------
 include/linux/tty_ldisc.h |    2 +-
 2 files changed, 54 insertions(+), 100 deletions(-)

---------------

Linus Torvalds (3):
      tty-ldisc: make refcount be atomic_t 'users' count
      tty-ldisc: turn ldisc user count into a proper refcount
      tty-ldisc: be more careful in 'put_ldisc' locking

