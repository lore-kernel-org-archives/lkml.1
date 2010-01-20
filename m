Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942Ab0ATXtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0ATXtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0ATXtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:49:01 -0500
Received: from kroah.org ([198.145.64.141]:33552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0ATXs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:48:56 -0500
Date: Wed, 20 Jan 2010 15:47:53 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.33-rc4
Message-ID: <20100120234753.GB32068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two 2.6.33-rc4 patches for the driver core:

They fix:
	- s390 boot oops with devtmpfs
	- revert a patch that was sent by Andrew that should not have
	  been merged into your tree yet as the api has not changed in
	  your tree, it is coming in the .34 merge.  This fixes a build
	  error in your current tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/devtmpfs.c |    3 ++-
 drivers/base/memory.c   |   32 ++++++++++++--------------------
 2 files changed, 14 insertions(+), 21 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Revert "sysdev: fix prototype for memory_sysdev_class show/store functions"

Heiko Carstens (1):
      driver-core: fix devtmpfs crash on s390

