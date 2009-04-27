Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZD0U2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZD0U2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZD0U2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:28:06 -0400
Received: from kroah.org ([198.145.64.141]:45404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZD0U2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:28:05 -0400
Date: Mon, 27 Apr 2009 12:35:32 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.81 release
Message-ID: <20090427193532.GA2948@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After over a year since the last release, I'd like to announce the
release of usbutils 0.81.  It can be found at the traditionally horrible
sf.net download page:
	https://sourceforge.net/project/showfiles.php?group_id=3581

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

I've pushed all patches that were in the Gentoo and SuSE usbutils trees
into this release.  If there are outstanding patches from other distros,
I'd be very interested in getting them integrated in.

thanks,

greg k-h

-----------

Shortlog of changes since last release (0.73):


Bjørn Mork (1):
      usbutils: Adding support for Device Firmware Upgrade functional descriptors

David Brownell (9):
      Update ChangeLog Ran autoreconf (for version 0.73).
      Make "update-usbids.sh" work better from cronjobs; update usb.ids
      Build on FreeBSD
      Use autotools for FreeBSD support; autoreconf. Grab the latest usb.ids file.
      use AC_C_BIGENDIAN, update usb.ids, minor layout fix, autoreconf
      refresh usb.ids
      Add libusb compat code
      refresh usb.ids
      add attribution omitted from a few years back

Greg Kroah-Hartman (12):
      added .gitignore
      update usb.ids based on Stephen's latest version
      fix compile warning in lsusb.c
      fix compile warning in usbmisc.c
      update .gitignore
      Add PTP gadget id for the Linux Foundation vendor id.
      Note in the ChangeLog to look at the git changelog instead.
      fix patch corruption in DFU patch
      lsusb: make strtoul to use base 10
      lsusb: make -t option work if proc file is not present.
      lsusb.8 - remove old comments and /proc/bus/usb lines
      0.81 release

Kay Sievers (11):
      rename configure.in -> configure.ac
      delete spec file
      delete generated autotools file
      update usb.ids
      clean up autotools files
      remove autotools cache on distclean
      bump version to 0.80 to pass "make distcheck"
      fix wrong copy-pasted mail address
      remove obsolete usbmodules
      delete .cvsignore
      /proc/bus/usb -> /dev/bus/usb


