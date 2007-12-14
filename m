Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXLNTvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXLNTvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXLNTvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:51:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbXLNTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:51:05 -0500
Date: Fri, 14 Dec 2007 11:49:53 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.10
Message-ID: <20071214194952.GA15765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.10 kernel.
It a number of bugfixes and anyone using the 2.6.23 kernel series is
recommended to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.23.9 and 2.6.23.10

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                              |    2 
 arch/i386/boot/pmjump.S               |    4 -
 crypto/algapi.c                       |    6 -
 drivers/ata/ahci.c                    |   65 ----------------
 drivers/ata/libata-core.c             |   17 ----
 drivers/atm/he.c                      |   10 +-
 drivers/base/core.c                   |    4 -
 drivers/base/power/Makefile           |    3 
 drivers/base/power/main.c             |    8 --
 drivers/base/power/power.h            |   25 ++++--
 drivers/block/rd.c                    |   13 +++
 drivers/char/apm-emulation.c          |   15 ++-
 drivers/char/random.c                 |    6 -
 drivers/input/mouse/alps.c            |    1 
 drivers/isdn/i4l/isdn_common.c        |    5 +
 drivers/isdn/i4l/isdn_net.c           |    8 +-
 drivers/kvm/kvm_main.c                |   16 ++--
 drivers/kvm/mmu.c                     |    1 
 drivers/kvm/svm.c                     |    4 +
 drivers/kvm/vmx.c                     |    3 
 drivers/kvm/x86_emulate.c             |   30 ++++++-
 drivers/net/forcedeth.c               |   38 ++++++---
 drivers/net/wireless/libertas/cmd.c   |   10 +-
 drivers/pnp/pnpacpi/rsparser.c        |   15 +++
 drivers/scsi/dpt_i2o.c                |  132 +++++++++++++++-------------------
 drivers/scsi/dpti.h                   |    9 +-
 drivers/scsi/esp_scsi.c               |    4 -
 drivers/scsi/scsi.c                   |   31 +++++++
 drivers/usb/host/ehci-hcd.c           |    5 +
 drivers/usb/image/microtek.c          |    2 
 drivers/video/fb_ddc.c                |    8 +-
 fs/xfs/linux-2.6/xfs_buf.c            |    2 
 include/linux/pci_ids.h               |    4 +
 include/linux/pnp.h                   |    4 -
 include/linux/thread_info.h           |   17 +++-
 include/net/sock.h                    |    3 
 include/net/tcp.h                     |    3 
 include/scsi/scsi_device.h            |    3 
 kernel/exit.c                         |    2 
 kernel/futex.c                        |   25 +++---
 kernel/hrtimer.c                      |    8 ++
 kernel/irq/manage.c                   |   20 ++++-
 kernel/sched.c                        |    6 -
 lib/textsearch.c                      |    8 +-
 mm/shmem.c                            |    5 -
 net/8021q/vlan_dev.c                  |    3 
 net/bridge/br.c                       |    4 -
 net/bridge/br_input.c                 |    7 +
 net/bridge/netfilter/ebtable_broute.c |    4 -
 net/decnet/dn_dev.c                   |    4 -
 net/ipv4/arp.c                        |   19 ----
 net/ipv4/netfilter/nf_nat_core.c      |    7 -
 net/ipv4/route.c                      |    8 --
 net/ipv4/sysctl_net_ipv4.c            |    2 
 net/ipv4/tcp_illinois.c               |    2 
 net/ipv4/tcp_output.c                 |    1 
 net/ipv6/addrconf.c                   |   11 ++
 net/key/af_key.c                      |    2 
 net/netfilter/nf_conntrack_extend.c   |    2 
 net/netfilter/xt_CONNMARK.c           |   10 +-
 net/netfilter/xt_CONNSECMARK.c        |   10 +-
 net/netfilter/xt_TCPMSS.c             |    4 -
 net/rxrpc/Kconfig                     |    1 
 net/sched/sch_generic.c               |    5 -
 net/unix/af_unix.c                    |    9 ++
 net/xfrm/xfrm_state.c                 |    2 
 66 files changed, 408 insertions(+), 319 deletions(-)


Summary of changes from v2.6.23.9 to v2.6.23.10
===============================================

Adrian Bunk (1):
      IPV4: Remove bogus ifdef mess in arp_process

Amit Shah (2):
      KVM: x86 emulator: Use emulator_write_emulated and not emulator_write_std
      KVM: SVM: Fix FPU leak while emulating clts

Andrew Morton (1):
      revert "dpt_i2o: convert to SCSI hotplug model"

Aurelien Jarno (1):
      KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3

Avi Kivity (4):
      KVM: x86 emulator: invd instruction
      KVM: SVM: Intercept the 'invd' and 'wbinvd' instructions
      KVM: Skip pio instruction when it is emulated, not executed
      KVM: VMX: Force vm86 mode if setting flags during real mode

Ayaz Abdulla (2):
      forcedeth: new mcp79 pci ids
      forcedeth boot delay fix

Charles Hardin (1):
      PFKEY: Sending an SADB_GET responds with an SADB_GET

Christian Borntraeger (1):
      Future of Linux 2.6.22.y series

Daniel Drake (1):
      create /sys/.../power when CONFIG_PM is set

David Brownell (1):
      USB: fix up EHCI startup synchronization

David Howells (1):
      RXRPC: Add missing select on CRYPTO

Eddie Dong (1):
      KVM: VMX: Reset mmu context when entering real mode

Eric Dumazet (2):
      NET: random : secure_tcp_sequence_number should not assume CONFIG_KTIME_SCALAR
      NET: Corrects a bug in ip_rt_acct_read()

Evgeniy Polyakov (3):
      NETFILTER: Fix NULL pointer dereference in nf_nat_move_storage()
      netfilter: Fix kernel panic with REDIRECT target.
      IPV6: Restore IPv6 when MTU is big enough

Florian Zumbiehl (1):
      UNIX: EOF on non-blocking SOCK_SEQPACKET

Greg Kroah-Hartman (1):
      Linux 2.6.23.10

H. Peter Anvin (1):
      x86 setup: add a near jump to serialize %cr0 on 386/486

Herbert Xu (3):
      Fix synchronize_irq races with IRQ handler
      CRYPTO api: Fix potential race in crypto_remove_spawn
      TCP: Fix TCP header misalignment

Hugh Dickins (1):
      tmpfs: restore missing clear_highpage

Ilpo Järvinen (1):
      TCP: MTUprobe: fix potential sk_send_head corruption

Jan Engelhardt (1):
      NETFILTER: fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

Jean Delvare (1):
      fb_ddc: fix DDC lines quirk

Joonwoo Park (1):
      VLAN: Fix nested VLAN transmit bug

Karsten Keil (2):
      I4L: fix isdn_ioctl memory overrun vulnerability
      isdn: avoid copying overly-long strings

Li Zefan (1):
      nf_nat: fix memset error

Maciej W. Rozycki (1):
      esp_scsi: fix reset cleanup spinlock recursion

Marcelo Tosatti (1):
      libertas: properly account for queue commands

Marko Kohtala (1):
      KVM: Fix hang on uniprocessor

Oliver Neukum (1):
      USB: make the microtek driver and HAL cooperate

Pablo Neira Ayuso (1):
      TEXTSEARCH: Do not allow zero length patterns in the textsearch infrastructure

Patrick McHardy (2):
      XFRM: Fix leak of expired xfrm_states
      NETFILTER: xt_TCPMSS: remove network triggerable WARN_ON

Pavel Emelyanov (3):
      BRIDGE: Lost call to br_fdb_fini() in br_init() error path
      DECNET: dn_nl_deladdr() almost always returns no error
      BRIDGE: Properly dereference the br_should_route_hook

Peter P Waskiewicz Jr (1):
      PKT_SCHED: Check subqueue status before calling hard_start_xmit

Rafael J. Wysocki (2):
      Freezer: Fix APM emulation breakage
      XFS: Make xfsbufd threads freezable

Sam Jansen (1):
      TCP: Problem bug with sysctl_tcp_congestion_control function

Scott James Remnant (1):
      wait_task_stopped(): pass correct exit_code to wait_noreap_copyout()

Sheng Yang (1):
      KVM: x86 emulator: implement 'movnti mem, reg'

Stephen Hemminger (1):
      TCP: illinois: Incorrect beta usage

Steven Rostedt (1):
      futex: fix for futex_wait signal stack corruption

Tejun Heo (1):
      libata: kill spurious NCQ completion detection

Thomas Gleixner (1):
      hrtimers: avoid overflow for large relative timeouts (CVE-2007-5966)

William Pettersson (1):
      Input: ALPS - add support for model found in Dell Vostro 1400

Zhao Yakui (1):
      PNP: increase the maximum number of resources

Zou Nan hai (1):
      sched: some proc entries are missed in sched_domain sys_ctl debug code

chas williams (1):
      ATM: [he] initialize lock and tasklet earlier

