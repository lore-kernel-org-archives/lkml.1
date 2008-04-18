Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYDRIsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYDRIsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYDRIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:48:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbYDRIsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:48:00 -0400
Date: Fri, 18 Apr 2008 01:47:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-mm1
Message-Id: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 

- git-xfs is undropped because I finally got around to fixing its clashes
  with git-vfs.

- git-arm-master, git-sparc64 and perhaps others are dropped because they
  don't generate a clean pull.  They might be empty - I didn't check.

- git-kvm remains dropped due to clashes with git-s390 and perhaps git-x86.

- git-selinux is newly dropped due to memory corruption regressions.

- git-nfs is (perhaps permanently) dropped because its content is also in
  git-nfsd.

- git-drm remains reverted due to build failures

- Tomorrow I'll do the -mm merge plans email and I'll dump a couple hundred
  patches on tree maintainers (these have about a 15% yay-he-merged-it rate).

  Then I'm travelling for a poorly-timed week.  I return late in the merge
  window to find out if any of these patches still apply.



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
  the mm-commits list.  These probably are at least compilable.

- More-than-daily -mm snapshots may be found at
  http://userweb.kernel.org/~akpm/mmotm/.  These are almost certainly not
  compileable.





Changes since 2.6.25-rc8-mm2:


 git-acpi.patch
 git-x86.patch
 git-kgdb-light.patch
 git-alsa-tiwai.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-dlm.patch
 git-hid.patch
 git-hrt.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-leds.patch
 git-libata-all.patch
 git-async-tx.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-udf.patch
 git-net.patch
 git-battery.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-security-testing.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-vfs.patch
 git-watchdog.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-pekka.patch
 git-semaphore.patch

 git trees

-cgroups-include-hierarchy-ids-in-proc-pid-cgroup.patch
-rtc-rtc-s35390ac-needs-the-bitreverse-library.patch
-eventfd-kaio-integration-fix.patch
-i2c-fix-platform-driver-hotplug-coldplug.patch
-spi-fix-platform-driver-hotplug-coldplug.patch
-usb-gadget-fix-platform-driver-hotplug-coldplug.patch
-usb-host-fix-platform-driver-hotplug-coldplug.patch
-watchdog-fix-platform-driver-hotplug-coldplug.patch
-rtc-fix-platform-driver-hotplug-coldplug.patch
-cciss-error-implicit-declaration-of-function-sg_init_table.patch
-hfs-fix-unlink-of-links.patch
-md-close-a-livelock-window-in-handle_parity_checks5.patch
-pnp-increase-number-of-devices-supported-per-protocol.patch
-signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch
-lzo-fix-typo-in-decompresor.patch
-generic_file_splice_read-fix-lockups.patch
-acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch
-git-acpi-revert-suspend-wakeup-code-in-c.patch
-revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only.patch
-git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5.patch
-git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch
-x86_64-do-not-reserve-ramdisk-two-times.patch
-git-alsa-tiwai-hda_codec-fix-locking.patch
-usb-audio-fix-another-dallas-quirk.patch
-usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch
-es1968-fix-jitter-on-some-maestro-cards.patch
-es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
-sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch
-lmb-add-lmb_alloc_nid.patch
-pm-remove-destroy_suspended_device.patch
-sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
-pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
-pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
-pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
-pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
-pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch
-v4l-common-replace-remaining-__function__-occurences.patch
-v4l-dvb-replace-remaining-__function__-occurences.patch
-v4l-video-replace-remaining-__function__-occurences.patch
-jdelvare-i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup.patch
-jdelvare-i2c-i2c-davinci-01-fix-lost-interrupt.patch
-jdelvare-i2c-i2c-tiny-usb-new-vid-pid-pair.patch
-maple-add-driver-for-sega-dreamcast-controller.patch
-input-put-ledstate-in-the-keyboard-notifier.patch
-aiptekc-add-support-for-genius-g-pen-560-tablet.patch
-ps-2-serio-driver-for-avr32-devices.patch
-input-replace-remaining-__function__-occurrences.patch
-git-libata-all-unbork-drivers-ata-sata_sx4c.patch
-ide-mm-remove-include-linux-hdsmart-h.patch
-ide-mm-ide-remove-cds-field-from-ide_hwif_t.patch
-ide-mm-scc_pata-add-in-out-put_data-methods.patch
-ide-mm-au1xxx-ide-add-in-out-put_data-methods.patch
-ide-mm-ide-h8300-add-in-out-put_data-methods.patch
-ehea-fix-dlpar-memory-add-support.patch
-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
-revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
-pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch
-sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
-sh-export-empty_zero_page.patch
-aacraid-fix-unchecked-down_interruptible.patch
-cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch
-gregkh-usb-usb-replace-remaining-__function__-occurrences.patch
-gregkh-usb-usb-remove-unnecessary-type-casting-of-urb-context.patch
-usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch
-xfs-replace-remaining-__function__-occurrences.patch
-xfs-replace-__inline-with-inline.patch
-acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch
-acpi-thermal-trip-points-increased-to-12.patch
-forcedeth-mac-address-fix.patch
-smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
-sc92031-sysfs-link-missing.patch
-usb-fix-interface-deregistration-during-unbind-operations.patch
-frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch
-frv-move-stack_top_max-up.patch
-frv-add-support-for-emulation-of-userspace-atomic-ops.patch
-frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch
-frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch
-usb-serial-more-fixes-and-groundwork-for-tty-changes.patch
-proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
-proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
-documentation-patch-tags-one-more-time.patch

 Merged into mainline or a subsystem tree.

-revert-x86-fix-call-to-set_cyc2ns_scale-from-time_cpufreq_notifier.patch

 Dropped

+mm-fix-possible-off-by-one-in-walk_pte_range.patch
+dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
+disable-the-memory-controller-by-default-v3.patch
+disable-the-memory-controller-by-default-v3-fix.patch
+cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list.patch
+rtc-pcf8583-build-fix.patch
+memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch

 2.6.25 queue.  Whoops.  These are tagged for 2.6.25.1.

+hotplug-memory-make-online_page-common.patch
+hotplug-memory-make-online_page-common-fix.patch

 memory-hotplug work.

+aio-io_getevents-should-return-if-io_destroy-is-invoked.patch

 AIO fix.

+acpi-video-balcklist-fujitsu-lifebook-s6410.patch

 ACPI fix

+miscacpibacklight-compal-laptop-extras-add-entry-to-maintainers.patch
+miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex.patch
+miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops.patch
+acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch

 Update miscacpibacklight-compal-laptop-extras-3rd-try.patch

+thinkpad-acpi-fix-possible-null-pointer-dereference.patch

 thinkpad driver fix

+x86_64-restore-mask_bits-in-msi-shutdown.patch
+x86-ptrace-pebs-support.patch
+x86-ptrace-pebs-support-warning-fix.patch
+arch-x86-video-fbdevc-add-module_license.patch

 x86 fixes

+git-arm-fix.patch

 Fix build in git-arm.patch

+agk-dm-dm-table-improve-unplug-performance.patch
+agk-dm-dm-table-drop-void-suspend_targets-return.patch
+agk-dm-dm-table-remove-unused-dm_create_error_table.patch
+agk-dm-dm-raid1-use-timer.patch

 device mapper tree updates

+macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch

 mac driver fix

+gregkh-driver-uio-hold-a-reference-to-the-device-s-owner-while-the-device-is-open.patch
+gregkh-driver-pm-remove-destroy_suspended_device.patch
+gregkh-driver-sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
+gregkh-driver-sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch
+gregkh-driver-pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch
+gregkh-driver-pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch
+gregkh-driver-pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch

 DRiver tree updates

+s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch

 PM debugging

+sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch

 Make a sysfs warning which shouldn't be coming out look less puzzling.

+revert-git-drm.patch

 Revert it via patch so I notice when it gets updated.

+git-dvb-kconfig-fix.patch

 git-dvb build fix

+jdelvare-i2c-i2c-bfin-twi-04-driver-description.patch
+jdelvare-i2c-i2c-fix-platform-driver-hotplug-coldplug.patch

 I2C tree updates

+input-fix-platform-driver-hotplug-coldplug.patch

 Fix hotplugging in input drivers

+ata-ide-fix-platform-driver-hotplug-coldplug.patch

 Fix hotplugging

+ide-mm-scc_pata-c-do-setup-itself-instead-of-ide_setup_pci_device.patch
+ide-mm-ide-make-ide_pci_check_iomem-actually-work.patch
+ide-mm-scc_pata-ide_find_port.patch
+ide-mm-ide-remove-cds-field-from-ide_hwif_t-take-2.patch
+ide-mm-ide-add-struct-ide_dma_ops-take-3.patch
+ide-mm-ide-add-struct-ide_io_ports-take-2.patch
+ide-mm-scc_pata-add-in-out-put_data-methods-take-2.patch
+ide-mm-au1xxx-ide-add-in-out-put_data-methods-take-2.patch
+ide-mm-ide-h8300-add-in-out-put_data-methods-take-2.patch
+ide-mm-ide-always-use-outbsync-method-for-executing-commands.patch
+ide-mm-ide-floppy-tape-scsi-400ns-delay-is-required-after-executing-the-command.patch
+ide-mm-ide-add-ide_execute_pkt_cmd-helper.patch
+ide-mm-ide-factor-out-debugging-code-from-ide_tf_load.patch
+ide-mm-ide-move-ide_tf_load-read-to-ide-iops-c.patch
+ide-mm-ide-add-tf_load-and-tf_read-methods.patch
+ide-mm-ide-cris-add-tf_load-read-methods.patch
+ide-mm-ide-h8300-add-tf_load-read-methods.patch
+ide-mm-scc_pata-add-tf_load-read-methods.patch
+ide-mm-ns87415-add-tf_read-method.patch
+ide-mm-ide-use-ide-io-helpers-directly-in-ide_tf_load-read.patch
+ide-mm-ide-remove-inw-and-outw-methods.patch
+ide-mm-ide-add-ide_pad_transfer-helper.patch
+ide-mm-ide-skip-vlb-sync-if-host-uses-mmio.patch
+ide-mm-scc_pata-add-dma_host_set-and-dma_start-methods.patch
+ide-mm-ide-remove-dma_vendor1-3-fields-from-ide_hwif_t.patch
+ide-mm-ide-remove-dma_prdtable-field-from-ide_hwif_t.patch
+ide-mm-remove-the-broken-etrax_ide-driver.patch

 IDE tree updates

+mtd-maps-fix-platform-driver-hotplug-coldplug.patch
+mtd-nand-fix-platform-driver-hotplug-coldplug.patch

 Fix hotplugging

+drivers-atm-use-time_before-time_before_eq-etc.patch
+drivers-net-appletalk-use-time_before-time_before_eq-etc.patch

 net cleanups

 ehea-fix-dlpar-memory-add-support-fix.patch

 This got stranded because Jeff merged the base patch but didn't merge my
 fix to it.

+net-drivers-fix-platform-driver-hotplug-coldplug.patch
+net-drivers-fix-platform-driver-hotplug-coldplug-sgiseeq-fix.patch
+smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch
+smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt-checkpatch-fixes.patch

 net driver things

+blackfin-add-include-boot-gitignore-files.patch

 blackfin fix

+nfs-fix-potential-null-pointer-dereference-v2.patch
+nfs-lsm-make-nfsv4-set-lsm-mount-options.patch

 nfs fixes

+gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch
+gregkh-pci-pci-hotplug-fakephp-return-success-not-enodev-when-bus-rescan-is-triggered.patch

 PCI tree updates

-pci-hotplug-introduce-pci_slot-fix.patch
-pci-hotplug-introduce-pci_slot-fix-fix.patch
-pci-hotplug-introduce-pci_slot-fix-2.patch
-pci-hotplug-introduce-pci_slot-fix-99.patch
-pci-hotplug-introduce-pci_slot-fix-3.patch

 Folded into pci-hotplug-introduce-pci_slot.patch

-pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
-drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch

 Folded into pci-hotplug-acpi-pci-slot-detection-driver.patch

+rcu-add-call_rcu_sched.patch
+rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
+rcu-add-rcu_barrier_sched-and-rcu_barrier_bh.patch
+rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
+rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch

 RCU updates

+scsi-fix-platform-driver-hotplug-coldplug.patch
+scsi-fix-platform-driver-hotplug-coldplug-sgiwd93-fix.patch

 Fix hotplugging

+mpt-remove-unused-struct-mpt_proc_entry_t.patch
+drivers-scsi-use-time_before-time_before_eq-etc.patch

 scsi driver cleanups

-kconfig-cleanup-block-kconfigiosched-help-descriptions.patch

 Dropped due to rejects (I think)

+gregkh-usb-usb-cp2101-add-new-device-ids.patch
+gregkh-usb-usb-fix-memory-leak-in-mon_stat_release.patch
+gregkh-usb-checkpatch-usb_free_urb-can-take-null.patch
+gregkh-usb-usb-serial-sierra-add-new-dev-group.patch
+gregkh-usb-usb-ohci-fix-bug-in-controller-resume.patch
+gregkh-usb-usb-convert-away-from-urb-status-in-xpad-driver.patch
+gregkh-usb-usb-root-hubs-don-t-lie-about-their-number-of-tts.patch
+gregkh-usb-usb-clarify-usage-of-hcd-suspend-resume-methods.patch
+gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch
+gregkh-usb-usb-replace-remaining-__pretty_function__-occurrences.patch
+gregkh-usb-usb-rework-sysfs-removal-of-interface-files.patch
+gregkh-usb-usb-gadget-section-fixes.patch
+gregkh-usb-usb-dummy-hcd-use-dynamic-allocation-for-platform_devices.patch
+gregkh-usb-usb-at91_udc-can-prefetch-data.patch
+gregkh-usb-usb-ehci-shutdown-refactored.patch
+gregkh-usb-usb-oti6858-fix-tcflsh-ioctl-handling.patch
+gregkh-usb-usb-r8a66597-hcd-fix-interrupt-transfer-interval.patch
+gregkh-usb-usb-r8a66597-hcd-fix-usb-device-connection-timing.patch
+gregkh-usb-usb-r8a66597-hcd-add-support-for-sh7366-usb-host.patch
+gregkh-usb-usb-add-extension-of-anchor-api-usb_unlink_anchored_urbs.patch
+gregkh-usb-usb-remove-superfluous-depends-on-usb_serial-from-kconfig.patch
+gregkh-usb-usb-update-comments-about-usb-driver-s-header.patch
+gregkh-usb-usb-log-an-error-message-when-usb-enumeration-fails.patch
+gregkh-usb-usb-ehci-qh-qtd-cleanup-comments.patch
+gregkh-usb-usb-add-documentation-about-usb_anchor.patch
+gregkh-usb-usb-optionc-correct-dtr-behaviour.patch
+gregkh-usb-usb-serial-remove-unneeded-number-endpoints-settings.patch
+gregkh-usb-usb-serial-remove-endpoints-setting-checks-from-core-and-header.patch
+gregkh-usb-usb-g_file_storage-ignore-bulk-out-data-after-invalid-cbw.patch
+gregkh-usb-usb-hcds-use-the-do_remote_wakeup-flag.patch
+gregkh-usb-usb-ohci-turn-off-rd-when-remote-wakeup-is-disabled.patch
+gregkh-usb-usb-don-t-explicitly-reenable-root-hub-status-interrupts.patch
+gregkh-usb-usb-add-documentation-about-callbacks.patch
+gregkh-usb-usb-cdc-acm-signedness-fix.patch
+gregkh-usb-usb-ehci-qh_completions-cleanup-and-bugfix.patch
+gregkh-usb-usb-replace-remaining-__function__-occurrences.patch
+gregkh-usb-usb-serial-more-fixes-and-groundwork-for-tty-changes.patch
+gregkh-usb-usb-remove-unnecessary-type-casting-of-urb-context.patch
+gregkh-usb-wusb-add-the-wireless-usb-stack-to-linux.patch
+gregkh-usb-wusb-add-whc-rc-radio-control-driver.patch
+gregkh-usb-wusb-add-hwa-rc-radio-controller-driver.patch
+gregkh-usb-wusb-add-uwb-core-for-wimedia-link-protocol.patch
+gregkh-usb-wusb-add-the-i1480-driver.patch
+gregkh-usb-wusb-add-the-usb-wireless-core-code.patch
+gregkh-usb-wusb-add-the-usb-wusb-cbaf-driver.patch
+gregkh-usb-wusb-add-the-usb-wireless-core-host-controller-helper-driver.patch
+gregkh-usb-wusb-add-hwa-hc-wireless-host-controller-driver.patch

 USB tree updates

+fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch
+fix-gregkh-usb-wusb-add-the-wireless-usb-stack-to-linux.patch
+fix-gregkh-usb-usb-hcds-use-the-do_remote_wakeup-flag.patch
+uwb-seems-to-need-pci.patch

 Fix it.

+git-xfs-fixups.patch

 Repair git-xfs

+aes-x86_64-asm-implementation-optimization.patch

 Make Intel crypto faster than AMD crypto ;)

-git-semaphore-vs-git-x86.patch

 Dropped

+input-replace-remaining-__function__-occurrences.patch

 cleanups

+pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch
+pageflags-get-rid-of-flags_reserved-sparc64-fix.patch

 Update the page-flags patches in -mm.

+mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch

 Fix mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch

+mm-page_allocc-remove-hand-coded-get_order.patch
+mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch
+mm-fix-misleading-__gfp_repeat-related-comments.patch
+page-allcoator-smarter-retry-of-costly-order-allocations.patch
+page-allocator-explicitly-retry-hugepage-allocations.patch

 MM work

+uml-make-a-function-static.patch
+uml-remove-a-useless-function.patch
+uml-make-three-functions-static.patch
+uml-make-several-things-static.patch
+arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch
+uml-clean-up-arch-um-drivers-ubd_kernc.patch

 UML updates

+update-checkpatchpl-to-version-018.patch

 checkpatch update

+smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

 smb.h fixlet.

+utimensat-non-conformances-and-fixes.patch
+utimensat-non-conformances-and-fixes-checkpatch-fixes.patch

 utimes fixes (awaiting input from Ulrich)

+serial-use-time_before-time_before_eq-etc.patch
+atmel_serial-remove-duplicated-macro-definition.patch

 Serial updates

+capifs-fix-memory-leak-on-remount.patch

 i4l fix

+ecryptfs-introduce-device-handle-for-userspace-daemon-communications.patch
+ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
+ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch
+ecryptfs-make-key-module-subsystem-respect-namespaces.patch
+ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
+ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch

 ecryptfs updates

+rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch
+drivers-char-rtcc-use-time_before-time_before_eq-etc.patch

 RTC updates

+x86-geode-add-virtual-systems-architecture-detection.patch
+gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
+gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
+olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch
+olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch

 geode/olpc things

+drivers-video-uvesafbc-fix-error-path-memory-leak.patch
+fb-convert-proc-fb-to-seq_file-interface.patch
+fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
+fbdev-intelfb-add-support-for-the-intel-integrated-graphics-controller-965g-965gm.patch
+drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
+x86-olpc-add-one-laptop-per-child-architecture-support.patch
+x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
+x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch

 fbdev updates

+raid-remove-leading-tab-on-printk-messages.patch
+raid-remove-trailing-space-from-printk-line.patch
+drivers-md-use-time_before-time_before_eq-etc.patch
+drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch

 MD udpates

+ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
+ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch

 ext3 fix

+ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
+ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
+ext3-fix-mount-messages-when-quota-disabled.patch

 ext3 fixes

+cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch

 Fix cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch

+cgroups-add-an-owner-to-the-mm_struct.patch

 cgroups work.

+use-vmalloc-for-mem_cgroup-allocation-v3.patch
+use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch

 memcg work

+ptrace_signal-subroutine.patch

 ptrace cleanup

+ext4-fix-mount-messages-when-quota-disabled.patch

 ext4 fix

+ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch
+ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch
+ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
+ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch

 ipc/namespace work

+ipmi-remove-write_proc-code.patch

 ipmi cleanup

+drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

 char driver cleanup

+s390-tty-prepare-for-put_char-to-return-success-fail.patch
+serial-m68k-put_char-returns.patch
+usb-gadget-switch-to-put_char-returning-int.patch
+amiserial-switch-put-char-to-return-success-fail.patch
+char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
+mxser-switch-to-put_char-being-int.patch
+pcmcia-serial-to-int-put_char-method.patch
+riscom-rocket-switch-to-int-put_char-method.patch
+serial167-switch-to-int-put_char-method.patch
+specialix-switch-to-int-put_char-method.patch
+synclink-series-switch-to-int-put_char-method.patch
+consoles-switch-to-int-put_char-method.patch
+isdn-switch-to-int-put_char-method.patch
+pty-prepare-for-tty-ops-changes.patch
+pc300-update-to-tty_set_operations.patch
+serial-switch-the-serial-core-to-int-put_char-methods.patch
+isicom-bring-into-coding-style.patch
+isicom-bring-into-coding-style-fix.patch
+tty-the-big-operations-rework.patch
+tty-the-big-operations-rework-fix-2.patch
+tty-the-big-operations-rework-isicom-fix.patch
+tty-the-big-operations-rework-simserial-fix.patch
+strip-fix-up-strip-for-the-new-order.patch
+tty-the-big-operations-rework-vs-git-kgdb-light.patch
+tty-the-big-operations-rework-vs-kgdb-2.patch
+tty-the-big-operations-rework-broke-wan.patch
+tty-fix-routine-name-in-ptmx_open.patch
+devpts-propagate-error-code-from-devpts_pty_new.patch
+devpts-factor-out-pty-index-allocation.patch
+devpts-factor-out-pty-index-allocation-fix.patch

 TTY driver work.

+proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
+proc-introduce-proc_create_data-to-setup-de-data.patch
+nfsd-use-proc_create-to-setup-de-proc_fops.patch
+nfs-use-proc_create-to-setup-de-proc_fops.patch
+afs-use-non-racy-method-for-proc-entries-creation.patch
+ext4-use-non-racy-method-for-proc-entries-creation.patch
+reiserfs-use-non-racy-method-for-proc-entries-creation.patch
+jbd2-use-non-racy-method-for-proc-entries-creation.patch
+sysvipc-use-non-racy-method-for-proc-entries-creation.patch
+mm-use-non-racy-method-for-proc-swaps-creation.patch
+sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
+zorro-use-non-racy-method-for-proc-entries-creation.patch
+samples-use-non-racy-method-for-proc-marker-example-creation.patch
+scsi-use-non-racy-method-for-proc-entries-creation.patch
+usb-use-non-racy-method-for-proc-entries-creation.patch
+s390-use-non-racy-method-for-proc-entries-creation.patch
+arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
+avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
+cris-use-non-racy-method-for-proc-system_profile-creation.patch
+ia64-use-non-racy-method-for-proc-entries-creation.patch
+parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
+powerpc-use-non-racy-method-for-proc-entries-creation.patch
+acpi-use-non-racy-method-for-proc-entries-creation.patch
+netdev-use-non-racy-method-for-proc-entries-creation.patch
+isdn-use-non-racy-method-for-proc-entries-creation.patch
+kernel-use-non-racy-method-for-proc-entries-creation.patch
+parisc-use-non-racy-method-for-proc-entries-creation.patch
+drivers-use-non-racy-method-for-proc-entries-creation.patch
+drivers-use-non-racy-method-for-proc-entries-creation-2.patch

 procfs work

+kernel-add-common-infrastructure-for-unaligned-access.patch
+kernel-move-arches-to-use-common-unaligned-access.patch
+drivers-block-use-get_unaligned_-helpers.patch
+hid-core-use-get_unaligned_-helpers.patch
+char-use-get_unaligned_-helpers.patch
+input-use-get_unaligned_-helpers.patch
+mmc-use-get-put_unaligned_-helpers.patch
+net-use-get-put_unaligned_-helpers.patch
+wireless-use-get-put_unaligned_-helpers.patch
+pcmcia-use-get-put_unaligned_-helpers.patch
+usb-use-get-put_unaligned_-helpers.patch
+video-use-get-put_unaligned_-helpers.patch
+fat-use-get-put_unaligned_-helpers.patch
+hfsplus-use-get-put_unaligned_-helpers.patch
+isofs-use-get-put_unaligned_-helpers.patch
+ncpfs-use-get-put_unaligned_-helpers.patch
+ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch

 unaligned access cleanups

+omap_rng-minor-updates.patch

 rng updates

+relayfs-support-larger-relay-buffer-take-3.patch
+relayfs-support-larger-relay-buffer-take-3-cleanup.patch

 relatfs update

+aio-remove-misleading-comment-from-ioctx_lookup.patch

 AIO cleanup

+add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
+x86-use-kbuildh.patch
+mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
+alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
+ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
+arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
+xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
+sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
+blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
+frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
+sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
+v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

 cleanups to asm-offsets.c

+proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

 procfs cleanup



6045 commits in 1878 patch files


All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 


