Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXDKRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXDKRsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXDKRsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:48:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34696 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXDKRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:48:18 -0400
Date: Wed, 11 Apr 2007 10:47:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.21-rc6
Message-ID: <20070411174739.GA26961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against 2.6.21-rc6.

They fix a reported regression with the ehci driver, and allow a new
device to work properly with the usb-storage driver.

The usb-storage patch has been in the -mm releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h

 drivers/usb/host/ehci-hcd.c        |    1 +
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

---------------

Alan Stern (1):
      EHCI: fix remote wakeup regression in 2.6.21-rc

Emil Larsson (1):
      USB: Nikon D80 unusual device patch

