Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbZEFW2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbZEFW2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZEFW1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:27:50 -0400
Received: from kroah.org ([198.145.64.141]:55566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZEFW1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:27:49 -0400
Date: Wed, 6 May 2009 15:24:39 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.82 release
Message-ID: <20090506222439.GB22327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.82 release of usbutils.

Many bugs with autoconf were resolved to hopefully make it easier for
distros to find where the usb.ids file is dynamically.  Wireless USB
device support was added, as well as other bugfixes.  The full shortlog
is below.

The tarballs can be downloaded from sf.net at:
	https://sourceforge.net/project/showfiles.php?group_id=3581

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Shortlog of changes since last release (0.81):


Aurelien Jarno (3):
      lsusb: fix parsing of /proc/bus/usb/devices
      lsusb(8): also suggests usbview(8)
      lsusb(8): explain that -t option overrides -v

Greg Kroah-Hartman (1):
      fix merge error that I missed.

Kay Sievers (5):
      configure: default to /usr
      substitute usb.id location in man page and update script
      use DISTCLEANFILES and 'g' for 'sed'
      add usbutils.pc file to point to database file
      add usbutils.pc to .gitignore

Mike Frysinger (3):
      configure: use AC_MSG_RESULT() rather than echo
      fix handling of usb.ids.gz in the Makefile.am
      add update-usbids.sh to EXTRA_DIST

王神 (1):
      lsusb: add WUSB definitions and descriptor dumping

