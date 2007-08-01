Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbXHAGJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbXHAGJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXHAGJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:09:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbXHAGJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:09:42 -0400
Date: Tue, 31 Jul 2007 23:09:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1-mm2
Message-Id: <20070731230932.a9459617.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/


- the git-block tree remains dropped due to disageement with the Vaio

- git-e1000new was withdrawn by the authors

- git-wireless is back.  It is still a >3MB diff, and appears to compile.

- Is anyone testing the kgdb code in here?



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

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

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
  the mm-commits list.


Changes since 2.6.23-rc1-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-audit-master.patch
 git-cifs.patch
 git-dma.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-input.patch
 git-jfs.patch
 git-kvm.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ixgbe.patch
 git-battery.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-kgdb.patch

 git trees

-tiny-signalfd-cleanup.patch
-kernel-doc-fix-for-kmodc.patch
-slab-maintainer-credits-update.patch
-rtc-stk17ta8-update-for-sysfs-api-change.patch
-use-ldflags_module-only-for-ko-links.patch
-pm-fix-compiler-error-of-ppc-dart_iommu.patch
-fixup-s3c24xx-build-after-arch-moves.patch
-rtc-ds1307-typo-fix-found-by-coverity.patch
-xen-xen-pageh-compile-fix.patch
-lguest-documentation-i-preparation.patch
-lguest-documentation-ii-guest.patch
-lguest-documentation-iii-drivers.patch
-lguest-documentation-iv-launcher.patch
-lguest-documentation-v-host.patch
-lguest-documentation-vi-switcher.patch
-lguest-documentation-vii-fixmes.patch
-x86_powernow_k8_acpi-must-depend-on-acpi.patch
-make-timerfd-return-a-u64-and-fix-the-__put_user.patch
-memory-unplug-v7-migration-by-kernel.patch
-memory-unplug-v7-isolate_lru_page-fix.patch
-revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
-reorder-rtc-makefile.patch
-ufs-printk-warning-fix.patch
-i2c-ds1682-warning-fix.patch
-edac-is-bust-on-mips.patch
-xenbus_xsc-fix-a-use-after-free.patch
-fix-inode_table-test-in-ext234_check_descriptors.patch
-kdebugh-forward-declare-struct-struct-notifier_block.patch
-git-acpi-build-fix.patch
-acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter.patch
-acpi-fix-oops-due-to-typo-in-new-throttling-code.patch
-agk-dm-dm-crypt-drop-device-ref-in-ctr-error-path.patch
-agk-dm-dm-delay-fix-ctr-error-paths.patch
-agk-dm-dm-netlink.patch
-agk-dm-dm-netlink-add-to-core.patch
-agk-dm-dm-netlink-mpath.patch
-gregkh-driver-howto-adjust-translation-header-of-japanese-stable_api_nonsensetxt.patch
-gregkh-driver-howto-sync-japanese-howto.patch
-gregkh-driver-kobject-fix-link-error-when-config_hotplug-is-disabled.patch
-gregkh-driver-kobject-put-kobject_actions-in-kobjecth.patch
-stradis-and-zoran-depend-on-virt_to_bus.patch
-clean-up-duplicate-includes-in-drivers-hwmon.patch
-hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
-ia64-allow-smp_call_function_single-to-current-cpu.patch
-ia64-rename-partial_page.patch
-applesmc-add-temperature-sensors-set-for-macbook.patch
-ide-ide-add-ide-set-pio-take3.patch
-ide-icside-fix-speedproc-for-unsupported-modes-take4.patch
-mmc-build-fix.patch
-drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
-dev-priv-to-netdev_privdev-drivers-net-tokenring.patch
-try-parent-numa_node-at-first-before-using-default-v2.patch
-try-parent-numa_node-at-first-before-using-default-v2-fix.patch
-more-request_queue_t-removal.patch
-gregkh-usb-usb-devices-misc-trivial-patch-to-build-the-iowarrior-when-it-is-selected-in-kconfig.patch
-gregkh-usb-usb-don-t-let-usb-storage-steal-blackberry-pearl.patch
-gregkh-usb-usb-more-quirky-devices.patch
-gregkh-usb-usb-usbh-kernel-doc-additions.patch
-gregkh-usb-usb-even-more-quirks.patch
-0-null-drivers-usb-gadget.patch
-clean-up-duplicate-includes-in-drivers-usb.patch
-geode-setup-correct-chipset-access-functions-fix.patch
-doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
-remove-unused-tif_notify_resume-flag.patch
-whitelist-references-from-__dbe_table-to-init.patch
-fix-user-struct-leakage-with-locked-ipc-shem-segment.patch
-bpqether-fix-rcu-usage.patch
-afs-fix-file-locking.patch
-fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
-fix-leak-on-proc-lockdep_stats.patch
-blktrace-use-cpu_clock-instead-of-sched_clock.patch
-futex-pass-nr_wake2-to-futex_wake_op.patch
-include-serial_regh-with-userspace-headers.patch
-trivial-in-string-typos-of-error.patch
-pure_initcall-id-inconsistency.patch
-serial-fix-section-mismatch-vr41xx_siu.patch
-serial-fix-vr41xx_siu-interface-select.patch
-serial-fix-vr41xx_siu-serial-console-support.patch
-remove-tx3912fb.patch
-isofs-mounting-to-regular-file-may-succeed.patch
-update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
-serial-mpsc-remove-race-between-rx-stop-restart.patch
-serial-mpsc-stop-rx-engine-when-cread-cleared.patch
-serial-mpsc-remove-duplicate-support_sysrq-definition.patch
-serial-mpsc-fix-coding-style-and-whitespace-issues.patch
-i2ch-kernel-doc-additions.patch
-irqh-fix-kernel-doc.patch
-docbook-bad-file-references.patch
-ipmi-fix-mem-leak-in-try_init_dmi.patch
-ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch
-broken-lilo-check-on-make-install.patch
-remove-one-more-leftover-reference-to-devfs.patch
-anon_inodes-shouldnt-be-user-visible.patch
-hpettxt-broken-link-fix.patch
-use-__val-in-__get_unaligned.patch
-vfs-fix-a-race-in-lease-breaking-during-truncate.patch
-fs-9p-convc-error-path-fix.patch
-kthread-silence-bogus-section-mismatch-warning.patch
-fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
-idr_remove_all-kill-unused-variable.patch
-typo-fixes-errror-error.patch
-i386-include-asm-bugsh-in-bugsc-for-check_bugs-prototype.patch
-x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch
-mark-sysrq_sched_debug_show-static.patch
-sb1250-duart-__maybe_unused-etc-fixes.patch
-rename-setleast-to-generic_setlease.patch
-remove-kconfig-setting-config_debug_shirq.patch
-videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
-documentation-update-sched-stattxt.patch
-debug-handling-of-early-spurious-interrupts.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
-allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
-drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
-kconfig-remove-top-level-menu-code-maturity-level-options.patch
-cciss-fix-memory-leak.patch
-udf-fix-uid-and-gid-mount-option-ignorance.patch
-ip2main-warning-fix.patch
-spi-kerneldoc-update.patch
-spi-device-setup-gets-better-error-checking.patch
-remove-isdn_-is-defined-but-unused-warnings.patch
-spi-kerneldoc-update.patch
-spi-device-setup-gets-better-error-checking.patch
-remove-isdn_-is-defined-but-unused-warnings.patch
-use-menuconfig-objects-rtc.patch
-rtc-m48t59-driver-no_irq-mode-fixup.patch
-sched2-sched-domain-sysctl.patch
-sched-add-above-background-load-function.patch

 Merged into mainline or a subsystem tree

+blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch
+genirq-temporary-fix-for-level-triggered-irq-resend.patch
+genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
+fix-hpet-init-race.patch
+direct-io-fix-error-path-crashes.patch
+changing-include-asm-generic-pgtableh-for-non-mmu.patch

 2.6.23 queue

+slow-down-printk-during-boot-fix-3.patch

 Fix slow-down-printk-during-boot.patch some more

+git-acpi-mark_tsc_unstable-build-fix.patch

 ACPI fix

+acpi-cure-run-together-printk-lines.patch
+make-drivers-acpi-eventcacpi_event_seqnum-static.patch
+make-struct-sony_nc_ids-static.patch

 ACPi things

+kernel-auditscc-fix-an-off-by-one.patch
+fix-auditscc-kernel-doc.patch

 audit fixes

+fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch

 CIFS cleanup

+cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
+cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch

 cpufreq: make ondemand the default

+drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch

 device mapper cleanups

+powerpc-clean-out-a-bunch-of-duplicate-includes.patch
+powerpc-fix-num_cpus-calculation-in-smp_call_function_map.patch

 powerpc things

+gregkh-driver-sysfs-filec-use-mutex-instead-of-semaphore.patch
+gregkh-driver-sysfs-cleanup-semaphoreh.patch

 driver tree additions

+nozomi-shoot-defunct-label.patch
+drivers-base-power-make-2-functions-static.patch

 driver tree fixes

+dma-intel_ioatdma-build-fix.patch

 Fix git-dma.patch

+git-dvb-fixup.patch

 Fix rejects in git-dvb

+drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc.patch

 DVB fix

+drivers-i2c-i2c-corec-make-code-static.patch

 i2c cleanup

+add-includes-to-scsi_transport_iscsih.patch

 scsi fix

+drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch

 input fix

+include-linux-kbuild-remove-duplicate-entries.patch

 kbuidl cleanup

+libata-acpi-checks-for-80wire-cable-headers.patch
+libata-acpi-checks-for-80wire-cable-implementation.patch
+libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
+libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
+libata-sff-unbreak-non-dma-capable-controllers-again.patch
+pata_cmd64x-correct-the-speed-ranges.patch
+fix-libata-warnings-with-config_pm=n.patch
+libata-correct-iordy-handling.patch
+pata_sis-fix-mwdma-for-=-udma66-chipsets-and-udma-for-udma33-chipsets.patch

 sata/pata things

-testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
-pata_ali-more-work.patch

 Dropped at Alan's request.

+ide-cs5535-fix-array-overrun.patch
+ide-ide-add-platform-ide-driver.patch
+ide-ide-make-config_ide_generic-default-to-n.patch
+ide-alim15x3-correct-hp-detect.patch
+ide-sis5513-add-fsc-amilo-a1630-pci-subvendor_dev-to-laptops.patch
+ide-ide-add-ide-set-pio-take-4.patch
+ide-icside-fix-speedproc-for-unsupported-modes-take-5.patch
+ide-ide-pmac-dont-check-kauai-lookup-timing-return-value.patch
+ide-ide-pmac-fix-pmac-ide-tune-chipset.patch
+ide-ide-pmac-fix-set-timings-mdma.patch
+ide-ide-pmac-remove-control-register-messing-from-pmac-ide-dma-check.patch
+ide-ide-pmac-remove-pmac-ide-dma-enable-take-2.patch
+ide-ide-config-drive-speed-bugfixes.patch
+ide-ide-add-__ide-wait-stat-helper.patch
+ide-ide-pmac-ide-do-setfeature-remove-pre-wait.patch
+ide-ide-pmac-use-__ide-wait-stat.patch
+ide-ide-pmac-remove-nien-clearing-from-pmac-ide-do-setfeature.patch
+ide-ide-pmac-remove-pmac-ide-do-setfeature-take-2.patch
+ide-ide-pmac-use-ide-tune-dma.patch

 IDE tree updates

-ide-bodge-things-around-to-make-arm-work.patch

 Otherwise fixed

+fix-runtogether-printks-in-cmd64x-ide-driver.patch
+fix-ide-ide-add-platform-ide-driver.patch
+eliminate-warnings-in-ide-tapec.patch
+drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch

 IDE things

+mips-remove-some-duplicate-includes.patch

 MIPS cleanup

+mips-qemu-network-work-again.patch

 MIPS fix

+drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch

 mmc cleanups

+mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch
+mtd-remove-redundant-dead-code-from-physmap_ofc.patch
+mtd-onenand_simc-make-struct-info-static.patch
+remove-fs-jffs2-ioctlc.patch
+drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch

 MTD things

+usb-remove-redundant-memset-from-amd5536udc.patch
+drivers-net-cxgb3-xgmacc-remove-dead-code.patch
+e1000-if-0-two-functions.patch

 netdev things

+git-ixgbe-build-fix.patch

 Fix git-ixgbe.patch for changes in mainline

-git-e1000new.patch

 Dropped

-e1000new-build-fix.patch
-e1000new-build-fix-2.patch

 Now unneeded

+fib_trie-cleanup.patch
+fib_trie-cleanup-fix.patch
+fib_trie-macro-cleanup.patch
+dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
+drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
+drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
+netconsole-cleanups-codingstyle-prettyfication.patch
+netconsole-remove-bogus-check.patch
+netconsole-simplify-boot-module-option-setup-logic.patch
+netconsole-use-netif_running-in-write_msg.patch
+netconsole-add-some-useful-tips-to-documentation.patch
+netconsole-introduce-netconsole_target.patch
+netconsole-introduce-netconsole_netdev_notifier.patch
+netconsole-support-multiple-logging-targets.patch
+netconsole-support-dynamic-reconfiguration-using-configfs.patch
+introduce-u16_max-and-u32_max.patch
+introduce-u16_max-and-u32_max-fix.patch
+introduce-strtol_check_range.patch
+introduce-strtol_check_range-fix.patch

 networking changes

+backlight-make-2-structs-static.patch

 backlight cleanup

+parisc-extern-inline-static-inline.patch

 parisc cleanup

+gregkh-pci-pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use.patch

 PCI tree updates

+cpqphp_ctrlc-remove-dead-code.patch
+drivers-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch

 PCI things

+kernel-schedc-make-code-static.patch
+tiny-sched_getaffinity-cleanup.patch

 sched cleanups

+sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch

 SH fix

+scsi-fix-build-for-config_scsi_tgt=n-2.patch
+drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
+fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
+nsp32_restart_autoscsi-remove-error-check.patch
+dtc-clean-up-indent-damage-and-add-printk-levels.patch
+make-scsi_host_link_pm_policy-static.patch
+drivers-scsi-scsi_errorc-should-include.patch
+drivers-scsi-constantsc-make-2-functions-static.patch
+use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
+drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-ide-scsic-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
+drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
+drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch

 scsi things

+clean-up-duplicate-includes-in-drivers-block.patch
+drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch

 block things

+partially-fix-up-the-lookup_one_noperm-mess.patch

 VFS cleanup

+git-unionfs-fixup.patch
+git-unionfs-build-fix.patch

 unionfs touchups

+gregkh-usb-usb-nikon-d50-is-an-unusual-device.patch
+gregkh-usb-usb-clean-up-duplicate-includes-in-drivers-usb.patch
+gregkh-usb-usblp-implement-the-enospc-convention.patch
+gregkh-usb-usblp-make-use-of-urb_free_buffer.patch

 USB tree updates

-merge-the-sonics-silicon-backplane-subsystem.patch
-merge-the-sonics-silicon-backplane-subsystem-fix.patch
-ssb-add-a-driver-for-the-broadcom-ohci-core.patch

 Updated

+kl5kusb105-switch-to-new-speed-api.patch
+mct_u232-convert-to-proper-speed-handling-api-fix.patch
+fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
+drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch

 USB things

+merge-the-sonics-silicon-backplane-subsystem.patch
+merge-the-sonics-silicon-backplane-subsystem-fix.patch
+avoid-ssb-compililation-on-s390.patch
+b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
+merge-the-sonics-silicon-backplane-subsystem-update.patch
+ssb-compile-fix.patch
+watchdog-support-3.patch
+ssb-add-a-driver-for-the-broadcom-ohci-core.patch
+use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch

 Wireless things (mainly SSB)

+x86_64-get-mp_bus_to_node-as-early-v2.patch
+x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
+try-parent-numa_node-at-first-before-using-default-v2.patch
+net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
+dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
+x86_64-store-core-id-bits-in-cpuinfo_x8.patch
+x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
+x86_64-remove-never-used-apic_mapped.patch
+x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
+x86_64-family-10h-and-11h-to-k8topology.patch
+x86-add-cpu-codenames-for-kconfigcpu.patch
+change-order-in-kconfigcpu-i386.patch
+i386-add-amd64-barcelona-pmu-msr-definitions.patch
+i386-remove-maccumulate-outgoing-args.patch
+arch-i386-mach-generic-probec-make-struct-apic_probe.patch
+arch-i386-mach-es7000-es7000platc-cleanups.patch
+i386-alternativec-really-stop-mces-during-code.patch
+i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
+arch-i386-mm-discontigc-make-some-variables-static.patch
+x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch
+expand-proc-interrupts-to-include-missing-vectors-v3.patch
+x86-expand-proc-interrupts-to-include-missing-vectors.patch
+arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch

 x86 fixes

+git-newsetup-fixup.patch

 Fix rejects in git-newsetup.patch

+xtensa-consolec-remove-duplicate-include.patch

 xtensa cleanup

+fix-kgdb-kernel-doc.patch
+serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch

 kgdb fixes

+dma_free_coherent-needs-irqs-enabled-sigh.patch
+usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
+sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
+sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
+tpmdd-maintainers.patch
+nfs-fix-put_nfs_open_context.patch
+make-oprofile-call-shutdown-only-once-per-session.patch
+perfctr_watchdog-do-not-bug_on-when-msr-is-unknown.patch
+acpi-bay-send-envp-with-uevent-fix.patch
+acpi-dock-send-key=value-pair-instead-of-plain-value.patch
+acpi_ec_remove-fix-use-after-free.patch
+acpi_battery_add-use-after-free.patch

 Random things which I think should be in 2.6.23, but which should go in via
 a subsystem maintainer.

 I've been doing it this way fo rthe past few kernel releases.  It is
 worrisome how much stuff people are losing track of.  People should cc me on
 bugfixes...

+generic-virtual-memmap-support-for-sparsemem-fix.patch

 Fix generic-virtual-memmap-support-for-sparsemem.patch

+vm-dont-run-touch_buffer-during-buffercache-lookups.patch

 A little VM experiment.  See changelog for details.

+fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
+fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch

 Fix
 fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
 some more

+mm-page_allocc-make-code-static.patch

 MM cleanup

+hugetlbfs-read-support-fix-2.patch

 Fix hugetlbfs-read-support.patch some more

+mm-shmemc-make-3-functions-static.patch
+mm-migratec-cleanups.patch
+mm-mempolicyc-cleanups.patch
+mm-vmstatc-cleanups.patch

 MM cleanups

+security-convert-lsm-into-a-static-interface-fix-2-fix.patch

 Fix security-convert-lsm-into-a-static-interface.patch even more.

+remove-frv-usage-of-flush_tlb_pgtables.patch
+include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch

 frv minor things

+m68knommu-remove-unused-config-symbol-config_disktel.patch

 nommu patch which Linus missed

+cleanup-arch-alpha-makefile.patch

 alpha cleanup

-pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch

 Unneeded

+unexport-pm_power_off_prepare.patch

 PM cleanup

+include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch

 m32r cleanup

+uml-move-userspace-code-to-userspace-file.patch
+uml-tidy-recently-moved-code.patch
+uml-fix-error-cleanup-ordering.patch
+uml-console-subsystem-tidying.patch

 UML updates for 2.6.24.

-hwrng-add-type-categories.patch

 Dropped

-use-list_head-in-binfmt-handling.patch
-use-list_head-in-binfmt-handling-fix.patch
+use-list_head-in-binfmt-handling-update.patch

 Updated

-loop-use-unlocked_ioctl.patch

 Dropped, broken.

+fix-config_debug_shirq-trigger-on-free_irq.patch
+fs-remove-the-unused-mempages-parameter.patch
+remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
+add-in-sunos-41x-compatible-mode-for-ufs.patch
+add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
+ufs-implement-show_options.patch
+argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
+core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
+core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
+core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
+core_pattern-fix-up-a-few-miscellaneous-bugs.patch
+core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
+epcac-reformat-comments-and-coding-style-improvements.patch
+fs-partitions-checkc-add-add_partition-error-handling.patch
+add-sys-module-name-notes.patch
+kernel-rtmutex-debugc-cleanups.patch
+fs-afs-possible-cleanups.patch
+lib-ioremapc-should-include-linux-ioh.patch
+ipc-shmc-make-2-functions-static.patch
+printk-add-interfaces-for-external-access-to-the-log-buffer.patch
+printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
+drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
+doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
+fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
+drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
+tpm_tis-fix-interrupt-probing.patch

 Misc random new things

+use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch

 ISDN cleanup

+fs-nfsd-exportc-make-3-functions-static.patch

 nfsd cleanup

+ecryptfs-remove-unnecessary-bug_on.patch
+ecryptfs-collapse-flag-set-into-one-statement.patch
+ecryptfs-grammatical-fix-destruct-to-destroy.patch
+ecryptfs-comments-for-some-structs.patch
+ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
+ecryptfs-remove-unnecessary-variable-initializations.patch
+ecryptfs-make-needlessly-global-symbols-static.patch

 ecrypts fixes for things which were in rc1-mm1.

+fbdev-export-fb_destroy_modelist.patch
+connector-change-connectors-max-message-size.patch
+uvesafb-add-connector-entries.patch
+uvesafb-the-driver-core.patch
+uvesafb-documentation.patch
+pm3fb-copyarea-and-partial-imageblit-suppor.patch
+skeletonfb-wrong-field-name-fix.patch
+pm3fb-header-file-reduction.patch
+pm3fb-imageblit-improved.patch
+pm3fb-3-small-fixes.patch
+pm3fb-improvements-and-cleanups.patch
+pm3fb-mtrr-support-and-noaccel-option.patch
+pm2fb-mtrr-support-and-noaccel-option.patch
+pm2fb-accelerated-imageblit.patch
+pm2fb-source-code-improvements.patch
+pm2fb-permedia-2v-initialization-fixes.patch
+pm2fb-accelerated-24-bit-fillrect.patch
+sm501fb-update-suspend-and-resume-code.patch
+sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
+sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
+mbxfb-improvements-and-new-features.patch
+pxafb-add-support-for-other-palette-formats.patch
+stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
+tridentfb-coding-style-improvement.patch
+tdfxfb-coding-style-improvement.patch
+tdfxfb-3-fixes.patch
+tdfxfb-palette-fixes.patch
+radeon_driver_vblank_do_wait-static.patch
+unexport-fb_prepare_logo.patch

 fbdev updates

+cpu-hotplug-slab-cleanup-cpuup_callback.patch
+cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
+cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
+cpu-hotplug-topology-remove-topology_dev_map.patch
+cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
+cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
+cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
+cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
+cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch

 cpu hotplug rework

+fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch

 ext4 cleanup

+task-containersv11-basic-task-container-framework-fix.patch

 fix containers patches in -mm

+containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch

 Fix containers-implement-namespace-tracking-subsystem.patch

+pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
+pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch

 fix pid-namespaces patches in -mm.

+char-moxa-fix-and-optimise-empty-timer.patch
+char-cyclades-remove-bottom-half-processing.patch
+char-cyclades-make-the-isr-code-readable.patch
+char-cyclades-move-spin_lock-to-one-place.patch
+char-cyclades-fix-some-w-warnings.patch

 char driver cleanups

+reiser4-cryptcompress-misc-fixups.patch
+reiser4-change-error-code-base.patch
+reiser4-use-lzo-library-functions.patch
+fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
+reiser4-kmalloc-memset-conversion-to-kzalloc.patch
+fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
+fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
+fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

 reiser4 updates

-alloc_pages-debug.patch

 Dropped

+single_open-seq_release-leak-diagnostics.patch

 Check for leaky seq_file users



All 942 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/patch-list


