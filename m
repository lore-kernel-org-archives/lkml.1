Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZHQWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZHQWhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZHQWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:37:46 -0400
Received: from kroah.org ([198.145.64.141]:35477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZHQWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:37:45 -0400
Date: Mon, 17 Aug 2009 15:36:26 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.86 release
Message-ID: <20090817223626.GA5826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.86 release of usbutils.

There's a few minor fixups for the usb-devices script, as well as a
patch to help make fetching HID descriptors a bit more robust.

And a number of build configuration fixes as well.

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

Shortlog of changes since last release (0.84):


Aurelien Jarno (2):
      usb-devices: move from /usr/sbin to /usr/bin
      usb-devices: fix parsing of bcdDevice

Frans Pop (2):
      usb-devices: harmonize class descriptions with usb/devices file
      lsusb(8): make version variable and update date of last modification

Greg Kroah-Hartman (6):
      update .gitignore to ignore .bz2 and .gz files
      remove a lot of wireless driver names from usb.ids file
      .gitignore update
      build fix now that usb-devices man page has moved
      usbutils 0.85 release
      usbutils 0.86 release

Kay Sievers (2):
      configure.ac: use AM_SILENT_RULES if available
      usbutils.pc: place non arch dependent .pc file in /usr/share/pkgconfig/

Stéphane Chatty (1):
      make HID devices a bit more robust

