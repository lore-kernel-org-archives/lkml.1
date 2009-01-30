Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZA3TFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZA3TFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZA3TFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:05:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:58553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZA3TE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:04:58 -0500
Subject: [git pull V2] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 00:34:14 +0530
Message-Id: <1233342254.21493.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filtered out CONFIG_* changes, based on Linus tree.

Please pull:

The following changes since commit f2257b70b0f9b2fe8f2afd83fc6798dca75930b8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6.git master

Jaswinder Singh Rajput (90):
      headers_check fix: can/bcm.h
      headers_check fix: dvb/audio.h
      headers_check fix: dvb/dmx.h
      headers_check fix: dvb/frontend.h
      headers_check fix: dvb/net.h
      headers_check fix: dvb/video.h
      headers_check fix: netfilter/xt_conntrack.h
      headers_check fix: nfsd/export.h
      headers_check fix: nfsd/nfsfh.h
      headers_check fix: nfsd/syscall.h
      headers_check fix: raid/md_p.h
      headers_check fix: spi/spidev.h
      headers_check fix: tc_act/tc_gact.h
      headers_check fix: tc_act/tc_mirred.h
      headers_check fix: tc_act/tc_pedit.h
      headers_check fix: tc_ematch/tc_em_cmp.h
      headers_check fix: tc_ematch/tc_em_meta.h
      headers_check fix: tc_ematch/tc_em_nbyte.h
      headers_check fix: tc_ematch/tc_em_text.h
      headers_check fix: usb/cdc.h
      headers_check fix: usb/gadgetfs.h
      headers_check fix: linux/aio_abi.h
      headers_check fix: linux/atalk.h
      headers_check fix: linux/atmbr2684.h
      headers_check fix: linux/auto_fs4.h
      headers_check fix: linux/bfs_fs.h
      headers_check fix: linux/blktrace_api.h
      headers_check fix: linux/capability.h
      headers_check fix: linux/cdrom.h
      headers_check fix: linux/cgroupstats.h
      headers_check fix: linux/dlm_plock.h
      headers_check fix: linux/dn.h
      headers_check fix: linux/edd.h
      headers_check fix: linux/efs_fs_sb.h
      headers_check fix: linux/elf-fdpic.h
      headers_check fix: linux/elf.h
      headers_check fix: linux/errqueue.h
      headers_check fix: linux/genetlink.h
      headers_check fix: linux/gfs2_ondisk.h
      headers_check fix: linux/hid.h
      headers_check fix: linux/hiddev.h
      headers_check fix: linux/icmpv6.h
      headers_check fix: linux/if_addr.h
      headers_check fix: linux/if_addrlabel.h
      headers_check fix: linux/if_fc.h
      headers_check fix: linux/if_hippi.h
      headers_check fix: linux/if_link.h
      headers_check fix: linux/if_ppp.h
      headers_check fix: linux/if_strip.h
      headers_check fix: linux/if_tr.h
      headers_check fix: linux/igmp.h
      headers_check fix: linux/inet_diag.h
      headers_check fix: linux/ip6_tunnel.h
      headers_check fix: linux/ipv6.h
      headers_check fix: linux/ipv6_route.h
      headers_check fix: linux/ipx.h
      headers_check fix: linux/irda.h
      headers_check fix: linux/minix_fs.h
      headers_check fix: linux/msdos_fs.h
      headers_check fix: linux/neighbour.h
      headers_check fix: linux/nfs_idmap.h
      headers_check fix: linux/phonet.h
      headers_check fix: linux/pkt_cls.h
      headers_check fix: linux/pkt_sched.h
      headers_check fix: linux/ppp_defs.h
      headers_check fix: linux/random.h
      headers_check fix: linux/signalfd.h
      headers_check fix: linux/sound.h
      headers_check fix: linux/synclink.h
      headers_check fix: linux/taskstats.h
      headers_check fix: linux/video_decoder.h
      headers_check fix: linux/video_encoder.h
      headers_check fix: linux/videodev.h
      headers_check fix: linux/virtio_blk.h
      headers_check fix: linux/virtio_console.h
      headers_check fix: linux/virtio_net.h
      headers_check fix: mtd/inftl-user.h
      headers_check fix: sound/hdsp.h
      headers_check fix: video/sisfb.h
      headers_check fix: video/uvesafb.h
      headers_check fix: linux/nubus.h
      headers_check fix: linux/rtnetlink.h
      headers_check fix: x86, e820.h
      headers_check fix: x86, kvm.h
      headers_check fix: x86, mce.h
      headers_check fix: x86, mtrr.h
      headers_check fix: x86, ptrace-abi.h
      headers_check fix: x86, sigcontext.h
      headers_check fix: x86, sigcontext32.h
      headers_check fix: x86, swab.h

 arch/x86/include/asm/e820.h            |    1 +
 arch/x86/include/asm/kvm.h             |    2 +-
 arch/x86/include/asm/mce.h             |    5 +----
 arch/x86/include/asm/mtrr.h            |    1 +
 arch/x86/include/asm/ptrace-abi.h      |    2 +-
 arch/x86/include/asm/sigcontext.h      |    2 +-
 arch/x86/include/asm/sigcontext32.h    |    2 ++
 arch/x86/include/asm/swab.h            |    2 +-
 include/linux/aio_abi.h                |    1 +
 include/linux/atalk.h                  |    1 +
 include/linux/atmbr2684.h              |    1 +
 include/linux/auto_fs4.h               |    1 +
 include/linux/bfs_fs.h                 |    3 ++-
 include/linux/blktrace_api.h           |    1 +
 include/linux/can/bcm.h                |    2 ++
 include/linux/capability.h             |    8 ++++----
 include/linux/cdrom.h                  |    1 +
 include/linux/cgroupstats.h            |    1 +
 include/linux/dlm_plock.h              |    2 ++
 include/linux/dn.h                     |    2 ++
 include/linux/dvb/audio.h              |    5 -----
 include/linux/dvb/dmx.h                |    2 +-
 include/linux/dvb/frontend.h           |    3 +--
 include/linux/dvb/net.h                |    3 +--
 include/linux/dvb/video.h              |    7 ++-----
 include/linux/edd.h                    |    2 ++
 include/linux/efs_fs_sb.h              |    1 +
 include/linux/elf-fdpic.h              |    2 ++
 include/linux/elf.h                    |    3 ++-
 include/linux/errqueue.h               |    2 ++
 include/linux/genetlink.h              |    1 +
 include/linux/gfs2_ondisk.h            |    2 ++
 include/linux/hid.h                    |    2 ++
 include/linux/hiddev.h                 |    2 ++
 include/linux/icmpv6.h                 |    1 +
 include/linux/if_addr.h                |    1 +
 include/linux/if_addrlabel.h           |    2 ++
 include/linux/if_fc.h                  |    1 +
 include/linux/if_hippi.h               |    1 +
 include/linux/if_link.h                |    1 +
 include/linux/if_ppp.h                 |    1 +
 include/linux/if_strip.h               |    2 ++
 include/linux/if_tr.h                  |    1 +
 include/linux/igmp.h                   |    1 +
 include/linux/inet_diag.h              |    2 ++
 include/linux/ip6_tunnel.h             |    2 ++
 include/linux/ipv6.h                   |    1 +
 include/linux/ipv6_route.h             |    2 ++
 include/linux/ipx.h                    |    1 +
 include/linux/irda.h                   |    2 ++
 include/linux/minix_fs.h               |    1 +
 include/linux/msdos_fs.h               |    1 +
 include/linux/neighbour.h              |    1 +
 include/linux/netfilter/xt_conntrack.h |    1 +
 include/linux/nfs_idmap.h              |    2 ++
 include/linux/nfsd/export.h            |    3 +--
 include/linux/nfsd/nfsfh.h             |    3 +--
 include/linux/nfsd/syscall.h           |    3 +--
 include/linux/nubus.h                  |    1 +
 include/linux/phonet.h                 |    2 ++
 include/linux/pkt_cls.h                |    1 +
 include/linux/pkt_sched.h              |    2 ++
 include/linux/ppp_defs.h               |    2 ++
 include/linux/raid/md_p.h              |    2 ++
 include/linux/random.h                 |    1 +
 include/linux/rtnetlink.h              |    1 +
 include/linux/signalfd.h               |    1 +
 include/linux/sound.h                  |    2 ++
 include/linux/spi/spidev.h             |    1 +
 include/linux/synclink.h               |    2 ++
 include/linux/taskstats.h              |    2 ++
 include/linux/tc_act/tc_gact.h         |    1 +
 include/linux/tc_act/tc_mirred.h       |    1 +
 include/linux/tc_act/tc_pedit.h        |    1 +
 include/linux/tc_ematch/tc_em_cmp.h    |    1 +
 include/linux/tc_ematch/tc_em_meta.h   |    1 +
 include/linux/tc_ematch/tc_em_nbyte.h  |    1 +
 include/linux/tc_ematch/tc_em_text.h   |    1 +
 include/linux/usb/cdc.h                |    2 ++
 include/linux/usb/gadgetfs.h           |    2 +-
 include/linux/video_decoder.h          |    2 ++
 include/linux/video_encoder.h          |    2 ++
 include/linux/videodev.h               |    1 +
 include/linux/virtio_blk.h             |    1 +
 include/linux/virtio_console.h         |    1 +
 include/linux/virtio_net.h             |    1 +
 include/mtd/inftl-user.h               |    2 ++
 include/sound/hdsp.h                   |    2 ++
 include/video/sisfb.h                  |    2 +-
 include/video/uvesafb.h                |    2 ++
 90 files changed, 125 insertions(+), 37 deletions(-)

Fixed 114 headers_check warnings:
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/can/bcm.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/audio.h:133: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/dmx.h:27: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/dmx.h:90: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/frontend.h:29: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/frontend.h:76: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/net.h:27: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/net.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/video.h:29: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dvb/video.h:102: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/netfilter/xt_conntrack.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfsd/export.h:13: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfsd/nfsfh.h:17: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfsd/nfsfh.h:28: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfsd/syscall.h:12: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfsd/syscall.h:104: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/raid/md_p.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/spi/spidev.h:83: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_act/tc_gact.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_act/tc_mirred.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_act/tc_pedit.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_ematch/tc_em_cmp.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_ematch/tc_em_meta.h:18: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_ematch/tc_em_nbyte.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/tc_ematch/tc_em_text.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/usb/cdc.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/usb/gadgetfs.h:21: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/aio_abi.h:58: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/atalk.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/atmbr2684.h:88: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/auto_fs4.h:132: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/bfs_fs.h:24: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/blktrace_api.h:96: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/capability.h:73: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/cdrom.h:155: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/cgroupstats.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dlm_plock.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/dn.h:75: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/edd.h:70: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/efs_fs_sb.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/elf.h:379: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/elf.h:387: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/elf.h:401: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/elf.h:402: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/errqueue.h:6: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/genetlink.h:12: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/gfs2_ondisk.h:109: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/hid.h:69: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/hid.h:76: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/hiddev.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/icmpv6.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_addr.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_addrlabel.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_fc.h:37: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_hippi.h:82: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_link.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_ppp.h:96: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_strip.h:22: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/if_tr.h:37: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/igmp.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/inet_diag.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/ip6_tunnel.h:21: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/ipv6.h:26: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/ipv6_route.h:42: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/ipx.h:13: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/irda.h:127: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/minix_fs.h:34: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/msdos_fs.h:100: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/neighbour.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nfs_idmap.h:55: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nubus.h:232: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/phonet.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/pkt_cls.h:122: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/pkt_sched.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/ppp_defs.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/random.h:39: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/rtnetlink.h:328: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/signalfd.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:33: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:34: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:35: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:36: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:37: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:39: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:40: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:41: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/sound.h:42: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/synclink.h:209: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/taskstats.h:44: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/video_decoder.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/video_encoder.h:5: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/videodev.h:53: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/virtio_blk.h:21: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/virtio_console.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/virtio_net.h:28: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/mtd/inftl-user.h:61: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/sound/hdsp.h:33: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/video/sisfb.h:25: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/video/sisfb.h:78: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/video/uvesafb.h:5: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/e820.h:44: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/kvm.h:9: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/kvm.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/mce.h:7: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/mce.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/mtrr.h:61: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/ptrace-abi.h:86: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/ptrace-abi.h:93: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/sigcontext.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/sigcontext.h:24: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/sigcontext32.h:20: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm/swab.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>

Complete diff:
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 3d8cedd..00d41ce 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -49,6 +49,7 @@
 #define E820_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 struct e820entry {
 	__u64 addr;	/* start of memory segment */
 	__u64 size;	/* size of memory segment */
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index b95162a..d2e3bf3 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -6,7 +6,7 @@
  *
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Architectural interrupt line count. */
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 1d6e17c..32c6e17 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -3,8 +3,8 @@
 
 #ifdef __x86_64__
 
+#include <linux/types.h>
 #include <asm/ioctls.h>
-#include <asm/types.h>
 
 /*
  * Machine Check support for x86
@@ -115,8 +115,6 @@ extern int mce_notify_user(void);
 
 #endif /* !CONFIG_X86_32 */
 
-
-
 #ifdef CONFIG_X86_MCE
 extern void mcheck_init(struct cpuinfo_x86 *c);
 #else
@@ -126,5 +124,4 @@ extern void stop_mce(void);
 extern void restart_mce(void);
 
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 14080d2..a51ada8 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -23,6 +23,7 @@
 #ifndef _ASM_X86_MTRR_H
 #define _ASM_X86_MTRR_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/errno.h>
 
diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 25f1bb8..8e0f8d1 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -83,7 +83,7 @@
 #ifdef CONFIG_X86_PTRACE_BTS
 
 #ifndef __ASSEMBLY__
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* configuration/status structure used in PTRACE_BTS_CONFIG and
    PTRACE_BTS_STATUS commands.
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 0afcb5e..ec66649 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_SIGCONTEXT_H
 
 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define FP_XSTATE_MAGIC1	0x46505853U
 #define FP_XSTATE_MAGIC2	0x46505845U
diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
index 6126188..ad1478c 100644
--- a/arch/x86/include/asm/sigcontext32.h
+++ b/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#include <linux/types.h>
+
 /* signal context for 32bit programs. */
 
 #define X86_FXSR_MAGIC		0x0000
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..557cd9f 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 9e01729..2c87316 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -27,6 +27,7 @@
 #ifndef __LINUX__AIO_ABI_H
 #define __LINUX__AIO_ABI_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 typedef unsigned long	aio_context_t;
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index e9ebac2..d34c187 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_ATALK_H__
 #define __LINUX_ATALK_H__
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/atmbr2684.h b/include/linux/atmbr2684.h
index 52bf72a..fdb2629 100644
--- a/include/linux/atmbr2684.h
+++ b/include/linux/atmbr2684.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_ATMBR2684_H
 #define _LINUX_ATMBR2684_H
 
+#include <linux/types.h>
 #include <linux/atm.h>
 #include <linux/if.h>		/* For IFNAMSIZ */
 
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index 55fa478..8b49ac4 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -12,6 +12,7 @@
 #define _LINUX_AUTO_FS4_H
 
 /* Include common v3 definitions */
+#include <linux/types.h>
 #include <linux/auto_fs.h>
 
 /* autofs v4 definitions */
diff --git a/include/linux/bfs_fs.h b/include/linux/bfs_fs.h
index 8ed6dfd..1c0b355 100644
--- a/include/linux/bfs_fs.h
+++ b/include/linux/bfs_fs.h
@@ -6,6 +6,8 @@
 #ifndef _LINUX_BFS_FS_H
 #define _LINUX_BFS_FS_H
 
+#include <linux/types.h>
+
 #define BFS_BSIZE_BITS		9
 #define BFS_BSIZE		(1<<BFS_BSIZE_BITS)
 
@@ -17,7 +19,6 @@
 #define BFS_VDIR 2L
 #define BFS_VREG 1L
 
-
 /* BFS inode layout on disk */
 struct bfs_inode {
 	__le16 i_ino;
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 1dba349..25379cb 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -1,6 +1,7 @@
 #ifndef BLKTRACE_H
 #define BLKTRACE_H
 
+#include <linux/types.h>
 #ifdef __KERNEL__
 #include <linux/blkdev.h>
 #include <linux/relay.h>
diff --git a/include/linux/can/bcm.h b/include/linux/can/bcm.h
index 7f29327..1432b27 100644
--- a/include/linux/can/bcm.h
+++ b/include/linux/can/bcm.h
@@ -14,6 +14,8 @@
 #ifndef CAN_BCM_H
 #define CAN_BCM_H
 
+#include <linux/types.h>
+
 /**
  * struct bcm_msg_head - head of messages to/from the broadcast manager
  * @opcode:    opcode, see enum below.
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 02bdb76..1b98725 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -69,10 +69,6 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-extern int file_caps_enabled;
-#endif
-
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
 	struct {
@@ -96,6 +92,10 @@ struct vfs_cap_data {
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+extern int file_caps_enabled;
+#endif
+
 typedef struct kernel_cap_struct {
 	__u32 cap[_KERNEL_CAPABILITY_U32S];
 } kernel_cap_t;
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 0b49e08..78e9047 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -11,6 +11,7 @@
 #ifndef	_LINUX_CDROM_H
 #define	_LINUX_CDROM_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*******************************************************
diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
index 4f53abf..3753c33 100644
--- a/include/linux/cgroupstats.h
+++ b/include/linux/cgroupstats.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_CGROUPSTATS_H
 #define _LINUX_CGROUPSTATS_H
 
+#include <linux/types.h>
 #include <linux/taskstats.h>
 
 /*
diff --git a/include/linux/dlm_plock.h b/include/linux/dlm_plock.h
index 18d5fdb..2dd2124 100644
--- a/include/linux/dlm_plock.h
+++ b/include/linux/dlm_plock.h
@@ -9,6 +9,8 @@
 #ifndef __DLM_PLOCK_DOT_H__
 #define __DLM_PLOCK_DOT_H__
 
+#include <linux/types.h>
+
 #define DLM_PLOCK_MISC_NAME		"dlm_plock"
 
 #define DLM_PLOCK_VERSION_MAJOR	1
diff --git a/include/linux/dn.h b/include/linux/dn.h
index 02bba04..fe99908 100644
--- a/include/linux/dn.h
+++ b/include/linux/dn.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_DN_H
 #define _LINUX_DN_H
 
+#include <linux/types.h>
+
 /*
 
 	DECnet Data Structures and Constants
diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
index 89412e1..bb0df2a 100644
--- a/include/linux/dvb/audio.h
+++ b/include/linux/dvb/audio.h
@@ -24,12 +24,7 @@
 #ifndef _DVBAUDIO_H_
 #define _DVBAUDIO_H_
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
-#include <stdint.h>
-#endif
-
 
 typedef enum {
 	AUDIO_SOURCE_DEMUX, /* Select the demux as the main source */
diff --git a/include/linux/dvb/dmx.h b/include/linux/dvb/dmx.h
index 402fb7a..fef9437 100644
--- a/include/linux/dvb/dmx.h
+++ b/include/linux/dvb/dmx.h
@@ -24,7 +24,7 @@
 #ifndef _DVBDMX_H_
 #define _DVBDMX_H_
 
-#include <asm/types.h>
+#include <linux/types.h>
 #ifdef __KERNEL__
 #include <linux/time.h>
 #else
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 55026b1..51c8d2d 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -26,8 +26,7 @@
 #ifndef _DVBFRONTEND_H_
 #define _DVBFRONTEND_H_
 
-#include <asm/types.h>
-
+#include <linux/types.h>
 
 typedef enum fe_type {
 	FE_QPSK,
diff --git a/include/linux/dvb/net.h b/include/linux/dvb/net.h
index 5be474b..f451e7e 100644
--- a/include/linux/dvb/net.h
+++ b/include/linux/dvb/net.h
@@ -24,8 +24,7 @@
 #ifndef _DVBNET_H_
 #define _DVBNET_H_
 
-#include <asm/types.h>
-
+#include <linux/types.h>
 
 struct dvb_net_if {
 	__u16 pid;
diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
index 50839fe..bd49c3e 100644
--- a/include/linux/dvb/video.h
+++ b/include/linux/dvb/video.h
@@ -24,17 +24,14 @@
 #ifndef _DVBVIDEO_H_
 #define _DVBVIDEO_H_
 
-#include <linux/compiler.h>
-
-#ifdef __KERNEL__
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <linux/compiler.h>
 #else
-#include <asm/types.h>
 #include <stdint.h>
 #include <time.h>
 #endif
 
-
 typedef enum {
 	VIDEO_FORMAT_4_3,     /* Select 4:3 format */
 	VIDEO_FORMAT_16_9,    /* Select 16:9 format. */
diff --git a/include/linux/edd.h b/include/linux/edd.h
index 5d747c5..4cbd0fe 100644
--- a/include/linux/edd.h
+++ b/include/linux/edd.h
@@ -30,6 +30,8 @@
 #ifndef _LINUX_EDD_H
 #define _LINUX_EDD_H
 
+#include <linux/types.h>
+
 #define EDDNR 0x1e9		/* addr of number of edd_info structs at EDDBUF
 				   in boot_params - treat this as 1 byte  */
 #define EDDBUF	0xd00		/* addr of edd_info structs in boot_params */
diff --git a/include/linux/efs_fs_sb.h b/include/linux/efs_fs_sb.h
index ff1945e..a01be90 100644
--- a/include/linux/efs_fs_sb.h
+++ b/include/linux/efs_fs_sb.h
@@ -9,6 +9,7 @@
 #ifndef __EFS_FS_SB_H__
 #define __EFS_FS_SB_H__
 
+#include <linux/types.h>
 #include <linux/magic.h>
 
 /* EFS superblock magic numbers */
diff --git a/include/linux/elf-fdpic.h b/include/linux/elf-fdpic.h
index 9f5b745..7cd2e80 100644
--- a/include/linux/elf-fdpic.h
+++ b/include/linux/elf-fdpic.h
@@ -58,11 +58,13 @@ struct elf_fdpic_params {
 #define ELF_FDPIC_FLAG_PRESENT		0x80000000	/* T if this object is present */
 };
 
+#ifdef __KERNEL__
 #ifdef CONFIG_MMU
 extern void elf_fdpic_arch_lay_out_mm(struct elf_fdpic_params *exec_params,
 				      struct elf_fdpic_params *interp_params,
 				      unsigned long *start_stack,
 				      unsigned long *start_brk);
 #endif
+#endif /* __KERNEL__ */
 
 #endif /* _LINUX_ELF_FDPIC_H */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 0b61ca4..45a937b 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -377,6 +377,7 @@ typedef struct elf64_note {
   Elf64_Word n_type;	/* Content type */
 } Elf64_Nhdr;
 
+#ifdef __KERNEL__
 #if ELF_CLASS == ELFCLASS32
 
 extern Elf32_Dyn _DYNAMIC [];
@@ -404,5 +405,5 @@ static inline int elf_coredump_extra_notes_write(struct file *file,
 extern int elf_coredump_extra_notes_size(void);
 extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
 #endif
-
+#endif /* __KERNEL__ */
 #endif /* _LINUX_ELF_H */
diff --git a/include/linux/errqueue.h b/include/linux/errqueue.h
index 92f8d4f..ceb1454 100644
--- a/include/linux/errqueue.h
+++ b/include/linux/errqueue.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_ERRQUEUE_H
 #define _LINUX_ERRQUEUE_H 1
 
+#include <linux/types.h>
+
 struct sock_extended_err
 {
 	__u32	ee_errno;	
diff --git a/include/linux/genetlink.h b/include/linux/genetlink.h
index 7da02c9..b834ef6 100644
--- a/include/linux/genetlink.h
+++ b/include/linux/genetlink.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_GENERIC_NETLINK_H
 #define __LINUX_GENERIC_NETLINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 #define GENL_NAMSIZ	16	/* length of family name */
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 14d0df0..c56b4bc 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -10,6 +10,8 @@
 #ifndef __GFS2_ONDISK_DOT_H__
 #define __GFS2_ONDISK_DOT_H__
 
+#include <linux/types.h>
+
 #define GFS2_MAGIC		0x01161970
 #define GFS2_BASIC_BLOCK	512
 #define GFS2_BASIC_BLOCK_SHIFT	9
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 81aa84d..fa8ee9c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -791,6 +791,7 @@ dbg_hid(const char *fmt, ...)
 		__FILE__ , ## arg)
 #endif /* HID_FF */
 
+#ifdef __KERNEL__
 #ifdef CONFIG_HID_COMPAT
 #define HID_COMPAT_LOAD_DRIVER(name)	\
 /* prototype to avoid sparse warning */	\
@@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
 	extern void hid_compat_##name(void);	\
 	hid_compat_##name();			\
 } while (0)
+#endif /* __KERNEL__ */
 
 #endif
 
diff --git a/include/linux/hiddev.h b/include/linux/hiddev.h
index c760ae0..bb6f58b 100644
--- a/include/linux/hiddev.h
+++ b/include/linux/hiddev.h
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Ucitelska 1576, Prague 8, 182 00 Czech Republic
  */
 
+#include <linux/types.h>
+
 /*
  * The event structure itself
  */
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index a93a8dd..10d701e 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_ICMPV6_H
 #define _LINUX_ICMPV6_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 struct icmp6hdr {
diff --git a/include/linux/if_addr.h b/include/linux/if_addr.h
index 43f3bed..a60c821 100644
--- a/include/linux/if_addr.h
+++ b/include/linux/if_addr.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_IF_ADDR_H
 #define __LINUX_IF_ADDR_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 struct ifaddrmsg
diff --git a/include/linux/if_addrlabel.h b/include/linux/if_addrlabel.h
index 9fe79c9..89571f6 100644
--- a/include/linux/if_addrlabel.h
+++ b/include/linux/if_addrlabel.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_IF_ADDRLABEL_H
 #define __LINUX_IF_ADDRLABEL_H
 
+#include <linux/types.h>
+
 struct ifaddrlblmsg
 {
 	__u8		ifal_family;		/* Address family */
diff --git a/include/linux/if_fc.h b/include/linux/if_fc.h
index 376a34e..6ed7f1b 100644
--- a/include/linux/if_fc.h
+++ b/include/linux/if_fc.h
@@ -20,6 +20,7 @@
 #ifndef _LINUX_IF_FC_H
 #define _LINUX_IF_FC_H
 
+#include <linux/types.h>
 
 #define FC_ALEN	6		/* Octets in one ethernet addr	 */
 #define FC_HLEN   (sizeof(struct fch_hdr)+sizeof(struct fcllc))
diff --git a/include/linux/if_hippi.h b/include/linux/if_hippi.h
index f0f2351..4a7c994 100644
--- a/include/linux/if_hippi.h
+++ b/include/linux/if_hippi.h
@@ -22,6 +22,7 @@
 #ifndef _LINUX_IF_HIPPI_H
 #define _LINUX_IF_HIPPI_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index f9032c8..176c518 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_IF_LINK_H
 #define _LINUX_IF_LINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 /* The struct should be in sync with struct net_device_stats */
diff --git a/include/linux/if_ppp.h b/include/linux/if_ppp.h
index c3b1f85..fcef103 100644
--- a/include/linux/if_ppp.h
+++ b/include/linux/if_ppp.h
@@ -33,6 +33,7 @@
 #ifndef _IF_PPP_H_
 #define _IF_PPP_H_
 
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 /*
diff --git a/include/linux/if_strip.h b/include/linux/if_strip.h
index fb5c5c9..6526a62 100644
--- a/include/linux/if_strip.h
+++ b/include/linux/if_strip.h
@@ -18,6 +18,8 @@
 #ifndef __LINUX_STRIP_H
 #define __LINUX_STRIP_H
 
+#include <linux/types.h>
+
 typedef struct {
     __u8 c[6];
 } MetricomAddress;
diff --git a/include/linux/if_tr.h b/include/linux/if_tr.h
index 5bcec8b..fc23aeb 100644
--- a/include/linux/if_tr.h
+++ b/include/linux/if_tr.h
@@ -19,6 +19,7 @@
 #ifndef _LINUX_IF_TR_H
 #define _LINUX_IF_TR_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>	/* For __be16 */
 
 /* IEEE 802.5 Token-Ring magic constants.  The frame sizes omit the preamble
diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index f734a0b..92fbd8c 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_IGMP_H
 #define _LINUX_IGMP_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 6e8bc54..bc8c490 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -1,6 +1,8 @@
 #ifndef _INET_DIAG_H_
 #define _INET_DIAG_H_ 1
 
+#include <linux/types.h>
+
 /* Just some random number */
 #define TCPDIAG_GETSOCK 18
 #define DCCPDIAG_GETSOCK 19
diff --git a/include/linux/ip6_tunnel.h b/include/linux/ip6_tunnel.h
index 1e7cc4a..acb9ad6 100644
--- a/include/linux/ip6_tunnel.h
+++ b/include/linux/ip6_tunnel.h
@@ -1,6 +1,8 @@
 #ifndef _IP6_TUNNEL_H
 #define _IP6_TUNNEL_H
 
+#include <linux/types.h>
+
 #define IPV6_TLV_TNL_ENCAP_LIMIT 4
 #define IPV6_DEFAULT_TNL_ENCAP_LIMIT 4
 
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 0b816ca..476d946 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -1,6 +1,7 @@
 #ifndef _IPV6_H
 #define _IPV6_H
 
+#include <linux/types.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
diff --git a/include/linux/ipv6_route.h b/include/linux/ipv6_route.h
index b323ff5..1e7d8af 100644
--- a/include/linux/ipv6_route.h
+++ b/include/linux/ipv6_route.h
@@ -13,6 +13,8 @@
 #ifndef _LINUX_IPV6_ROUTE_H
 #define _LINUX_IPV6_ROUTE_H
 
+#include <linux/types.h>
+
 #define RTF_DEFAULT	0x00010000	/* default - learned via ND	*/
 #define RTF_ALLONLINK	0x00020000	/* (deprecated and will be removed)
 					   fallback, no routers on link */
diff --git a/include/linux/ipx.h b/include/linux/ipx.h
index eb19b4e..aabb1d2 100644
--- a/include/linux/ipx.h
+++ b/include/linux/ipx.h
@@ -1,5 +1,6 @@
 #ifndef _IPX_H_
 #define _IPX_H_
+#include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/socket.h>
 #define IPX_NODE_LEN	6
diff --git a/include/linux/irda.h b/include/linux/irda.h
index 28f88ec..00bdad0 100644
--- a/include/linux/irda.h
+++ b/include/linux/irda.h
@@ -25,6 +25,8 @@
 #ifndef KERNEL_IRDA_H
 #define KERNEL_IRDA_H
 
+#include <linux/types.h>
+
 /* Please do *not* add any #include in this file, this file is
  * included as-is in user space.
  * Please fix the calling file to properly included needed files before
diff --git a/include/linux/minix_fs.h b/include/linux/minix_fs.h
index 0e39745..13fe09e 100644
--- a/include/linux/minix_fs.h
+++ b/include/linux/minix_fs.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_MINIX_FS_H
 #define _LINUX_MINIX_FS_H
 
+#include <linux/types.h>
 #include <linux/magic.h>
 
 /*
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index e0a9b20..ce38f1c 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_MSDOS_FS_H
 #define _LINUX_MSDOS_FS_H
 
+#include <linux/types.h>
 #include <linux/magic.h>
 #include <asm/byteorder.h>
 
diff --git a/include/linux/neighbour.h b/include/linux/neighbour.h
index bd3bbf6..8730d5d 100644
--- a/include/linux/neighbour.h
+++ b/include/linux/neighbour.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_NEIGHBOUR_H
 #define __LINUX_NEIGHBOUR_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 struct ndmsg
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index f3fd83e..8f53452 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -5,6 +5,7 @@
 #ifndef _XT_CONNTRACK_H
 #define _XT_CONNTRACK_H
 
+#include <linux/types.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
diff --git a/include/linux/nfs_idmap.h b/include/linux/nfs_idmap.h
index 15a9f3b..91a1c24 100644
--- a/include/linux/nfs_idmap.h
+++ b/include/linux/nfs_idmap.h
@@ -37,6 +37,8 @@
 #ifndef NFS_IDMAP_H
 #define NFS_IDMAP_H
 
+#include <linux/types.h>
+
 /* XXX from bits/utmp.h  */
 #define IDMAP_NAMESZ  128
 
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index 5431512..bcd0201 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -10,9 +10,8 @@
 #ifndef NFSD_EXPORT_H
 #define NFSD_EXPORT_H
 
-#include <asm/types.h>
-#ifdef __KERNEL__
 # include <linux/types.h>
+#ifdef __KERNEL__
 # include <linux/in.h>
 #endif
 
diff --git a/include/linux/nfsd/nfsfh.h b/include/linux/nfsd/nfsfh.h
index b2e0938..fa317f6 100644
--- a/include/linux/nfsd/nfsfh.h
+++ b/include/linux/nfsd/nfsfh.h
@@ -14,9 +14,8 @@
 #ifndef _LINUX_NFSD_FH_H
 #define _LINUX_NFSD_FH_H
 
-#include <asm/types.h>
-#ifdef __KERNEL__
 # include <linux/types.h>
+#ifdef __KERNEL__
 # include <linux/string.h>
 # include <linux/fs.h>
 #endif
diff --git a/include/linux/nfsd/syscall.h b/include/linux/nfsd/syscall.h
index 4e43976..7a3b565 100644
--- a/include/linux/nfsd/syscall.h
+++ b/include/linux/nfsd/syscall.h
@@ -9,9 +9,8 @@
 #ifndef NFSD_SYSCALL_H
 #define NFSD_SYSCALL_H
 
-#include <asm/types.h>
-#ifdef __KERNEL__
 # include <linux/types.h>
+#ifdef __KERNEL__
 # include <linux/in.h>
 #endif 
 #include <linux/posix_types.h>
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index c435507..7382af3 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -12,6 +12,7 @@
 #ifndef LINUX_NUBUS_H
 #define LINUX_NUBUS_H
 
+#include <linux/types.h>
 #ifdef __KERNEL__
 #include <asm/nubus.h>
 #endif
diff --git a/include/linux/phonet.h b/include/linux/phonet.h
index 4157faa..ee5e3c9 100644
--- a/include/linux/phonet.h
+++ b/include/linux/phonet.h
@@ -23,6 +23,8 @@
 #ifndef LINUX_PHONET_H
 #define LINUX_PHONET_H
 
+#include <linux/types.h>
+
 /* Automatic protocol selection */
 #define PN_PROTO_TRANSPORT	0
 /* Phonet datagram socket */
diff --git a/include/linux/pkt_cls.h b/include/linux/pkt_cls.h
index e6aa848..3c842ed 100644
--- a/include/linux/pkt_cls.h
+++ b/include/linux/pkt_cls.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_PKT_CLS_H
 #define __LINUX_PKT_CLS_H
 
+#include <linux/types.h>
 #include <linux/pkt_sched.h>
 
 /* I think i could have done better macros ; for now this is stolen from
diff --git a/include/linux/pkt_sched.h b/include/linux/pkt_sched.h
index e3f133a..b2648e8 100644
--- a/include/linux/pkt_sched.h
+++ b/include/linux/pkt_sched.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_PKT_SCHED_H
 #define __LINUX_PKT_SCHED_H
 
+#include <linux/types.h>
+
 /* Logical priority bands not depending on specific packet scheduler.
    Every scheduler will map them to real traffic classes, if it has
    no more precise mechanism to classify packets.
diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 6e8adc7..1c866bd 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -25,6 +25,8 @@
  * OR MODIFICATIONS.
  */
 
+#include <linux/types.h>
+
 /*
  *  ==FILEVERSION 20000114==
  *
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 9491026..6ba830f 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -15,6 +15,8 @@
 #ifndef _MD_P_H
 #define _MD_P_H
 
+#include <linux/types.h>
+
 /*
  * RAID superblock.
  *
diff --git a/include/linux/random.h b/include/linux/random.h
index 407ea36..25d02fe 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/irqnr.h>
 
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index e88f705..1e5f673 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_RTNETLINK_H
 #define __LINUX_RTNETLINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 #include <linux/if_link.h>
 #include <linux/if_addr.h>
diff --git a/include/linux/signalfd.h b/include/linux/signalfd.h
index bef0c46..b363b91 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_SIGNALFD_H
 #define _LINUX_SIGNALFD_H
 
+#include <linux/types.h>
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
diff --git a/include/linux/sound.h b/include/linux/sound.h
index 9e2a94f..44dcf05 100644
--- a/include/linux/sound.h
+++ b/include/linux/sound.h
@@ -25,6 +25,7 @@
 #define SND_DEV_AMIDI		13	/* Like /dev/midi (obsolete) */
 #define SND_DEV_ADMMIDI		14	/* Like /dev/dmmidi (onsolete) */
 
+#ifdef __KERNEL__
 /*
  *	Sound core interface functions
  */
@@ -40,3 +41,4 @@ extern void unregister_sound_special(int unit);
 extern void unregister_sound_mixer(int unit);
 extern void unregister_sound_midi(int unit);
 extern void unregister_sound_dsp(int unit);
+#endif /* __KERNEL__ */
diff --git a/include/linux/spi/spidev.h b/include/linux/spi/spidev.h
index c93ef9d..95251cc 100644
--- a/include/linux/spi/spidev.h
+++ b/include/linux/spi/spidev.h
@@ -22,6 +22,7 @@
 #ifndef SPIDEV_H
 #define SPIDEV_H
 
+#include <linux/types.h>
 
 /* User space versions of kernel symbols for SPI clocking modes,
  * matching <linux/spi/spi.h>
diff --git a/include/linux/synclink.h b/include/linux/synclink.h
index c844a22..99b8bdb 100644
--- a/include/linux/synclink.h
+++ b/include/linux/synclink.h
@@ -13,6 +13,8 @@
 #define _SYNCLINK_H_
 #define SYNCLINK_H_VERSION 3.6
 
+#include <linux/types.h>
+
 #define BIT0	0x0001
 #define BIT1	0x0002
 #define BIT2	0x0004
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 18269e9..341dddb 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -16,6 +16,8 @@
 #ifndef _LINUX_TASKSTATS_H
 #define _LINUX_TASKSTATS_H
 
+#include <linux/types.h>
+
 /* Format for per-task data returned to userland when
  *	- a task exits
  *	- listener requests stats for a task
diff --git a/include/linux/tc_act/tc_gact.h b/include/linux/tc_act/tc_gact.h
index 23a03eb..e895c0a 100644
--- a/include/linux/tc_act/tc_gact.h
+++ b/include/linux/tc_act/tc_gact.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_GACT_H
 #define __LINUX_TC_GACT_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 #define TCA_ACT_GACT 5
diff --git a/include/linux/tc_act/tc_mirred.h b/include/linux/tc_act/tc_mirred.h
index 71d6340..0a99ab6 100644
--- a/include/linux/tc_act/tc_mirred.h
+++ b/include/linux/tc_act/tc_mirred.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_MIR_H
 #define __LINUX_TC_MIR_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 #define TCA_ACT_MIRRED 8
diff --git a/include/linux/tc_act/tc_pedit.h b/include/linux/tc_act/tc_pedit.h
index 83e56e3..54ce906 100644
--- a/include/linux/tc_act/tc_pedit.h
+++ b/include/linux/tc_act/tc_pedit.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_PED_H
 #define __LINUX_TC_PED_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 #define TCA_ACT_PEDIT 7
diff --git a/include/linux/tc_ematch/tc_em_cmp.h b/include/linux/tc_ematch/tc_em_cmp.h
index c7f4d43..38e7f7b 100644
--- a/include/linux/tc_ematch/tc_em_cmp.h
+++ b/include/linux/tc_ematch/tc_em_cmp.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_EM_CMP_H
 #define __LINUX_TC_EM_CMP_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 struct tcf_em_cmp
diff --git a/include/linux/tc_ematch/tc_em_meta.h b/include/linux/tc_ematch/tc_em_meta.h
index c50d2ba..dcfb733 100644
--- a/include/linux/tc_ematch/tc_em_meta.h
+++ b/include/linux/tc_ematch/tc_em_meta.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_EM_META_H
 #define __LINUX_TC_EM_META_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 enum
diff --git a/include/linux/tc_ematch/tc_em_nbyte.h b/include/linux/tc_ematch/tc_em_nbyte.h
index f19d1f5..9ed8c2e 100644
--- a/include/linux/tc_ematch/tc_em_nbyte.h
+++ b/include/linux/tc_ematch/tc_em_nbyte.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_EM_NBYTE_H
 #define __LINUX_TC_EM_NBYTE_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 struct tcf_em_nbyte
diff --git a/include/linux/tc_ematch/tc_em_text.h b/include/linux/tc_ematch/tc_em_text.h
index 7cd43e9..d12a73a 100644
--- a/include/linux/tc_ematch/tc_em_text.h
+++ b/include/linux/tc_ematch/tc_em_text.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_TC_EM_TEXT_H
 #define __LINUX_TC_EM_TEXT_H
 
+#include <linux/types.h>
 #include <linux/pkt_cls.h>
 
 #define TC_EM_TEXT_ALGOSIZ	16
diff --git a/include/linux/usb/cdc.h b/include/linux/usb/cdc.h
index 18a7293..3c86ed2 100644
--- a/include/linux/usb/cdc.h
+++ b/include/linux/usb/cdc.h
@@ -9,6 +9,8 @@
 #ifndef __LINUX_USB_CDC_H
 #define __LINUX_USB_CDC_H
 
+#include <linux/types.h>
+
 #define USB_CDC_SUBCLASS_ACM			0x02
 #define USB_CDC_SUBCLASS_ETHERNET		0x06
 #define USB_CDC_SUBCLASS_WHCM			0x08
diff --git a/include/linux/usb/gadgetfs.h b/include/linux/usb/gadgetfs.h
index ea45f26..612102e 100644
--- a/include/linux/usb/gadgetfs.h
+++ b/include/linux/usb/gadgetfs.h
@@ -18,7 +18,7 @@
 #ifndef __LINUX_USB_GADGETFS_H
 #define __LINUX_USB_GADGETFS_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/ioctl.h>
 
 #include <linux/usb/ch9.h>
diff --git a/include/linux/video_decoder.h b/include/linux/video_decoder.h
index 121e26d..e26c0c8 100644
--- a/include/linux/video_decoder.h
+++ b/include/linux/video_decoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_DECODER_H
 #define _LINUX_VIDEO_DECODER_H
 
+#include <linux/types.h>
+
 #define HAVE_VIDEO_DECODER 1
 
 struct video_decoder_capability { /* this name is too long */
diff --git a/include/linux/video_encoder.h b/include/linux/video_encoder.h
index 4b0e690..b7b6423 100644
--- a/include/linux/video_encoder.h
+++ b/include/linux/video_encoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_ENCODER_H
 #define _LINUX_VIDEO_ENCODER_H
 
+#include <linux/types.h>
+
 struct video_encoder_capability { /* this name is too long */
 	__u32	flags;
 #define	VIDEO_ENCODER_PAL	1	/* can encode PAL signal */
diff --git a/include/linux/videodev.h b/include/linux/videodev.h
index 15a653d..837f392 100644
--- a/include/linux/videodev.h
+++ b/include/linux/videodev.h
@@ -12,6 +12,7 @@
 #ifndef __LINUX_VIDEODEV_H
 #define __LINUX_VIDEODEV_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index c1aef85..94c56d2 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_BLK_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/types.h>
 #include <linux/virtio_config.h>
 
 /* The ID for virtio_block */
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index 7615ffc..dc16111 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -1,5 +1,6 @@
 #ifndef _LINUX_VIRTIO_CONSOLE_H
 #define _LINUX_VIRTIO_CONSOLE_H
+#include <linux/types.h>
 #include <linux/virtio_config.h>
 /* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
  * anyone can use the definitions to implement compatible drivers/servers. */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 5cdd0aa..3efa86c 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_NET_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/types.h>
 #include <linux/virtio_config.h>
 
 /* The ID for virtio_net */
diff --git a/include/mtd/inftl-user.h b/include/mtd/inftl-user.h
index e17eda3..d409d48 100644
--- a/include/mtd/inftl-user.h
+++ b/include/mtd/inftl-user.h
@@ -6,6 +6,8 @@
 #ifndef __MTD_INFTL_USER_H__
 #define __MTD_INFTL_USER_H__
 
+#include <linux/types.h>
+
 #define	OSAK_VERSION	0x5120
 #define	PERCENTUSED	98
 
diff --git a/include/sound/hdsp.h b/include/sound/hdsp.h
index dec6b1d..d98a78d 100644
--- a/include/sound/hdsp.h
+++ b/include/sound/hdsp.h
@@ -19,6 +19,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/types.h>
+
 #define HDSP_MATRIX_MIXER_SIZE 2048
 
 enum HDSP_IO_Type {
diff --git a/include/video/sisfb.h b/include/video/sisfb.h
index e402eb5..fdd74f1 100644
--- a/include/video/sisfb.h
+++ b/include/video/sisfb.h
@@ -21,8 +21,8 @@
 #ifndef _LINUX_SISFB_H_
 #define _LINUX_SISFB_H_
 
+#include <linux/types.h>
 #include <asm/ioctl.h>
-#include <asm/types.h>
 
 /**********************************************/
 /*                   PUBLIC                   */
diff --git a/include/video/uvesafb.h b/include/video/uvesafb.h
index 95bcef1..0993a22 100644
--- a/include/video/uvesafb.h
+++ b/include/video/uvesafb.h
@@ -1,6 +1,8 @@
 #ifndef _UVESAFB_H
 #define _UVESAFB_H
 
+#include <linux/types.h>
+
 struct v86_regs {
 	__u32 ebx;
 	__u32 ecx;


