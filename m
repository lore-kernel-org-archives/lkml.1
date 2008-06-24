Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYFXV3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYFXV3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYFXV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:28:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYFXV24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:28:56 -0400
Date: Tue, 24 Jun 2008 14:26:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.9
Message-ID: <20080624212638.GA31109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.9 kernel.

It contains a number of assorted bugfixes all over the tree.  Any users
of the 2.6.25 kernel series are STRONGLY encouraged to upgrade!

I'll also be replying to this message with a copy of the patch between
2.6.25.8 and 2.6.25.9

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                   |    2 
 arch/powerpc/kernel/vdso.c |    2 
 arch/x86/kernel/setup_32.c |   10 ++
 drivers/hwmon/adt7473.c    |    3 
 drivers/hwmon/lm85.c       |    2 
 drivers/net/atl1/atl1_hw.c |    1 
 drivers/watchdog/hpwdt.c   |  154 +++++++++++++++++++++++----------------------
 include/asm-x86/page_32.h  |    3 
 include/linux/bootmem.h    |    2 
 mm/bootmem.c               |    4 -
 mm/memory.c                |   41 +++++++++--
 mm/migrate.c               |   10 ++
 net/sctp/socket.c          |    4 -
 13 files changed, 145 insertions(+), 93 deletions(-)

Bernhard Walle (2):
      Add return value to reserve_bootmem_node()
      x86: use BOOTMEM_EXCLUSIVE on 32-bit

David S. Miller (1):
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow.

Greg Kroah-Hartman (1):
      Linux 2.6.25.9

Jean Delvare (2):
      hwmon: (lm85) Fix function RANGE_TO_REG()
      hwmon: (adt7473) Initialize max_duty_at_overheat before use

Jeremy Fitzhardinge (1):
      x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.

Linus Torvalds (3):
      Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix XIP
      watchdog: hpwdt: fix use of inline assembly
      Fix ZERO_PAGE breakage with vmware

Radu Cristescu (1):
      atl1: relax eeprom mac address error check

