Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXCHET0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXCHET0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXCHET0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:19:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbXCHETX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:19:23 -0500
Date: Wed, 7 Mar 2007 20:18:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc3-mm1
Message-Id: <20070307201839.6f45735b.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.21-rc3-mm1/

Will appear later at

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/



- The wireless changes in here need a lot of testers, please.  It is major
  rework.

  Of course the config files got all changed around so `make oldconfig'
  breaks everything.  I was able to get ipw2200 working after some fumbling,
  but perhaps John can tell people what has been changed in there?  What has
  happened, from a big picture perspective?

- This patchset contains Con's rip-up-and-rewrite of the CPU scheduling
  algorithm.  It oopsed for me on one machine so I'll do an rc3-mm2 without
  those changes shortly.  If 2.6.21-rc3-mm1 crashes and 2.6.rc3-mm2 does not,
  don't forget to Cc: Con Kolivas <kernel@kolivas.org> on the report ;)

  Feedback on this change is sought.  Especially from the
  enterprise-database and volanomark loonies: this stuff might be headed your
  way so don't tell us afterwards that it hurt.

- Added Nick's lock-the-page-in-the-pagefault-handler patches.  These reduce
  the incidence of one bug and increase the incidence of another.  VM is fun. 

- Re-added the ext4 development tree to the -mm lineup.  It has stuff in
  it.  



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




Changes since 2.6.21-rc2-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-avr32.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-input.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-md-accel-fixup.patch
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
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-wireless-fixup.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-paravirt-build-fixes.patch
-fix-suspend-resume-with-periodic-tick-devices.patch
-nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
-atyfb-fix-kconfig-error-part-2.patch
-fbdev-fix-kconfig-error-if-fb_ddc=n.patch
-fix-2621-rfcomm-lockups.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
-i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch
-hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
-hrtimers-hrtimer_clock_base-description-typo.patch
-highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
-highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch
-highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
-kconfig-update-swsusp-description.patch
-remove-arch-i386-kernel-tscccustom_sched_clock.patch
-mqueue-nested-locking-annotation.patch
-fix-vsyscall-settimeofday.patch
-fs-nobh_truncate_page-fix.patch
-geode-aes-use-unsigned-long-for-spin_lock_irqsave.patch
-publish-rcutorture-module-parameters-via-sysfs-read-only.patch
-cciss-fix-for-2tb-support.patch
-cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier.patch
-initramfs-should-not-depend-on-config_block.patch
-linux-audith-needs-linux-typesh.patch
-uml-fix-formatting-violations-in-signal-delivery-code.patch
-uml-add-a-debugging-message.patch
-uml-comment-the-initialization-of-a-global.patch
-knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
-knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
-knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server.patch
-sdhci-handle-resumed-devices.patch
-knfsd-provide-sunrpc-pool_mode-module-option.patch
-git-acpi-fix-cpuidle-borkage-2.patch
-drivers-cpuidle-make-code-static.patch
-sony-laptop-fix-uninitialised-variable.patch
-altix-reinitialize-acpi-tables.patch
-fix-acpi-documentation-in-kernel-parameterstxt.patch
-ds1374-check-for-workqueue-creation.patch
-ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch
-remove-stack-hard-limit-on-ia64.patch
-always-build-arch-ia64-lib-xoro.patch
-ia64-sync-compat-getdents-on-ia64-and-parisc.patch
-ia64-permon-use-after-free-fix.patch
-ia64-kexec-use-efi_loader_data-for-elf-core-header.patch
-ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch
-wistron-button-support-for-travelmate-610.patch
-user-of-the-jiffies-rounding-code-e1000.patch
-phy-layer-add-kernel-doc-docbook.patch
-revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
-dmfe-trivial-spelling-fixes.patch
-dmfe-fix-two-bugs.patch
-dmfe-fix-link-detection.patch
-dmfe-add-support-for-suspend-resume.patch
-dmfe-add-support-for-suspend-resume-fix.patch
-dmfe-add-support-for-wake-on-lan.patch
-sis900-warning-fixes.patch
-8139too-fix-irq-problem-with-napi-netpoll.patch
-drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch
-3c59x-handle-pci_enable_device-failure-while-resuming.patch
-__devinit-__devexit-cleanups-for-de2104x-driver.patch
-sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch
-network-add-the-missing-phy_device-speed-information-to-phy_mii_ioctl.patch
-bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch
-parisc-sync-compat-getdents-on-ia64-and-parisc.patch
-x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
-uml-hostfs-fix-double-free.patch
-uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
-uml-fix-a-memory-leak-in-the-multicast-driver.patch
-uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
-uml-mark-both-consoles-as-con_anytime.patch
-uml-fix-confusion-irq-early-reenabling.patch
-uml-activate_fd-return-enomem-only-when-appropriate.patch
-uml-fix-errno-usage.patch

 Merged into mainline or a subsystem tree

+uml-hostfs-fix-double-free.patch
+uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
+uml-fix-a-memory-leak-in-the-multicast-driver.patch
+uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
+uml-mark-both-consoles-as-con_anytime.patch
+uml-fix-confusion-irq-early-reenabling.patch
+uml-activate_fd-return-enomem-only-when-appropriate.patch
+uml-fix-errno-usage.patch
+x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
+bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch
+add-epoll-compat_-code-to-fs-compatc.patch
+check_partition-fix-error-check.patch
+uml-arch_prctl-should-set-thread-fs.patch
+connector-bugfix-for-cn_call_callback.patch
+26-altix-console-fix-for-config_debug_shirq-usage.patch

 2.6.21 queue.

+swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
+paravirt-build-fixes.patch

 Might be 2.6.21 material.

+acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch

 ACPI niceness

+sound-strlcpy-is-smart-enough.patch

 alsa fixlet.

+gregkh-driver-device-symlink.patch

 Driver tree update

-driver-core-cleanup-device-links-code.patch
-driver-core-add-missing-symlinks-error-handling.patch
-driver-core-check-sysfs_create_link-errors.patch

 Dropped - Greg broke them instead of merging them.  Such is my life.

+uevent-improve-error-checking-and-handling.patch
+uevent-use-add_uevent_var-instead-of-open-coding-it.patch

 uevent fixlets and code consolidation

+ivtv-warning-fix.patch

 DVB fix

-jdelvare-i2c-i2c-06-remove-duplicate-i2c-drivers-list.patch
+jdelvare-i2c-i2c-07-i2c_register_driver-cleanup.patch
+jdelvare-i2c-i2c-08-shrink-i2c_client.patch
+jdelvare-i2c-ds1374-check-for-workqueue-creation.patch

 I2C tree updates

-gfs2-build-fix.patch

 Unneeded

-setstream-param-for-psmouse-tweak.patch

 Folded into setstream-param-for-psmouse.patch

-libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
-acpi-driver-support-for-pata.patch
-libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
-libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
-libata-cable-detection-fixes.patch
-pata_platform-set-a-cable-type-which-to-set.patch
-pata_qdi-set-cable-type.patch
-pata_sl82c105-missing-methods-cable.patch
-ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
-pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
-pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
-pata_cypress-clean-up-by-using-cable_detect-method.patch
-pata_isapnp-set-cable-type.patch
-pata_ixp4xx_cf-set-cable-type.patch
-pata_legacy-fix-missing-methods-and-add-cable-types.patch
-pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
-pata_radisys-switch-to-cable-method-to-cleanup-code.patch
-pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
-pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
-pata_winbond-set-cable-type.patch
-pata_cmd64x-various-fixes.patch
-pata_hpt3x3-clean-up-by-using-cable-method.patch
-support-for-marvell-7042-chip.patch
-pata_cmd640-cmd640-pci-support.patch
-libata-kconfig-update-the-various-experimentality-levels.patch
-pata_pdc202xx_old-fix-data-corruption-and-other-problems.patch

 Dropped - Jeff broke them instead of merging them.  Such is my life. 
 Alan's, too.

+ata_piix-remove-ugly-layering-violation.patch
+pata_cmd640-multiple-updates.patch

 [sp]ata stuff

+ide-pdc202xx_old-rewrite-mode-programming-v2.patch
+ide-serverworks-pio-mode-setup-fixes.patch
+ide-sis5513-pio-mode-setup-fixes.patch

 IDE tree updates

-git-mmc-fix-99.patch

 Unneeded

+git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch

 Impedance unmismatching.

-nommu-present-backing-device-capabilities-for-mtd-fix.patch

 Folded into nommu-present-backing-device-capabilities-for-mtd.patch

-nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch

 Folded into nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch

+dilnetpc-fix-warning.patch
+mtd-correct-misspelled-preprocessor-variable.patch

 MTD fixes

+ehea-strlcpy-is-smart-enough.patch
+via-rhine-set-avoid_d3-for-broken-bioses.patch
+netxen-fix-warnings.patch
+e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq.patch
+e1000-fix-firmware-handover-bits.patch
+e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch
+8139too-fix-irq-problem-with-napi-netpoll.patch

 netdev updates

-div64_64-common-code-fix.patch

 Folded into div64_64-common-code.patch

+allow-pktgen-to-work-with-loopback-devices.patch

 Net enhancement.

+mpsc-serial-driver-tx-locking.patch
+serial-suppress-rts-assertion-with-disabled-crtscts.patch

 Serial updates

+resurrect-sdev.patch

 scsi mightfix, needs updating, way late.

-fix-the-reproducible-oops-in-scsi.patch

 Tentatively dropped, due to alleged effects of previous.

-usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch

 Folded into usbatm-create-sysfs-link-device-from-atm-class-device.patch

-after-before-x86_64-mm-mmconfig-share.patch

 Unneeded

-i386-irq-kill-irq-compression-fix.patch

 Folded into i386-irq-kill-irq-compression.patch, sent to maintainer, ignored.

-linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
-linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch

 Folded into linux-sysdevh-needs-to-include-linux-moduleh.patch

-x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
-x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch

 Dropped

-x86_64-map-fake-nodes-to-real-nodes-fix.patch

 Folded into x86_64-map-fake-nodes-to-real-nodes.patch

-lguest-kconfig-and-headers-fix.patch

 Folded into lguest-kconfig-and-headers.patch

-lguest-trivial-guest-network-driver-fix.patch

 Folded into lguest-trivial-guest-network-driver.patch

-remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch

 Folded into remove-hardcoding-of-hard_smp_processor_id-on-up.patch

-use-the-apic-to-determine-the-hardware-processor-id-i386-fix.patch

 Folded into use-the-apic-to-determine-the-hardware-processor-id-i386.patch

-i386-add-the-x86_feature_sync_rdtsc-flag.patch
-optimize-and-simplify-get_cycles_sync.patch

 Dropped, bad.

+xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
+xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch

 XFS things.

+z85230-fix-fifo-handling.patch
+revert-ac97-fix-microphone-and-line_in-selection-logic.patch
+null-pointer-in-ia64-irq_chip-mask-unmask-function-v2.patch

 Probable 2.6.21 material

+move-free-pages-between-lists-on-steal-fix.patch

 Folded into move-free-pages-between-lists-on-steal.patch

+mm-debug-check-for-the-fault-vs-invalidate-race.patch
+mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
+mm-simplify-filemap_nopage.patch
+mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
+mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
+mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
+mm-merge-nopfn-into-fault.patch
+mm-remove-legacy-cruft.patch

 Fix pagefault-versus-invalidation race.  Make unfixable deadlocks easier.

+mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

 Fix obscure race which might affect msync() quality.

+blackfin-blackfin-i2c-driver-update-2.patch

 blackfin arch driver support.

+uml-mark-tt-mode-code-for-future-removal.patch
+uml-print-coredump-limits.patch
+uml-handle-block-device-hotplug-errors.patch
+uml-driver-formatting-fixes.patch
+uml-driver-formatting-fixes-fix.patch
+uml-network-interface-hotplug-error-handling.patch

 UML updates

+xtensa-strlcpy-is-smart-enough.patch

 Cleanup

-procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
+fix-race-between-proc_get_inode-and-remove_proc_entry.patch

 Updated.  Looks sane.

+exec-fix-remove_arg_zero-add-comment.patch

 Document exec-fix-remove_arg_zero.patch a bit

+epoll-optimizations-and-cleanups.patch
+epoll-optimizations-and-cleanups-tidy.patch
+add-an-anonymous-inode-source.patch
+add-an-anonymous-inode-source-tidy.patch
+epoll-use-anonymous.patch
+oss-strlcpy-is-smart-enough.patch
+add-filesystem-subtype-support.patch
+vfs-remove-superflous-sb-==-null-checks.patch
+nameic-remove-utterly-outdated-comment.patch
+tpm_infineon-add-support-for-devices-in-mmio-space.patch
+replace-pci_find_device-in-drivers-telephony-ixjc.patch
+floppy-handle-device_create_file-failure-while-init.patch
+drivers-macintosh-mac_hidc-make-code-static.patch
+rocket-remove-modversions-include.patch
+virtual_eisa_root_init-should-be-__init.patch

 Misc

+ext4-extent-overlap-bugfix.patch
+ext4-persistent_allocation_1_ioctl_and_unitialized_extents.patch
+ext4-persistent_allocation_2_support_for_writing_to_unitialized_extent.patch
+ext4-booked-page-flag.patch
+ext4-ext4-block-reservation.patch
+ext4-ext4-delayed-allocation.patch
+ext4-ext4-delalloc-extents-48bit.patch
+ext4-ext4-nanosecond-patch.patch

+lists-add-list-splice-tail.patch
+sched-remove-sleepavg-from-proc.patch
+sched-remove-noninteractive-flag.patch
+sched-implement-180-bit-sched-bitmap.patch
+sched-implement-rsdl-cpu-scheduler.patch
+sched-document-rsdl-cpu-scheduler.patch

 Con's new CPU scheduler algorithm.

+swap-prefetch-avoid-repeating-entry.patch

 Might fix unreproducible swap-prefetch bug.

+udf-use-sector_t-and-loff_t-for-file-offsets.patch
+udf-introduce-struct-extent_position.patch
+udf-use-get_bh.patch
+udf-add-assertions.patch
+udf-support-files-larger-than-1g.patch
+udf-fix-link-counts.patch

 UDF fixes

+statistics-infrastructure-prerequisite-parser-fix.patch
+add-for_each_substring-and-match_substring.patch
+statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
+statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch

 Tweak statistics patches in -mm,

+msi-debug-code.patch

 Debug

-squash-udf-warnings.patch

 Unneeded due to UDF updates.



All 781 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc3-mm1/patch-list


