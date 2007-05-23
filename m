Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbXEWHmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbXEWHmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXEWHmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:42:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbXEWHmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:42:36 -0400
Date: Wed, 23 May 2007 00:42:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2-mm1
Message-Id: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/

- A new readahead patch series.  This needs serious review and performance
  testing please.

- Added Ingo's CFS CPU scheduler

- Xen dom-U support is now in the x86 tree.



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




Changes since 2.6.22-rc1-mm1:


 origin.patch
 git-acpi.patch
 git-acpi-export-acpi_set_cstate_limit.patch
 git-alsa.patch
 git-alsa-fixup.patch
 git-cpufreq.patch
 git-cpufreq-fix.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-input.patch
 git-kvm.patch
 git-leds.patch
 git-leds-fixup.patch
 git-libata-all.patch
 git-md-accel.patch
 git-md-accel-build-fix.patch
 git-mips.patch
 git-mips-fixup.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-battery.patch
 git-ioat.patch
 git-ioat-vs-git-md-accel.patch
 git-nfs.patch
 git-nfs-server-cluster-locking-api.patch
 git-nfs-server-cluster-locking-api-fixup.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-gccbug.patch

 git trees

-afs-write-back-dirty-data-on-unmount.patch
-slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
-slub-dont-confuse-ctor-and-dtor.patch
-afs-fix-afs_prepare_write.patch
-spi-fix-spidev-for-sizeoflong-32-devices.patch
-parport_pc-needs-dma-mappingh.patch
-acpi-driver-model-flags-and-platform_enable_wake.patch
-alsa-fix-isa_bus-conversion.patch
-arm-fix-hard_smp_processor_id-compile-error.patch
-fix-agk-dm-dm-io-fix-panic-on-large-request.patch
-update-documentation-driver-model-platformtxt.patch
-tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch
-jdelvare-hwmon-hwmon-maintainer-position-open.patch
-wistron_btns-add-led-support.patch
-add-support-for-reading-stdin-with-gen_init_cpio.patch
-add-support-for-squashing-uid-gid-in-gen_initramfs_listsh.patch
-time-locale-in-gen_initramfs_listsh.patch
-powerpc64-symbols-start-with.patch
-drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
-libata-fix-shutdown-warning-message-printing.patch
-drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver.patch
-drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
-ide-alim15x3-use-ide-tune-dma.patch
-ide-pdc202xx_new-use-ide-tune-dma.patch
-ide-pdc202xx_old-rewrite-mode-programming-v2.patch
-ide-serverworks-pio-mode-setup-fixes.patch
-ide-sis5513-pio-mode-setup-fixes.patch
-ide-ide-dma-off-quietly-fix.patch
-ide-ide-no-mdma-udma-sharing-filter.patch
-ide-ide-tune-dma-2.patch
-ide-cs5530-sc1200-dma-cleanup.patch
-ide-cs5530-sc1200-add-speedproc.patch
-ide-sl82c105-add-speedproc-method-and-mwdma01-support.patch
-ide-ide-dma-enable.patch
-ide-ide-check-dma-words-validity.patch
-ide-ide-remove-ide-use-dma.patch
-ide-ide-use-mutex-instead-of-semaphore-in-ide-driver.patch
-sl82c105-switch-to-ref-counting-api.patch
-use-menuconfig-objects-ide.patch
-use-mutex-instead-of-semaphore-in-ide-driver.patch
-nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
-dont-force-uclinux-mtd-map-to-be-root-dev.patch
-fix-race-condition-about-network-device-name-allocation.patch
-nf_conntrack-fix-use-after-free-in-helper-destroy-callback.patch
-git-battery-warning-fix.patch
-ds2760_battery-warning-fix.patch
-ocfs2-fix-type-borkage.patch
-fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
-pci-x-pci-express-read-control-interfaces.patch
-scsi-lpfc-lpfc_initc-remove-unused-variable.patch
 scsi-fix-ambiguous-gdthtable-definition.patch
-update-maintainer-email-id-for-megaraid-scsi-drivers.patch
-aacraid-fix.patch
-cxacru-add-documentation-file.patch
-cxacru-cleanup-sysfs-attribute-code.patch
-cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
-cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
-use-menuconfig-objects-ii-usb.patch
-auerswald-fix-file-release-handler.patch
-usb-dont-try-to-kzalloc-0-bytes.patch
-x86_64-mm-build-tar-files.patch
-x86_64-mm-various-cleanups.patch
-x86-use-elfnoteh-to-generate-vsyscall-notes.patch
-i386-fix-machine-rebooting-fix.patch
-use-menuconfig-objects-crypto.patch
-slob-implement-rcu-freeing.patch
-i386-x86-64-fix-section-mismatch.patch
-slab-allocators-drop-support-for-destructors.patch
-remove-slab_ctor_constructor.patch
-remove-constructor-from-buffer_head.patch
-remove-slab_ctor_constructor-fix.patch
-make-__vunmap-static.patch
-simplify-compat_sys_timerfd.patch
-let-smp_call_function_single-return-ebusy-on-up.patch
-let-smp_call_function_single-return-ebusy-on-up-fix.patch
-refine-screen_info-sanity-check-for-vgacon-initialization.patch
-slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
-make-freezeable-workqueues-singlethread.patch
-slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
-slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
-slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
-parport-mailing-list-is-subscribers-only.patch
-docbook-make-kernel-locking-table-readable.patch
-gpio-interface-loosens-call-restrictions.patch
-rtc-omap-build-fix.patch
-rtc-kconfig-clarification.patch
-icom-add-new-sub-device-id-to-support-new-adapter.patch
-make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size.patch
-ecryptfs-use-zero_user_page.patch
-slab-warn-on-zero-length-allocations.patch
-i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
-circular-locking-dependency-found-in-quota-off.patch
-swsusp-fix-sysfs-interface.patch
-slub-fix-handling-of-oversized-slabs.patch
-compat_core_sys_select-avoid-kmalloc0.patch
-mm-more-rmap-checking.patch
-mm-more-rmap-checking-tidy.patch
-add-kstrndup.patch
-add-argv_split.patch
-split-usermodehelper-setup-from-execution.patch
-add-common-orderly_poweroff.patch
-tidy-up-usermode-helper-waiting-a-bit.patch

 Merged into mainline or a subsystem tree

+powerpc-fix.patch
+ignore-bogus-acpi-info-for-offline-cpus.patch
+slub-debug-fix-object-size-calculation.patch
+fuse-fix-mknod-of-regular-file.patch
+mpc52xx_psc_spi-fix-it-for-config_ppc_merge.patch
+spi-doc-update-describe-clock-mode-bits.patch
+nohz-rate-limit-the-local-softirq-pending-warning-output.patch
+capabilityh-warning-fix.patch

 2.6.22 queue

+invalidate_mapping_pages-add-cond_resched.patch
+make-common-helpers-for-seq_files-that-work-with-list_head-s.patch

 Probably 2.6.22 queue

+acpi-bay-send-envp-with-uevent.patch

 ACPI thing

+git-alsa-fixup.patch

 Fix rejects in git-alsa.patch

+avr32-ratelimit-segfault-reporting-rate.patch

 avr32 tweak

+cifs-oops-fix.patch

 Might fix CIFS oopses

+git-cpufreq-fix.patch

 Fix git-cpufreq.patch

+gregkh-driver-debugfs-add-rename-for-debugfs-files.patch
+gregkh-driver-update-documentation-driver-model-platformtxt.patch
+gregkh-driver-driver-core-keep-physdev-for-old-struct-class_device.patch
+gregkh-driver-driver-core-kill-unused-code.patch
+gregkh-driver-howto-removing-duplicated-entry.patch
+gregkh-driver-dmi-based-module-autoloading.patch

 Driver tree updates

+driver-core-check-return-code-of-sysfs_create_link.patch
+driver-core-check-return-code-of-sysfs_create_link-fix.patch
+driver-core-coding-style-cleanup.patch
+remove-odd-and-misleading-comments-from-uioh.patch

 Driver tree things

+jdelvare-i2c-i2c-legacy-drivers-shouldnt-issue-uevents.patch
+jdelvare-i2c-i2c-usb-tiny-fix-name-length.patch
+jdelvare-i2c-i2c-piix4-add-ati-sb700-support.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-ds1621-swapped-limits.patch
+jdelvare-hwmon-hwmon-new-maintainer.patch
+jdelvare-hwmon-hwmon-w83627hf-quiet-when-no-chip.patch
+jdelvare-hwmon-hwmon-ds1621-cleanups.patch
+jdelvare-hwmon-hwmon-ds1621-dynamic-attributes.patch
+jdelvare-hwmon-hwmon-ds1621-individual-alarm-files.patch
+jdelvare-hwmon-hwmon-dme1737-new-driver.patch
+jdelvare-hwmon-hwmon-dme1737-documentation.patch

 hwmon tree updates

+dave-broke-gfs2-26-nmwgit.patch

 gfs2 fix

+make-input-layer-use-seq_list_xxx-helpers.patch
+touchscreen-fujitsu-touchscreen-driver.patch

 Input things

+libata-implement-ata_wait_after_reset.patch
+drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
+drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
+drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
+cleanup-libata-hpa-support.patch
+cleanup-libata-hpa-support-fix.patch
+hpt3x2n-correct-revision-boundary.patch
+pata_sis-fix-and-clean-up-some-timing-setups.patch

 ATA/PATA things

+ide-ide-use-mutex-instead-of-ide_cfg_sem-semaphore.patch
+ide-cmd64x-init-code-cleanup.patch
+ide-aec62xx-rework-init_setup_aec6x80.patch
+ide-aec62xx-remove-init_dma-method.patch
+ide-aec62xx-kill-speedproc-method-wrapper.patch
+ide-ide-use-mutex-instead-of-ide_setting_sem-semaphore.patch

 IDE tree updates

+ide-warning-fixes.patch
+ide-add-seagate-stt20000a-to-dma-blacklist.patch

 IDE fixes

+git-md-accel-build-fix.patch

 Fix git-md-accel.patch

+nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch

 Fix nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch

-git-ubi-fixup.patch

 Unneeded

+fix-compiler-warning-in-fixedc.patch
+forcedeth-add-vitesse-phy.patch
+forcedeth-fix-power-management-support.patch
+forcedeth-fix-cpu-irq-mask.patch
+forcedeth-version-bump.patch

 netdev things

+make-atm-driver-use-seq_list_xxx-helpers.patch
+make-some-network-related-proc-files-use-seq_list_xxx.patch
+make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
+xfrm_algo-warning-fixes.patch

 net things

+nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
+sunrpc-rename-rpcb_getport_external-routine.patch
+sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch
+nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch
+nfs-clean-up-in-kernel-nfs-mount.patch
+nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
+nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
+nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
+nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
+nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
+nfs-move-nfs_copy_user_string.patch
+nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
+nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch

 NFS cleanups

+serial-set-dtr-in-uart-for-kernel-serial-console.patch

 Serial fix

+gregkh-pci-pci-add-pci-x-pci-express-read-control-interfaces.patch
+gregkh-pci-pci-use-a-weak-symbol-for-the-empty-version-of-pcibios_add_platform_entries.patch
+gregkh-pci-pci-make-pcibios_add_platform_entries-return-errors.patch
+gregkh-pci-pci-pci_find_slot-mark-deprecated.patch

 PCI tree updates

+sh-support-older-gccs.patch

 Make sh compile for me.

+aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete.patch
+scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io.patch
+scsi-remove-__gfp_dma.patch
+ncr5380-warning-fixes.patch

 scsi stuff

-git-block-fixup.patch

 Unneeded

-git-sas.patch

 Dropped

+gregkh-usb-usb-ehci-support-for-big-endian-descriptors.patch
+gregkh-usb-usb-auerswald-fix-file-release-handler.patch
+gregkh-usb-usb-cxacru-add-documentation-file.patch
+gregkh-usb-usb-cxacru-cleanup-sysfs-attribute-code.patch
+gregkh-usb-usb-cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
+gregkh-usb-usb-cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
+gregkh-usb-usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg.patch
+gregkh-usb-usb-remove-duplicate-ids-from-option-card-driver.patch
+gregkh-usb-usb-deref-urb-after-usbmon-is-done-with-it.patch
+gregkh-usb-usb-remove-short-initial-timeout-for-device-descriptor-fetch.patch
+gregkh-usb-usb-don-t-try-to-kzalloc-0-bytes.patch
+gregkh-usb-usb-onetouch-switch-to-using-input_dev-devparent.patch
+gregkh-usb-usb-fix-debug-output-of-ark3116.patch
+gregkh-usb-usb-usblp-use-correct-dma-address-in-case-of-probe-error.patch
+gregkh-usb-usb-fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
+gregkh-usb-usb-handle-errors-in-power-level-attribute.patch
+gregkh-usb-usb-fix-ratelimit-call-semantics.patch
+gregkh-usb-usb-m66592-udc-peripheral-controller-driver-for-m66592.patch
+gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch
+gregkh-usb-usb-interface-pm-state.patch
+gregkh-usb-usb-implement-pm-freeze-and-prethaw.patch
+gregkh-usb-usb-move-bus_suspend-and-bus_resume-method-calls.patch
+gregkh-usb-usb-don-t-unsuspend-for-a-new-connection.patch
+gregkh-usb-usb-fix-race-between-autosuspend-and-unregister-for-root-hubs.patch
+gregkh-usb-usb-remove-references-to-devpowerpower_state.patch
+gregkh-usb-usb-remove-locktree-routine-from-the-hub-driver.patch
+gregkh-usb-usb-make-hub-driver-s-release-more-robust.patch
+gregkh-usb-ohci-fix-machine-check-in-ohci_hub_status_data.patch
+gregkh-usb-usb-use-menuconfig-objects.patch
+gregkh-usb-usb-ehci-refcounts-work-on-ppc7448.patch

 USB updates

+fix-gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch

 USB fix

+drivers-net-wireless-libertas-rxc-fix.patch

 wireless fix

+x86_64-mm-stack-align.patch
+x86_64-mm-apic-id.patch
+x86_64-mm-acpi-various-cleanups.patch
+x86_64-mm-fam10-string.patch
+x86_64-mm-gcc43-memcpy.patch
+x86_64-mm-remove-size-of-apicid_to_node-from-header.patch
+x86_64-mm-tsc-unstable.patch
+x86_64-mm-verify-cpu-rename.patch
+x86_64-mm-xencleanup-use-elfnote_h-to-generate-vsyscall-notes.patch
+x86_64-mm-xencleanup-add-kstrndup.patch
+x86_64-mm-xencleanup-add-argv_split.patch
+x86_64-mm-xencleanup-split-usermodehelper-setup-from-execution.patch
+x86_64-mm-add-common-orderly_poweroff.patch
+x86_64-mm-xencleanup-tidy-up-usermode-helper-waiting-a-bit.patch
+x86_64-mm-xen-allocate-and-free-vmalloc-areas.patch
+x86_64-mm-xen-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
+x86_64-mm-xen-add-xen-interface-header-files.patch
+x86_64-mm-core-xen-implementation.patch
+x86_64-mm-xen-xen-virtual-mmu.patch
+x86_64-mm-xen-event-channels.patch
+x86_64-mm-xen-xen-time-implementation.patch
+x86_64-mm-xen-xen-configuration.patch
+x86_64-mm-xen-complete-pagetable-pinning-for-xen.patch
+x86_64-mm-xen-ignore-rw-mapping-of-ro-pages-in-pagetable_init.patch
+x86_64-mm-xen-fix-multicall-batching.patch
+x86_64-mm-xen-account-for-time-stolen-by-xen.patch
+x86_64-mm-xen-implement-xen_sched_clock.patch
+x86_64-mm-xen-xen-smp-guest-support.patch
+x86_64-mm-xen-add-support-for-preemption.patch
+x86_64-mm-xen-lazy-mmu-operations.patch
+x86_64-mm-xen-deal-with-negative-stolen-time.patch
+x86_64-mm-xen-use-the-hvc-console-infrastructure-for-xen-console.patch
+x86_64-mm-xen-add-early-printk-support-via-hvc-console.patch
+x86_64-mm-xen-add-xen-grant-table-support.patch
+x86_64-mm-xen-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
+x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
+x86_64-mm-xen-rename-xen-netif_-structures-to-xen_netif.patch
+x86_64-mm-xen-add-the-xen-virtual-network-device-driver.patch
+x86_64-mm-xen-xen-machine-operations.patch
+x86_64-mm-xen-handle-external-requests-for-shutdown-reboot-and-sysrq.patch
+x86_64-mm-xen-place-vcpu_info-structure-into-per-cpu-memory-if-possible.patch
+x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch

 x86 tree updates

+arch-x86_64-vdso-vmac-needs-schedh.patch
+xen-build-fix.patch
+fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
+fix-x86_64-mm-sched-clock-share.patch

 Fix it.

+x86_64-mcelog-tolerant-level-cleanup.patch
+x86_64-mce-poll-at-idle_start-and-printk-fix.patch

 MCE fixes

+x86-fix-section-mismatch-warnings-in-mtrr.patch
+bug-in-i386-mtrr-initialization.patch
+x86_64-ratelimit-segfault-reporting-rate.patch

 x86 updates

-git-newsetup-fixup.patch

 Unneeded

+prohibit-rcutorture-from-being-compiled-into-the-kernel.patch
+documentation-fix-the-explanation-of-kconfig-files.patch
+avoid-zero-size-allocation-in-cache_k8_northbridges.patch
+recalc_sigpending_tsk-fixes.patch
+optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets.patch
+spi-potential-memleak-in-spidev_ioctl.patch
+fbdev-cleanup-of-sparc-fb-options.patch
+pm2fb-rdac_wr-barriers-clean-up.patch
+pm3fb-various-fixes.patch
+w100fb-fix-compile-warnings.patch
+ps3fb-use-fb_sys_-instead-of-fb_cfb_.patch
+imxfb-remove-ifdefs.patch
+imxfb-fix-memory-hole.patch
+missing-const-from-reiserfs-min_key-declaration.patch
+uselib-add-missing-mnt_noexec-check.patch
+x86_64-allocate-sparsemem-memmap-above-4g.patch
+x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
+fuse-generic_write_checks-for-direct_io.patch
+fuse-delete-inode-on-drop.patch
+fix-unused-setup_nr_node_ids.patch
+slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch
+char-cyclades-fix-deadlock.patch
+simplify-cleanup_workqueue_thread.patch
+simplify-cleanup_workqueue_thread-fix.patch
+simplify-cleanup_workqueue_thread-fix2.patch
+misc-phantom-move-to-unlocked_ioctl.patch
+misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
+misc-phantom-take-care-of-pci-posting.patch
+power-fix-sizeofpage_size-typo.patch
+update-dontdiff-file.patch
+procfs-directory-entry-cleanup.patch
+procfs-directory-entry-cleanup-fix.patch
+signalfd-retrieve-multiple-signals-with-one-read-call.patch
+signalfd-retrieve-multiple-signals-with-one-read-call-tidy.patch
+i2o-destroy-event-queue-only-when-drv-event-is-set.patch
+i2o-fix-notifiers-when-max_drivers-is-configured.patch
+i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch
+i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp.patch
+md-avoid-overflow-in-raid0-calculation-with-large-components.patch
+md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
+md-fix-bug-with-linear-hot-add-and-elsewhere.patch
+documentation-documentation-initrdtxt.patch
+hisax-fix-error-checking-for-hisax_register.patch
+loop-preallocate-eight-loop-devices.patch
+sch_htb-fix-event-cache-time-calculation.patch
+applesmc-sensors-patch-missing-from-2622-rc2.patch
+off-by-one-in-floppyc.patch
+ecryptfs-delay-writing-0s-after-llseek-until-write.patch
+doc-clocksources.patch
+ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch
+prevent-going-idle-with-softirq-pending.patch
+fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch
+i386-fix-early-usage-of-atomic_add_return-and.patch
+documentation-memory-barrierstxt-various-fixes.patch
+omap_uwire-spi_cpha-mode-bugfix.patch
+ads7846-spi_cpha-mode-bugfix.patch
+capifunc-warning-fixes.patch
+hardware-eicon-messagec-warning-fixes.patch

 Probable 2.6.22 material

+change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch

 Fix change-zonelist-order-zonelist-order-selection-logic.patch

+hugetlb-remove-unnecessary-nid-initialization.patch
+mm-use-div_round_up-in-mm-memoryc.patch
+make-proc-slabinfo-use-seq_list_xxx-helpers.patch
+mm-alloc_large_system_hash-can-free-some-memory-for.patch
+remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
+slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
+move-three-functions-that-are-only-needed-for.patch
+slob-rework-freelist-handling.patch
+slob-remove-bigblock-tracking.patch
+slob-improved-alignment-handling.patch

 MM things

+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
+add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patchh
+group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
+group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch

 Update the MM patches in -mm.

+create-the-zone_movable-zone-fix.patch

 Fix create-the-zone_movable-zone.patch

+allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
+allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch

 Fix allow-huge-page-allocations-to-use-gfp_high_movable.patch

-mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
-mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch

 Folded into pther patches

+maps2-move-the-page-walker-code-to-lib-fix.patch

 Fix maps2-move-the-page-walker-code-to-lib.patch

+nfs-invariant-fix.patch
+fs-introduce-some-page-buffer-invariants-obnoxiousness.patch

 NFS things

+fix-rmmod-read-write-races-in-proc-entries-fix.patch

 Fix fix-rmmod-read-write-races-in-proc-entries.patch

+add-lzo1x-compression-support-to-the-kernel-tidy.patch

 Clena up add-lzo1x-compression-support-to-the-kernel.patch

+udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch

 UDF fixlet

+fuse-warning-fix.patch
+vxfs-warning-fixes.patch
+percpu_counters-use-cpu-notifiers.patch
+percpu_counters-use-for_each_online_cpu.patch
+make-afs-use-seq_list_xxx-helpers.patch
+make-crypto-api-use-seq_list_xxx-helpers.patch
+make-proc-misc-use-seq_list_xxx-helpers.patch
+make-proc-modules-use-seq_list_xxx-helpers.patch
+make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
+make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
+make-nfs-client-use-seq_list_xxx-helpers.patch
+fat-gcc-43-warning-fix.patch
+remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
+drivers-block-z2ram-remove-true-false-defines.patch
+fix-compiler-warnings-in-acornc.patch
+update-zilog-timeout.patch
+edd-switch-to-pci_get-based-api.patch
+fix-up-codingstyle-in-isofs.patch
+define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
+preserve-the-dirty-bit-in-init_page_buffers.patch
+rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
+rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
+rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
+delete-every-useless-reference-to-noret_type-in-the-tree.patch
+add-notime-boot-option.patch
+mpu401-warning-fixes.patch

 Misc

+spi-controller-drivers-check-for-unsupported-modes.patch
+spi-add-3wire-mode-flag.patch

 SPI udpates

+mismatching-declarations-of-revision-strings-in-hisax.patch
+make-isdn-capi-use-seq_list_xxx-helpers.patch

 ISDN updates

+nfsd-warning-fix.patch

 NFSD fix

+revoke-core-code-fix-zero-length-kmalloc.patch

 Fix revoke-core-code.patch

+lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
+lguest-the-host-code-update-for-mm-simplify-boot_params.patch

 lguest updates

+char-cyclades-add-firmware-loading.patch
+char-cyclades-fix-sparse-warning.patch
+char-isicom-cleanup-locking.patch
+char-isicom-del_timer-at-exit.patch
+char-isicom-proper-variables-types.patch

 char driver cleanups

+fbcon-smart-blitter-usage-for-scrolling.patch
+nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch

 fbdev updates

+md-improve-message-about-invalid-superblock-during-autodetect.patch
+md-improve-the-is_mddev_idle-test-fix.patch
+md-check-that-internal-bitmap-does-not-overlap-other-data.patch
+md-change-bitmap_unplug-and-others-to-void-functions.patch

 RAID updates

+readahead-introduce-pg_readahead.patch
+readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
+readahead-min_ra_pages-max_ra_pages-macros.patch
+readahead-data-structure-and-routines.patch
+readahead-on-demand-readahead-logic.patch
+readahead-convert-filemap-invocations.patch
+readahead-convert-splice-invocations.patch
+readahead-convert-ext3-ext4-invocations.patch
+readahead-remove-the-old-algorithm.patch
+mm-share-pg_readahead-and-pg_reclaim.patch
+mm-share-pg_readahead-and-pg_reclaim-fix.patch
+mm-share-pg_readahead-and-pg_reclaim-fix-2.patch

 New, simplified readahead patchset

+fallocate-implementation-on-i86-x86_64-and-powerpc.patch
+fallocate-on-s390.patch
+fallocate-on-ia64.patch
+fallocate-on-ia64-fix.patch

 fallocate() support

+cfs-scheduler.patch
+cfs-scheduler-vs-detach-schedh-from-mmh.patch
+cfs-scheduler-warning-fixes.patch

 CFS CPU scheduler

+rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch

 Fix prefetch patches for other changes in -mm,

+reiser4-use-lzo-library-functions.patch

 Teach reiser4 to use new generic LZO code

-mprotect-patch-for-use-by-slim.patch
-integrity-service-api-and-dummy-provider.patch
-slim-main-patch.patch
-slim-secfs-patch.patch
-slim-make-and-config-stuff.patch
-slim-debug-output.patch
-slim-integrity-patch.patch
-slim-documentation.patch
-integrity-new-hooks.patch
-integrity-fs-hook-placement.patch
-integrity-evm-as-an-integrity-service-provider.patch
-integrity-ima-integrity_measure-support.patch
-integrity-ima-identifiers.patch
-integrity-ima-cleanup.patch
-integrity-tpm-internal-kernel-interface.patch
-ibac-patch.patch

 Dropped

-vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
-vdso-print-fatal-signals-use-ctl_unnumbered.patch
-vdso-print-fatal-signals-fix-compiling-error-bug-in.patch

 Dropped

+vdso-print-fatal-signals-fix.patch

 Fix vdso-print-fatal-signals.patch

-git-gccbug-fixup.patch

 Unneeded



All 901 patches:


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/patch-list



