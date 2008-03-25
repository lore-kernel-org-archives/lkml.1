Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYCYGG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYCYGG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbYCYGGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:06:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:44979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbYCYGGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:06:34 -0400
Date: Mon, 24 Mar 2008 23:05:03 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes against 2.6.25-rc6 git
Message-ID: <20080325060503.GB20741@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 patches against your current git tree that do:
	- fix UIO to work properly on ARM and other platforms
	- remove BUG in sysfs and add better debugging for attributes
	  that overflow the buffer provided by sysfs.  Andrew asked that
	  this patch go in now to help people out.

Both of these patches have been in -next and -mm for quite a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/


Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/core.c |    5 +++++
 drivers/uio/uio.c   |    2 ++
 fs/sysfs/file.c     |    8 +++++++-
 3 files changed, 14 insertions(+), 1 deletions(-)

---------------

Andrew Morton (1):
      driver core: debug for bad dev_attr_show() return value.

Jean-Samuel Chenard (1):
      UIO: add pgprot_noncached() to UIO mmap code

