Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZJLXTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZJLXTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZJLXTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:19:42 -0400
Received: from kroah.org ([198.145.64.141]:35912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbZJLXTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:19:36 -0400
Date: Mon, 12 Oct 2009 16:15:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.37
Message-ID: <20091012231554.GC23794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.37 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.35 and 2.6.27.36

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 -
 arch/x86/ia32/ia32entry.S  |   56 ++++++++++++++++++++++++---------------------
 arch/x86/kvm/x86.c         |    6 ++++
 arch/x86/mm/mmap.c         |   17 ++++++++++++-
 drivers/net/iseries_veth.c |    2 -
 drivers/watchdog/hpwdt.c   |   15 +++++-------
 fs/ecryptfs/inode.c        |    2 +
 include/asm-x86/elf.h      |    2 +
 include/linux/kvm_para.h   |    1 
 kernel/time/timekeeping.c  |   22 +++++++++++++++++
 10 files changed, 87 insertions(+), 38 deletions(-)

Greg Kroah-Hartman (1):
      Linux 2.6.27.37

Jan Beulich (2):
      x86-64: slightly stream-line 32-bit syscall entry code
      x86: Don't leak 64-bit kernel register values to 32-bit processes

Jan Kiszka (1):
      KVM: x86: Disallow hypercalls for guest callers in rings > 0 [CVE-2009-3290]

Jean Delvare (1):
      net: Fix wrong sizeof

John Stultz (1):
      time: catch xtime_nsec underflows and fix them

Michal Hocko (1):
      x86: Increase MIN_GAP to include randomized stack

Thomas Mingarelli (1):
      hpwdt.c: Add new HP BMC controller.

Tyler Hicks (1):
      eCryptfs: Prevent lower dentry from going negative during unlink (CVE-2009-2908)

