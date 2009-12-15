Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZLOP4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZLOP4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZLOP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:56:48 -0500
Received: from kroah.org ([198.145.64.141]:39975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbZLOP4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:56:47 -0500
Date: Tue, 15 Dec 2009 07:56:25 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB printer fix for 2.6.33-git
Message-ID: <20091215155625.GA3394@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the revert, and fix, for the USB printer issue you found.

Note, when I tested this, I couldn't get it to work at all, with the
original patch applied, or reverted.  Turns out that this is an issue
with my system and CUPS, it wanted the usblp driver to not be loaded at
all in order for it to print to my printer, which is something new to
me, and I'll need to figure that out later.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/usb.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Revert "USB: Close usb_find_interface race"

Russ Dill (1):
      USB: Close usb_find_interface race v3

