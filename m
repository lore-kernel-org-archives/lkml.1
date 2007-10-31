Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXJaTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXJaTyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXJaTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:54:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXJaTyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:54:44 -0400
Date: Wed, 31 Oct 2007 12:54:02 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fix for previous 2.6.24-rc1 pull
Message-ID: <20071031195402.GA16583@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I messed up with my previous set of driver core fixes and sent a patch
that removed some functions that the ia64 arch still uses.

I've now reverted that patch, sorry about that.

Thanks to Tony Luck for pointing out my mistake.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

thanks,

greg k-h


 drivers/base/class.c   |   18 ++++++++++++++++++
 include/linux/device.h |    4 ++++
 2 files changed, 22 insertions(+), 0 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Revert "Driver core: remove class_device_*_bin_file"

