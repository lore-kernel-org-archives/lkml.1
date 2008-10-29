Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYJ2Wmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYJ2Wmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYJ2WmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:42:04 -0400
Received: from kroah.org ([198.145.64.141]:43723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754037AbYJ2WmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:42:01 -0400
Date: Wed, 29 Oct 2008 15:38:24 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for your 2.6-git tree
Message-ID: <20081029223824.GB21657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 6 patches for your 2.6-git tree.

They contain:
	- 4 documentation updates:
		- ja_JP/HOWTO update
		- stable_kernel_rules.txt update
		- document the taint flags properly
		- fix some function comments in drivers/base/sys.c that
		  were incorrect.
	- bugfix for the dynamic_printk command line option
	- bugfix for the sysdev code

All of these have been in the -next trees and the -mm releases for a
while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/ja_JP/HOWTO             |   14 +++++++-------
 Documentation/stable_kernel_rules.txt |    1 +
 Documentation/sysctl/kernel.txt       |   24 +++++++++++++++++-------
 drivers/base/sys.c                    |   10 ++++++----
 lib/dynamic_printk.c                  |    4 +++-
 5 files changed, 34 insertions(+), 19 deletions(-)

---------------

Andi Kleen (1):
      sysfs: Fix return values for sysdev_store_{ulong,int}

Greg Kroah-Hartman (1):
      Document kernel taint flags properly

Jason Baron (1):
      Driver core: fix 'dynamic_debug' cmd line parameter

Josh Boyer (1):
      Update stable tree documentation

Qinghuang Feng (1):
      driver core: drivers/base/sys.c: update comments

Tsugikazu Shibata (1):
      HOWTO: Sync patch for jp_JP/HOWTO

