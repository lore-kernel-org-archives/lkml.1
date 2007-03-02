Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXCBLAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXCBLAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXCBLAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:00:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbXCBLAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:00:38 -0500
Date: Fri, 2 Mar 2007 03:00:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc2-mm1
Message-Id: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/

Will appear later at

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/


- Quite a lot of less-popular architectures still aren't compiling due
  to utrace.  x86, x86_64, powerpc, ia64 and s390 should be OK.

- Added the KVM tree to the -mm lineup, as git-kvm.patch (Avi Kivity
  <avi@qumranet.com>)

- git-mmc.patch got tempdropped due to disagreements with gcc

- Some of the x86_64 tree has been tossed out due to rejects

- The memory management changes in here to take mlocked and anon pages off
  the LRU need a lot of testing before they can go into mainline.  I probably
  do not have the time to do this.

- Nor am I likely to have time to review the blackfin architecture closely. 
  Help is sought.

- Is everyone reading Documentation/SubmitChecklist?  Oh.



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



Changes since 2.6.20-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-avr32.patch
 git-cifs.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-ia64.patch
 git-ieee1394.patch
 git-input.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-ubi.patch
 git-netdev-all.patch
 git-backlight.patch
 git-ioat.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-block.patch
 git-unionfs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-fix-build-errors-if-bitop-functions-are-do-while-macros.patch
-xfs-warning-fix.patch
-machzwd-warning-fix.patch
-minix-v3-fix-superblock-definition.patch
-fix-missing-declaration-of-init_irq_proc.patch
-fix-modular-agpgart-ia64-allmodconfig.patch
-gregkh-driver-driverh-copyright.patch
-gregkh-driver-driver-core-let-request_module-send-a-sys-modules-kmod-uevent.patch
-gregkh-driver-serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232-adapter.patch
-gregkh-driver-kobject-kobj-k_name-verification-fix.patch
-gregkh-driver-driver-remove-redundant-kobject_unregister-checks.patch
-gregkh-driver-debugfs-implement-symbolic-links.patch
-gregkh-driver-debugfs-remove-misleading-comments.patch
-gregkh-driver-driver-core-device_add_attrs-cleanup.patch
-gregkh-driver-pcmcia-some-class_device-fallout.patch
-gregkh-driver-sysfs-fix-build-errors-uevent-with-config_sysfs-n.patch
-power-management-no-valid-states-w-o-pm_ops-docs.patch
-power-management-fix-struct-layout-and-docs.patch
-saa7134-cleanup.patch
-jdelvare-hwmon-hwmon-it87-pwm-freq.patch
-jdelvare-hwmon-hwmon-drop-unused-mutexes.patch
-jdelvare-hwmon-hwmon-simplify-locking-1.patch
-jdelvare-hwmon-hwmon-legacy-comment-fix.patch
-jdelvare-hwmon-hwmon-lm70-make-lm70_remove-a-devexit-function.patch
-jdelvare-hwmon-hwmon-should-subsys-init.patch
-jdelvare-hwmon-hwmon-w83627ehf-add-w83627dhg-support.patch
-jdelvare-hwmon-hwmon-adm1029-new-driver.patch
-jdelvare-hwmon-hwmon-unchecked-return-status-fixes-abituguru.patch
-jdelvare-hwmon-hwmon-f71805f-remove-redundant-kfree.patch
-jdelvare-hwmon-hwmon-vt1211-add-probing-of-alternate-config-index-port.patch
-sis-warning-fixes.patch
-sata-use-null-for-ptrs.patch
-sata_via-fix-resource-managed-iomap-conversion.patch
-adjust-legacy-ide-resource-setting-v2.patch
-ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
-dmaengine-uninline-large-functions.patch
-mips-remove-smp_tune_scheduling.patch
-onenand_base-warning-fix.patch
-sc520cdp-warning-fix.patch
-netsc520-warning-fix.patch
-ck804xrom-warning-fix.patch
-esb2rom-warning-fixes.patch
-amd76xrom-warning-fix.patch
-ichxrom-warning-fix.patch
-jffs2-warning-fixes.patch
-cafe-warning-fix.patch
-8139too-force-media-setting-fix.patch
-Fabric7-VIOC-driver.patch
-Fabric7-VIOC-driver-fixes.patch
-r8169-rtnl-and-flush_scheduled_work-deadlock.patch
-sis190-rtnl-and-flush_scheduled_work-deadlock.patch
-8139too-rtnl-and-flush_scheduled_work-deadlock.patch
-s2io-rtnl-and-flush_scheduled_work-deadlock.patch
-natsemi-add-support-for-using-mii-port-with-no-phy.patch
-natsemi-add-support-for-using-mii-port-with-no-phy-update.patch
-natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards.patch
-backlight-tree-versus-acpi-tree.patch
-remove-useless-find_first_bit-macro-from-cardbusc.patch
-gregkh-pci-pci-sysfs-kobject-kernel-doc-fixes.patch
-gregkh-pci-pci-pcitxt-fix-__devexit-usage.patch
-gregkh-pci-pci-make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
-gregkh-pci-pci-pci-devices-get-assigned-redundant-irqs.patch
-gregkh-pci-pci-add-systems-for-automatic-breadth-first-device-sorting.patch
-gregkh-pci-pci-make-pci-device-numa-node-attribute-visible-in-sysfs.patch
-gregkh-usb-ehci-turn-off-remote-wakeup-during-shutdown.patch
-gregkh-usb-berry_charge.patch
-gregkh-usb-usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
-gregkh-usb-usb-fix-needless-failure-under-certain-conditions.patch
-gregkh-usb-usb-pl2303-willcom-ws002in-support.patch
-gregkh-usb-usb-teac-hd-35pu-patch-to-unusual_devsh.patch
-gregkh-usb-usb-unusual_devs-update-for-sony-p990i-phone.patch
-gregkh-usb-usb-add-flow-control-to-usb-serial-generic-driver.patch
-gregkh-usb-usb-fix-apparent-typo-config_usb_cdcether.patch
-gregkh-usb-usbcore-small-changes-to-hub-driver-s-suspend-method.patch
-gregkh-usb-ehci-add-debugging-message-to-ehci_bus_suspend.patch
-gregkh-usb-usb-descriptor-structures-have-to-be-packed.patch
-gregkh-usb-usb-fix-error-cleanup-path-in-airprime.patch
-gregkh-usb-usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
-gregkh-usb-usb-asix-fix-endian-issues-in-asix_tx_fixup.patch
-gregkh-usb-usb-fix-autosuspend-race-in-skeleton-driver.patch
-gregkh-usb-usb-storage-indistinguishable-devices-with-broken-and-unbroken-firmware.patch
-gregkh-usb-usb-usb_rtl8150-must-select-mii.patch
-gregkh-usb-usb-input-hid-add-cidc-usb-device-to-hid-blacklist.patch
-gregkh-usb-usb-fix-misspelled-usbnet_mii-kernel-config-option.patch
-gregkh-usb-usb-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch
-gregkh-usb-usb-use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
-gregkh-usb-usb-fix-g_serial-small-error.patch
-gregkh-usb-usb-make-usb_iso_packet_descriptorstatus-signed.patch
-gregkh-usb-usb-unconfigure-devices-which-have-config-0.patch
-gregkh-usb-usb-cdc-acm-fix-incorrect-throtteling-make-set_control-optional.patch
-gregkh-usb-usb-quirky-device-for-cdc-acm.patch
-gregkh-usb-usb-kernel-doc-fixes.patch
-gregkh-usb-usb-hid-corec-removes-gtco-calcomp-interwrite-ipanel-pids-from-blacklist.patch
-gregkh-usb-usb-change-__init-to-__devinit-for-isp116x_probe.patch
-gregkh-usb-usb-remove-airprime-device-from-optionc.patch
-gregkh-usb-usbnet-recognize-sitecom-cn-124.patch
-gregkh-usb-usbnet-init-fault-cleanup-whitespace-fixes.patch
-gregkh-usb-usbnet-add-missing-kconfig-for-kc2190-cables.patch
-gregkh-usb-usb-at91_udc-shrink-runtime-footprint.patch
-gregkh-usb-usb-ueagle-atmc-needs-schedh.patch
-gregkh-usb-usb-another-id-for-cp2101-driver.patch
-gregkh-usb-usb-at91-ohci-handle-extra-at91sam9261-ahb-clock.patch
-gregkh-usb-usb-iowarrior.patch
-gregkh-usb-usb_match_device.patch
-gregkh-usb-usb-blacklist.patch
-x86_64-mm-rwmsr-on-cpu.patch
-x86_64-mm-simplfy-__assign_irq_vector.patch
-x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
-x86_64-mm-pit_latch_buggy-has-no-effect.patch
-x86-dont-probe-for-ddc-on-vbe12.patch
-cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
-fix-mempolicys-check-on-a-system-with-memory-less-node.patch
-mincore-warning-fix.patch
-vm-invalidate_inode_pages2_range-should-not-exit-early.patch
-replace-highest_possible_node_id-with-nr_node_ids.patch
-convert-highest_possible_processor_id-to-nr_cpu_ids.patch
-convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
-slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
-shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
-shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch
-fs-fix-__block_write_full_page-error-case-buffer-submission.patch
-kprobes-list-all-active-probes-in-the-system.patch
-kprobes-list-all-active-probes-in-the-system-fix.patch
-reduce-size-of-task_struct-on-64-bit-machines-fix.patch
-fat-dio-write-fallback-to-normal-buffered.patch
-fault-injection-split-up-stacktrace-filter-kconfig-option.patch
-pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch
-mwave-interesting-flags-savings.patch
-ext-update-documentation.patch
-add-epoll-compat-code-to-kernel-compatc.patch
-add-epoll-compat-code-to-kernel-compatc-tidy.patch
-cfag12864b-fix-crash-when-built-in-and-no-parport.patch
-lockdep-debug_locks-check-after-check_chain_key.patch
-mfd-sm501-core-driver-3.patch
-kernel-doc-include-struct-short-description-in-title.patch
-tty-use-null-for-ptrs.patch
-cdrom-use-unsigned-bitfields.patch
-8250-fix-gcc4-signed-unsigned-mismatch-warning.patch
-update-osdl-linux-foundation-maintainer-addresses.patch
-ppc64-kdump-documentation-update-for-2620.patch
-loosen-dependancy-on-rtc-cmos.patch
-fs-fix-libfs-data-leak.patch
-fs-fix-nobh-data-leak.patch
-autofs4-header-file-update.patch
-autofs4-fix-another-race-between-mount-and-expire.patch
-autofs4-check-for-directory-re-create-in-lookup.patch
-affs-implement-drop_inode.patch
-genalloc-warning-fixes.patch
-missing-__user-in-pointer-referenced-within-copy_from_user.patch
-update-doc-oops-tracingtxt-for-taint_user.patch
-update-doc-oops-tracingtxt-for-taint_user-fix.patch
-rtc-sa1100-rtc_wklarmenabled-bugfixes.patch
-at91_rtc-updates.patch
-gpio-api-pxa-wrapper-cleanup.patch
-remove-modpost-false-warnings-on-arm.patch
-drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch
-lockdep-annotate-blkpg_del_partition.patch
-parport_pc-fix-parport_pc_probe_port-section-warning.patch
-spi-controller-build-warning-fixes.patch
-spi_s3c2410_gpioc-spi-mode-2-and-3-support.patch
-gpio-api-s3c2410-wrapper-cleanup-2.patch
-gpio-api-sa1100-wrapper-cleanup.patch
-fb-sm501-framebuffer-driver-5.patch
-fb-sm501-framebuffer-driver-5-fix.patch
-i810fb-fix-i810_check_params-section-mismatch.patch

 Merged into mainline or a subsystem tree

+cyclades-return-closing_wait.patch
+io_apic-needs-apicdefh.patch
+msi-sanely-support-hardware-level-msi-disabling.patch
+msi-fixup-the-msi-enable-disable-logic.patch
+msi-support-masking-msi-irqs-without-a-mask-bit.patch
+ecryptfs-check-xattr-operation-support-fix.patch
+parport-is-an-orphan.patch
+fix-soft-lockup-with-iseries-viocd-driver.patch
+add-config_generic_gpio.patch
+gpio_keys-driver-shouldnt-be-arm-specific.patch
+dz-remove-struct-pt_regs-references.patch
+schedule-wext-rtnl-for-removal.patch
+shmem-and-simple-const-super_operations.patch
+sched-remove-smt-nice.patch
+fb-sm501fb-off-by-1-sysfs-store.patch
+fix-radeon-blanking-return-value.patch
+page-migration-fix-vma-flag-checking.patch
+vmi-timer-fixes-round-two.patch
+vmi-sched-clock-paravirt-op-fix.patch
+vmi-cpu-cycles-fix.patch
+vmi-fix-highpte.patch
+vmi-paravirt-drop-udelay-op.patch
+vmi-pit-override.patch
+vmi-fix-nohz-compile.patch
+vmi-apic-ops.patch
+vmi-smp-fixes.patch
+knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
+knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
+knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
+md-fix-for-raid6-reshape.patch
+md-fix-for-raid6-reshape-fix.patch

 2.6.21 queue

+slab-introduce-krealloc.patch
+slab-introduce-krealloc-fix.patch

 slab feature

+git-acpi-fix-cpuidle-borkage.patch

 Fix git-acpi.

+altix-reinitialize-acpi-tables.patch

 Altix fix

+git-alsa-oops-fix.patch

 Make git-alsa oops less.

+agp-prevent-probe-collision-of-sis-agp-and-amd64_agp.patch

 AGP fix

+gregkh-driver-platform-reorder-platform_device_del.patch
+gregkh-driver-driver-core-udev-triggered-device-driver-binding.patch
+gregkh-driver-uio-support-for-multiple-mappings.patch
+gregkh-driver-uio-update-documentation-for-multiple-mappings.patch

 Driver tree updates

+driver-core-cleanup-device-links-code.patch
+driver-core-add-missing-symlinks-error-handling.patch
+driver-core-check-sysfs_create_link-errors.patch

 driver core things

+git-dvb-fixup.patch

 Fix rejects in git-dvb.patch

+drivers-media-video-cpia_ppc-dont-use-_work_nar.patch

 DVB cleanup

+jdelvare-i2c-i2c-amd8111-missed-cleanup.patch
+jdelvare-i2c-i2c-02-revert-core-warning-removal.patch
+jdelvare-i2c-i2c-03-use-i2c_adapterdevparent-for-messages.patch
+jdelvare-i2c-i2c-parport-optimize-size.patch
+jdelvare-i2c-i2c-nforce2-add-mcp61-mcp65-support.patch
+jdelvare-i2c-clean-up-i2c-header-includes.patch
+jdelvare-i2c-i2c-i801-restore-initial-state.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-smsc47m192-document-lpc47m292-support.patch
+jdelvare-hwmon-hwmon-request-regions.patch
+jdelvare-hwmon-hwmon-smsc47m1-add-lpc47m292-support.patch
+jdelvare-hwmon-hwmon-smsc47m1-drop-useless-lock.patch
+jdelvare-hwmon-hwmon-only-call-vid_which_vrm-when-needed.patch
+jdelvare-hwmon-hwmon-fix-vid-table.patch

 hwmon tree updates

+always-build-arch-ia64-lib-xoro.patch
+ia64-sync-compat-getdents-on-ia64-and-parisc.patch
+ia64-permon-use-after-free-fix.patch

 ia64 stuff

+fix-locking-in-mousedev.patch

 Input locking fix

+kconfig-abort-configuration-with-recursive-dependencies.patch
+allow-kernel-to-build-on-cygwin.patch

 Kconfig updates

+git-leds-fixup.patch

 Fix rejects in git-leds.patch

+git-leds-make-it-compile.patch

 Make LEDS code compile by disabling a lot of it.

+libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
+expose-set_mode-method-so-it-can-be-wrapped.patch
+acpi-driver-support-for-pata.patch
+pcmcia-spot-slave-decode-flaws-for-testing.patch
+libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
+libata-add-ncq-blacklist-entries-from-silicon-image-windows.patch
+libata-cable-detection-fixes.patch
+libata-core-fix-simplex-handling.patch
+libata-dev_config-does-not-need-ap-and-adev-passing.patch
+pata_platform-set-a-cable-type-which-to-set.patch
+pata_qdi-set-cable-type.patch
+pata_sl82c105-missing-methods-cable.patch
+ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
+pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
+pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
+pata_cypress-clean-up-by-using-cable_detect-method.patch
+pata_isapnp-set-cable-type.patch
+pata_ixp4xx_cf-set-cable-type.patch
+pata_legacy-fix-missing-methods-and-add-cable-types.patch
+pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
+pata_radisys-switch-to-cable-method-to-cleanup-code.patch
+pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
+pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
+pata_winbond-set-cable-type.patch
+pata_cmd64x-various-fixes.patch
+pata_hpt3x3-clean-up-by-using-cable-method.patch
+support-for-marvell-7042-chip.patch

 ATA updates

-ide-sl82c105-dma-support-code-cleanup.patch
+ide-sl82c105-dma-support-code-cleanup-take3.patch
+ide-cmd64x-interrupt-status-fixes-resend.patch
+ide-cmd64x-add-fix-enablebits.patch
+ide-cmd64x-procfs-code-fixes-cleanups.patch
+ide-ide-cs-update-device-table.patch
+ide-ide-fix-pmac-breakage.patch
+ide-pci-adjust-legacy-ide-resource-setting-v2.patch
+ide-cmd64x-use-interrupt-status-from-mrdmode-register.patch
+ide-siimage-drac4-note.patch
+ide-ide-remove-a-ton-of-pointless-undef-really-slow-io.patch
+ide-delkin_cb-pci_module_init-to-pci_register_driver.patch

 IDE tree updates

+ide-ide-fix-pmac-breakage-fix.patch

 Fix it

-git-lxdialog-fixup.patch

 Unneeded

+git-md-accel-fixup.patch

 Fix rejects in git-md-accel.patch

-git-mips-fixup.patch

 Unneeded

+remove-fs-jffs2-ioctlc.patch
+nommu-present-backing-device-capabilities-for-mtd.patch
+nommu-present-backing-device-capabilities-for-mtd-fix.patch
+nommu-add-support-for-direct-mapping-through-mtdconcat.patch
+nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
+nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
+mtd-chips-oops-in-cfi_amdstd_sync.patch

 MTD updates

+ehea-dynamic-add--remove-port-update.patch
+8139too-fix-irq-problem-with-napi-netpoll.patch
+cxgb3-add-sw-lro-support.patch
+drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch
+3c59x-handle-pci_enable_device-failure-while-resuming.patch
+__devinit-__devexit-cleanups-for-de2104x-driver.patch
+sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch
+fix-mv643xx_eth-compilation.patch
+drivers-net-vioc-possible-cleanups.patch
+8139too-force-media-setting-fix.patch
+cisco_ioctl-initialise-header_cache_update.patch
+bonding-replace-system-timer-with-work-queue.patch
+bonding-replace-system-timer-with-work-queue-tidy.patch

 netdev updates

+bluetooth-hid-quirks-mightymouse-quirk.patch

 bluetooth fix

+nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch

 NFS fix

-git-parisc-fixup.patch

 Unneeded

+parisc-sync-compat-getdents-on-ia64-and-parisc.patch
+parisc-unbreak-setupc-re-command_line.patch

 parisc stuff

+pcmcia-pccard-deadlock-fix.patch

 PCMCIA fix

+serial-driver-pmc-msp71xx.patch
+rm9000-serial-driver.patch
+rm9000-serial-driver-tidy.patch
+serial-define-fixed_port-flag-for-serial_core.patch
+serial-use-resource_size_t-for-serial-port-io-addresses.patch

 Serial driver updates

+gregkh-pci-pci-allow-multiple-calls-to-pcim_pin_device.patch
+gregkh-pci-pci-new-pci-e-reset-api.patch

 PCI tree updates

+pcie-fix-section-mismatch-warning.patch
+aer-fix-section-mismatch-warning.patch
+pci-do-not-mark-exported-functions-as-__devinit.patch

 PCI updates

+mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
+remove-the-broken-scsi_acornscsi_3-driver.patch
+fusion-kernel-doc-warning-fixes.patch
+bug-in-gdthc-crashing-machine.patch

 scsi updates

+git-block-another-md-fix.patch

 More git-block fixes

-git-unionfs-fixup.patch

 Unneeded

+unionfs-fix-slab-abuses-with-krealloc.patch

 Use krealloc() in unionfs

+gregkh-usb-pxa2xx_udc-cleanups-use-platform_get_irq.patch
+gregkh-usb-usb-at91_udc-fix-more-modpost-bogosity.patch
+gregkh-usb-usb-storage-removed-duplicate-supertop-unusual_dev-entry.patch
+gregkh-usb-usb-storage-nokia-6288-unusual_devs-entry.patch
+gregkh-usb-usb-goku_udc-remove-crude-cache-coherency-code.patch
+gregkh-usb-usb-set-the-correct-interval-for-interrupt-urbs.patch
+gregkh-usb-uhci-fix-port-resume-problem.patch
+gregkh-usb-usbmon-extended-text-api.patch

 USB tree updates

+usbatm-create-sysfs-link-device-from-atm-class-device.patch
+usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
+usb-elan-ftdi-check-for-workqueue-creation-v2.patch
+cxacru-export-detailed-device-info-through-sysfs-updated.patch
+maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
+usb-serial-secret-patch.patch

 USB stuff

-git-wireless-fixup.patch

 Unneeded

+x86_64-mm-dont-probe-for-ddc-on-vbe1_2.patch
+x86_64-mm-timer-prototype-cleanup.patch
+x86_64-mm-i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
+x86_64-mm-x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
+x86_64-mm-add-__init-to-probe_bigsmp.patch
+x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
+x86_64-mm-number-of-cpus.patch

 x86_64 tree updates

+revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch

 This patch needs updating

+i386-irq-kill-irq-compression-fix.patch

 Fix i386-irq-kill-irq-compression.patch

+make-struct-vmi_ops-static.patch
+type-cast-clean-up-for-find_next_zero_bit.patch
+x86_64-wire-up-compat-sched_rr_get_interval2.patch
+x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
+i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
+x86_64-fix-section-mismatch-warnings.patch
+log-reason-why-tsc-was-marked-unstable.patch
+fully-honor-vdso_enabled.patch
+x86_64-shut-up-vm862.patch
+x86_64-fix-ia32_binfmtc-build-error.patch
+linux-sysdevh-needs-to-include-linux-moduleh.patch
+linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
+linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
+x86_64-configurable-fake-numa-node-sizes.patch
+x86_64-split-remaining-fake-nodes-equally.patch
+x86_64-fixed-size-remaining-fake-nodes.patch
+x86_64-map-fake-nodes-to-real-nodes.patch
+x86_64-disable-alien-cache-for-fake-numa.patch
+x86_64-export-physnode-mapping-to-userspace.patch
+x86_64-fake-numa-for-cpusets-document.patch
+remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
+remove-hardcoding-of-hard_smp_processor_id-on-up.patch
+remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
+use-the-apic-to-determine-the-hardware-processor-id-i386.patch
+use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
+always-ask-the-hardware-to-obtain-hardware-processor.patch

 x86/x86_64 updates

+lguest-kconfig-and-headers-fix.patch

 Fix lguest-kconfig-and-headers.patch

-xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
-xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
-xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
-xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
-xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
-xen-paravirt-remove-ctor-for-pgd-cache.patch
-xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
-xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
-xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
-xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
-xen-paravirt-allocate-and-free-vmalloc-areas.patch
-xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
-xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
-xen-paravirt-add-xen-interface-header-files.patch
-xen-paravirt-core-xen-implementation.patch
-xen-paravirt-core-xen-implementation-fix.patch
-xen-paravirt-add-the-xen-virtual-console-driver.patch
-xen-paravirt-add-xen-grant-table-support.patch
-xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
-xen-paravirt-add-xen-virtual-block-device-driver.patch
-xen-paravirt-add-the-xen-virtual-network-device-driver.patch

 These got killed by the VMI updates

+make-xfs-workqueues-nonfreezable.patch

 XFS freezer fix

+acpi-fan-after-suspend-to-mem-fix.patch

 ACPI fix

+safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
+safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
+safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
+proper-prototype-for-hugetlb_get_unmapped_area.patch
+mm-remove-gcc-workaround.patch
+slab-ensure-cache_alloc_refill-terminates.patch
+mm-more-rmap-checking.patch
+mm-make-read_cache_page-synchronous.patch
+fs-buffer-dont-pageuptodate-without-page-locked.patch
+allow-oom_adj-of-saintly-processes.patch
+introduce-config_has_dma.patch
+mm-slabc-proper-prototypes.patch
+mm-detach_vmas_to_be_unmapped-fix.patch
+take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch

 MM stuff

+driver_bfin_serial_core-update.patch
+blackfin-on-chip-ethernet-mac-controller-driver.patch
+blackfin-patch-add-blackfin-support-in-smc91x.patch
+blackfin-on-chip-rtc-controller-driver.patch

 Blackfin updates

+convert-h8-300-to-generic-timekeeping.patch

 h8300 time update

+fix-refrigerator-vs-thaw_process-race.patch

 freezer fix

+uml-delete-unused-code.patch
+uml-formatting-fixes.patch
+uml-host_info-tidying.patch

 UML updates

+v850-generic-timekeeping-conversion.patch

 v850 time update

+filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch

 Fix filesystem-disk-errors-at-boot-time-caused-by-probe.patch

+fix-quadratic-behavior-of-shrink_dcache_parent-update.patch

 Fix fix-quadratic-behavior-of-shrink_dcache_parent.patch

+ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup.patch

 Fix ipmi-add-new-ipmi-nmi-watchdog-handling.patch

+documentation-ask-driver-writers-to-provide-pm-support.patch
+kill-net-rxrpc-rxrpc_symsc.patch
+fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
+fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
+use-symbolic-constants-in-generic-lseek-code.patch
+use-use-seek_max-to-validate-user-lseek-arguments.patch
+devpts-add-fsnotify-create-event.patch
+tty-clarify-documentation-of-write.patch
+cciss-fix-for-2tb-support.patch
+cciss-fix-for-2tb-support-again.patch
+cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch
+drivers-char-hvc_consolec-cleanups.patch
+is_power_of_2-in-fat.patch
+is_power_of_2-in-fs-hfs.patch
+is_power_of_2-in-fs-block_devc.patch
+freevxfs-possible-null-pointer-dereference-fix.patch
+reiserfs-possible-null-pointer-dereference-during-resize.patch
+scripts-kernel-doc-whitespace-cleanup.patch
+fix-section-mismatch-warning-in-lib-swiotlbc.patch
+init-do_mountsc-proper-prepare_namespace-prototype.patch
+fix-compilation-of-drivers-with-o0.patch
+update-__copy_to_user_inatomic.patch
+reiserfs-shrink-superblock-if-no-xattrs.patch
+module-use-krealloc.patch
+reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
+kconfig-centralize-the-selection-of-semaphore-debugging.patch
+irq-add-__must_check-to-request_irq.patch
+use-stop_machine_run-in-the-intel-rng-driver.patch
+cap-shmmax-at-int_max-in-compat-shminfo.patch
+exec-fix-remove_arg_zero.patch
+scatterlisth-needs-typesh.patch
+merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
+merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
+merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
+timer-run-calc_load-halfway-through-each-round_jiffies.patch
+rcutorture-mark-rcu_torture_init-as-__init.patch
+extend-print_symbol-capability.patch
+init-dma-masks-in-pnp_dev.patch

 Misc

+workqueue-kill-noautorel-works.patch
+worker_thread-dont-play-with-signals.patch

 More workqueue work

+____call_usermodehelper-dont-flush_signals.patch

 Cleanup

+freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
+freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
+freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
+freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
+freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
+freezer-fix-vfork-problem.patch
+freezer-take-kernel_execve-into-consideration.patch

 Process freezer fixes

+drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch

 ISDN cleanup

+the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch

 NFSD fix

+ecryptfs-handles-aop_truncated_page-better.patch

 ecryptfs fixlet

+sched-fix-idle-load-balancing-in-softirqd-context.patch
+sched-dynticks-idle-load-balancing-v3.patch
+speedup-divides-by-cpu_power-in-scheduler.patch
+speedup-divides-by-cpu_power-in-scheduler-up-fix.patch

 CPU scheduler updates

-mm-only-sched-add-a-few-scheduler-event-counters.patch

 Dropped

-sysctl-remove-insert_at_head-from-register_sysctl-fix.patch

 Folded into a different patch

+lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
+lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch

 Wire up lutimes on x86_64.

+rtc-remove-sys-class-rtc-dev.patch
+rtc-rtc-interfaces-dont-use-class_device.patch
+rtc-simplified-rtc-sysfs-attribute-handling.patch
+rtc-simplified-proc-driver-rtc-handling.patch
+rtc-remove-rest-of-class_device.patch
+rtc-suspend-resume-restores-system-clock.patch
+rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch

 RTC updates

+utrace-prep.patch
+utrace-prep-2.patch

 Make the utrace patches apply

+revert-utrace-prep-2.patch

 Remove a Make-the-utrace-patches-apply patch

+local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch

 Fix local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch

+linux-kernel-markers-kconfig-menus-fix-5.patch

 Fix linux-kernel-markers-kconfig-menus-fix-4.patch

+linux-kernel-markers-architecture-independant-code-license-fix.patch
+linux-kernel-markers-architecture-independant-code-flags.patch

 Fix linux-kernel-markers-architecture-independant-code.patch

+linux-kernel-markers-powerpc-optimization-flags.patch

 Fix linux-kernel-markers-powerpc-optimization.patch

+linux-kernel-markers-i386-optimization-fix.patch
+linux-kernel-markers-i386-optimization-export-fix.patch
+linux-kernel-markers-i386-optimization-flags.patch

 Fix linux-kernel-markers-i386-optimization.patch

+linux-kernel-markers-non-optimized-architures-fallback-flags.patch

 Fix linux-kernel-markers-non-optimized-architectures.patch

+linux-kernel-markers-documentation-update-flags.patch

 More docs

+nfs-fix-congestion-control-use-atomic_longs.patch

 Avoid overflow on monster machines

+reiser4-drop-unused-semaphores.patch
+reiser4-use-dynamic-lattice-for-adaptive-compression.patch

 reiser4 updates

+ps3fb-thread-updates-2.patch
+ps3fb-thread-updates-42.patch

 Fix ps3fb-thread-updates.patch some more

+change-rivafb_remove-to-__devexit.patch
+atyfb-replace-busy-loop-with-mdelay.patch
+atyfb-fix-kconfig-error.patch
+fbdev-display-class.patch
+fbdev-display-class-update.patch
+fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
+intelfb-fix-ring-space-calculation.patch
+nvidiafb-bring-back-generic-ddc-reading.patch
+fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
+fbdev-fix-obvious-bug-in-show_pan.patch
+neofb-fill-transp-msb_right-with-the-correct.patch
+atyfb-kill-dead-code.patch
+fbdev-mm-deferred-io-support.patch
+fbdev-hecuba-framebuffer-driver.patch
+fbdev-hecuba-framebuffer-driver-fix.patch
+tgafb-turbochannel-support.patch

 fbdev updates



All 950 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/patch-list


