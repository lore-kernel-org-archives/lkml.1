Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYCKAnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYCKAnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYCKAmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:42:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:58577 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYCKAmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:42:53 -0400
Date: Mon, 10 Mar 2008 17:42:19 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes against 2.6.25-rc5 git
Message-ID: <20080311004219.GA17890@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 4 fixes fixes against your current git tree that fix some more
problems that have cropped up:
	- nozomi driver fixes for oopses found by users
	- resource calculation problem found by the scsi people
	- sysdev fixes for oopses for kvm and ooprofile code
	- firmware.h gets stubs for when the config option is not
	  enabled, fixing build errors.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/platform.c  |    2 +-
 drivers/base/sys.c       |    4 +++
 drivers/char/nozomi.c    |   61 ++++++++++++++++++++++++++++++++-------------
 include/linux/firmware.h |   23 +++++++++++++++++
 4 files changed, 71 insertions(+), 19 deletions(-)

---------------

Frank Seidel (1):
      nozomi: fix initialization and early flow control access

Greg Kroah-Hartman (1):
      sysdev: fix problem with sysdev_class being re-registered

James Bottomley (2):
      firmware: provide stubs for the FW_LOADER=n case
      drivers: fix dma_get_required_mask

