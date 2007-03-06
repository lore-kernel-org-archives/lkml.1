Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbXCFIoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbXCFIoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXCFIoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:44:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077AbXCFIoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:44:13 -0500
Date: Tue, 6 Mar 2007 00:44:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc2-mm2
Message-Id: <20070306004408.d3f6434d.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/

Will appear later at

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm2/


- git-block.patch is having problems which are getting in the way - it has
  been dropped.

- As a consequence all the AIO patches were dropped

- Some MM patches were dropped:

  - lumpy-reclaim is being redone

  - remove-mlocked-pages-from-the-LRU: is being redone

  - remove-anon-pages-from-the-LRU-if-we-have-no-swap: ditto

- Merged Mel's MM patches: GFP_MOVABLE and anti-fragmentation.  I don't
  yet know if we want to do this, but let's get the code some more test and
  eyeball time.

- Lots of patches were folded into their base patches.




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



Changes since 2.6.20-rc2-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-input.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mmc.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-wireless-fixup.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-cyclades-return-closing_wait.patch
-io_apic-needs-apicdefh.patch
-msi-sanely-support-hardware-level-msi-disabling.patch
-msi-fixup-the-msi-enable-disable-logic.patch
-msi-support-masking-msi-irqs-without-a-mask-bit.patch
-ecryptfs-check-xattr-operation-support-fix.patch
-parport-is-an-orphan.patch
-fix-soft-lockup-with-iseries-viocd-driver.patch
-add-config_generic_gpio.patch
-gpio_keys-driver-shouldnt-be-arm-specific.patch
-dz-remove-struct-pt_regs-references.patch
-schedule-wext-rtnl-for-removal.patch
-shmem-and-simple-const-super_operations.patch
-sched-remove-smt-nice.patch
-fb-sm501fb-off-by-1-sysfs-store.patch
-fix-radeon-blanking-return-value.patch
-page-migration-fix-vma-flag-checking.patch
-vmi-timer-fixes-round-two.patch
-vmi-sched-clock-paravirt-op-fix.patch
-vmi-cpu-cycles-fix.patch
-vmi-fix-highpte.patch
-vmi-paravirt-drop-udelay-op.patch
-vmi-pit-override.patch
-vmi-fix-nohz-compile.patch
-vmi-apic-ops.patch
-vmi-smp-fixes.patch
-pvrusb-warning-fix.patch
-git-leds-fixup.patch
-git-leds-make-it-compile.patch
-libata-core-fix-simplex-handling.patch
-libata-dev_config-does-not-need-ap-and-adev-passing.patch
-ide-alim15x3-fix-pio-mode-setup.patch
-ide-cmd64x-fix-pio-mode-setup-take3.patch
-ide-ide-fix-drive-side-80c-cable-check.patch
-ide-cmd64x-fix-recovery-time-calculation.patch
-ide-piix-slc90e66-more-tuneproc-fixing-take2.patch
-ide-ide-get-best-pio-mode-returns-incorrect-iordy-setting-take2.patch
-ide-ide-cs-update-device-table.patch
-ide-ide-fix-pmac-breakage.patch
-ide-pci-adjust-legacy-ide-resource-setting-v2.patch
-ide-siimage-drac4-note.patch
-ide-ide-remove-a-ton-of-pointless-undef-really-slow-io.patch
-ide-ide-max-dma-mode-v2.patch
-ide-ide-remove-obsolete-params-v2.patch
-ide-ide-legacy-params-v2.patch
-ide-delkin_cb-pci_module_init-to-pci_register_driver.patch
-ide-ide-fix-pmac-breakage-fix.patch
-ehea-dynamic-add--remove-port.patch
-ehea-dynamic-add--remove-port-update.patch
-fix-mv643xx_eth-compilation.patch
-parisc-unbreak-setupc-re-command_line.patch
-pcie-fix-section-mismatch-warning.patch
-aer-fix-section-mismatch-warning.patch
-usb-serial-secret-patch.patch
-ecryptfs-handles-aop_truncated_page-better.patch
-atyfb-replace-busy-loop-with-mdelay.patch
-atyfb-fix-kconfig-error.patch

 Merged into mainline or a subsystem tree

+paravirt-build-fixes.patch
+fix-suspend-resume-with-periodic-tick-devices.patch
+nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
+atyfb-fix-kconfig-error-part-2.patch
+fbdev-fix-kconfig-error-if-fb_ddc=n.patch
+fix-2621-rfcomm-lockups.patch
+scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
+i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch
+hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
+hrtimers-hrtimer_clock_base-description-typo.patch
+highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
+highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch
+highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
+kconfig-update-swsusp-description.patch
+remove-arch-i386-kernel-tscccustom_sched_clock.patch
+mqueue-nested-locking-annotation.patch
+fix-vsyscall-settimeofday.patch
+fs-nobh_truncate_page-fix.patch
+geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch
+publish-rcutorture-module-parameters-via-sysfs-read-only.patch
+cciss-fix-for-2tb-support.patch
+cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier.patch
+initramfs-should-not-depend-on-config_block.patch
+linux-audith-needs-linux-typesh.patch
+uml-fix-formatting-violations-in-signal-delivery-code.patch
+uml-add-a-debugging-message.patch
+uml-comment-the-initialization-of-a-global.patch
 knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
 knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
+knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server.patch
+sdhci-handle-resumed-devices.patch
+ecryptfs-nested-locking-annotation.patch
+knfsd-provide-sunrpc-pool_mode-module-option.patch

 2.6.21 queue

-git-acpi-fix-cpuidle-borkage.patch
+git-acpi-fix-cpuidle-borkage-2.patch

 New version

+drivers-cpuidle-make-code-static.patch

 ACPi cleanup

+fix-acpi-documentation-in-kernel-parameterstxt.patch

 ACPI documentation fix

+gregkh-driver-remove-devfs-from-maintainers.patch
+gregkh-driver-driver-core-export-device_rename.patch

 Driver tree updates

+make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch

 DRM cleanup

-git-dvb-fixup.patch

 Unneeded

+dvb-core-fix-several-locking-related-problems.patch
+saa7134-fix-modules=n-compilation.patch

 DVB fixes

+gfs2-build-fix.patch

 Fix git-gfs2-nmw.patch

+ia64-kexec-use-efi_loader_data-for-elf-core-header.patch
+ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch

 ia64 fixes

+wistron-button-support-for-travelmate-610.patch

 Input device support

-allow-kernel-to-build-on-cygwin.patch

 Dropped

+pata_cmd640-cmd640-pci-support.patch
+libata-kconfig-update-the-various-experimentality-levels.patch
+sata_nv-dont-read-shadow-registers-when-in-adma-mode.patch
+pata_pdc202xx_old-fix-data-corruption-and-other-problems.patch

 sata/pata updates

+ide-cmd64x-fix-recovery-time-calculation-take2.patch
+ide-cmd64x-add-back-mwdma-support.patch
+ide-ide-max-dma-mode-v3.patch

 IDE tree updates

+git-mmc-fix-99.patch

 Fix git-mmc.

+nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch

 Fix nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch

+mtd-esb2-check-for-closed-rom-window.patch

 MTD fix

+git-netdev-all-ipw2200-fix.patch

 Fix git-netdev-all.patch

+mv643xx-ethernet-driver-irq-registration-fix.patch
+network-add-the-missing-phy_device-speed-information-to-phy_mii_ioctl.patch

 netdev updates

-cisco_ioctl-initialise-header_cache_update.patch

 Dropped

+div64_64-common-code.patch
+div64_64-common-code-fix.patch

 Implement div64_64()

+drivers-net-bonding-bond_maincmake-3-functions-static.patch

 Bonding cleanup

+bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch

 bluetooth fix

+gregkh-pci-pcie-fix-section-mismatch-warning.patch
+gregkh-pci-pci-aer-fix-section-mismatch-warning.patch
+gregkh-pci-pci-fix-section-mismatch-warning.patch

 PCI tree updates

-scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
-scsi-megaraid_sas-return-sync-cache-call-with-success.patch
+scsi-megaraid_sas-throttle-io-if-cmds-are-in-risk-of.patch

 Update megaraid patches

-revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
-git-block.patch
-git-block-fixup.patch
-git-block-dupe-definitions.patch
-git-block-xfs-barriers-broke.patch

 The death of git-block

+gregkh-usb-usb-pxa2xx_udc-fix-hardcoded-irq-number.patch
+gregkh-usb-usb-ratelimit-debounce-error-messages.patch
+gregkh-usb-usb-fix-skeleton-driver.patch
+gregkh-usb-usb-kill-bkl-in-skeleton-driver.patch
+gregkh-usb-usb-kill-dead-code-from-hubc.patch
+gregkh-usb-usb-new-device-ids-for-cp2101-driver.patch
+gregkh-usb-usb-add-ql355p-power-supply-ids-to-fdti_sio.patch
+gregkh-usb-usb-add-additional-pids-in-ftdi_sio.patch
+gregkh-usb-usb-serial-fix-shutdown-device_unregister-order.patch
+gregkh-usb-usb-ftdi_sio-use-port_probe-port_remove-thereby-fixing-access-to-the-latency_timer.patch
+gregkh-usb-usb-rts-dtr-signal-patch-for-airprime-driver.patch
+gregkh-usb-usb-fix-usb-serial-device-naming-bug.patch
+gregkh-usb-usb-further-fix-for-usb-serial.patch
+gregkh-usb-usb-kill-bkl-in-usblcd.patch
+gregkh-usb-usb-ipaqc-additional-devices.patch
+gregkh-usb-usbnet-dm9501-add-corega-fether-usb-txc-support.patch
+gregkh-usb-usb-additional-structure-from-cdc-spec.patch
+gregkh-usb-usb-cdc-acm-export-parsed-capabilities-through-sysfs.patch

 USB updates

+git-wireless-fixup.patch

 Fix rejects in git-wireless.patch

+x86_64-mm-pit_latch_buggy-has-no-effect.patch

 x86_64 tree updates

-fully-honor-vdso_enabled.patch

 Dropped

+x86_64-irq-remove-extra-smp_processor_id-calling.patch
+x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
+x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch

 x86_64 IRQ fixes

+x86_64-map-fake-nodes-to-real-nodes-fix.patch

 Fix x86_64-map-fake-nodes-to-real-nodes.patch

+i386-vdso_prelink-warning-fix.patch

 Fix warning

+use-the-apic-to-determine-the-hardware-processor-id-i386-fix.patch

 Fix use-the-apic-to-determine-the-hardware-processor-id-i386.patch

+i386-extend-alternative-instructions-framework.patch
+x86_64-changes-to-x86_64-architecture-for.patch
+i386-add-the-x86_feature_sync_rdtsc-flag.patch
+optimize-and-simplify-get_cycles_sync.patch

 x86 updates

-acpi-fan-after-suspend-to-mem-fix.patch

 Dropped

+uml-hostfs-fix-double-free.patch
+uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
+uml-fix-a-memory-leak-in-the-multicast-driver.patch
+uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
+uml-mark-both-consoles-as-con_anytime.patch
+uml-fix-confusion-irq-early-reenabling.patch
+uml-activate_fd-return-enomem-only-when-appropriate.patch
+uml-fix-errno-usage.patch

 UML fixes

-safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
-safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch

 Folded into safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch

-use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch

 Folded into use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch

-make-try_to_unmap-return-a-special-exit-code.patch
-add-nr_mlock-zvc.patch
-add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
-add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
-logic-to-move-mlocked-pages.patch
-consolidate-new-anonymous-page-code-paths.patch
-avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
-opportunistically-move-mlocked-pages-off-the-lru.patch
-take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch

 Dropped

-lumpy-reclaim-v2.patch
-lumpy-reclaim-v2-page_to_pfn-fix.patch
-lumpy-reclaim-v2-tidy.patch
-lumpy-reclaim-cleanup.patch

 Dropped

+free-swap-space-of-reactivated-pages.patch

 Might improve behaviour under swapout with limited swapspace.

+add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
+add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
+split-the-free-lists-for-movable-and-unmovable-allocations.patch
+choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
+add-a-configure-option-to-group-pages-by-mobility.patch
+drain-per-cpu-lists-when-high-order-allocations-fail.patch
+move-free-pages-between-lists-on-steal.patch
+group-short-lived-and-reclaimable-kernel-allocations.patch
+group-high-order-atomic-allocations.patch
+bias-the-placement-of-kernel-pages-at-lower-pfns.patch
+be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
+create-the-zone_movable-zone.patch
+allow-huge-page-allocations-to-use-gfp_high_movable.patch
+x86-specify-amount-of-kernel-memory-at-boot-time.patch
+ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
+x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
+ia64-specify-amount-of-kernel-memory-at-boot-time.patch
+add-documentation-for-additional-boot-parameter-and-sysctl.patch

 Mel's stuff

-file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
-file-capabilities-honor-secure_noroot.patch

 Folded into implement-file-posix-capabilities.patch

+file-capabilities-accomodate-future-64-bit-caps.patch

 Fix implement-file-posix-capabilities.patch

+blackfin-on-chip-ethernet-mac-controller-driver-update.patch
+blackfin-blackfin-on-chip-spi-controller-driver.patch

 blackfin updates

+nommu-hide-vm_mm-in-nommu-mode.patch

 nommu tweak

-procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch

 Folded into procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch

-factor-outstanding-i-o-error-handling-tidy.patch

 Folded into block_write_full_page-handle-enospc.patch

-fix-rmmod-read-write-races-in-proc-entries.patch
-fix-rmmod-read-write-races-in-proc-entries-fix.patch

 Dropped

-filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch

 Folded into filesystem-disk-errors-at-boot-time-caused-by-probe.patch

-allow-access-to-proc-pid-fd-after-setuid-fix.patch
-allow-access-to-proc-pid-fd-after-setuid-update.patch
-allow-access-to-proc-pid-fd-after-setuid-update-2.patch

 Folded into allow-access-to-proc-pid-fd-after-setuid.patch

-fix-quadratic-behavior-of-shrink_dcache_parent-update.patch

 Folded into fix-quadratic-behavior-of-shrink_dcache_parent.patch

-ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup.patch

 Folded into ipmi-add-new-ipmi-nmi-watchdog-handling.patch

-fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch

 Folded into fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch

-cciss-fix-for-2tb-support.patch
-cciss-fix-for-2tb-support-again.patch
-cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch

 cciss patches were updated

-merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
-merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch

 Folded into merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

-timer-run-calc_load-halfway-through-each-round_jiffies.patch

 Dropped

+optimize-timespec_trunc.patch
+ext3-dirindex-error-pointer-issues.patch
+the-scheduled-removal-of-obsolete_oss-options.patch
+add-epoll-compat_-code-to-fs-compatc.patch

 Misc

-consolidate-generic_writepages-and-mpage_writepages-tidy.patch

 Folded into consolidate-generic_writepages-and-mpage_writepages.patch

-extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
-extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
-extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch

 Folded into extend-notifier_call_chain-to-count-nr_calls-made.patch

-define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch

 Folded into define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch

-eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch

 Folded into eliminate-lock_cpu_hotplug-in-kernel-schedc.patch

-workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch

 Folded into workqueue-dont-save-interrupts-in-run_workqueue.patch

-unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch

 Folded into unify-queue_delayed_work-and-queue_delayed_work_on.patch

-per-backing_dev-dirty-and-writeback-page-accounting-fix.patch

 Folded into per-backing_dev-dirty-and-writeback-page-accounting.patch

-ext2-fix-reservation-extension.patch
-make-ext2_get_blocks-static.patch
-ext2-balloc-fix-_with_rsv-freeze.patch
-ext2-balloc-reset-windowsz-when-full.patch
-ext2-balloc-fix-off-by-one-against-rsv_end.patch
-ext2-balloc-fix-off-by-one-against-grp_goal.patch
-ext2-balloc-say-rb_entry-not-list_entry.patch

 Folded into ext2-reservations.patch

-fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
-fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
-fsaio-rename-__lock_page-to-lock_page_blocking.patch
-fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
-fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
-fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
-fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
-fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
-fsaio-enable-asynchronous-wait-page-and-lock-page.patch
-fsaio-filesystem-aio-read.patch
-fsaio-aio-o_sync-filesystem-write.patch
-rework-compat_sys_io_submit.patch
-fix-aioh-includes.patch
-fix-access_ok-checks.patch
-make-good_sigevent-non-static.patch
-make-good_sigevent-non-static-fix.patch
-make-__sigqueue_free-and.patch
-aio-completion-signal-notification.patch
-aio-completion-signal-notification-fix.patch
-aio-completion-signal-notification-fixes-and-cleanups.patch
-aio-completion-signal-notification-small-cleanup.patch
-add-listio-syscall-support.patch

 Dropped

+sched-fix-idle-load-balancing-in-softirqd-context-fix.patch

 Fix sched-fix-idle-load-balancing-in-softirqd-context.patch

-speedup-divides-by-cpu_power-in-scheduler-up-fix.patch

 Folded into speedup-divides-by-cpu_power-in-scheduler.patch

+sched-optimize-siblings-status-check-logic-in-wake_idle.patch

 scheduler speedup.

-sched2-sched-domain-sysctl-use-ctl_unnumbered.patch

 Folded into sched2-sched-domain-sysctl.patch

-mm-implement-swap-prefetching-vs-zvc-stuff.patch
-mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
-mm-implement-swap-prefetching-use-ctl_unnumbered.patch
-swap_prefetch-vs-zoned-counters.patch
-add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
-zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
-reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
-sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
-numa-add-zone_to_nid-function-swap_prefetch.patch
-remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch

 Folded into mm-implement-swap-prefetching.patch

+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch

 Fix swap-prefetch for Mel's stuff

-lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch

 Folded into lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

+blackfin-blackfin-utrace-patch.patch

 utrace for blackfin

+utrace-nommu-fixup-support-utrace.patch

 Fix utrace

-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch

 Folded into atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch

-local_t-mips-extension-fix.patch
-local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
-local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
-local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch

 Folded into local_t-mips-extension.patch

-local_t-powerpc-extension-fix.patch
-local_t-powerpc-extension-shrink-powerpc-localh.patch
-local_t-powerpc-extension-fix-build-fix.patch

 Folded into local_t-powerpc-extension.patch

-linux-kernel-markers-kconfig-menus-fix.patch
-linux-kernel-markers-kconfig-menus-fix-2.patch
-linux-kernel-markers-kconfig-menus-fix-3.patch
-linux-kernel-markers-kconfig-menus-fix-4.patch
-linux-kernel-markers-kconfig-menus-fix-5.patch

 Folded into linux-kernel-markers-kconfig-menus.patch

-linux-kernel-markers-architecture-independant-code-license-fix.patch
-linux-kernel-markers-architecture-independant-code-flags.patch

 Folded into linux-kernel-markers-architecture-independant-code.patch

-linux-kernel-markers-powerpc-optimization-flags.patch

 Folded into linux-kernel-markers-powerpc-optimization.patch

-linux-kernel-markers-i386-optimization-fix.patch
-linux-kernel-markers-i386-optimization-export-fix.patch
-linux-kernel-markers-i386-optimization-flags.patch

 Folded into linux-kernel-markers-i386-optimization.patch

-linux-kernel-markers-non-optimized-architures-fallback-flags.patch

 Folded into linux-kernel-markers-non-optimized-architectures.patch

-linux-kernel-markers-documentation-fix.patch
-linux-kernel-markers-documentation-update-adds-context.patch
-linux-kernel-markers-documentation-update-markerh.patch
-linux-kernel-markers-documentation-update-flags.patch

 Folded into linux-kernel-markers-documentation.patch

-readahead-kconfig-options-fix.patch

 Folded into readahead-kconfig-options.patch

-readahead-events-accounting-make-readahead_debug_level-static.patch

 Folded into readahead-events-accounting.patch

-readahead-sysctl-parameters-use-ctl_unnumbered.patch
-readahead-sysctl-parameters-fix.patch
-readahead-sysctl-parameters-set-readahead_hit_rate=1.patch

 Folded into readahead-sysctl-parameters.patch

-readahead-min-max-sizes-remove-get_readahead_bounds.patch
-readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch

 Folded into readahead-min-max-sizes.patch

-readahead-state-based-method-aging-accounting-vs-zvc-changes.patch

 Folded into readahead-state-based-method-aging-accounting.patch

-readahead-state-based-method-prevent-tiny-size.patch
-readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch

 Folded into readahead-state-based-method.patch

-readahead-context-based-method-locking-fix.patch
-readahead-context-based-method-locking-fix-2.patch
-readahead-context-based-method-update-ra_min.patch
-readahead-context-based-method-remove-readahead_ratio.patch

 Folded into readahead-context-based-method.patch

-readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch

 Folded into readahead-initial-method-user-recommended-size.patch

-readahead-thrashing-recovery-method-fix.patch

 Folded into readahead-thrashing-recovery-method.patch

-readahead-call-scheme-ifdef-fix.patch
-readahead-call-scheme-build-fix.patch
-readahead-call-scheme-remove-get_readahead_bounds.patch
-readahead-call-scheme-fix-thrashed-unaligned-read.patch

 Folded into readahead-call-scheme.patch

-readahead-laptop-mode-fix.patch

 Folded into readahead-laptop-mode.patch

-readahead-nfsd-case-fix.patch
-readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
-readahead-nfsd-case-remove-ra_min.patch
-readahead-turn-on-by-default.patch

 Folded into readahead-nfsd-case.patch

-reiser4-sb_sync_inodes-fix.patch

 Folded into reiser4-sb_sync_inodes.patch

-reiser4-export-remove_from_page_cache-fix.patch

 Folded into reiser4-export-remove_from_page_cache.patch

-reiser4-configh.patch
-resier4-add-include-linux-freezerh-and-move-definitions-from.patch
-reiser4-reiser4_drop_page-dont-call-remove_from_page_cache.patch
-make-kmem_cache_destroy-return-void-reiser4.patch
-reiser4-hardirq-include-fix.patch
-reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
-reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
-reiser4-bug-fixes.patch
-reiser4-fix-gcc-ws-compains.patch
-fs-reiser4-possible-cleanups.patch
-reiser4-get_sb_dev-fix.patch
-reiser4-vs-zoned-allocator.patch
-inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch
-inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
-reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
-reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
-reiser4-rename-generic_sounding_globalspatch.patch
-reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch
-reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch
-reiser4-use-generic-file-read.patch
-reiser4-use-generic-file-read-fix-readpages-unix-file.patch
-reiser4-simplify-reading-of-partially-converted-files.patch
-reiser4-use-page_offset.patch
-reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
-reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
-reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
-reiser4-possible-cleanups-2.patch
-reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
-reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
-reiser4-cleanups-in-lzo-compression-library.patch
-reiser4-get-rid-of-deprecated-crypto-api.patch
-reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
-reiser4-fix-missed-unlock-and-exit_context.patch
-reiser4-use-list_head-instead-of-struct-blocknr.patch
-reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
-reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
-#
-reiser4-temp-fix.patch
-reiser4-fix-write_extent-1.patch
-fs-reiser4-possible-cleanups-2.patch
-fs-reiser4-more-possible-cleanups.patch
-reiser4-use-null-for-pointers.patch
-reiser4-kmem_cache_t-removal.patch
-reiser4-test_clear_page_dirty.patch
-reiser4-fix-readpage_cryptcompress.patch
-reiser4-improve-estimation-for-number-of-nodes-occupied.patch
-reiser4-drop-check_cryptcompress.patch
-reiser4-drop-unused-semaphores.patch
-reiser4-use-dynamic-lattice-for-adaptive-compression.patch
-reiser4-fix-freeze-and-corruption.patch
-reiser4-vs-git-block.patch
-reiser4-vs-git-block-2.patch
-reiser4-vs-git-block3.patch

 Folded into reiser4.patch

-ps3fb-thread-updates-update.patch
-ps3fb-thread-updates-2.patch
-ps3fb-thread-updates-42.patch

 Folded into ps3fb-thread-updates.patch

-fbdev-display-class-update.patch

 Folded into fbdev-display-class.patch

+fbdev-display-class-fix.patch

 Fix it

+fbdev-mm-deferred-io-support-fix.patch
+fbdev-mm-deferred-io-support-fix-2.patch

 Folded into fbdev-mm-deferred-io-support.patch

+tgafb-accelerated-code.patch

 fbdev update

-statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch

 Folded into statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch

-statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch
-statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
-statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch
-statistics-use-the-enhanced-percpu-interface.patch
-statistics-replace-inode-ugeneric_ip-with-i_private.patch

 Folded into statistics-infrastructure.patch

-zfcp-gather-hba-specific-latencies-in-statistics.patch

 Folded into statistics-infrastructure-exploitation-zfcp.patch

-integrity-service-api-and-dummy-provider-cleanup-use-of-configh.patch
-integrity-service-api-and-dummy-provider-compilation-warning-fix.patch
-integrity-service-api-and-dummy-provider-fix.patch

 Folded into integrity-service-api-and-dummy-provider.patch

-slim-main-patch-socket_post_create-hook-return-code.patch
-slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch
-slim-main-patch-handle-failure-to-register.patch
-slim-main-patch-fix-bug-with-mm_users-usage.patch
-slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
-slim-main-include-fix.patch

 Folded into slim-main-patch.patch

-slim-secfs-patch-slim-correct-use-of-snprintf.patch
-slim-secfs-patch-cleanup-use-of-configh.patch

 Folded into slim-secfs-patch.patch

-slim-make-and-config-stuff-makefile-fix.patch

 Folded into slim-make-and-config-stuff.patch

-slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
-slim-fix-security-issue-with-the-task_post_setuid-hook.patch
-slim-secfs-inode-i_private-build-fix.patch
-fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch
-panic-on-slim-selinux.patch

 Folded into slim-debug-output.patch

-mutex-subsystem-synchro-test-module-fix.patch

 Folded into mutex-subsystem-synchro-test-module.patch

-profile_likely-export-do_check_likely.patch
-profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
-profile-likely-unlikely-macros-x86_64-fix.patch

 Folded into profile-likely-unlikely-macros.patch

-lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
-lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch

 Folded into lockdep-show-held-locks-when-showing-a-stackdump.patch

-add-debugging-aid-for-memory-initialisation-problems-fix.patch

 Folded into add-debugging-aid-for-memory-initialisation-problems.patch

+mm-only-free-swap-space-of-reactivated-pages-debug.patch

 Debug swap management




All 799 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm2/patch-list


