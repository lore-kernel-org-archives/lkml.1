Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXIAGww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXIAGww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXIAGwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:52:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbXIAGwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:52:42 -0400
Date: Fri, 31 Aug 2007 23:52:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc5
Message-ID: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm making ready to leave for the kernel summit (as are probably a lot of 
other core kernel people), and as part of that, there's a 2.6.23-rc5 out 
there now.

Hopefully we've addressed most regressions, so please do give it a good 
testing.

The shortlog and diffstat are appended: the diffstat is uglified by some 
powerpc defconfig updates, but otherwise it all looks pretty nice and 
small. The shortlog is fairly informative if you care about the details of 
what changed, but it does end up boiling down to "fixing a number of 
generally pretty small issues". Mostly in drivers and SCTP.

So have fun, give it a go, and expect a quiet week next week.

		Linus

---
Adrian Bunk (2):
      Input: psmouse - make dummy touchkit_ps2_detect() static
      xtensa process.c must #include <linux/fs.h>

Alan Cox (2):
      libata-core: Allow translation setting to fail
      pata_marvell: Add more identifiers

Alexey Dobriyan (1):
      userns: don't leak root user

Alexey Starikovskiy (1):
      ACPI: EC: Check if boot_ec was really found in DSDT

Andre Detsch (1):
      [POWERPC] spufs: Don't call spu_run_init from spu_reacquire_runnable

Andrew Morton (3):
      Input: iforce - fix 'unused variable' warning
      revert "eCryptfs: fix lookup error for special files"
      process_zones(): fix recovery code

Andrew Victor (1):
      Fix typo in atmel_spi.c

Arjan van de Ven (1):
      [BNX2]: Use msleep().

Arnd Bergmann (1):
      [POWERPC] spufs: Fix update of mailbox status register during backed wbox write

Atsushi Nemoto (1):
      spi: correct name for spi_txx9

Bartlomiej Zolnierkiewicz (1):
      ata: add ATA_MWDMA* and ATA_SWDMA* defines

Christian Krafft (1):
      [POWERPC] spu_manage: fix spu_unit_number for celleb device tree

Christoph Lameter (3):
      SLUB: Force inlining for functions in slub_def.h
      slub: do not fail if we cannot register a slab with sysfs
      Page migration: Do not accept invalid nodes in the target nodeset

David Brownell (3):
      ARM: OMAP: fix OMAP1 dmtimer build warning
      ARM: OMAP: OSK led fixes
      SPI driver hotplug/coldplug fixes

David Gibson (1):
      hugepage: fix broken check for offset alignment in hugepage mappings

David S. Miller (3):
      [TCP]: Allow minimum RTO to be configurable via routing metrics.
      [SPARC64]: Fix type and constant sizes wrt. sun4u IMAP/ICLR handling.
      [SPARC64]: Fix several bugs in MSI handling.

Dirk Behme (1):
      ARM: OMAP: H3 workqueue fixes

Divy Le Ray (2):
      cxgb3 - Fix dev->priv usage
      - cxgb3 engine microcode load

Fernando Luis Vázquez Cao (1):
      Input: i8042 - fix retrun value of i8042_aux_test_irq

Frank Blaschka (2):
      qeth: enforce a rate limit for inbound scatter gather messages
      qeth: Announce tx checksumming for qeth devices in TSO/EDDP mode

H. Peter Anvin (1):
      [x86 setup] Don't rely on the VESA BIOS being register-clean

Heiko Carstens (1):
      qeth: dont return the return values of void functions.

Hugh Dickins (1):
      fix maxcpus=1 oops in show_stat()

Ingo Molnar (4):
      sched: make the scheduler converge to the ideal latency
      sched: fix wait_start_fair condition in update_stats_wait_end()
      sched: small schedstat fix
      sched: clean up task_new_fair()

Jan Kara (2):
      UDF: handle wrong superblock better
      Fix possible NULL pointer dereference in udf_table_free_blocks()

Jared Hulbert (1):
      [ARM] 4554/1: replace consistent_sync() with flush_ioremap_region()

Jarek Poplawski (1):
      request_irq: fix DEBUG_SHIRQ handling

Jason Gaston (1):
      ata_piix: IDE mode SATA patch for Intel Tolapai

Jeff Dike (2):
      uml: fix linker script alignment bugs
      uml: fix x86_64 core dump crash

Jeff Garzik (1):
      [libata] Bump driver versions

Jesper Bengtsson (1):
      [NETFILTER]: xt_tcpudp: fix wrong struct in udp_checkentry

Jesper Juhl (1):
      Input: gpio_keys - remove duplicate includes

Jiri Slaby (1):
      MAINTAINERS, order NETERION alphabetically

Joachim Fenkes (1):
      IB/ehca: SRQ fixes to enable IPoIB CM

Jonathan Lim (1):
      Assign task_struct.exit_code before taskstats_exit()

Juha Yrjola (2):
      ARM: OMAP2: Force APLLs always active
      ARM: OMAP: Enable serial idling and wakeup features

KAMEZAWA Hiroyuki (1):
      fix rcu_read_lock() in page migraton

Karl Olsen (1):
      [ARM] 4553/1: ARM at91: define FIQ_START

Kevin Hilman (1):
      ARM: OMAP: Fix 32k timer unsupported one-shot mode

Klaus D. Wacker (1):
      qeth: Drop ARP packages on HiperSockets interface with NOARP attribute.

Krzysztof Helt (1):
      [ARM] 4551/1: s3c24xx: fix wrong virtual address offsets

Kumar Gala (2):
      [POWERPC] Flush registers to proper task context
      [POWERPC] Update defconfigs

Linus Torvalds (3):
      Do not use the ia64 clocksource on non-ia64 architectures
      x86: be even more careful about checking the stack frame on dumping
      Linux 2.6.23-rc5

Lucas Nussbaum (1):
      [NET_SCHED] sch_prio.c: remove duplicate call of tc_classify()

Mariusz Kozlowski (1):
      Input: gscps2 - convert to use kzalloc

Masakazu Mokuno (2):
      [POWERPC] PS3: Fix bug where the major version part is not compared
      PS3: fix the bug that 'ifconfig down' would hang

Michael Chan (1):
      [BNX2]: Add write posting comment.

Mikael Pettersson (1):
      sata_promise: FastTrack TX4200 is a second-generation chip

Mike Galbraith (1):
      sched: fix sleeper bonus limit

Oleg Nesterov (2):
      setpgid(child) fails if the child was forked by sub-thread
      sigqueue_free: fix the race with collect_signal()

Paul Mackerras (1):
      [POWERPC] Update defconfigs

Pavel Emelyanov (1):
      [PKTGEN]: Remove write-only variable.

Pavel Pisa (2):
      [ARM] 4552/1: i.MX/MX1 GPIO output setup fix
      [ARM] 4561/1: i.MX/MX1 GPIO parenthes omission and input setup fix

Rafael J. Wysocki (1):
      PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION

Ralf Baechle (4):
      Fix font dependency for SGI Newport console driver
      Add MAINTAINERS entry for IOC3 serial driver
      Fix modpost warning in serial driver
      IOC3: Program UART predividers.

Randy Dunlap (1):
      MAINTAINERS: update DCO info

Robert Olsson (1):
      [PKTGEN]: Fix multiqueue oops.

Rusty Russell (1):
      Fix lguest page-pinning logic ("lguest: bad stack page 0xc057a000")

Ryusuke Konishi (1):
      eCryptfs: fix possible fault in ecryptfs_sync_page

Samuel (1):
      [ARM] 4557/1: Fix PXA irq gpio initialization

Shane Huang (1):
      i2c-piix4: Fix SB700 PCI device ID

Stefan Roscher (1):
      IB/ehca: Fix Small QP regressions

Stephen Hemminger (2):
      [BRIDGE]: Packets leaking out of disabled/blocked ports.
      [BRIDGE]: Fix OOPS when bridging device without ethtool.

Stephen Smalley (1):
      SELinux: clear parent death signal on SID transitions

Tejun Heo (3):
      ata_piix: add Satellite U200 to broken suspend list
      libata: implement BROKEN_HPA horkage and apply it to affected drives
      ata_piix: implement IOCFG bit18 quirk

Ting Yang (1):
      sched: call update_curr() in task_tick_fair()

Trond Myklebust (1):
      NFS: Fix the mount regression

Ursula Braun (3):
      qeth: ungrouping a device must not be interruptible
      qeth: crash during reboot after failing online setting
      qeth: provide specific message for OSA-adapters exclusively used

Vlad Yasevich (7):
      SCTP: properly clean up fragment and ordering queues during FWD-TSN.
      SCTP: Assign stream sequence numbers to the entire message
      SCTP: Pick the correct port when binding to 0.
      SCTP: Uncomfirmed transports can't become Inactive
      SCTP: Do not retransmit chunks that are newer then rtt.
      SCTP: Correctly disable listening when backlog is 0.
      SCTP: Abort on COOKIE-ECHO if backlog is exceeded.

Wei Yongjun (4):
      SCTP: Fix sctp_addto_chunk() to add pad with correct length
      SCTP: Fix to encode PROTOCOL VIOLATION error cause correctly
      SCTP: Use net_ratelimit to suppress error messages print too fast
      SCTP: Fix to handle invalid parameter length correctly

dhananjay@netxen.com (2):
      netxen: Avoid firmware load in PCI probe
      netxen: fix crashes during module unload
---
 Documentation/i2c/busses/i2c-piix4              |    2 +-
 MAINTAINERS                                     |   41 +-
 Makefile                                        |    2 +-
 arch/arm/Kconfig                                |    7 +-
 arch/arm/mach-imx/generic.c                     |    7 +-
 arch/arm/mach-omap1/board-h3.c                  |   12 +-
 arch/arm/mach-omap1/leds-osk.c                  |    6 +-
 arch/arm/mach-omap1/pm.c                        |   11 -
 arch/arm/mach-omap2/clock.c                     |   13 +-
 arch/arm/mach-omap2/serial.c                    |    2 +-
 arch/arm/mach-pxa/irq.c                         |    2 +-
 arch/arm/plat-omap/common.c                     |    2 +-
 arch/arm/plat-omap/dmtimer.c                    |    5 -
 arch/arm/plat-omap/timer32k.c                   |   10 +-
 arch/i386/boot/video-vesa.c                     |   34 +-
 arch/i386/kernel/traps.c                        |   33 +-
 arch/i386/mm/hugetlbpage.c                      |    2 +-
 arch/ia64/mm/hugetlbpage.c                      |    6 +-
 arch/mips/tx4938/toshiba_rbtx4938/setup.c       |    2 +-
 arch/powerpc/configs/celleb_defconfig           |  196 ++----
 arch/powerpc/configs/chrp32_defconfig           |  220 ++----
 arch/powerpc/configs/ebony_defconfig            |  190 ++----
 arch/powerpc/configs/g5_defconfig               |  208 ++----
 arch/powerpc/configs/holly_defconfig            |  203 ++----
 arch/powerpc/configs/iseries_defconfig          |  210 ++----
 arch/powerpc/configs/linkstation_defconfig      |  219 ++----
 arch/powerpc/configs/lite5200_defconfig         |  191 ++----
 arch/powerpc/configs/maple_defconfig            |  189 ++----
 arch/powerpc/configs/mpc7448_hpc2_defconfig     |  202 ++----
 arch/powerpc/configs/mpc8272_ads_defconfig      |  193 ++----
 arch/powerpc/configs/mpc8313_rdb_defconfig      |  224 ++----
 arch/powerpc/configs/mpc832x_mds_defconfig      |  209 ++----
 arch/powerpc/configs/mpc832x_rdb_defconfig      |  211 ++----
 arch/powerpc/configs/mpc834x_itx_defconfig      |  206 ++----
 arch/powerpc/configs/mpc834x_itxgp_defconfig    |  203 ++----
 arch/powerpc/configs/mpc834x_mds_defconfig      |  205 ++----
 arch/powerpc/configs/mpc836x_mds_defconfig      |  209 ++----
 arch/powerpc/configs/mpc8540_ads_defconfig      |  183 ++----
 arch/powerpc/configs/mpc8544_ds_defconfig       |  459 +++++++++++--
 arch/powerpc/configs/mpc8560_ads_defconfig      |  196 ++----
 arch/powerpc/configs/mpc8568mds_defconfig       |   43 +-
 arch/powerpc/configs/mpc85xx_cds_defconfig      |  198 ++----
 arch/powerpc/configs/mpc8641_hpcn_defconfig     |  880 ++++++++++++++++++-----
 arch/powerpc/configs/mpc866_ads_defconfig       |  174 ++----
 arch/powerpc/configs/mpc885_ads_defconfig       |  174 ++----
 arch/powerpc/configs/pasemi_defconfig           |  225 ++----
 arch/powerpc/configs/pmac32_defconfig           |  237 +++----
 arch/powerpc/configs/ppc64_defconfig            |  220 +++----
 arch/powerpc/configs/prpmc2800_defconfig        |  213 ++----
 arch/powerpc/configs/pseries_defconfig          |  205 ++----
 arch/powerpc/kernel/process.c                   |    6 +-
 arch/powerpc/platforms/cell/spu_manage.c        |    8 +
 arch/powerpc/platforms/cell/spufs/backing_ops.c |    3 +-
 arch/powerpc/platforms/cell/spufs/run.c         |    6 +-
 arch/powerpc/platforms/ps3/setup.c              |    3 +-
 arch/sparc64/kernel/irq.c                       |   27 +-
 arch/sparc64/kernel/pci.c                       |    1 -
 arch/sparc64/kernel/pci_sun4v.c                 |   18 +-
 arch/sparc64/mm/hugetlbpage.c                   |    2 +-
 arch/um/kernel/dyn.lds.S                        |   12 +-
 arch/um/kernel/uml.lds.S                        |   11 +-
 arch/um/os-Linux/sys-x86_64/registers.c         |   15 +
 arch/um/sys-x86_64/ptrace.c                     |    6 -
 arch/x86_64/defconfig                           |    1 -
 arch/xtensa/kernel/process.c                    |    1 +
 drivers/acpi/ec.c                               |    3 +-
 drivers/ata/ata_generic.c                       |    2 +-
 drivers/ata/ata_piix.c                          |   72 ++-
 drivers/ata/libata-core.c                       |   16 +-
 drivers/ata/pata_ali.c                          |    2 +-
 drivers/ata/pata_amd.c                          |    2 +-
 drivers/ata/pata_atiixp.c                       |    2 +-
 drivers/ata/pata_cs5520.c                       |    2 +-
 drivers/ata/pata_cs5530.c                       |    2 +-
 drivers/ata/pata_isapnp.c                       |    2 +-
 drivers/ata/pata_it821x.c                       |    2 +-
 drivers/ata/pata_marvell.c                      |    2 +
 drivers/ata/pata_mpc52xx.c                      |    2 +-
 drivers/ata/pata_pcmcia.c                       |    2 +-
 drivers/ata/pata_pdc2027x.c                     |    2 +-
 drivers/ata/pata_platform.c                     |    2 +-
 drivers/ata/pata_sc1200.c                       |    2 +-
 drivers/ata/pata_scc.c                          |    2 +-
 drivers/ata/pata_serverworks.c                  |    2 +-
 drivers/ata/pata_sil680.c                       |    2 +-
 drivers/ata/pata_sl82c105.c                     |    2 +-
 drivers/ata/pdc_adma.c                          |    2 +-
 drivers/ata/sata_inic162x.c                     |    2 +-
 drivers/ata/sata_mv.c                           |    2 +-
 drivers/ata/sata_nv.c                           |    2 +-
 drivers/ata/sata_promise.c                      |    6 +-
 drivers/ata/sata_qstor.c                        |    2 +-
 drivers/ata/sata_sil.c                          |    2 +-
 drivers/ata/sata_sil24.c                        |    2 +-
 drivers/ata/sata_sis.c                          |    2 +-
 drivers/ata/sata_svw.c                          |    2 +-
 drivers/ata/sata_sx4.c                          |    2 +-
 drivers/ata/sata_uli.c                          |    2 +-
 drivers/ata/sata_via.c                          |    2 +-
 drivers/ata/sata_vsc.c                          |    2 +-
 drivers/char/hpet.c                             |    3 +
 drivers/i2c/busses/Kconfig                      |    1 +
 drivers/i2c/busses/i2c-piix4.c                  |    6 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_hca.c           |   10 +-
 drivers/infiniband/hw/ehca/ehca_irq.c           |   48 +-
 drivers/infiniband/hw/ehca/ehca_qp.c            |   10 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c          |    2 +-
 drivers/input/joystick/iforce/iforce-packets.c  |    8 +-
 drivers/input/keyboard/gpio_keys.c              |    1 -
 drivers/input/mouse/touchkit_ps2.h              |    3 +-
 drivers/input/serio/gscps2.c                    |    6 +-
 drivers/input/serio/i8042.c                     |    4 +-
 drivers/lguest/interrupts_and_traps.c           |    7 +-
 drivers/mtd/maps/lubbock-flash.c                |    6 +-
 drivers/mtd/maps/mainstone-flash.c              |    5 +-
 drivers/net/bnx2.c                              |   10 +-
 drivers/net/cxgb3/adapter.h                     |    2 +
 drivers/net/cxgb3/common.h                      |    3 +-
 drivers/net/cxgb3/cxgb3_main.c                  |  252 ++++---
 drivers/net/cxgb3/cxgb3_offload.c               |   16 +-
 drivers/net/cxgb3/cxgb3_offload.h               |    2 +
 drivers/net/cxgb3/sge.c                         |   23 +-
 drivers/net/cxgb3/t3_hw.c                       |   46 +-
 drivers/net/cxgb3/t3cdev.h                      |    3 -
 drivers/net/ioc3-eth.c                          |   80 ++-
 drivers/net/netxen/netxen_nic_hdr.h             |    6 +-
 drivers/net/netxen/netxen_nic_hw.c              |    8 +-
 drivers/net/netxen/netxen_nic_main.c            |   19 +-
 drivers/net/ps3_gelic_net.c                     |    1 -
 drivers/s390/net/qeth.h                         |    4 +-
 drivers/s390/net/qeth_main.c                    |  158 +++-
 drivers/s390/net/qeth_mpc.h                     |    1 +
 drivers/s390/net/qeth_sys.c                     |    8 +-
 drivers/serial/8250_pci.c                       |    2 +-
 drivers/spi/atmel_spi.c                         |    2 +-
 drivers/spi/spi_bfin5xx.c                       |    3 +-
 drivers/spi/spi_imx.c                           |    2 +-
 drivers/spi/spi_mpc83xx.c                       |    1 +
 drivers/spi/spi_s3c24xx.c                       |    1 +
 drivers/spi/spi_s3c24xx_gpio.c                  |    2 +-
 drivers/spi/spi_txx9.c                          |    2 +-
 drivers/spi/xilinx_spi.c                        |    2 +-
 drivers/video/console/Kconfig                   |    2 +-
 fs/ecryptfs/inode.c                             |    4 -
 fs/ecryptfs/mmap.c                              |    3 +-
 fs/hugetlbfs/inode.c                            |   15 +-
 fs/nfs/super.c                                  |  110 ++--
 fs/udf/balloc.c                                 |   10 +-
 fs/udf/super.c                                  |   26 +-
 include/asm-arm/arch-at91/irqs.h                |    3 +
 include/asm-arm/arch-omap/irda.h                |    1 +
 include/asm-arm/cacheflush.h                    |    7 +
 include/asm-arm/plat-s3c/map.h                  |   12 +-
 include/asm-sparc64/device.h                    |    2 -
 include/asm-sparc64/irq.h                       |   25 +-
 include/asm-um/common.lds.S                     |  124 ++--
 include/asm-um/elf-x86_64.h                     |   40 +
 include/linux/ata.h                             |   13 +
 include/linux/cpu.h                             |    6 +-
 include/linux/hugetlb.h                         |   10 +-
 include/linux/libata.h                          |    1 +
 include/linux/pci_ids.h                         |    3 +-
 include/linux/rtnetlink.h                       |    2 +
 include/linux/sched.h                           |    1 +
 include/linux/slub_def.h                        |    8 +-
 include/net/sctp/sm.h                           |    2 +-
 include/net/sctp/structs.h                      |    1 +
 include/net/sctp/ulpqueue.h                     |    1 +
 init/main.c                                     |    8 -
 kernel/cpu.c                                    |    4 +-
 kernel/exit.c                                   |    2 +-
 kernel/irq/manage.c                             |   11 +-
 kernel/power/Kconfig                            |   41 +-
 kernel/sched.c                                  |    1 +
 kernel/sched_fair.c                             |   46 +-
 kernel/signal.c                                 |   19 +-
 kernel/sys.c                                    |    3 +-
 kernel/user_namespace.c                         |    1 +
 mm/mempolicy.c                                  |    5 +
 mm/migrate.c                                    |   11 +-
 mm/page_alloc.c                                 |    2 +
 mm/slub.c                                       |    8 +-
 net/bridge/br_fdb.c                             |    5 +
 net/bridge/br_if.c                              |   16 +-
 net/bridge/br_input.c                           |    3 +-
 net/core/pktgen.c                               |    8 +-
 net/ipv4/tcp_input.c                            |   14 +-
 net/netfilter/xt_tcpudp.c                       |    2 +-
 net/sched/sch_prio.c                            |    2 +-
 net/sctp/associola.c                            |    7 +-
 net/sctp/outqueue.c                             |    7 +
 net/sctp/sm_make_chunk.c                        |  112 ++-
 net/sctp/sm_sideeffect.c                        |    8 +-
 net/sctp/sm_statefuns.c                         |   51 +-
 net/sctp/socket.c                               |    3 +
 net/sctp/ulpqueue.c                             |   75 ++-
 security/selinux/hooks.c                        |    3 +
 198 files changed, 4253 insertions(+), 5011 deletions(-)
