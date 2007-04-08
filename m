Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXDHVgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXDHVgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 17:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXDHVgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 17:36:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXDHVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 17:36:05 -0400
Date: Sun, 8 Apr 2007 14:35:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc6-mm1
Message-Id: <20070408143559.f5014629.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/


- Lots of x86 updates

- This is a 25MB diff against mainline, which is rather large.



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


Changes since 2.6.21-rc5-mm4:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-e1000.patch
 git-net.patch
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees.

-md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch
-md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch
-revert-driver-core-do-not-wait-unnecessarily-in-driver_unregister.patch
-net-sunrpc-svcsockc-fix-a-check.patch
-agp-prevent-probe-collision-of-sis-agp-and-amd64_agp.patch
-cifs-remove-unneeded-checks.patch
-git-libata-all-ipr-fix.patch
-pcmcia-spot-slave-decode-flaws-for-testing.patch
-sata_nv-dont-read-shadow-registers-when-in-adma-mode.patch
-pata_ali-remove-all-the-crap-again-and-switch-to.patch
-pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
-pata_netcell-re-remove-all-the-crud.patch
-pata_qdi-restore-cable-detect.patch
-pata_sl82c105-restore-cable-detect-method.patch
-pata_winbond-restore-cable-method.patch
-pata_optidma-rework-for-cable-detect-and-to-remove.patch
-ide-sl82c105-rework-pio-support.patch
-ide-sl82c105-dma-support-code-cleanup-take3.patch
-mtd-pmc-msp71xx-flash-rootfs-mappings.patch
-jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
-mtd-support-for-auto-locking-flash-on-power-up.patch
-make-drivers-net-qla3xxxcphy_devices-static.patch
-git-wireless-debug-build-fixes.patch
-cxgb3-safeguard-tcam-size-usage.patch
-cxgb3-detect-nic-only-adapters.patch
-cxgb3-tighten-xgmac-workaround.patch
-cxgb3-firwmare-update.patch
-fix-scsi_send_eh_cmnd-scatterlist-handling.patch
-slab-mention-slab-name-when-listing-corrupt-objects.patch
-turn-do_sync_file_range-into-do_sync_mapping_range.patch

 Merged into mainline or a subsystem tree.

+fuse-validate-rootmode-mount-option.patch
+proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
+omap_cf-oops-on-suspend-fix.patch
+x86_64-early-quirks-fix-early_qrk-section-tag.patch
+i386-irqbalance_disable-section-fix.patch

 2.6.21 queue.

-vmi-paravirt-ops-bugfix-for-2621.patch

 Dropped.

+make-proc-acpi-wakeup-more-useful.patch
+sony-laptop-remove-acpi-references-from-variable-and-function-names.patch
+sony-laptop-prepare-the-platform-driver-for-multiple-users.patch
+sony-laptop-add-debug-macros-also-used-by-the-sonypi-reimplementation.patch
+sony-laptop-add-sny6001-device-handling-sonypi-reimplementation.patch
+sony-laptop-unify-the-input-subsystem-event-forwarding.patch
+sony-laptop-additional-platform-attributes-coming-from-sny6001.patch
+sony-laptop-sanitize-printks.patch
+sony-laptop-update-documentation-and-kconfig-help.patch
+sony-laptop-add-sonypi-compat-code.patch

 sony-laptop work.

+arm-fix-section-mismatch-warning-in-board-sam9260.patch

 ARM fix

+agk-dm-dm-bio-list-helpers.patch
+agk-dm-dm-delay.patch

 device-mapper tree updates

+unused-round_up-name_offset-macro-in-arch-powerpc.patch

 powerpc cleanup

+fix-sysfs_readdir-oops.patch

 Another go at fixing the rare sysfs readdir crash

+i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch

 I2C tree update

+git-input-fixup.patch

 Fix rejects in git-input

+input-replace-more-deprecated-sa_xxx-interrupt-flags.patch

 Cleanup

+pata_acpi-restore-driver-fix-2.patch

 Fix pata_acpi-restore-driver.patch

+drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch

 ata build fix

+ide-ide-correctly-prevent-ide-timer-expiry-function-to-run-if-request-was-already-handled.patch
+ide-ide-ugly-messages-trying-to-open-cd-drive-with-no-media-present.patch
+ide-ide-add-optical-to-sysfs-media-attribute.patch
+ide-sl82c105-rework-pio-support-take2.patch
+ide-sl82c105-dma-support-code-cleanup-take4.patch
-ide-sl82c105-add-speedproc.patch
+ide-sl82c105-add-speedproc-method-and-mwdma01-support.patch

 IDE tree updates

+vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch

 netdev cleanup

+net-possible-cleanups.patch
+round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch

 net cleanups

+iucv-fix-compilation-on-s390-up.patch

 net build fix

+pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
+at91_cf-minor-fix.patch

 pcmcia updates

+git-r8169-fixup.patch

 Fix rejects in git-r8169.patch

+8250_pci-fix-pci-must_checks.patch

 PCI fixes

+scsi-fix-config_scsi_wait_scan=m.patch
+scsi-fix-config_scsi_wait_scan=m-fix.patch
+scsi-fix-config_scsi_wait_scan=m-fix-fix.patch

 scsi fixes

+usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
+hid-add-quirk_hiddev-for-belkin-flip-kvm.patch

 USB updates

+revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch

 Revert temp-for-2.6.21 VMI patch

+fix-x86_64-mm-fix-amd64-agp-aperture-validation.patch
+paravirt_ops-update-maintainers.patch
+paravirt_ops-remove-config_debug_paravirt.patch
+paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
+paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
+paravirt_ops-hooks-to-set-up-initial-pagetable.patch
+paravirt_ops-allocate-a-fixmap-slot.patch
+paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
+paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
+paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
+paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
+paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
+paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
+paravirt_ops-document-asm-i386-paravirth.patch
+paravirt_ops-clean-up-paravirt-patchable-wrappers.patch
+paravirt_ops-add-common-patching-machinery.patch
+paravirt_ops-add-flush_tlb_others-paravirt_op.patch
+paravirt_ops-revert-map_pt_hook.patch
+paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
+add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
+re-enable-vdso-by-default-with-paravirt.patch
+remove-noreplacement-option.patch
+remove-smp_alt_instructions.patch
+rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
+rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
+allow-boot-time-disable-of-smp-altinstructions.patch
+allow-boot-time-disable-of-paravirt_ops-patching.patch
+fix-mtrr-sections.patch
+i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
+i386-clean-up-asm-i386-bugsh.patch
+x86_64-clean-up-asm-x86_64-bugsh.patch
+x86-clean-up-identify_cpu.patch
+x86-clean-up-identify_cpu-update.patch
+i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
+i386-make-compat_vdso-runtime-selectable.patch
+i386-cleanup-flush_tlb_others-fn.patch
+i386-mce-check-capability.patch

 x86 updates

-i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch

 Dropped

+xfs-clean-up-shrinker-games.patch

 xfs cleanup

+fix-hotplug-for-legacy-platform-drivers-update.patch

 Fix fix-hotplug-for-legacy-platform-drivers.patch

+depcac-fix-handling-of-platorm_device_add-failure.patch
+pktgen-add-try_to_freeze.patch

 Fixes for 2.6.21 (IMO)

+move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch

 Fix Mel's MM stuff

+maps2-uninline-some-functions-in-the-page-walker.patch
+maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
+maps2-remove-vma-from-args-in-the-page-walker.patch
+maps2-propagate-errors-from-callback-in-page-walker.patch
+maps2-add-callbacks-for-each-level-to-page-walker.patch
+maps2-move-the-page-walker-code-to-lib.patch
+maps2-move-the-page-walker-code-to-lib-fix.patch
+maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
+maps2-move-clear_refs-code-to-task_mmuc.patch
+maps2-regroup-task_mmu-by-interface.patch
+maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
+maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
+maps2-add-proc-pid-pagemap-interface.patch
+maps2-add-proc-kpagemap-interface.patch

 New interfaces for inspecting process memory status

+mm-clean-up-and-kernelify-shrinker-registration.patch

 MM cleanup

+fix-section-mismatch-of-memory-hotplug-related-code.patch
+add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
+split-mmap.patch
+only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
+i386-use-page-allocator-to-allocate-thread_info-structure.patch
+slub-fix-numa-bootstrap.patch
+slub-use-correct-flags-to-check-for-dma-cache.patch
+slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
+make-page-private-usable-in-compound-pages-v1.patch
+add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch

 MM updates

+blackfin-arch-always-include-linux-kallsysms-header-file.patch
+blackfin-arch-sync-with-uclibc-no-functional-changes.patch
+blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
+blackfin-arch-add-missing-__clear_user-function-to.patch
+blackfin-arch-use-boot_command_line-instead-of.patch
+blackfin-arch-fix-some-coding-style-in-include.patch
+blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
+blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
+blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
+blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch

 Blackfin updates

+round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch

 Alpha cleanup

+freezer-remove-pf_nofreeze-from-handle_initrd.patch

 swsusp fix

+cris-remove-code-related-to-pre-22-kernel.patch

 Cris cleanup

+uml-tidy-processc-fix.patch

 Fix uml-tidy-processc.patch

+uml-tidy-fault-code.patch
+uml-kernel-segfaults-should-dump-proper-registers.patch
+uml-comment-early-boot-locking.patch
+uml-irq-locking-commentary.patch
+uml-delete-host_frame_size.patch
+uml-drivers-get-release-methods.patch
+uml-dump-registers-on-ptrace-or-wait-failure.patch
+uml-speed-up-page-table-walking.patch

 UML updates

-serial-allocate-minor-device-numbers-for.patch

 Dropped (I think)

+move-die-notifier-handling-to-common-code-fix.patch

 Fix move-die-notifier-handling-to-common-code.patch some more

-remove-hardcoding-of-hard_smp_processor_id-on-up.patch

 Updated version was merged

+unexport-pci_proc_attach_device.patch

 Cleanup

+kdump-kexec-calculate-note-size-at-compile-time-update-2.patch

 Fix kdump-kexec-calculate-note-size-at-compile-time.patch

+pnpacpi-sets-pnpdev-devarchdata.patch
+simplify-module_get_kallsym-by-dropping-length-arg.patch
+fix-race-between-rmmod-and-cat-proc-kallsyms.patch
+simplify-kallsyms_lookup.patch
+fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
+fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
+kernel-paramsc-fix-lying-comment-for-param_array.patch
+replace-deprecated-sa_xxx-interrupt-flags.patch
+deprecate-sa_xxx-interrupt-flags-v2.patch
+expose-range-checking-functions-from-arch-specific.patch
+remove-hardcoding-of-hard_smp_processor_id-on-up.patch
+use-the-apic-to-determine-the-hardware-processor-id-i386.patch
+use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
+always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
+round_up-macro-cleanup-in-drivers-char-lpc.patch
+i386-schedh-inclusion-from-moduleh-is-baack.patch
+parport_serial-fix-pci-must_checks.patch
+round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
+round_up-macro-cleanup-in-fs-smbfs-requestc.patch
+doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
+kernel-doc-handle-spaces-in-array-size.patch
+kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch

 Misc

+sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

 sched speedup

+revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

 Revert it again so that Con's stuff applies

+sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch

 staircase sched fix

-clocksource-arm-initialize-list-value.patch
-clocksource-parisc-initialize-list-value.patch
-clocksource-avr32-initialize-list-value.patch
-clocksource-mips-initialize-list-value.patch
-clocksource-i386-initialize-list-value.patch
-clocksource-x86_64-initialize-list-value.patch
-clocksource-s390-initialize-list-value.patch
-clocksource-driver-initialize-list-value.patch
-clocksource-refactor-duplicate-registration-checking.patch

 Dropped

+kprobes-the-on-off-knob-thru-debugfs-updated.patch
+kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch

 kprobes work

+undo-utrace-prep-2.patch
-utrace-x86_64-fix.patch

 utrace tweaks

+signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
+signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
+signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch
+signal-timer-event-fds-v9-timerfd-core-fix.patch
+signal-timer-event-fds-v9-timerfd-core-fix-fix.patch
+signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
+signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch

 Various fixes and updates against the signalfd work in -mm.

+epoll-cleanups-epoll-no-module.patch
+epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch

 epoll stuff

+char-cyclades-remove-pause.patch
+char-cyclades-cy_readx-writex-cleanup.patch
+char-cyclades-timer-cleanup.patch
+char-cyclades-remove-volatiles.patch
+char-cyclades-remove-useless-casts.patch

 cyclades cleanups

+pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
+pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
+smsc-ircc2-tidy-up-module-parameter-checking.patch
+smsc-ircc2-add-pnp-support.patch
+x86-serial-convert-legacy-com-ports-to-platform-devices.patch
+x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch

 PNP work

+locks-trivial-removal-of-unnecessary-parentheses.patch
+locks-create-posix-to-flock-helper-functions.patch
+locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
+locks-give-posix_test_lock-same-interface-as-lock.patch
+locks-factor-out-generic-filesystem-switch-from-test_lock.patch
+locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
+locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
+locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
+locks-add-lock-cancel-command.patch
+nfsd4-convert-nfsv4-to-new-lock-interface.patch
+lockd-save-lock-state-on-deferral.patch
+lockd-handle-fl_notify-callbacks.patch
+lockd-pass-cookie-in-nlmsvc_testlock.patch
+lockd-handle-test_lock-deferrals.patch
+lockd-always-preallocate-block-in-nlmsvc_lock.patch
+lockd-add-code-to-handle-deferred-lock-requests.patch
+gfs2-nfs-lock-support-for-gfs2.patch

 Rework file locking code for nfs

+mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch

 update reiser4 for shrinker changes

+s3fb-fix-pci-must_checks.patch

 fbdev driver fixes




All 1405 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/patch-list


