Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYJ2Gi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYJ2Gi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ2Gio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:38:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYJ2Gik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:38:40 -0400
Date: Tue, 28 Oct 2008 23:38:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc2-mm1
Message-Id: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/

- Various architectures don't compile very well.  ia64, alpha, s390,
  arm.  ftrace seems to be a particular culprit.

- But it seems to work OK on the six machines I ran it on.




Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://userweb.kernel.org/~akpm/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.  These probably are at least compilable.

- More-than-daily -mm snapshots may be found at
  http://userweb.kernel.org/~akpm/mmotm/.  These are almost certainly not
  compileable.


All patches:

    origin.patch
	2.6.28-rc2 -> mainline

2.6.28 queue:

    mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
      mm: increase the default mlock limit from 32k to 64k
    
    viafb-removed-duplicated-includes.patch
      viafb: removed duplicated #include's
    
    gitignore-updates.patch
      .gitignore updates
    
    edac-x38-new-mc-driver-module.patch
      edac x38: new MC driver module
    
    epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
      epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes
    
    freezer_cg-fix-improper-bug_on-causing-oops.patch
      freezer_cg: fix improper BUG_ON() causing oops
    
    freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
      freezer_cg: remove redundant check in freezer_can_attach()
    
    freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
      freezer_cg: use thaw_process() in unfreeze_cgroup()
    
    freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
      freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
    
    freezer_cg-simplify-freezer_change_state.patch
      freezer_cg: simplify freezer_change_state()
    
    cgroups-tiny-cleanups.patch
      cgroups: tiny cleanups
    
    fs-remove-prepare_write-commit_write.patch
      fs: remove prepare_write/commit_write
    
    fs-remove-prepare_write-commit_write-fix.patch
      fs-remove-prepare_write-commit_write-fix
    
    mm-write_cache_pages-writepage-error-fix.patch
      mm: write_cache_pages() writepage error fix
    
    docbook-fix-command-spacing.patch
      docbook: fix command spacing
    
    docs-fix-managementstyle-book-name.patch
      docs: fix ManagementStyle book name
    
    rtc-s3c-fix-section-mismatch-warnings.patch
      rtc-s3c: fix section mismatch warnings
    
    edac-fix-enabling-of-polling-cell-module.patch
      edac: fix enabling of polling cell module
    
    fbcon-dont-inline-updatescrollmode.patch
      fbcon: don't inline updatescrollmode
    
    linux-ratelimith-fixed-missing-initializer-warning.patch
      linux/ratelimit.h: fixed "missing initializer" warning
    
    sony-laptop-ignore-missing-_dis-method-on-pic-device.patch
      sony-laptop: ignore missing _DIS method on pic device
    
    init-do_mounts_mdc-msleep-compile-fix.patch
      init/do_mounts_md.c: msleep compile fix
    
    hdpuftrs-fix-build.patch
      hdpuftrs: fix build
    
    memcg-update-menuconfig-help-text.patch
      memcg: update menuconfig help text
    
    kernel-profile-fix-profile_init-section-mismatch.patch
      kernel/profile: fix profile_init() section mismatch
    
    ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs.patch
      ecryptfs: fix memory corruption when storing crypto info in xattrs
    
    i2o-fix-kernel-doc-warnings.patch
      i2o: fix kernel-doc warnings
    
    mm-fix-kernel-doc-function-notation.patch
      mm: fix kernel-doc function notation
    
    fs-remove-excess-kernel-doc.patch
      fs: remove excess kernel-doc
    
    kill-sig-1-must-only-apply-to-callers-namespace.patch
      'kill sig -1' must only apply to caller's namespace
    
    sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2.patch
      sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified
    
    maintainers-add-ltp-info-to-the-list.patch
      MAINTAINERS: add LTP info to the list
    
    rtc-ds3234-doesnt-link-when-built-in.patch
      rtc: ds3234 doesn't link when built-in
    
    rationalise-randys-address-a-bit.patch
      Rationalise Randy's address a bit
    
    kernelh-fix-might_sleep-kernel-doc.patch
      kernel.h: fix might_sleep kernel-doc
    
    rtc-s3c-add-device_init_wakeup-invokation.patch
      rtc S3C: add device_init_wakeup() invokation
    
    framebuffer-compat_ioctl-deadlock.patch
      framebuffer compat_ioctl deadlock
    
    ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si.patch
      ipmi: add MODULE_ALIAS to load ipmi_devintf with ipmi_si
    
    nfsd-fix-vm-overcommit-crash.patch
      nfsd: fix vm overcommit crash
    
    nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch
      nfsd-fix-vm-overcommit-crash-checkpatch-fixes
    
    nfsd-fix-vm-overcommit-crash-fix.patch
      nfsd-fix-vm-overcommit-crash-fix

mm-only stuff:

    mm-remove-the-might_sleep-from-lock_page.patch
      mm: remove the might_sleep() from lock_page()
    
    repeatable-slab-corruption-with-ltp-msgctl08.patch
      Re: repeatable slab corruption with LTP msgctl08

linux-next:
    
    linux-next.patch
      linux-next.patch
    
    linux-next-git-rejects.patch
      linux-next-git-rejects
    
    linux-next-rejects.patch
      linux-next-rejects
    
    next-remove-localversion.patch
      next: remove localversion

Things for subsystem trees:
    
    ia64-fix-arch-ia64-kernel-iosapicc-build.patch
      ia64: fix arch/ia64/kernel/iosapic.c build
    
    drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
      drivers/i2c/busses/i2c-s3c2410.c: Correct use of ! and &
    
    fujitsu-laptop-fix-section-mismatch-warning.patch
      fujitsu-laptop: fix section mismatch warning
    
    acpi-compal-laptop-use-rfkill-switch-subsystem.patch
      acpi: compal-laptop: use rfkill switch subsystem
    
    acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
      compal-laptop: depends on RKFILL
    
    drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch
      drivers/idle/: memory power in config; show up only when it applies
    
    acpi-use-macro-to-replace-hard-number.patch
      acpi: use macro to replace hard number
    
    mm-only-enforce-acpi-resource-conflict-checks.patch
      Enforce ACPI resource conflict checks
    
    x86-remove-init_mm-export-as-planned-for-2626.patch
      x86: remove init_mm export as planned for 2.6.26
    
    x86_64-add-memory-hotremove-config-option.patch
      x86_64: add memory hotremove config option
    
    arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
      arch/x86/kernel/setup.c: omit dmi_low_memory_corruption() when it is unneeded
    
    kvmclockc-fix-section-mismatch-warning.patch
      kvmclock.c: fix section mismatch warning
    
    kgdb-fix-kernel-doc-error.patch
      kgdb: fix kernel-doc error
    
    agp-follow-lspci-device-vendor-style.patch
      agp: follow lspci device/vendor style
    
    intel-agp-avoid-oops-for-g33-on-1mb-stolen-case.patch
      intel-agp: avoid oops for G33 on 1MB stolen case
    
    ep93xx-fix-ohci-dma-mask.patch
      ep93xx: fix OHCI DMA mask
    
    gpio_free-might-sleep-arm-architecture.patch
      gpio_free might sleep, arm architecture
    
    audit-remove-excess-kernel-doc.patch
      audit: remove excess kernel-doc
    
    cifs-remove-global_extern-macro.patch
      cifs: remove GLOBAL_EXTERN macro
    
    cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch
      cpu-freq/Documentation: add Blackfin to list of supported processors
    
    pcmcia-pccard-deadlock-fix.patch
      pcmcia/pccard deadlock fix
    
    anysee-initialize-anysee_usb_mutex-statically.patch
      anysee: initialize anysee_usb_mutex statically
    
    tick-schedc-suppress-needless-timer-reprogramming.patch
      tick-sched.c: suppress needless timer reprogramming
    
    ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch
      ia64: fix the difference between node_mem_map and node_start_pfn
    
    ia64-use-common-header-for-software-io-tlb.patch
      ia64: use common header for software IO/TLB
    
    linux-timexh-cleanup-for-userspace.patch
      linux/timex.h: cleanup for userspace
    
    linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
      linux-timexh-cleanup-for-userspace-checkpatch-fixes
    
    drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
      drivers/input/touchscreen/ucb1400_ts.c needs GPIO
    
    input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
      input/touchscreen driver: add support AD7877 touchscreen driver
    
    input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5.patch
      Input/Touchscreen Driver: add support AD7877 touchscreen driver (try #5)
    
    input-ads7846c-sparse-lock-annotation.patch
      input: ads7846.c sparse lock annotation
    
    serio_raw-add-support-for-translated-serio_i8042xl-ports.patch
      serio_raw: add support for translated (SERIO_I8042XL) ports
    
    input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
      input: mousedev: distinguish a moving finger from a tapping finger
    
    i8042-add-blue-fb5601-to-noloop-execption-table.patch
      i8042: add Blue FB5601 to noloop exception table
    
    input-ad7879-touchscreen-driver.patch
      input: AD7879 Touchscreen driver
    
    genksyms-track-symbol-checksum-changes.patch
      genksyms: track symbol checksum changes
    
    genksyms-allow-to-ignore-symbol-checksum-changes.patch
      genksyms: allow to ignore symbol checksum changes
    
    lkdtm-fix-for-config_scsi=n.patch
      lkdtm: fix for CONFIG_SCSI=n
    
    scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch
      scripts/package: don't break if %{_smp_mflags} isn't set
    
    scripts-package-allow-custom-options-to-rpm.patch
      scripts/package: allow custom options to rpm
    
    scripts-checksyscallssh-fix-for-non-gnu-sed.patch
      scripts/checksyscalls.sh: fix for non-gnu sed
    
    adjust-init-section-definitions.patch
      adjust init section definitions
    
    tags-skip-in-filenames.patch
      tags: skip ./ in filenames
    
    kbuild-fix-kbuild_extra_symbols.patch
      kbuild: fix KBUILD_EXTRA_SYMBOLS
    
    kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
      kbuild: prevent modpost from looking for a .cmd file for a static library linked into a module
    
    fix-incompatibility-with-versions-of-perl-less-than-560.patch
      Fix incompatibility with versions of Perl less than 5.6.0
    
    kconfig-add-module_name-shortcut.patch
      kconfig: add module_name shortcut
    
    setlocalversion-dont-include-svn-change-count.patch
      setlocalversion: don't include svn change count
    
    led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
      led: driver for LEDs on PCEngines ALIX.2 and ALIX.3 boards
    
    leds-pca9532-mark-pca9532_event-static.patch
      leds-pca9532: mark pca9532_event() static
    
    m32r-kernel-smpbootc-must-include-linux-cpuh.patch
      m32r/kernel/smpboot.c must #include <linux/cpu.h>
    
    mips-use-the-new-byteorder-headers.patch
      mips: use the new byteorder headers
    
    drivers-rtc-rtc-ds1286c-is-borked.patch
      drivers/rtc/rtc-ds1286.c is borked
    
    drivers-rtc-rtc-m48t35c-is-borked-too.patch
      drivers/rtc/rtc-m48t35.c is borked too
    
    mmc-fix-clock-off-in-pxa255-270.patch
      mmc: fix clock-off in PXA255/270
    
    pci-use-pci_ioremap_bar-in-drivers-mmc.patch
      pci: use pci_ioremap_bar() in drivers/mmc
    
    forcedeth-power-down-phy-when-interface-is-down.patch
      forcedeth: power down phy when interface is down
    
    forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
      forcedeth: fix MAC address detection on network card (regression in 2.6.23)
    
    skge-adapt-skge-to-use-reworked-pci-pm.patch
      skge: adapt skge to use reworked PCI PM
    
    the-overdue-eepro100-removal.patch
      the overdue eepro100 removal
    
    forcdeth-increase-max_interrupt_work.patch
      forcdeth: increase max_interrupt_work
    
    drivers-net-sfc-falconc-fix-min-warnings.patch
      drivers/net/sfc/falcon.c: fix min() warnings
    
    e100-adapt-to-the-reworked-pci-pm.patch
      e100: adapt to the reworked PCI PM
    
    e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
      e1000e: make E1000E default to the same kconfig setting as E1000
    
    3x59x-fix-pci-resource-management.patch
      3c59x: fix PCI resource management
    
    smc-ultra-get-rid-of-eth%d-message.patch
      smc-ultra: get rid of "eth%d" message
    
    gpio_free-might-sleep-blackfin-architecture.patch
      gpio_free might sleep, blackfin architecture
    
    blackfin-remove-__function__-in-new-serial-driver.patch
      blackfin: remove __FUNCTION__ in new serial driver
    
    blackfin-remove-__function__-in-video-driver.patch
      blackfin: remove __FUNCTION__ in video driver
    
    ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
      ext4: fix a bug accessing freed memory in ext4_abort
    
    ocfs2-truncate-outstanding-block-after-direct-io-failure.patch
      ocfs2: truncate outstanding block after direct io failure
    
    parisc-lib-make-code-static.patch
      parisc/lib/: make code static
    
    drivers-parisc-make-code-static.patch
      drivers/parisc/: make code static
    
    piix3-warn-softer-about-enabling-passive-release.patch
      piix3: warn softer about enabling passive release
    
    pci-uninline-pci_ioremap_bar.patch
      pci: uninline pci_ioremap_bar()
    
    mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch
      mutex: improve header comment to be actually informative about the API
    
    sh-use-the-new-byteorder-headers.patch
      sh: use the new byteorder headers
    
    if-0-ses_match_host.patch
      #if 0 ses_match_host()
    
    scsi-replace-__inline-with-inline.patch
      scsi: replace __inline with inline
    
    mpt-remove-unused-struct-mpt_proc_entry_t.patch
      MPT: remove unused struct -- mpt_proc_entry_t
    
    scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
      scsi: use the common hex_asc array rather than a private one
    
    drivers-scsi-a2091c-make-2-functions-static.patch
      drivers/scsi/a2091.c: make 2 functions static
    
    drivers-scsi-a3000c-make-2-functions-static.patch
      drivers/scsi/a3000.c: make 2 functions static
    
    drivers-scsi-use-div_round_up.patch
      drivers/scsi: Use DIV_ROUND_UP
    
    drivers-scsi-megaraid-use-div_round_up.patch
      drivers/scsi/megaraid: Use DIV_ROUND_UP
    
    scsi-gdthc-use-unaligned-access-helpers.patch
      scsi: gdth.c use unaligned access helpers
    
    scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
      scsi: annotate gdth_rdcap_data, gdth_rdcap16_data endianness
    
    gdth-fix-section-mismatch-warnings.patch
      gdth: fix section mismatch warnings
    
    esp-fix-section-mismatch-warning.patch
      esp: fix section mismatch warning
    
    scsi-remove-private-implementation-of-get_unaligned_be32.patch
      scsi: remove private implementation of get_unaligned_be32
    
    scsi-fix-bad-use-of-udelay-in-atp870uc.patch
      scsi: fix bad use of udelay in atp870u.c
    
    u14-34f-fix-scsi_dma_map-failure-case.patch
      U14-34F: fix scsi_dma_map failure case
    
    megaraid-fix-mega_internal_command-oops.patch
      megaraid: fix mega_internal_command oops
    
    scsi-ioctl-fix-kernel-doc-warning.patch
      scsi ioctl: fix kernel-doc warning
    
    cciss-new-hardware-support.patch
      cciss: new hardware support
    
    cpqarry-fix-return-value-of-cpqarray_init.patch
      cpqarry: fix return value of cpqarray_init()
    
    block-remove-excess-kernel-doc.patch
      block: remove excess kernel-doc
    
    sparc-use-the-new-byteorder-headers.patch
      sparc: use the new byteorder headers
    
    usb-protect-hcdh-from-multiple-inclusions.patch
      usb: protect hcd.h from multiple inclusions
    
    drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch
      drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
    
    usb-add-nikon-d300-camera-to-unusual_devs.patch
      usb: add Nikon D300 camera to unusual_devs
    
    usb-avoid-needless-address-taking-of-function-parameters.patch
      usb: avoid needless address-taking of function parameters
    
    vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
      vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
    
    include-linux-fsh-put-declarations-in-__kernel__.patch
      include: linux/fs.h: put declarations in __KERNEL__
    
    fs-namespacec-drop-code-after-return.patch
      fs/namespace.c: drop code after return
    
    introduce-new-lsm-hooks-where-vfsmount-is-available.patch
      vfs: introduce new LSM hooks where vfsmount is available.
    
    introduce-new-lsm-hooks-where-vfsmount-is-available-update.patch
      introduce-new-lsm-hooks-where-vfsmount-is-available update
    
    fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch
      fs/block_dev.c: __read_mostly improvement and sb_is_blkdev_sb utilization
    
    fs-fix-inodec-kernel-doc-warnings.patch
      fs: fix inode.c kernel-doc warnings
    
    kill-suid-bit-only-for-regular-files.patch
      kill suid bit only for regular files
    
    pika-warp-appliance-watchdog-timer.patch
      Pika Warp appliance watchdog timer
    
    mm.patch
      add -mmN to EXTRAVERSION

More 2.6.28 material:
    
    vt-incomplete-initialization-of-vc_tab_stop.patch
      vt: incomplete initialization of vc_tab_stop
    
    rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch
      rtc: fix handling of missing tm_year data when reading alarms
    
    hwmon-applesmc-add-support-for-imac-5.patch
      hwmon: applesmc: add support for iMac 5
    
    hwmon-applesmc-add-support-for-macbook-5.patch
      hwmon: applesmc: add support for Macbook 5
    
    hwmon-applesmc-add-support-for-macbook-pro-5.patch
      hwmon: applesmc: Add support for Macbook Pro 5
    
    hwmon-applesmc-add-support-for-imac-8.patch
      hwmon: applesmc: add support for iMac 8
    
    autofs4-correct-offset-mount-expire-check.patch
      autofs4: correct offset mount expire check
    
    autofs4-collect-version-check-return.patch
      autofs4: collect version check return
    
    autofs4-collect-version-check-return-checkpatch-fixes.patch
      autofs4-collect-version-check-return-checkpatch-fixes
    
    cciss-fix-sysfs-broken-symlink-regression.patch
      cciss: fix sysfs broken symlink regression
    
    cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
      cciss: fix regression firmware not displayed in procfs
    
    hugetlbfs-handle-pages-higher-order-than-max_order.patch
      hugetlbfs: handle pages higher order than MAX_ORDER
    
    hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch
      hugetlb: pull gigantic page initialisation out of the default path
    
    maintainers-make-ioat-easier-to-find.patch
      MAINTAINERS: make IOAT easier to find
    
    oom-do-not-dump-task-state-for-non-thread-group-leaders.patch
      oom: do not dump task state for non thread group leaders
    
    add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs.patch
      fbdev: add new framebuffer driver for Fujitsu MB862xx GDCs
    
    add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2.patch
      fbdev: Fujitsu MB862xx framebuffer driver i386 allmodconfig fix
    
    ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch
      ext3: fix a bug accessing freed memory in ext3_abort
    
    fat-document-additional-vfat-mount-options.patch
      fat: document additional vfat mount options
    
    fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
      fat: move fs/vfat/* and fs/msdos/* to fs/fat
    
    fat-split-include-msdos_fsh.patch
      fat: split include/msdos_fs.h
    
    fat-fix-and-cleanup-timestamp-conversion.patch
      fat: Fix and cleanup timestamp conversion
    
    fat-use-generic_file_llseek-for-directory.patch
      fat: use generic_file_llseek() for directory
    
    fat-cleanup-fat_parse_long-error-handling.patch
      fat: cleanup fat_parse_long() error handling
    
    fat-improve-fat_hash.patch
      fat: improve fat_hash()
    
    fat-fix-fat_ent_update_ptr-for-fat12.patch
      fat: Fix fat_ent_update_ptr() for FAT12
    
    fat-use-fat_detach-in-fat_clear_inode.patch
      fat: use fat_detach() in fat_clear_inode()
    
    vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
      vfat: Fix vfat_find() error path in vfat_lookup()
    
    fat-fix-cleanup-dcache-handling-for-vfat.patch
      fat: Fix/Cleanup dcache handling for vfat
    
    fat-kill-d_invalidate-in-vfat_lookup.patch
      fat: Kill d_invalidate() in vfat_lookup()
    
    fat-cleanup-msdos_lookup.patch
      fat: Cleanup msdos_lookup()
    
    fat-cleanup-fat-attribute-stuff.patch
      fat: Cleanup FAT attribute stuff
    
    fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
      fat: Fix ATTR_RO in the case of (~umask & S_WUGO) == 0
    
    fat-fix-attr_ro-for-directory.patch
      fat: Fix ATTR_RO for directory
    
    fat-fix-_fat_bmap-race.patch
      fat: Fix _fat_bmap() race
    
    fat-add-printf-attribute-to-fat_fs_panic.patch
      fat: Add printf attribute to fat_fs_panic()
    
    fat-mmu_private-race-fix.patch
      fat: mmu_private race fix
    
    fat-i_pos-race-fix.patch
      fat: ->i_pos race fix
    
    fat-i_blocks-warning-fix.patch
      fat: i_blocks warning fix
    
    mm-move-migrate_prep-out-from-under-mmap_sem.patch
      mm: move migrate_prep out from under mmap_sem
    
    vmemmap-warn-about-page_structs-with-remote-distance.patch
      vmemmap: warn about page_structs with remote distance
    
    reintroduce-accept4.patch
      reintroduce accept4

mm-only:
    
    scsi-dpt_i2o-is-bust-on-ia64.patch
      scsi: dpt_i2o is bust on ia64

More 2.6.28 material:
    
    posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
      posix-timers: use "struct pid*" instead of "struct task_struct*"
    
    posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
      posix-timers: check ->it_signal instead of ->it_pid to validate the timer
    
    posix-timers-simplify-de_thread-exit_itimers-path.patch
      posix-timers: simplify de_thread()->exit_itimers() path

2.6.29 material:

(Some of this is 2.6.28 - I need to go through it)
    
    mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
      mm: report the pagesize backing a VMA in /proc/pid/smaps
    
    mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
      mm: report the MMU pagesize in /proc/pid/smaps
    
    mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
      mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix
    
    mm-dont-mark_page_accessed-in-fault-path.patch
      mm: don't mark_page_accessed in fault path
    
    mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
      mm: rework do_pages_move() to work on page_sized chunks
    
    mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch
      mm-rework-do_pages_move-to-work-on-page_sized-chunks update
    
    mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch
      mm: move_pages: no need to set pp->page to ZERO_PAGE(0) by default
    
    mm-invoke-oom-killer-from-page-fault.patch
      mm: invoke oom-killer from page fault
    
    mm-invoke-oom-killer-from-page-fault-fix.patch
      mm-invoke-oom-killer-from-page-fault-fix
    
    mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
      mm-invoke-oom-killer-from-page-fault-fix-fix-2
    
    oom-fix-zone_scan_mutex-name.patch
      oom: fix zone_scan_mutex name
    
    oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
      oom: print triggering task's cpuset and mems allowed
    
    fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch
      fs: truncate blocks outside i_size after generic_file_direct_write error
    
    fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
      fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix
    
    m68knommu-use-the-new-byteorder-headers.patch
      m68knommu: use the new byteorder headers
    
    cris-use-the-new-byteorder-headers.patch
      cris: use the new byteorder headers
    
    init-properly-placing-noinline-keyword.patch
      init: properly placing noinline keyword
    
    atomic_t-unify-all-arch-definitions.patch
      atomic_t: unify all arch definitions
    
    pci-use-pci_ioremap_bar-in-drivers-misc.patch
      pci: use pci_ioremap_bar() in drivers/misc
    
    check-fops_get-return-value.patch
      Check fops_get() return value
    
    checkpatch-add-checks-for-in_atomic.patch
      checkpatch: add checks for in_atomic()
    
    checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
      checkpatch: comment detection may miss an implied comment on the last hunk
    
    checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
      checkpatch: widen implied comment detection to allow multiple stars
    
    checkpatch-structure-member-assignments-are-not-complex.patch
      checkpatch: structure member assignments are not complex
    
    checkpatch-__weak-is-an-official-attribute.patch
      checkpatch: __weak is an official attribute
    
    checkpatch-detect-multiple-bitfield-declarations.patch
      checkpatch: detect multiple bitfield declarations
    
    checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
      checkpatch: comment ends inside strings is most likely not an open comment
    
    checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
      checkpatch: dissallow spaces between stars in pointer types
    
    checkpatch-version-025.patch
      checkpatch: version: 0.25
    
    lis3lv02dx-accelerometer-driver.patch
      LIS3LV02Dx Accelerometer driver
    
    lis3lv02dx-accelerometer-driver-fix.patch
      LIS3LV02D: Conform to the new ACPI API
    
    ibmpex-add-endian-annotation-to-extract_data-helper.patch
      ibmpex: add endian annotation to extract_data() helper
    
    pci-use-pci_ioremap_bar-in-drivers-serial.patch
      pci: use pci_ioremap_bar() in drivers/serial
    
    max3100-spi-uart-driver.patch
      MAX3100 SPI UART driver
    
    max3100-spi-uart-driver-fix.patch
      max3100-spi-uart-driver fix
    
    spi_gpio-driver.patch
      spi_gpio driver
    
    spi_gpio-driver-cleanups.patch
      spi_gpio-driver cleanups
    
    kprobes-indirectly-call-kprobe_target.patch
      kprobes: indirectly call kprobe_target
    
    kprobes-add-tests-for-register_kprobes.patch
      kprobes: add tests for register_kprobes
    
    autofs4-improve-parameter-usage.patch
      autofs4: improve parameter usage
    
    autofs4-fix-var-shadowed-by-local-delaration.patch
      autofs4: fix var shadowed by local delaration
    
    autofs4-make-autofs-type-usage-explicit.patch
      autofs4: make autofs type usage explicit
    
    autofs4-fix-string-validation-check-order.patch
      autofs4: fix string validation check order
    
    rtc-ds1307-smbus-compatibility.patch
      rtc-ds1307: SMBus compatibility
    
    rtc-ds1307-remove-legacy-probe-checks.patch
      rtc-ds1307: remove legacy probe() checks
    
    add-dallas-ds1390-93-94-rtc-chips.patch
      rtc: add Dallas DS1390/93/94 RTC chips
    
    rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
      rtc: rtc-wm8350: add support for WM8350 RTC
    
    rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch
      rtc-rtc-wm8350-add-support-for-wm8350-rtc update 2
    
    rtc-remove-the-bkl.patch
      RTC: remove the BKL
    
    rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
      rtc: basic implementation of Epson RX-8581 I2C Real Time Clock
    
    rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
      rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix
    
    pci-use-pci_ioremap_bar-in-drivers-video.patch
      pci: use pci_ioremap_bar() in drivers/video
    
    fbdev-fix-typo-in-drivers-video-modedbc.patch
      fbdev: fix typo in drivers/video/modedb.c
    
    intelfb-support-i854.patch
      intelfb: support i854
    
    ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms.patch
      ext3: add support for non-native signed/unsigned htree hash algorithms
    
    quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch
      quota: add callbacks for allocating and destroying dquot structures
    
    quota-increase-size-of-variables-for-limits-and-inode-usage.patch
      quota: increase size of variables for limits and inode usage
    
    quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
      quota: remove bogus 'optimization' in check_idq() and check_bdq()
    
    quota-make-_suspended-just-a-flag.patch
      quota: make _SUSPENDED just a flag
    
    quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
      quota: permit separately enabling quota accounting and enforcing limits
    
    ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
      ext3: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
    
    ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
      ext4: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
    
    reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
      reiserfs: use sb_any_quota_loaded() instead of sb_any_quota_enabled()
    
    quota-remove-compatibility-function-sb_any_quota_enabled.patch
      quota: remove compatibility function sb_any_quota_enabled()
    
    quota-introduce-dquot_quota_sys_file-flag.patch
      quota: introduce DQUOT_QUOTA_SYS_FILE flag
    
    quota-move-quotaio_vh-from-include-linux-to-fs.patch
      quota: move quotaio_v[12].h from include/linux/ to fs/
    
    quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
      quota-move-quotaio_vh-from-include-linux-to-fs-fix
    
    quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
      quota: more headers_check hackarounds
    
    quota-split-off-quota-tree-handling-into-a-separate-file.patch
      quota: split off quota tree handling into a separate file
    
    quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
      quota: convert union in mem_dqinfo to a pointer
    
    quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
      quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup
    
    quota-support-64-bit-quota-format.patch
      quota: support 64-bit quota format
    
    quota-support-64-bit-quota-format-fix.patch
      quota-support-64-bit-quota-format-fix
    
    quota-support-64-bit-quota-format-fix-2.patch
      quota-support-64-bit-quota-format-fix-2
    
    cgroups-make-cgroup-config-a-submenu.patch
      cgroups: make cgroup config a submenu
    
    memcg-introduce-charge-commit-cancel-style-of-functions.patch
      memcg: introduce charge-commit-cancel style of functions
    
    memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
      memcg-introduce-charge-commit-cancel-style-of-functions-fix
    
    memcg-fix-gfp_mask-of-callers-of-charge.patch
      memcg: fix gfp_mask of callers of charge
    
    memcg-simple-migration-handling.patch
      memcg: simple migration handling
    
    elf-implement-at_random-for-glibc-prng-seeding.patch
      ELF: implement AT_RANDOM for glibc PRNG seeding
    
    relay-reset-consumed.patch
      Relay Reset Consumed
    
    trace-code-and-documentation.patch
      Trace code and documentation
    
    trace-code-and-documentation-merging-documentation-tracetxt-with-documentation-filesystems-relaytxt.patch
      Merge Documentation/trace.txt with Documentation/filesystems/relay.txt
    
    trace-sample.patch
      Trace sample
    
    pci-use-pci_ioremap_bar-in-drivers-edac.patch
      pci: use pci_ioremap_bar() in drivers/edac
    
    bfs-add-some-basic-sanity-checks.patch
      bfs: add some basic sanity checks
    
    bfs-check-that-filesystem-fits-on-the-blockdevice.patch
      bfs: check that filesystem fits on the blockdevice
    
    memstick-annotate-endianness-of-attribute-structs.patch
      memstick: annotate endianness of attribute structs
    
    w1-export-w1_read_8-function.patch
      w1: export w1_read_8 function
    
    w1-export-w1_read_8-function-checkpatch-fixes.patch
      w1-export-w1_read_8-function-checkpatch-fixes
    
    hdq-driver-for-omap2430-3430.patch
      hdq driver for OMAP2430/3430
    
    hdq-bq27000-hdq-slave-interface-driver.patch
      hdq: bQ27000 HDQ Slave Interface Driver
    
    hdq-documentation-for-omap-hdq.patch
      hdq: documentation for OMAP HDQ
    
    add-c2-port-support.patch
      Add c2 port support
    
    c2port-add-c2port-support-for-eurotech-duramar-2150.patch
      c2port: add c2port support for Eurotech Duramar 2150
    
    vmcore-remove-saved_max_pfn-check.patch
      vmcore: remove saved_max_pfn check
    
    powerpc-hugetlb-pgtable-cache-access-cleanup.patch
      powerpc: hugetlb pgtable cache access cleanup
    
    filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
      filesystem freeze: add error handling of write_super_lockfs/unlockfs
    
    filesystem-freeze-implement-generic-freeze-feature.patch
      filesystem freeze: implement generic freeze feature
    
    filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch
      filesystem freeze: remove XFS specific ioctl interfaces for freeze feature
    
    nilfs2-add-document.patch
      nilfs2: add document
    
    nilfs2-disk-format-and-userland-interface.patch
      nilfs2: disk format and userland interface
    
    nilfs2-add-inode-and-other-major-structures.patch
      nilfs2: add inode and other major structures
    
    nilfs2-integrated-block-mapping.patch
      nilfs2: integrated block mapping
    
    nilfs2-b-tree-based-block-mapping.patch
      nilfs2: B-tree based block mapping
    
    nilfs2-direct-block-mapping.patch
      nilfs2: direct block mapping
    
    nilfs2-b-tree-node-cache.patch
      nilfs2: B-tree node cache
    
    nilfs2-buffer-and-page-operations.patch
      nilfs2: buffer and page operations
    
    nilfs2-meta-data-file.patch
      nilfs2: meta data file
    
    nilfs2-persistent-object-allocator.patch
      nilfs2: persistent object allocator
    
    nilfs2-disk-address-translator.patch
      nilfs2: disk address translator
    
    nilfs2-inode-map-file.patch
      nilfs2: inode map file
    
    nilfs2-checkpoint-file.patch
      nilfs2: checkpoint file
    
    nilfs2-segment-usage-file.patch
      nilfs2: segment usage file
    
    nilfs2-inode-operations.patch
      nilfs2: inode operations
    
    nilfs2-inode-operations-fix.patch
      nilfs2-inode-operations-fix
    
    nilfs2-file-operations.patch
      nilfs2: file operations
    
    nilfs2-directory-entry-operations.patch
      nilfs2: directory entry operations
    
    nilfs2-pathname-operations.patch
      nilfs2: pathname operations
    
    nilfs2-pathname-operations-fix.patch
      nilfs2-continuous-snapshotting-file-system-fix
    
    nilfs2-operations-for-the_nilfs-core-object.patch
      nilfs2: operations for the_nilfs core object
    
    nilfs2-super-block-operations.patch
      nilfs2: super block operations
    
    nilfs2-super-block-operations-fix.patch
      nilfs2-super-block-operations-fix
    
    nilfs2-segment-buffer.patch
      nilfs2: segment buffer
    
    nilfs2-segment-constructor.patch
      nilfs2: segment constructor
    
    nilfs2-recovery-functions.patch
      nilfs2: recovery functions
    
    nilfs2-another-dat-for-garbage-collection.patch
      nilfs2: another dat for garbage collection
    
    nilfs2-block-cache-for-garbage-collection.patch
      nilfs2: block cache for garbage collection
    
    nilfs2-ioctl-operations.patch
      nilfs2: ioctl operations
    
    nilfs2-update-makefile-and-kconfig.patch
      nilfs2: update makefile and Kconfig
    
    reiser4-vfs-add-super_operationssync_inodes-2.patch
      reiser4: vfs: add super_operations.sync_inodes() (2)
    
    reiser4-export-remove_from_page_cache.patch
      reiser4: export pagecache add/remove functions to modules
    
    reiser4-export-find_get_pages.patch
    
    reiser4.patch
      reiser4: add to build system
      reiser4: fix for drop-unused-semaphores.patch
      reiser4-slab-allocators-remove-slab_debug_initial-flag
      reiser4: use simple_prepare_write to zero page data
      reiser4-fix
      reiser4: use zero_user_page
      reiser4: remove typedefs
      reiser4: fix write_extent
      reiser4 make sync_inodes non-void
      Reiser4: Drop 'size' argument from bio_endio and bi_end_io
      mm: clean up and kernelify shrinker registration
      reiser4: fix NULL dereference in __mnt_is_readonly in ftruncate()
      reiser4: fix extent2tail
      reiser4: fix read_tail
      reiser4: fix unix-file readpages filler
      reiser4: fix readpage_unix_file
      reiser4: fix for new aops patches
      reiser4: do not allocate struct file on stack
      git-block-vs-reiser4
      reiser4: cryptcompress misc fixups
      reiser4: cryptcompress misc fixups-2
      fs/reiser4/plugin/: make 3 functions static
      reiser4: change error code base
      reiser4: use lzo library functions
      fs/reiser4/plugin/file/cryptcompress.c: kmalloc + memset conversion to kzalloc
      reiser4: kmalloc + memset conversion to kzalloc
      fs/reiser4/init_super.c: kmalloc + memset conversion to kzalloc
      fs/reiser4/plugin/inode_ops_rename.c: kmalloc + memset conversion to kzalloc
      fs/reiser4/ktxnmgrd.c: kmalloc + memset conversion to kzalloc
      Use helpers to obtain task pid in printks
      Subject: [PATCH 1/2] remove asm/bitops.h includes
      git-nfsd-broke-reiser4
      slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4
      reiser4 kgdb fix
      Reiser4 portion of zero_user cleanup patch
      reiser4: replace uid==0 check with capability
      jens-fixed-reiser4
      reiser4: make methods supplied to vfs invariant
      reiser4: new export ops
      reiser4: new export ops (update)
      reiser4: new export_ops fixup
      reiser4: specify splice file operations
      reiser4: fix dummy ioctl_cryptcompress
      reiser4: granulate rw-serialization when accessing file conversion set
      reiser4: fix disk cluster synchronization
      reiser4: use balance_dirty_pages_ratelimited_nr
      reiser4: correct references to filemap_nopage()
      reiser4: fix null pointer dereference in reiser4_write_extent
      reiser4: code cleanups
    
    reiser4-tree_lock-fixes.patch
      reiser4-tree_lock-fixes
    
    reiser4-tree_lock-fixes-fix.patch
      reiser4-tree_lock-fixes-fix
    
    reiser4-fix-handling-enospc-cryptcompress.patch
      reiser4: fix handling ENOSPC cryptcompress
    
    reiser4-fix-handling-enospc-unix_file.patch
      reiser4: fix handling ENOSPC unix_file
    
    reiser4-fix-kill_hook_internal.patch
      reiser4: fix kill_hook_internal
    
    reiser4-semaphore-fix.patch
      reiser4-semaphore-fix
    
    slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
      slb-drop-kmem-cache-argument-from-constructor-reiser4
    
    reiser4-suid.patch
      reiser4-suid
    
    reiser4-compile-warning-cleanups.patch
      reiser4: compile warning cleanups
    
    reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch
      reiser4: use wake_up_process() instead of wake_up() when possible
    
    reiser4-track-upstream-changes.patch
      reiser4: track upstream changes
    
    reiser4-broke.patch
      reiser4-broke
    
    make-sure-nobodys-leaking-resources.patch
      Make sure nobody's leaking resources
    
    journal_add_journal_head-debug.patch
      journal_add_journal_head-debug
    
    releasing-resources-with-children.patch
      Releasing resources with children
    
    nr_blockdev_pages-in_interrupt-warning.patch
      a
    
    mm-debug-dump-pageframes-on-bad_page.patch
      mm debug: dump pageframes on bad_page()
    
    make-frame_pointer-default=y.patch
      make FRAME_POINTER default=y
    
    mutex-subsystem-synchro-test-module.patch
      mutex subsystem, synchro-test module
    
    slab-leaks3-default-y.patch
      slab-leaks3-default-y
    
    put_bh-debug.patch
      put_bh() debug
    
    add-debugging-aid-for-memory-initialisation-problems.patch
      Add debugging aid for memory initialisation problems
    
    shrink_slab-handle-bad-shrinkers.patch
      shrink_slab(): handle bad shrinkers
    
    keep-track-of-network-interface-renaming.patch
      keep track of network interface renaming
    
    workaround-for-a-pci-restoring-bug.patch
      pci: test for unexpectedly disabled bridges
    
    prio_tree-debugging-patch.patch
      prio_tree: debugging patch
    
    single_open-seq_release-leak-diagnostics.patch
      single_open/seq_release leak diagnostics
    
    add-a-refcount-check-in-dput.patch
      Add a refcount check in dput()
    
    getblk-handle-2tb-devices.patch
      getblk(): handle 2TB devices
    
    getblk-handle-2tb-devices-fix.patch
      fix getblk_slow "integer constant is too large" warning
    
    undeprecate-pci_find_device.patch
      undeprecate-pci_find_device
    
    notify_change-callers-must-hold-i_mutex.patch
      notify_change(): callers must hold i_mutex
    
    profile-likely-unlikely-macros.patch
      Profile likely/unlikely macros
    
    drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
      drivers/net/bonding/bond_sysfs.c: suppress uninitialized var warning
    
    w1-build-fix.patch
      w1-build-fix
    
    
    
