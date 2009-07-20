Return-Path: <linux-kernel-owner+w=401wt.eu-S1750933AbZGTEK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933AbZGTEK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 00:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZGTEK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 00:10:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:42116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZGTEK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 00:10:26 -0400
Date: Sun, 19 Jul 2009 21:06:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.27
Message-ID: <20090720040655.GA11940@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.26 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.26 and 2.6.27.27

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    7 ++-
 drivers/block/floppy.c        |    5 ++
 drivers/md/dm.c               |    4 --
 drivers/net/tulip/interrupt.c |   84 +++++++++++++++++++++++++++---------------
 drivers/net/tulip/tulip.h     |   32 +++++++++++++++-
 drivers/pci/iova.c            |   26 +++++++++++--
 include/linux/mm.h            |    2 -
 include/linux/personality.h   |    5 ++
 include/linux/security.h      |    2 +
 kernel/resource.c             |    2 -
 kernel/sysctl.c               |    2 -
 mm/Kconfig                    |   18 +++++++++
 mm/mmap.c                     |    3 +
 security/Kconfig              |   22 -----------
 security/security.c           |    3 -
 15 files changed, 145 insertions(+), 72 deletions(-)

Christoph Lameter (1):
      security: use mmap_min_addr indepedently of security models

David Woodhouse (1):
      Fix iommu address space allocation

Eugene Teo (1):
      Add '-fno-delete-null-pointer-checks' to gcc CFLAGS

Greg Kroah-Hartman (2):
      Revert "dm: sysfs skip output when device is being destroyed"
      Linux 2.6.27.27

Jiri Slaby (1):
      floppy: fix lock imbalance

Julien Tinnes (1):
      personality: fix PER_CLEAR_ON_SETID (CVE-2009-1895)

Linus Torvalds (1):
      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x

Tomasz Lemiech (1):
      tulip: Fix for MTU problems with 802.1q tagged frames

Zhang Rui (1):
      kernel/resource.c: fix sign extension in reserve_setup()

