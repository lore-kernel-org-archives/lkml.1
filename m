Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXLWHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXLWHcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXLWHcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:32:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbXLWHb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:31:58 -0500
Date: Sat, 22 Dec 2007 23:30:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc6-mm1
Message-Id: <20071222233056.d652743e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/

- This kernel doesn't work on i386!

  It oopses late in boot due to an unrevertable change (e3c1b141) in git-x86
  which I stared at for a while then I ran out of time and gave up.

  I would have just abandoned this release until it was fixed but I'll be
  largely offline for ten days starting tomorrow.

  The culprits have been notified and hopefully we'll have a patch for
  hot-fixes/ tomorrow.

  x86_64 and powerpc work OK though.

- git-block is dropped due to more conflicts that I'm prepared to repair
  with git-scsi-misc

- git-perfmon is dropped due to conflicts with git-x86

- git-kgdb is dropped due to conflicts with git-x86

- git-newsetup is dropped due to conflicts with git-x86

- Andi's x86 quilt tree is dropped due to conflicts with git-x86

- Someone broke suspend-to-RAM on the t61p again.  It just instantly resumes
  itself.



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



Changes since 2.6.24-rc5-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-hrt.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-lblnet.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-net-fixup.patch
 git-netdev-all.patch
 git-battery.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sched-fixup.patch
 git-sh.patch
 git-scsi-misc.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-watchdog-fixup.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-x86.patch
 git-x86-fixup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-cryptodev-fixup.patch
 git-xtensa.patch

 git trees

-revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
-uml-stop-gdb-from-deleting-breakpoints-when-running-uml.patch
-alpha-strncpy-strncat-fixes.patch
-rtc-at32ap700x-fix-irq-init-oops.patch
-parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch
-ecryptfs-initialize-new-auth_tokens-before-teardown.patch
-knfsd-change-mailing-list-for-nfsd-in-maintainers.patch
-fix-lguest-documentation.patch
-sparsemem-make-sparsemem_vmemmap-selectable.patch
-fs-kconfig-grammar-fix.patch
-ext3-ext4-avoid-divide-by-zero.patch
-alpha-build-fixes.patch
-git-acpi-ia64-build-fix.patch
-git-acpi-build-fix.patch
-acpi-add-reboot-mechanism.patch
-acpi-cleanup-linux-acpih.patch
-alsa-nopage.patch
-alsa-usx2y-nopage.patch
-drivers-char-remove-unnecessary-pci_dev_put.patch
-git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
-agk-dm-dm-table-detect-io-beyond-device.patch
-agk-dm-dm-mpath-hp-requires-scsi.patch
-agk-dm-dm-crypt-fix-write-endio.patch
-agk-dm-dm-trigger-change-uevent-on-rename.patch
-agk-dm-dm-merge-max_hw_sector.patch
-agk-dm-dm-crypt-use-bio_add_page.patch
-agk-dm-dm-ioctl-move-compat-code-fix.patch
-dm-persistent_read_metadata-warning-fix.patch
-arch-powerpc-remove-duplicate-includes.patch
-arch-ppc-remove-duplicate-includes.patch
-arch-ppc-remove-an-unnecessary-pci_dev_put.patch
-powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
-powerpc-fix-typo-ifdef-ifndef.patch
-powerpc-add-support-for-porta-and-portb-odr-registers.patch
-powerpc-stop-the-toc-overflowing-for-large-builds.patch
-ppc-fix-missed-increment-on-device-interface-counter.patch
-ppc-chrp-fix-possible-null-pointer-dereference.patch
-ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
-powerpc-dont-cast-a-pointer-to-pointer-of-list_head.patch
-arch-powerpc-add-missing-of_node_put.patch
-arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch
-gregkh-driver-kobject-fix-the-documentation-of-how-kobject_set_name-works.patch
-revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
-gregkh-driver-kset-convert-acpi-to-use-kset_create.patch
-gregkh-driver-kobject-remove-old-outdated-documentation.patch
-gregkh-driver-kobject-update-the-kobject-kset-documentation.patch
-gregkh-driver-kobject-add-sample-code-for-how-to-use-kobjects-in-a-simple-manner.patch
-gregkh-driver-kobject-add-sample-code-for-how-to-use-ksets-ktypes-kobjects.patch
-gregkh-driver-kobject-warn.patch
-mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
-drm-dont-cast-a-pointer-to-pointer-of-list_head.patch
-git-dvb-fix-build-in-drivers-media-dvb-frontends-tda18271h.patch
-git-dvb-one-videobuf_read_start-is-enough.patch
-git-dvb-drivers-media-dvb-frontends-zl10353c-avoid-64-bit-divide.patch
-git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings.patch
-media-video-usbvision-add-mutex_unlock-to-error-paths.patch
-media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
-media-video-usbvision-remove-ctrlurblock.patch
-i2c-fix-drivers-media-video-bt866c.patch
-gfs2-avoid-64-bit-divide.patch
-ia64-slim-down-__clear_bit_unlock.patch
-ia64-signal-remove-redundant-code-in-setup_sigcontext.patch
-ia64-ia32-nopage.patch
-ieee1394-nopage.patch
-ib-nopage.patch
-fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch
-fujitsu-application-panel-driver.patch
-apanel-free-input-device-on-close.patch
-apanel-change-name-of-led.patch
-apanel-detach-on-shutdown.patch
-apanel-use-generic-keycode-routines.patch
-fujitsu-application-panel-led-value.patch
-ads7846-stop-updating-dev-powerpower_state.patch
-drivers-ata-libata-ehc-fix-printk-warning.patch
-pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
-pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
-ata-ahci-enclosure-management-via-led.patch
-pata_legacy-restructure-and-revamp.patch
-ide-mm-ide-scsi-add-ide_scsi_hex_dump-helper.patch
-ide-mm-ide-add-missing-checks-for-control-register-existence.patch
-ide-mm-ide-deprecate-config_blk_dev_offboard.patch
-ide-mm-ide-fix-ide_scan_pcibus-error-message.patch
-ide-mm-ide-coding-style-fixes-for-drivers-ide-setup-pci-c.patch
-ide-mm-ide-add-sys-bus-ide-devices-model-firmware-serial-sysfs-entries.patch
-ide-mm-ide-dma-reporting-and-validity-checking-fixes-take-3.patch
-ide-mm-ide-cd-remove-dead-post_transform_command.patch
-ide-mm-pdc202xx_new-fix-promise-tx4-support.patch
-ide-mm-hpt366-fix-hpt37x-pio-mode-timings-take-2.patch
-ide-mm-ide-remove-dead-code-from-__ide_dma_test_irq.patch
-ide-mm-ide-remove-stale-changelog-from-ide-disk-c.patch
-ide-mm-ide-remove-stale-changelog-from-ide-probe-c.patch
-md-balance-braces-in-raid5-debug-code.patch
-mips-fix-makefile-borkage.patch
-mips-remove-dead-config-symbols-from-mips-code.patch
-ipsec-fix-reversed-icmp6-policy-check.patch
-ipsec-do-not-let-packets-pass-when-icmp-flag-is-off.patch
-git-net-fix-drivers-net-ns83820c-build.patch
-updates-to-nfsroot-documentation-take-3.patch
-net-use-mutex_is_locked-for-assert_rtnl.patch
-tipc-fix-semaphore-handling.patch
-ppp-synchronous-tty-convert-dead_sem-to-completion.patch
-ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
-pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
-net-ibm_newemac-remove-spin_lock_unlocked.patch
-e100-free-irq-to-remove-warning-when-rebooting.patch
-net-smc911x-shut-up-compiler-warnings.patch
-bnx2x-depends-on-zlib_inflate.patch
-plip-driver-convert-killed_timer_sem-to-completion.patch
-pcie-fix-double-initialization-bug.patch
-pci-dont-load-acpi_php-when-acpi-is-disabled.patch
-pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
-track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
-merge-multiple-error-paths-in-alloc_uid-into-one.patch
-kernel-time-make-tick_do_broadcast-static.patch
-git-scsi-misc-fix-build-in-drivers-scsi-scsi_tgt_libc.patch
-initio-fix-conflict-when-loading-driver.patch
-ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
-ips-trim-trailing-whitespace.patch
-ips-pci-api-cleanups.patch
-ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
-scsi-gdth-kill-unneeded-irq-argument.patch
-scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
-scsi-ncr5380-minor-irq-handler-cleanups.patch
-advansys-fix-section-mismatch-warning.patch
-aic94-fix-section-mismatches.patch
-sym2-fix-section-mismatch-warning.patch
-aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di.patch
-drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
-hptiop-add-more-adapter-models-and-other-fixes.patch
-hptiop-add-more-adapter-models-and-other-fixes-update.patch
-hptiop-add-more-adapter-models-and-other-fixes-fix-2.patch
-drivers-scsi-iprc-use-list_head-instead-of-list_head_init.patch
-libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
-belkin_sa-clean-up-for-new-style-termios-and-speed.patch
-keyspan_pda-clean-up-speed-handling.patch
-mct232-speed-new-termios-and-compliance-cleanups.patch
-mct232-speed-new-termios-and-compliance-cleanups-fix.patch
-ohci-hcdcohci_irq-locking-fix.patch
-edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
-usb-testing-driver-convert-dev-sem-to-mutex.patch
-usb-testing-driver-dont-free-a-locked-mutex.patch
-usb-mon-nopage.patch
-txx9-watchdog-driver.patch
-net-mac80211-fix-inappropriate-memory-freeing.patch
-wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head.patch
-git-x86-__vdso_getcpu-warning-fix.patch
-git-x86-fix-allnoconfig-build.patch
-uml-add-asm-um-asmh.patch
-x86_64-add-acpi-reboot-option.patch
-clocksource-make-clocksource_mask-bullet-proof.patch
-time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
-mcheck-mce_64-mce_read_sem-to-mutex.patch
-x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
-x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
-x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix.patch
-x86_64-efi-runtime-service-support-efi-runtime-services.patch
-x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
-x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
-x86-boot-use-e820-memory-map-on-efi-32-platform.patch
-ieee80211_rate-missed-unlock.patch
-drivers-cpufreq-cpufreq_statsc-section-fix.patch
 bonding-locking-fix.patch
-bridge-assign-random-address.patch
-nfs-fix-an-oops-in-nfs-unmount.patch
-acpi-sbs-reset-alarm-bit.patch
-acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch
-acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch
-usb-use-irqf_disabled-for-hcd-interrupt-handlers.patch
-usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch
-iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch
-iwlwifi3945-4965-fix-rate-control-algo-reference-leak-fix.patch
-mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
-mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
-mm-sparsec-improve-the-error-handling-for-sparse_add_one_section-fix.patch
-pktcdvd-add-kobject_put-when-kobject-register-fails.patch
-libertas-select-wireless_ext.patch
-bcm43xx_debugfs-sscanf-fix.patch
-apm_eventinfo_t-are-userspace-types.patch
-drivers-macintosh-via-pmuc-added-a-missing-iounmap.patch
-tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
-shmem-factor-out-sbi-free_inodes-manipulations.patch
-shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
-i-oat-fixups-from-code-comments.patch
-rcu-move-three-variables-to-__read_mostly-to-save-space.patch
-ext4-fix-mb_debug-format-warnings.patch
-jbd2-remove-printk-from-j_assert-macros.patch
-64-bit-i_version-afs-fixes.patch
-ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
-ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
-ext4-superc-fix-ifdefs.patch
-ext4-add-block-bitmap-validation.patch
-ext4-fix-up-ext4fs_debug-builds.patch
-jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
-ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks.patch
-ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
-drivers-dma-iop-admac-use-list_head-instead-of-list_head_init.patch

 Merged into mainline or a subsystem tree

+quicklists-do-not-release-off-node-pages-early.patch
+ecryptfs-fix-string-overflow-on-long-cipher-names.patch
+fix-computation-of-skb-size-for-quota-messages.patch
+dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch
+ecryptfs-fix-unlocking-in-error-paths.patch
+ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
+maintainers-mailing-list-archives-are-web-links.patch
+ps3-vuart-fix-error-path-locking.patch
+lib-proportion-fix-underflow-in-prop_norm_percpu.patch
+pcmcia-remove-pxa2xx_lubbock-build-warning.patch
+kconfig-obey-kconfig_allconfig-choices-with-randconfig.patch

 2.6.24 queue

+fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch
+hfs-handle-more-on-disk-corruptions-without-oopsing.patch
+hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
+tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch

 Maybe 2.6.24 queue

+timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
+timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
+timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch

 update timerfd patches

+git-alsa-fixup.patch
+sound-usb-usbaudioc-fix-build-with-config_pm=n.patch

 Fix git-alsa

+git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch

 Fix crash in git-agpgart.patch

-arm-remove-dead-config-symbols-from-arm-code.patch

 Dropped

+agk-dm-dm-snapshot-use-uninitialized_var.patch
+agk-dm-dm-raid1-handle-write-failures.patch
+agk-dm-dm-raid1-report-fault-status.patch
+agk-dm-dm-raid1-fix-eio-after-log-failure.patch
+agk-dm-dm-raid1-handle-read-failures.patch
+agk-dm-dm-raid1-mark-and-clear-nosync-writes.patch

 device-mapper tree updates

+powerpc-add-fixed-phy-support-for-fs_enet.patch

 pwerpc net driver fix

+gregkh-driver-kref-add-kref_set.patch
+gregkh-driver-kobject-convert-sys-firmware-acpi-to-use-kobject_create.patch
+gregkh-driver-kobject-change-net-bridge-to-use-kobject_create_and_add.patch
+gregkh-driver-kobject-change-gfs2-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-infiniband-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-firmware-eddc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-firmware-efivarsc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-cpufreq-cpufreqc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-edac-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-cpuidle-sysfsc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-pci-hotplug-pci_hotplug_corec-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-base-sysc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-arch-x86-kernel-cpu-intel_cacheinfoc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-acpi-systemc-to-use-kobject_create_and_add.patch
+gregkh-driver-kobject-change-drivers-block-pktcdvdc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-arch-sh-kernel-cpu-sh4-sqc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-net-ibmvethc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-parisc-pdc_stablec-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-arch-ia64-kernel-topologyc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-drivers-md-mdc-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_create_and_add.patch
+gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-the-cris-iop_fw_loadc-code-is-broken.patch
+gregkh-driver-kobject-convert-drivers-base-classc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-drivers-base-corec-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-drivers-net-iseries_vethc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-fs-char_devc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-kernel-paramsc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-kernel-userc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-mm-slubc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-net-bridge-br_ifc-to-use-kobject_init-add_ng.patch
+gregkh-driver-driver-add-driver_add_kobj-for-looney-iseries_veth-driver.patch
+gregkh-driver-kobject-change-drivers-base-bus-to-use-kobject_init_and_add.patch
+gregkh-driver-kobject-convert-block-elevatorc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-block-ll_rw_blkc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-drivers-md-mdc-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-convert-kernel-modulec-to-use-kobject_init-add_ng.patch
+gregkh-driver-kobject-remove-kobject_add-as-no-one-uses-it-anymore.patch
+gregkh-driver-kobject-rename-kobject_add_ng-to-kobject_add.patch
+gregkh-driver-kobject-remove-kobject_init-as-no-one-uses-it-anymore.patch
+gregkh-driver-kobject-rename-kobject_init_ng-to-kobject_init.patch
+gregkh-driver-kobject-remove-kobject_register.patch
+gregkh-driver-kset-remove-kset_add-function.patch
+gregkh-driver-kobject-auto-cleanup-on-final-unref.patch
+gregkh-driver-kobject-convert-arch-from-kobject_unregister-to-kobject_put.patch
+gregkh-driver-kobject-convert-drivers-from-kobject_unregister-to-kobject_put.patch
+gregkh-driver-kobject-convert-fs-from-kobject_unregister-to-kobject_put.patch
+gregkh-driver-kobject-convert-remaining-kobject_unregister-to-kobject_put.patch
+gregkh-driver-kobject-remove-kobject_unregister-as-no-one-uses-it-anymore.patch
+gregkh-driver-driver-core-change-sysdev-classes-to-use-dynamic-kobject-names.patch
+gregkh-driver-kobject-remove-old-outdated-documentation.patch
+gregkh-driver-kobject-update-the-kobject-kset-documentation.patch
+gregkh-driver-kobject-add-sample-code-for-how-to-use-kobjects-in-a-simple-manner.patch
+gregkh-driver-kobject-add-sample-code-for-how-to-use-ksets-ktypes-kobjects.patch
+gregkh-driver-driver-core-use-list_head-instead-of-call-to-init_list_head-in-__init.patch

 driver tree updates

+revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
+drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch

 Fix it

+driver-base-memory-semaphore-to-mutex.patch

 mutex conversion

-git-drm-oops-fix.patch

 Now unneeded

+jdelvare-i2c-i2c-omap-fix-reset-on-error.patch
+jdelvare-i2c-i2c-spelling-fixes.patch
+jdelvare-i2c-i2c-tps65010-move-header.patch
+jdelvare-i2c-i2c-i801-01-document-features.patch
+jdelvare-i2c-i2c-i801-02-features-as-a-bitfield.patch
+jdelvare-i2c-i2c-i801-03-clear-block-buffer-mode.patch
+jdelvare-i2c-i2c-i801-04-add-support-for-i2c-block-read.patch
+jdelvare-i2c-i2c-id-document-optional.patch
+jdelvare-i2c-i2c-id-delete-unused.patch

 I2C tree updates

+ia64-remove-dead-code.patch
+ia64-honor-notify_die-returning-notify_stop.patch

 ia64 updates

+git-infiniband-versus-driver-tree.patch

+input-handle-ev_pwr-in-input_set_capability.patch

 Input fix

+kvm-ist-kaput.patch

 Disable KVM due to large clashes with git-x86

+git-lblnet-fixup.patch

 Fix rejects in git-lblnet.patch

+git-libata-all-fix-pata_winbond-borkage.patch
+git-libata-all-wtf.patch

 Fix git-libata-all.

-libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch

 Fiolded into libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch

+ide-mm-ide-spelling-fixes.patch
+ide-mm-hpt366-merge-set_dma_mode-methods.patch
+ide-mm-ide-fix-build-break-caused-by-ide-remove-ideprobe_init.patch
+ide-mm-ide-fix-io_32bit-race-in-ide_taskfile_ioctl.patch
+ide-mm-ide-clear-hob-bit-for-req_type_ata_cmd-requests-in-ide_end_drive_cmd.patch
+ide-mm-ide-fix-final-status-check-in-task_in_intr.patch
+ide-mm-ide-tape-fix-handling-of-non-special-requests-in-end_request-method.patch
+ide-mm-ide-set-ide_tflag_in-flags-before-queuing-executing-command.patch
+ide-mm-ide-remove-needless-cursg-clearing-from-task_end_request.patch
+ide-mm-ide-use-rq-nr_sectors-in-task_end_request.patch
+ide-mm-ide-task_end_request-fix.patch
+ide-mm-ide-kill-data_ready-define.patch
+ide-mm-ide-use-wait_drive_not_busy-in-drive_cmd_intr-take-2.patch
+ide-mm-ide-initialize-rq-cmd_type-in-ide_init_drive_cmd-callers.patch
+ide-mm-ide-convert-empty-req_type_ata_cmd-requests-to-use-req_type_ata_taskfile.patch
+ide-mm-ide-dont-enable-local-irqs-for-pio-in-in-driver_cmd_intr-take-2.patch
+ide-mm-ide-check-busy-and-error-status-bits-before-reading-data-in-drive_cmd_intr.patch
+ide-mm-ide-fix-final-status-check-in-drive_cmd_intr.patch
+ide-mm-ide-switch-set_xfer_rate-to-use-req_type_ata_taskfile-requests.patch
+ide-mm-ide-switch-ide_cmd_ioctl-to-use-req_type_ata_taskfile-requests.patch
+ide-mm-ide-remove-req_type_ata_cmd.patch
+ide-mm-ide-cd-fix-samsung-cd-rom-scr-3231-quirk.patch
+ide-mm-ide-cd-fix-acer-aopen-24x-cdrom-speed-reporting-on-big-endian-machines.patch
+ide-mm-ide-cd-use-ide_cd_release-in-ide_cd_probe.patch
+ide-mm-ide-cd-fix-error-messages-in-cdrom_read-write_check_ireason.patch
+ide-mm-ide-cd-add-missing-ireason-masking-to-cdrom_write_intr.patch
+ide-mm-ide-cd-fix-error-messages-in-cdrom_write_intr.patch
+ide-mm-ide-cd-add-error-message-for-dma-error-to-cdrom_read_intr.patch
+ide-mm-ide-cd-fix-error-message-in-cdrom_pc_intr.patch
+ide-mm-ide-cd-fix-ireason-reporting-in-cdrom_pc_intr.patch
+ide-mm-ide-cd-use-xfer_func_t-in-cdrom_pc_intr.patch
+ide-mm-ide-cd-add-ide_cd_pad_transfer-helper.patch
+ide-mm-ide-cd-fix-missing-data-handling-in-cdrom_pc_intr.patch
+ide-mm-ide-cd-fix-dma-error-handling-in-cdrom_newpc_intr.patch
+ide-mm-ide-cd-fix-trailing-whitespaces-in-changelog.patch
+ide-mm-ide-cd-move-historical-changelog-to-documentation-ide-changelog-ide-cd-1994-2004.patch
+ide-mm-ide-cd-remove-stale-cdrom_transfer_packet_command-comment.patch
+ide-mm-ide-cd-remove-unused-defines-from-ide-cd-h.patch
+ide-mm-ide-cd-remove-dead-code-from-cdrom_pc_intr.patch
+ide-mm-ide-cd-remove-unused-struct-atapi_cdrom_subchnl.patch
+ide-mm-ide-cd-remove-needless-zeroing-of-info-fields-from-ide_cdrom_setup.patch
+ide-mm-ide-cd-remove-unused-and-write-only-struct-ide_cd_config_flags-fields.patch
+ide-mm-ide-cd-remove-struct-atapi_mechstat_header-changer_info-slot.patch
+ide-mm-ide-cd-cleanup-ide_cdrom_update_speed.patch
+ide-mm-ide-cd-add-ide_cd_capabilities-define.patch
+ide-mm-ide-cd-remove-redundant-config-flags.patch
+ide-mm-ide-cd-kill-cdrom_config_flags-macro.patch
+ide-mm-ide-cd-kill-cdrom_state_flags-macro.patch
+ide-mm-ide-cd-remove-struct-atapi_capabilities_page.patch
+ide-mm-ide-cd-remove-struct-ide_cd_config-state_flags.patch
+ide-mm-ide-cd-remove-no_door_locking-define.patch
+ide-mm-ide-cd-remove-standard_atapi-define.patch
+ide-mm-ide-cd-use-bcd2bin-bin2bcd-macros-from-linux-bcd-h.patch
+ide-mm-ide-cd-re-organize-handling-of-quirky-devices.patch
+ide-mm-ide-cd-remove-duplicate-sense-keys-definitions-from-ide-cd-h.patch
+ide-mm-ide-cd-coding-style-fixes-for-verbose_ide_cd_errors-code.patch
+ide-mm-ide-cd-move-verbose_ide_cd_errors-code-to-ide-cd_verbose-c.patch
+ide-mm-ide-cd-factor-out-ioctl-handlers-from-ide_cdrom_audio_ioctl.patch
+ide-mm-ide-cd-merge-cdrom_play_audio-into-ide_cd_fake_play_trkind.patch
+ide-mm-ide-cd-merge-cdrom_read_subchannel-into-ide_cdrom_get_mcn.patch
+ide-mm-ide-cd-merge-cdrom_select_speed-into-ide_cdrom_select_speed.patch
+ide-mm-ide-cd-move-lba_to_msf-and-msf_to_lba-to-linux-cdrom-h.patch
+ide-mm-ide-cd-coding-style-fixes-for-cdrom_get_toc_entry.patch
+ide-mm-ide-cd-rename-cdrom_-functions-to-ide_cd_.patch
+ide-mm-ide-cd-move-code-handling-cdrom-c-ioctls-to-ide-cd_ioctl-c.patch
+ide-mm-ide-cd-remove-bug_on-from-cdrom_newpc_intr.patch
+ide-mm-ide-cd-call-blk_dump_rq_flags-on-missing-data-in-cdrom_newpc_intr.patch
+ide-mm-ide-cd-factor-out-request-sense-fixup-from-cdrom_pc_intr.patch
+ide-mm-ide-cd-unify-request-end-exit-path-in-cdrom_pc_intr.patch
+ide-mm-ide-cd-merge-cdrom_pc_intr-and-cdrom_newpc_intr.patch
+ide-mm-ide-cd-remove-cdrom_do_pc_continuation.patch
+ide-mm-ide-cd-merge-cdrom_do_packet_command-and-cdrom_do_block_pc.patch
+ide-mm-ide-cd-add-ide_cd_drain_data-helper.patch
+ide-mm-ide-cd-factor-out-transfer-size-checking-from-cdrom_read_intr.patch
+ide-mm-ide-cd-merge-cdrom_read_intr-and-cdrom_write_intr.patch
+ide-mm-ide-cd-merge-cdrom_start_read_continuation-and-cdrom_start_write_cont.patch
+ide-mm-ide-cd-merge-cdrom_start_read-and-cdrom_start_write.patch
+ide-mm-ide-cd-unify-moving-to-the-next-buffer-in-cdrom_rw_intr.patch
+ide-mm-ide-cd-prepare-cdrom_rw_intr-and-cdrom_newpc_intr-to-be-merged.patch
+ide-mm-ide-cd-call-blk_dump_rq_flags-on-missing-data-in-cdrom_rw_intr.patch
+ide-mm-ide-cd-merge-cdrom_rw_intr-and-cdrom_newpc_intr.patch
+ide-mm-ide-cd-merge-cdrom_write_check_ireason-and-cdrom_read_check_ireason.patch
+ide-mm-ide-cd-unify-request-end-exit-path-in-cdrom_decode_status.patch
+ide-mm-ide-cd-update-driver-version-comments-and-copyrights.patch

 IDE tree updates

+git-net-fixup.patch

 Fix rejects in git-net.patch

+git-net-vs-git-lblnet-2.patch

 Fix disagreement between git-lblnet and git-net.

+git-net-vs-git-netdev-all.patch

 Fix disagreement between git-netdev-all and git-net.

-backlight-omap1-backlight-driver-fix.patch

 Fix backlight-omap1-backlight-driver.patch

+pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
+pcmcia-3c574_cs-fix-shadow-variable-warning.patch
+pcmcia-axnet_cs-make-functions-static.patch
+pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
+pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
+pcmcia-pcnet_cs-fix-shadow-variable-warning.patch

 pcmcia fixes

+serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
+serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch

 Serial device support

+gregkh-pci-pcie-fix-pcie-hotplug-so-that-it-works-with-expresscard-slots-on-dell-notebooks-in-conjunction-with-modparam-of-pciehp_force-1.patch
+gregkh-pci-pci-more-fixes-for-pcie-hotplug-so-that-it-works-with-expresscard-slots-on-dell-notebooks-in-conjunction-with-modparam-of-pciehp_force-1.patch
+gregkh-pci-pcie-make-use-of-the-previously-split-out-pcie_init_enable_events-function.patch
+gregkh-pci-pcie-fix-double-initialization-bug.patch
+gregkh-pci-pci-hotplug-acpiphp-fix-trivial-typos.patch
+gregkh-pci-pci-hotplug-acpiphp-remove-unneeded-acpi_get_name-function-call.patch
+gregkh-pci-pci-hotplug-pciehp-remove-needless-members-from-struct-controller.patch
+gregkh-pci-pci-hotplug-pciehp-remove-needless-hp_slot-calculation.patch
+gregkh-pci-pci-hotplug-pciehp-use-generic-function-to-find-ext-capability.patch
+gregkh-pci-pci-hotplug-pciehp-fix-some-whitespace-damage.patch
+gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
+gregkh-pci-pci-fix-warning-in-setup-resc-on-32-bit-platforms-with-64-bit-resources.patch
+gregkh-pci-pci-remove-default-pci-expansion-rom-memory-allocation.patch
+gregkh-pci-pci-quirk-enable-msi-mapping-on-ht1000.patch
+gregkh-pci-pci-drivers-pci-msic-move-arch-hooks-to-the-top.patch
+gregkh-pci-pci-kconfig-help-don-t-refer-to-the-pci-howto.patch
+gregkh-pci-pci-spelling-fixes.patch
+gregkh-pci-pci-fix-for-quirk_e100_interrupt.patch
+gregkh-pci-pci-print-quirk-name-in-debug-messages.patch
+gregkh-pci-pci-use-dev_printk-in-quirk-messages.patch
+gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
+gregkh-pci-pci-fix-typo-in-pci_save_pcix_state.patch
+gregkh-pci-pci-correctly-initialize-a-structure-for-pcie_save_pcix_state.patch
+gregkh-pci-pci-avoid-save-the-same-type-of-cap-multiple-times.patch
+gregkh-pci-pci-add-pci_enable_device_-io-mem-intefaces.patch
+gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
+gregkh-pci-pci-remove-pci_enable_device_bars.patch

 PCI tree updates

-quirk-enable-msi-mapping-on-ht1000.patch
-quirk-enable-msi-mapping-on-ht1000-v2.patch


 Dropped

+if-0-pci_cleanup_aer_correct_error_status.patch
+cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch

 PCI cleanups

-pci-hotplug-mm-pci-hotplug-pciehp-deal-with-pre-inserted-expresscards.patch
-pci-hotplug-mm-pci-hotplug-pciehp-split-out-hardware-init-from-pcie_init.patch
-pci-hotplug-mm-pci-hotplug-pciehp-reinit-hotplug-h-w-on-resume-from-suspend.patch

 Not sure what happened to these - they don't apply by a mile and don't seem
 to have been merged.

+git-sched-fixup.patch
+git-sched-fix-preempt-rcu-on-non-preemptible-architectures.patch

 Repair git-sched.patch

+scsi-megaraidc-__devexit-annotation.patch
+scsi-aic94xx-cleanups.patch
+scsi-aic94xx-cleanups-checkpatch-fixes.patch
+scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
+small-cleanups-for-scsi_hosth.patch

 scsi stuff

+scsi-scsi_data_buffer.patch
+scsi-pending-arm-convert-to-accessors.patch
+scsi-bidi-support.patch

 More scsi stuff

+gregkh-usb-usb-unbreak-fsl_usb2_udc.patch
+gregkh-usb-usb-vid-pid-update-for-sierra.patch
+gregkh-usb-usb-new-device-id-for-the-cp2101-driver.patch
+gregkh-usb-usb-convert-ohci-debug-files-to-use-debugfs-instead-of-sysfs.patch
+gregkh-usb-usb-convert-ehci-debug-files-to-use-debugfs-instead-of-sysfs.patch
+gregkh-usb-usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
+gregkh-usb-usb-repair-usbdevfs_connect-ioctl.patch
+gregkh-usb-usb-updates-to-usb_reset_composite_device.patch
+gregkh-usb-usb-edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
+gregkh-usb-usb-add-usbfs-stubs-for-suspend-and-resume.patch
+gregkh-usb-usb-ehci-add-separate-iaa-watchdog-timer.patch
+gregkh-usb-usb-dummy_hcd-change-the-default-power-budget.patch
+gregkh-usb-usb-pl2303-cleanup-fish-and-soup-macros-in-pl2303-driver.patch
+gregkh-usb-usb-pl2303-move-pl2303-vendor-specific-init-to-probe-function.patch
+gregkh-usb-usb-pl2303-add-autosuspend-support-to-pl2303-usb-serial-converter.patch
+gregkh-usb-usb-update-pxa27x-ohci-driver-to-use-clk-support.patch
+gregkh-usb-usb-belkin_sa-clean-up-for-new-style-termios-and-speed-handling-plus-style.patch
+gregkh-usb-usb-keyspan_pda-clean-up-speed-handling.patch
+gregkh-usb-usb-mct232-speed-new-termios-and-compliance-cleanups.patch
+gregkh-usb-usb-mon-nopage.patch
+gregkh-usb-usb-testing-driver-convert-dev-sem-to-mutex.patch
+gregkh-usb-usb-testing-driver-don-t-free-a-locked-mutex.patch
+gregkh-usb-usb-gadget-pxa2xx_udc-supports-inverted-vbus.patch
+gregkh-usb-usb-spelling-fixes.patch
+gregkh-usb-usb-ps3-fix-ehci-iso-transfer-bug.patch
+gregkh-usb-usb-usb-storage-initializersc-fix-signedness-difference.patch
+gregkh-usb-usb-usbdevfs_urb-__user-annotation.patch
+gregkh-usb-usb-ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch
+gregkh-usb-usb-add-marvell-orion-usb-host-support.patch
+gregkh-usb-usb-ehci-potential-oops-fix-on-arc-tdi-cores.patch
+gregkh-usb-usb-gadget-ethernet-error-path-potential-oops-fix.patch
+gregkh-usb-usb-fix-null-pointer-dereference-on-drivers-usb-serial-whiteheatc.patch
+gregkh-usb-usb-gadget-at91_udc-minor-fix.patch
+gregkh-usb-usb-fix-hcd-kconfig-goofage.patch
+gregkh-usb-usb-tosa_udc_use_gpio_vbuspatch.patch

 USB tree updates

+ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
+usb-microtek-remove-unused-semaphore.patch
+usb-libusual-locking-cleanup.patch

 USB things

+git-watchdog-fixup.patch

 Fix rejects in git-watchdog

-add-support-for-sb1-hardware-watchdog-fix.patch

 Folded into add-support-for-sb1-hardware-watchdog.patch

+prism54-remove-questionable-down_interruptible-usage.patch

 wireless fix

+git-x86-fixup.patch
+git-x86-arch-x86-math-emu-errorsc-fix-printk-warnings.patch
+git-x86-drivers-pnp-pnpbios-bioscallsc-build-fix.patch
+git-x86-fix-doubly-merged-patch.patch
+git-x86-export-leave_mm.patch

 Partially repair git-x86

+pci-dont-load-acpi_php-when-acpi-is-disabled.patch
+arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch
+arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch
+arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes-checkpatch-fixes.patch

 x86 stuff

+drm-i915-fix-oops-after-killing-x.patch
+usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
+usbtouchscreen-fix-buffer-overflow-make-more-egalax-work-checkpatch-fixes.patch
+fix-rtc_aie-with-config_hpet_emulate_rtc.patch
+cpufreq-initialise-default-governor-before-use.patch

 Probably for 2.6.24, via subsystem trees

-slub-optimise-the-clearing-of-__gfp_zero.patch

 Unneeded

+shmem-factor-out-sbi-free_inodes-manipulations.patch
+shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
+tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
+tmpfs-move-swap_state-stats-update.patch
+tmpfs-shuffle-add_to_swap_caches.patch
+tmpfs-move-swap-swizzling-into-shmem.patch
+tmpfs-allow-filepage-alongside-swappage.patch
+tmpfs-allocate-on-read-when-stacked.patch
+tmpfs-make-shmem_unuse-more-preemptible.patch
+tmpfs-open-a-window-in-shmem_unuse_inode.patch
+tmpfs-radix_tree_preloading.patch
+tmpfs-fix-shmem_swaplist-races.patch

 MM things

+maps4-add-proc-kpagecount-interface-fix.patch
+maps4-add-proc-kpageflags-interface-fix.patch
+maps4-add-proc-kpageflags-interface-fix-2.patch
+maps4-add-proc-kpageflags-interface-fix-2-fix.patch

 maps4 fixes

+page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
+page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch

 Fix page-allocator-clean-up-pcp-draining-functions.patch

+mm-remove-fastcall-from-mm.patch
+mm-remove-fastcall-from-mm-checkpatch-fixes.patch
+set_page_refcounted-vm_bug_on-fix.patch
+fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
+oom_kill-remove-uid==0-checks.patch

 More mm things

+m68knommu-remove-duplicate-exports.patch

 m68knommu cleanup

+arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
+cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch

 cris updates

+uml-header-untangling-fix.patch

 Fix uml-header-untangling.patch

+ik8-add-dell-uk-6400-inspiron-model-mm061.patch
+parport_pc-detection-for-superio-it87xx-post.patch
+lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
+kernel-paramsc-remove-sparse-warning-different-signedness.patch
+fix-missing-n-in-checkpatchpl.patch
+xen-fiddle_vdso-must-be-__init.patch
+calibrate_delay-must-be-__cpuinit.patch
+idle_regs-must-be-__cpuinit.patch
+kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch
+debug_smp_processor_id-fixlets.patch
+use-ilog2-in-fs-namespacec.patch
+use-ilog2-in-fs-namespacec-fix.patch
+printk_ratelimit-functions-should-use-config_printk.patch
+w1-gpio-add-gpio-w1-bus-master-driver.patch
+docs-convert-kref-semaphore-to-mutex.patch
+fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
+maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch
+avoid-overflows-in-kernel-timec.patch
+avoid-overflows-in-kernel-timec-fix.patch
+export-iov_shorten-for-ext4s-use.patch
+export-iov_shorten-for-ext4s-use-fix.patch

 Misc

+ser_gigaset-convert-mutex-to-completion.patch

 gigaset cleanup

+ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
+ecryptfs-minor-fixes-to-printk-messages.patch
+ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch
+ecryptfs-load-each-file-decryption-key-only-once.patch

 ecryptfs work

-logo-move-declarations-of-logos-to-linux_logoh.patch
-logo-move-declarations-of-logos-to-linux_logoh-fix.patch

 Dropped these - it was too much work trying to make them work.

+drivers-video-pm3fbc-section-fix.patch
+neofb-avoid-overwriting-fb_info-fields.patch

 fbdev things

+md-support-external-metadata-for-md-arrays.patch
+md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
+md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
+md-allow-devices-to-be-shared-between-md-arrays.patch
+md-lock-address-when-changing-attributes-of-component-devices.patch
+md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch

 RAID updates

-ext4-mm-ext4_grpnum_t.patch
-ext4-mm-ext4_grpnum_t_int_fix.patch
-ext4-mm-ext4-cleanup.patch
-ext4-mm-ext4-cleanup-2.patch
-ext4-mm-ext4-cleanup-3.patch
-ext4-mm-ext4-cleanup-4.patch
+ext4-mm-ext4_extents_use_ext4_lblk_t_fix.patch
+ext4-mm-ext4_extents_remove_unneeded_casts.patch
+ext4-mm-ext4_grp_t.patch
+ext4-mm-ext4_grp_t_int_fix.patch
+ext4-mm-ext4_add_update_incompat_feature.patch
+ext4-mm-ext4-sparse-warning-fix.patch
+ext4-mm-ext4-rename-i_file_acl-to-i_file_acl_lo.patch
+ext4-mm-ext4-rename-i_dir_acl-to-i_size_high.patch
+ext4-mm-ext4_different_maxbytes_funcs_for_bitmap_and_extent_files.patch
+ext4-mm-ext4_store_maxbytes_for_bitmaped_files.patch
+ext4-mm-ext4_ifdef_fix.patch
+ext4-mm-ext4_fix_oops_on_corrupted_mount.patch
+ext4-mm-change-default-ext4-error.patch
+ext4-mm-ext4_add_block_bitmap_validation.patch
+ext4-mm-ext4-add-block-bitmap-validation-fix.patch
+ext4-mm-jbd2-remove-printk-from-j_assert-macros.patch
+ext4-mm-jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
+ext4-mm-ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks.patch
+ext4-mm-ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
+ext4-mm-remove-unused-code-from-ext4_find_entry.patch
+ext4-mm-jbd-stats-through-procfs-with-external-journal-oops-fix.patch
+ext4-mm-ext4_jbd2_stats_kmalloc_failure_fix.patch
+ext4-mm-ext4_jbd2_stats_comments_fix.patch
+ext4-mm-ext4_accumulated_jbd2_stats_in_jiffies.patch
+ext4-mm-ext4_open-code-jbd2_stats-union-references.patch
-ext4-mm-64-bit-i_version.patch
-ext4-mm-i_version_hi.patch
-ext4-mm-ext4_i_version_hi_2.patch
-ext4-mm-i_version_update_ext4.patch
+ext4-mm-ext4_journal_chksum_highmem_fix.patch
+ext4-mm-inode-version-vfs.patch
+ext4-mm-inode-version-ext4.patch
+ext4-mm-64-bit-i_version-afs-fixes.patch
-ext4-mm-mballoc-bug-workaround.patch
-ext4-mm-ext4_grpnumt-mballoc-fix.patch
-ext4-mm-mballoc-compilebench-fix.patch
+ext4-mm-ext4-fix-mb_debug-format-warnings.patch
+ext4-mm-ext4_mballoc_freespace_accounting_fix.patch
+ext4-mm-enable-delalloc-and-mballoc.patch
+ext4-mm-show-mballoc-delalloc-option.patch
+ext4-mm-fix-show-options.patch
+ext4-mm-ext4_fix_up_ext4fs_debug_builds.patch

 Changes in the ext4 tree

+ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch

 ext4 fix

+ext3-remove-unused-code-from-ext3_find_entry.patch

 ext3 cleanup

+memory-controller-memory-accounting-v7-move-page_assign_page_cgroup-to-vm_bug_on-in-free_hot_cold_page.patch
+memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
+memcgroup-tidy-up-mem_cgroup_charge_common.patch
+memcgroup-fix-hang-with-shmem-tmpfs.patch
+memory-controller-remove-control_type-feature.patch

 Memory controller updates

+iget-stop-isofs-from-using-read_inode-fix-2.patch
+iget-stop-isofs-from-using-read_inode-fix-2-update.patch

 Fix iget-stop-isofs-from-using-read_inode.patch

+pid-namespaces-vs-locks-interaction.patch

 namespaces fix

+pid-fix-mips-irix-emulation-pid-usage-fix.patch

 Fix pid-fix-mips-irix-emulation-pid-usage.patch

+aout-move-stack_top-to-asm-processorh-fix.patch

 Fix aout-move-stack_top-to-asm-processorh.patch against git-x86 changes

+fs-remove-fastcall-it-is-always-empty.patch
+fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
+kernel-remove-fastcall-in-kernel.patch
+kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
+lib-remove-fastcall-from-lib.patch
+lib-remove-fastcall-from-lib-checkpatch-fixes.patch
+remove-fastcall-from-linux-include.patch
+remove-fastcall-from-linux-include-checkpatch-fixes.patch
+asm-generic-remove-fastcall.patch
+misc-removal-of-final-callers-using-fastcall.patch

 Start removal of fastcall

+udf-remove-wrong-prototype-of-udf_readdir.patch
+udf-improve-readability-of-do_udf_readdir.patch
+udf-fix-coding-style-of-dirc.patch
+udf-fix-3-signedness-1-unitialized-variable-warnings.patch
+udf-fix-signedness-issue.patch

 UDF fixlets

+constify-tables-in-kernel-sysctl_checkc.patch
+constify-tables-in-kernel-sysctl_checkc-fix.patch

 Cleanups

+aoe-bring-driver-version-number-to-47.patch
+aoe-handle-multiple-network-paths-to-aoe-device.patch
+aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
+aoe-clean-up-udev-configuration-example.patch
+aoe-eliminate-goto-and-improve-readability.patch
+aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
+aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
+aoe-only-install-new-aoe-device-once.patch
+aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
+aoe-the-aoeminor-doesnt-need-a-long-format.patch
+aoe-make-error-messages-more-specific.patch
+aoe-update-copyright-date.patch
+aoe-statically-initialise-devlist_lock.patch

 AOE driver update

+use-pgoff_t-instead-of-unsigned-long.patch

 MM cleanup

+ipc-convert-handmade-min-to-min.patch

 IPC cleanup

+reiser4-replace-uid==0-check-with-capability.patch

 reiser4 fix



6223 commits in 1825 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/patch-list


