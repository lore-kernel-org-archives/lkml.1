Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYHFR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYHFR7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYHFR6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:58:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:37500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbYHFR6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:58:47 -0400
Date: Wed, 6 Aug 2008 10:55:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.2
Message-ID: <20080806175529.GB27119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.2
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.26
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.26.1 and 2.6.26.2

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

-------------

 Documentation/ftrace.txt              | 1353 ----------------------------------
 Makefile                              |    2 
 arch/powerpc/kernel/ppc32.h           |    2 
 arch/powerpc/kernel/ptrace32.c        |   27 
 arch/x86/kernel/io_delay.c            |    3 
 arch/x86/kernel/kprobes.c             |    1 
 arch/x86/kernel/process.c             |    3 
 block/bsg.c                           |    9 
 drivers/input/serio/i8042-x86ia64io.h |   43 -
 drivers/md/linear.c                   |    2 
 drivers/md/md.c                       |    2 
 drivers/net/wireless/ath5k/base.c     |   35 
 drivers/net/wireless/ath5k/base.h     |    2 
 drivers/scsi/ch.c                     |    1 
 fs/jbd/transaction.c                  |   57 +
 fs/namei.c                            |   19 
 fs/nfs/inode.c                        |    4 
 fs/nfs/internal.h                     |    1 
 fs/nfs/nfs3acl.c                      |    9 
 fs/nfs/nfs4proc.c                     |    5 
 fs/romfs/inode.c                      |   37 
 include/sound/emu10k1.h               |    1 
 mm/filemap.c                          |    3 
 net/bluetooth/bnep/core.c             |    5 
 net/bluetooth/hidp/core.c             |   10 
 net/ipv4/netfilter/nf_nat_sip.c       |   38 
 net/netfilter/xt_time.c               |    2 
 sound/core/seq/oss/seq_oss_synth.c    |    3 
 sound/pci/emu10k1/emu10k1_main.c      |    1 
 sound/pci/emu10k1/emumixer.c          |   13 
 sound/pci/hda/hda_intel.c             |  124 ++-
 sound/pci/hda/patch_analog.c          |   33 
 32 files changed, 398 insertions(+), 1452 deletions(-)

Andreas Schwab (1):
      Add compat handler for PTRACE_GETSIGINFO

Cyrill Gorcunov (2):
      x86: idle process - add checking for NULL early param
      x86: io delay - add checking for NULL early param

David Howells (1):
      netfilter: xt_time: fix time's time_mt()'s use of do_div()

FUJITA Tomonori (2):
      SCSI: bsg: fix bsg_mutex hang with device removal
      SCSI: ch: fix ch_remove oops

Greg Kroah-Hartman (2):
      ftrace: remove unneeded documentation
      Linux 2.6.26.2

Herbert Xu (1):
      netfilter: nf_nat_sip: c= is optional for session

Jiri Kosina (3):
      Input: i8042 - add Intel D845PESV to nopnp list
      Input: i8042 - add Gericom Bellagio to nomux blacklist
      Input: i8042 - add Acer Aspire 1360 to nomux blacklist

Jiri Slaby (2):
      Ath5k: fix memory corruption
      Ath5k: kill tasklets on shutdown

Linus Torvalds (1):
      romfs_readpage: don't report errors for pages beyond i_size

Marcel Holtmann (1):
      Bluetooth: Signal user-space for HIDP and BNEP socket errors

Miklos Szeredi (1):
      vfs: fix lookup on deleted directory

Mingming Cao (1):
      jbd: fix race between free buffer and commit transaction

Neil Brown (1):
      Close race in md_probe

Nikanth Karthikesan (1):
      linear: correct disk numbering error check

Peter Zijlstra (1):
      Kprobe smoke test lockdep warning

Takashi Iwai (4):
      ALSA: hda - Fix wrong volumes in AD1988 auto-probe mode
      ALSA: hda - Fix DMA position inaccuracy
      ALSA: hda - Add missing Thinkpad Z60m support
      ALSA: emu10k1 - Fix inverted Analog/Digital mixer switch on Audigy2

Trond Myklebust (1):
      NFS: Ensure we zap only the access and acl caches when setting new acls

Willy Tarreau (1):
      sound: ensure device number is valid in snd_seq_oss_synth_make_info

