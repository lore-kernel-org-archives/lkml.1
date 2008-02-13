Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYBMG56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYBMG56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYBMG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:57:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60344 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYBMG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:57:46 -0500
Date: Tue, 12 Feb 2008 23:02:15 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080213070215.GA11969@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the big "linux-next" series of emails, David Miller suggested that
the feature-removal-schedule file be broken up into little pieces, as it
is causing merge problems for different trees.

This changeset does just that.  Turns out that this makes things more
readable, as it's easier to look at a list of filenames for things than
picking through a 300 line text file.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

thanks,

greg k-h

--------

 Documentation/feature-removal-schedule.txt                                        |  308 ----------
 Documentation/feature-removal-schedule/README                                     |   16 
 Documentation/feature-removal-schedule/acpi-procfs                                |    6 
 Documentation/feature-removal-schedule/b43_support_for_old_firmware               |    6 
 Documentation/feature-removal-schedule/bcm43xx-wireless-driver                    |    6 
 Documentation/feature-removal-schedule/dev-power.power_state                      |   10 
 Documentation/feature-removal-schedule/eepro100-driver                            |    4 
 Documentation/feature-removal-schedule/i2c-i810_i2c-prosavage_i2c-savage4_drivers |    4 
 Documentation/feature-removal-schedule/i386-x86_65-bzImage-symlinks               |    7 
 Documentation/feature-removal-schedule/ieee80211-softmac                          |    5 
 Documentation/feature-removal-schedule/kernel_thread_EXPORT_SYMBOL                |    9 
 Documentation/feature-removal-schedule/libata-spindown-warning                    |   15 
 Documentation/feature-removal-schedule/netfilter-rules                            |   29 
 Documentation/feature-removal-schedule/old_ncr54c9_driver                         |    6 
 Documentation/feature-removal-schedule/pcmcia-control-ioctl                       |   14 
 Documentation/feature-removal-schedule/ppc-arch-include-directories               |   10 
 Documentation/feature-removal-schedule/proc-acpi-button                           |    5 
 Documentation/feature-removal-schedule/proc-acpi-event                            |    5 
 Documentation/feature-removal-schedule/rc80211-simple-rate-control-for-mac80211   |    7 
 Documentation/feature-removal-schedule/sk98lin-driver                             |    5 
 Documentation/feature-removal-schedule/solaris_syscall_support                    |    8 
 Documentation/feature-removal-schedule/sys_sysctl                                 |   32 +
 Documentation/feature-removal-schedule/uevent_PHYSDEV                             |    7 
 Documentation/feature-removal-schedule/unused_EXPORT_SYMBOL_exports               |    7 
 Documentation/feature-removal-schedule/vfl1-ioctls                                |   16 
 Documentation/feature-removal-schedule/vm_ops.nopage                              |    6 
 26 files changed, 245 insertions(+), 308 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Split up feature-removal-schedule.txt into individual files.

