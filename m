Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752252AbYLQT2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYLQT2z (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLQT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:28:43 -0500
Received: from kroah.org ([198.145.64.141]:54227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761AbYLQT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:28:43 -0500
Date: Wed, 17 Dec 2008 11:27:37 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for your 2.6-git tree
Message-ID: <20081217192737.GA24641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 4 patches for your 2.6-git tree.

They contain:
	- licensing fix for the xilinx_hwicap drivers (signed off by the
	  original authors)
	- 2 dynamic debug printk fixes
	- staging Kconfig fix

All of these have been in the -next trees and the -mm releases for a
while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/char/xilinx_hwicap/buffer_icap.c   |    3 ---
 drivers/char/xilinx_hwicap/buffer_icap.h   |    3 ---
 drivers/char/xilinx_hwicap/fifo_icap.c     |    3 ---
 drivers/char/xilinx_hwicap/fifo_icap.h     |    3 ---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    3 ---
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |    3 ---
 drivers/staging/Kconfig                    |    3 +++
 lib/dynamic_printk.c                       |    6 +++---
 8 files changed, 6 insertions(+), 21 deletions(-)

---------------

Dmitry Baryshkov (1):
      STAGING: Move staging drivers back to staging-specific menu

Greg Kroah-Hartman (1):
      xilinx_hwicap: remove improper wording in license statement

Johann Felix Soden (1):
      driver core: fix using 'ret' variable in unregister_dynamic_debug_module

Marcel Holtmann (1):
      driver core: add newlines to debugging enabled/disabled messages

