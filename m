Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZA3T1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZA3T1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZA3T05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:26:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35151 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZA3T04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:26:56 -0500
Date: Fri, 30 Jan 2009 20:26:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull V2] headers_check fixes
Message-ID: <20090130192627.GA32705@elte.hu>
References: <1233342254.21493.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233342254.21493.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> filtered out CONFIG_* changes, based on Linus tree.
> 
> Please pull:
> 
> The following changes since commit f2257b70b0f9b2fe8f2afd83fc6798dca75930b8:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../sfrench/cifs-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6.git master
> 
> Jaswinder Singh Rajput (90):
>       headers_check fix: can/bcm.h
>       headers_check fix: dvb/audio.h
>       headers_check fix: dvb/dmx.h
>       headers_check fix: dvb/frontend.h
>       headers_check fix: dvb/net.h
>       headers_check fix: dvb/video.h
>       headers_check fix: netfilter/xt_conntrack.h
>       headers_check fix: nfsd/export.h
>       headers_check fix: nfsd/nfsfh.h
>       headers_check fix: nfsd/syscall.h
>       headers_check fix: raid/md_p.h
>       headers_check fix: spi/spidev.h
>       headers_check fix: tc_act/tc_gact.h
>       headers_check fix: tc_act/tc_mirred.h
>       headers_check fix: tc_act/tc_pedit.h
>       headers_check fix: tc_ematch/tc_em_cmp.h
>       headers_check fix: tc_ematch/tc_em_meta.h
>       headers_check fix: tc_ematch/tc_em_nbyte.h
>       headers_check fix: tc_ematch/tc_em_text.h
>       headers_check fix: usb/cdc.h
>       headers_check fix: usb/gadgetfs.h
>       headers_check fix: linux/aio_abi.h
>       headers_check fix: linux/atalk.h
>       headers_check fix: linux/atmbr2684.h
>       headers_check fix: linux/auto_fs4.h
>       headers_check fix: linux/bfs_fs.h
>       headers_check fix: linux/blktrace_api.h
>       headers_check fix: linux/capability.h
>       headers_check fix: linux/cdrom.h
>       headers_check fix: linux/cgroupstats.h
>       headers_check fix: linux/dlm_plock.h
>       headers_check fix: linux/dn.h
>       headers_check fix: linux/edd.h
>       headers_check fix: linux/efs_fs_sb.h
>       headers_check fix: linux/elf-fdpic.h
>       headers_check fix: linux/elf.h
>       headers_check fix: linux/errqueue.h
>       headers_check fix: linux/genetlink.h
>       headers_check fix: linux/gfs2_ondisk.h
>       headers_check fix: linux/hid.h
>       headers_check fix: linux/hiddev.h
>       headers_check fix: linux/icmpv6.h
>       headers_check fix: linux/if_addr.h
>       headers_check fix: linux/if_addrlabel.h
>       headers_check fix: linux/if_fc.h
>       headers_check fix: linux/if_hippi.h
>       headers_check fix: linux/if_link.h
>       headers_check fix: linux/if_ppp.h
>       headers_check fix: linux/if_strip.h
>       headers_check fix: linux/if_tr.h
>       headers_check fix: linux/igmp.h
>       headers_check fix: linux/inet_diag.h
>       headers_check fix: linux/ip6_tunnel.h
>       headers_check fix: linux/ipv6.h
>       headers_check fix: linux/ipv6_route.h
>       headers_check fix: linux/ipx.h
>       headers_check fix: linux/irda.h
>       headers_check fix: linux/minix_fs.h
>       headers_check fix: linux/msdos_fs.h
>       headers_check fix: linux/neighbour.h
>       headers_check fix: linux/nfs_idmap.h
>       headers_check fix: linux/phonet.h
>       headers_check fix: linux/pkt_cls.h
>       headers_check fix: linux/pkt_sched.h
>       headers_check fix: linux/ppp_defs.h
>       headers_check fix: linux/random.h
>       headers_check fix: linux/signalfd.h
>       headers_check fix: linux/sound.h
>       headers_check fix: linux/synclink.h
>       headers_check fix: linux/taskstats.h
>       headers_check fix: linux/video_decoder.h
>       headers_check fix: linux/video_encoder.h
>       headers_check fix: linux/videodev.h
>       headers_check fix: linux/virtio_blk.h
>       headers_check fix: linux/virtio_console.h
>       headers_check fix: linux/virtio_net.h
>       headers_check fix: mtd/inftl-user.h
>       headers_check fix: sound/hdsp.h
>       headers_check fix: video/sisfb.h
>       headers_check fix: video/uvesafb.h
>       headers_check fix: linux/nubus.h
>       headers_check fix: linux/rtnetlink.h
>       headers_check fix: x86, e820.h
>       headers_check fix: x86, kvm.h
>       headers_check fix: x86, mce.h
>       headers_check fix: x86, mtrr.h
>       headers_check fix: x86, ptrace-abi.h
>       headers_check fix: x86, sigcontext.h
>       headers_check fix: x86, sigcontext32.h
>       headers_check fix: x86, swab.h
> 
>  arch/x86/include/asm/e820.h            |    1 +
>  arch/x86/include/asm/kvm.h             |    2 +-
>  arch/x86/include/asm/mce.h             |    5 +----
>  arch/x86/include/asm/mtrr.h            |    1 +
>  arch/x86/include/asm/ptrace-abi.h      |    2 +-
>  arch/x86/include/asm/sigcontext.h      |    2 +-
>  arch/x86/include/asm/sigcontext32.h    |    2 ++
>  arch/x86/include/asm/swab.h            |    2 +-
>  include/linux/aio_abi.h                |    1 +
>  include/linux/atalk.h                  |    1 +
>  include/linux/atmbr2684.h              |    1 +
>  include/linux/auto_fs4.h               |    1 +
>  include/linux/bfs_fs.h                 |    3 ++-
>  include/linux/blktrace_api.h           |    1 +
>  include/linux/can/bcm.h                |    2 ++
>  include/linux/capability.h             |    8 ++++----
>  include/linux/cdrom.h                  |    1 +
>  include/linux/cgroupstats.h            |    1 +
>  include/linux/dlm_plock.h              |    2 ++
>  include/linux/dn.h                     |    2 ++
>  include/linux/dvb/audio.h              |    5 -----
>  include/linux/dvb/dmx.h                |    2 +-
>  include/linux/dvb/frontend.h           |    3 +--
>  include/linux/dvb/net.h                |    3 +--
>  include/linux/dvb/video.h              |    7 ++-----
>  include/linux/edd.h                    |    2 ++
>  include/linux/efs_fs_sb.h              |    1 +
>  include/linux/elf-fdpic.h              |    2 ++
>  include/linux/elf.h                    |    3 ++-
>  include/linux/errqueue.h               |    2 ++
>  include/linux/genetlink.h              |    1 +
>  include/linux/gfs2_ondisk.h            |    2 ++
>  include/linux/hid.h                    |    2 ++
>  include/linux/hiddev.h                 |    2 ++
>  include/linux/icmpv6.h                 |    1 +
>  include/linux/if_addr.h                |    1 +
>  include/linux/if_addrlabel.h           |    2 ++
>  include/linux/if_fc.h                  |    1 +
>  include/linux/if_hippi.h               |    1 +
>  include/linux/if_link.h                |    1 +
>  include/linux/if_ppp.h                 |    1 +
>  include/linux/if_strip.h               |    2 ++
>  include/linux/if_tr.h                  |    1 +
>  include/linux/igmp.h                   |    1 +
>  include/linux/inet_diag.h              |    2 ++
>  include/linux/ip6_tunnel.h             |    2 ++
>  include/linux/ipv6.h                   |    1 +
>  include/linux/ipv6_route.h             |    2 ++
>  include/linux/ipx.h                    |    1 +
>  include/linux/irda.h                   |    2 ++
>  include/linux/minix_fs.h               |    1 +
>  include/linux/msdos_fs.h               |    1 +
>  include/linux/neighbour.h              |    1 +
>  include/linux/netfilter/xt_conntrack.h |    1 +
>  include/linux/nfs_idmap.h              |    2 ++
>  include/linux/nfsd/export.h            |    3 +--
>  include/linux/nfsd/nfsfh.h             |    3 +--
>  include/linux/nfsd/syscall.h           |    3 +--
>  include/linux/nubus.h                  |    1 +
>  include/linux/phonet.h                 |    2 ++
>  include/linux/pkt_cls.h                |    1 +
>  include/linux/pkt_sched.h              |    2 ++
>  include/linux/ppp_defs.h               |    2 ++
>  include/linux/raid/md_p.h              |    2 ++
>  include/linux/random.h                 |    1 +
>  include/linux/rtnetlink.h              |    1 +
>  include/linux/signalfd.h               |    1 +
>  include/linux/sound.h                  |    2 ++
>  include/linux/spi/spidev.h             |    1 +
>  include/linux/synclink.h               |    2 ++
>  include/linux/taskstats.h              |    2 ++
>  include/linux/tc_act/tc_gact.h         |    1 +
>  include/linux/tc_act/tc_mirred.h       |    1 +
>  include/linux/tc_act/tc_pedit.h        |    1 +
>  include/linux/tc_ematch/tc_em_cmp.h    |    1 +
>  include/linux/tc_ematch/tc_em_meta.h   |    1 +
>  include/linux/tc_ematch/tc_em_nbyte.h  |    1 +
>  include/linux/tc_ematch/tc_em_text.h   |    1 +
>  include/linux/usb/cdc.h                |    2 ++
>  include/linux/usb/gadgetfs.h           |    2 +-
>  include/linux/video_decoder.h          |    2 ++
>  include/linux/video_encoder.h          |    2 ++
>  include/linux/videodev.h               |    1 +
>  include/linux/virtio_blk.h             |    1 +
>  include/linux/virtio_console.h         |    1 +
>  include/linux/virtio_net.h             |    1 +
>  include/mtd/inftl-user.h               |    2 ++
>  include/sound/hdsp.h                   |    2 ++
>  include/video/sisfb.h                  |    2 +-
>  include/video/uvesafb.h                |    2 ++
>  90 files changed, 125 insertions(+), 37 deletions(-)
> 
> Fixed 114 headers_check warnings:

They all look reasonable, pulled them into tip/core/header-fixes, thanks 
Jaswinder!

Sam, would you mind to remove the CONFIG_* warnings from headers_check, 
and get that commit to Linus ASAP? (or we can put it into this branch too, 
if you prefer it that way)

Those warnings wont be worked around in the headers and that check litters 
the CONFIG_HEADER_CHECK=y build with warnings right now and make it 
impossible to reach a warning-free build.

	Ingo
