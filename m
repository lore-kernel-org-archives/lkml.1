Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYKHFqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYKHFqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 00:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYKHFpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 00:45:54 -0500
Received: from kroah.org ([198.145.64.141]:37130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752294AbYKHFpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 00:45:53 -0500
Date: Fri, 7 Nov 2008 21:45:11 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING fixes for 2.6.28
Message-ID: <20081108054511.GA28846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two small Kconfig staging patches against your 2.6 git tree.

They fix a Kconfig dependancy on the USB/IP drivers that Randy Dunlap
found, and they add a second Kconfig option, which enables the staging
drivers to be automatically excluded from a 'make allmodconfig' or 'make
allyesconfig' build.  This last patch will help out the -next tree a lot
in its automatic build tests.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 drivers/staging/Kconfig       |   20 ++++++++++++++++++--
 drivers/staging/usbip/Kconfig |    2 +-
 2 files changed, 19 insertions(+), 3 deletions(-)

---------------

Greg Kroah-Hartman (2):
      Staging: only build the tree if we really want to
      Staging: make usbip depend on CONFIG_NET

