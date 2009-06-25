Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZFYRfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZFYRfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZFYRew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:34:52 -0400
Received: from kroah.org ([198.145.64.141]:47177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZFYRew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:34:52 -0400
Date: Thu, 25 Jun 2009 10:30:39 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.84 release
Message-ID: <20090625173039.GA4750@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.84 release of usbutils.

A bug in the 0.82 release concerning HID descriptors has been fixed
(hopefully), and a new script 'usb-devices' has been added.

Also a big sync of the usb.ids file has happened.

Many thanks to Frans Pop for cleaning up the usb-devices script and
providing a man page for it.

The tarballs can be downloaded from sf.net at:
	https://sourceforge.net/project/showfiles.php?group_id=3581

Or directly from kernel.org now:
	http://www.kernel.org/pub/linux/utils/usb/usbutils/

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Shortlog of changes since last release (0.82):


Greg Kroah-Hartman (8):
      new Audio Gadget id for the Linux Foundation vendor id.
      usb-devices:  add script and man page.
      add usb-devices.8 to the build properly
      0.83 release
      make distclean fix
      sync up with a lot of usb.ids changes.
      more usb.ids updates

Stephane Chatty (2):
      fix HID descriptor dumps that were previously broken
      usb.ids: added new Digitizer usages for multitouch devices

