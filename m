Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXA3Epd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXA3Epd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXA3Epd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:45:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbXA3Epb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:45:31 -0500
Date: Mon, 29 Jan 2007 20:45:28 -0800
From: Andrew Morton <akpm@osdl.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-rc6-mm3
Message-Id: <20070129204528.eb8d695e.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/

Will appear later at

	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/


- Restored git-block.patch: mainly the block unplugging rework.  The
  problematic CFQ updates have been taken out.

- Restored the fsaio patches as a consequence.

- A huge ACPI update.

- A decent number of x86 patches have been temporarily dropped due to their
  clash against the ACPI update.

- A few problems reported against 2.6.20-rc6-mm2 have been fixed.




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

- Semi-daily snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.


Changes since 2.6.20-rc6-mm2:

 origin.patch
 git-acpi.patch
 git-ibm-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-libata-all.patch
 git-lxdialog.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-net.patch
 git-ioat.patch
 git-ocfs2.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-block.patch
 git-qla3xxx.patch
 git-unionfs.patch
 git-watchdog.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees

-bonding-arp-monitoring-broken-on-x86_64.patch
-powerpc-fix-sys_pciconfig_iobase-bus-matching.patch
-netfilter-is-subscribers-only.patch
-remove-useless-reference-to-obsolete-kerneld.patch
-sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x.patch
-fix-gfs2-circular-dependency.patch
-git-ieee1494-build-fix.patch
-git-netdev-all-fixup.patch
-pnpacpi-remove-experimental-dependency.patch
-cdevh-forward-declarations.patch

 Merged into mainline or a subsystem tree.

+fuse-fix-bug-in-control-filesystem-mount.patch
+cdevh-forward-declarations.patch
+fix-via-irq-quirk-breakage.patch
+i386-in-assign_irq_vector-look-at-all-vectors-before-giving-up.patch
+translate-dashes-in-filenames-for-headers-install.patch
+remove-warning-vfs-is-out-of-sync-with-lock-manager.patch
+scsi_ioctl-sg_io-timeout-conversion-fix.patch
+fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d.patch

 2.6.20 queue.

+enable-mouse-button-23-emulation-for-x86-macs.patch

 Might be 2.6.20.

-x86-fix-vdso-mapping-for-aout-executables-fixes.patch
-x86-fix-vdso-mapping-for-aout-executables-fixes-2.patch
-x86-fix-vdso-mapping-for-aout-executables-cleanups.patch
-x86-fix-vdso-mapping-for-aout-executables-doh.patch
-x86-fix-vdso-mapping-for-aout-executables-sh-fix.patch
-x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch

 Folded into x86-fix-vdso-mapping-for-aout-executables.patch

+acpi-updates-rtc-cmos-device-platform_data-vs-git-acpi.patch

 Update acpi-updates-rtc-cmos-device-platform_data.patch for git-acpi.

+drivers-acpi-hotkeyc-make-2-structs-static.patch

 ACPI cleanup

+powerpc-rtas-msi-support.patch

 powerpc MSI support

+spider-fix-gregkh-driver-network-device.patch

 Fix gregkh patch

+drivers-media-video-cafe_ccicc-fix-warning.patch
+cx88-videoc-remove-struct-radionorms.patch
+if-0-v4l_printk_ioctl_arg.patch

 DVB things

+tsl2550-support-i2c-device-driver.patch

 I2C driver

+config_input_debug-improvements.patch

 input Kconfig tweaks

+make-help-in-build-tree-doesnt-show-headers_-targets.patch
+kbuild-remove-references-to-deprecated-prepare-all-target.patch
+new-toplevel-target-headers_check_all.patch

 kbuild things

+libata-fix-translation-for-start-stop-unit.patch

 libata fix

+ehea-fixed-wrong-jumbo-frames-status-query.patch
+ehea-fixed-missing-tasklet_kill-call.patch
+sky2-fix-msi-related-resume-breakage.patch

 netdev fixes

+bonding-arp-monitoring-broken-on-x86_64.patch

 net fix

+fix-i-oat-for-kexec.patch

 Fix IOAT driver.

+git-block-fixup.patch
+git-block-borkage.patch
+git-block-atomicity-fix.patch

 Restore git-block fixes

+drivers-char-pcmcia-ipwireless_cs_-possible-cleanups.patch

 Fix git-ipwireless_cs.patch

-x86_64-mm-amd-tsc-sync.patch
-x86_64-mm-always-use-physical-delivery-mode-on-8-cpus.patch
-x86_64-mm-remove-es7000-workaround.patch
-x86_64-mm-remove-clustered-apic-mode.patch
-x86_64-mm-default-to-physical-mode-on-hotplug-cpu-kernels.patch
-x86_64-mm-share-whats-shareable.patch
-x86_64-mm-only-call-unreachable_devices-when-type-1-is-available.patch
-x86_64-mm-only-map-whats-necessary.patch
-x86_64-mm-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
-x86_64-mm-reserve-resources-but-only-when-were-sure-about-them.patch
-x86_64-mm-fix-x86_64-ioremap-base_address.patch
-x86_64-mm-reject-a-broken-mcfg-tables-on-asus-etc.patch
-x86_64-mm-readd-fadt-physflat.patch

 Temporarily dropped due to clashes with new git-acpi tree.

-mmconfig-cleanup.patch
-mmconfig-fix-unreachable_devices.patch
-i386-modpost-apic-related-warning-fixes.patch

 Ditto.

-remove-final-vestiges-of-config_unwind_info.patch

 Dropped

+i386-probe_roms-cleanup.patch
+x86_64-sync-up-probe_roms-with-i386.patch
+i386-add-option-to-show-more-code-in-oops-reports.patch
+use-__u32-in-asm-x86_64-msrh.patch
+cleanup-x86_64-mm-vmi-timer.patch

 x86 updates.

+page_mkwrite-race-fix.patch

 VM fix

+sn2-use-static-proc_fops.patch

 ia64 cleanup

+replace-highest_possible_node_id-with-nr_node_ids-fix.patch
+convert-highest_possible_processor_id-to-nr_cpu_ids.patch

 Fix patches in -mm.

-mm-search_binary_handler-mem-limit-fix.patch

 Dropped.

+highmem-catch-illegal-nesting.patch
+change-constant-zero-to-notify_done-in-ratelimit_handler.patch

 Misc updates.

+tick-management-dyntick--highres-functionality-fix.patch
+tick-management-dyntick--highres-functionality-fix-2.patch

 Fix tick-management-dyntick--highres-functionality.patch

+kblockd-use-flush_work.patch

 Restore this due to git-block restoration.

+ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch

 Fix ecryptfs-generalize-metadata-read-write.patch

+fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
+fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
+fsaio-rename-__lock_page-to-lock_page_blocking.patch
+fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
+fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
+fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
+fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
+fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
+fsaio-enable-asynchronous-wait-page-and-lock-page.patch
+fsaio-filesystem-aio-read.patch
+fsaio-aio-o_sync-filesystem-write.patch

 Restore these due to git-block restoration.

+rcu-debug-trace-for-rcu-fix.patch
+rcu-debug-trace-for-rcu-fix-2.patch

 Fix rcu-debug-trace-for-rcu.patch

+ufs2-write-mount-as-rw.patch
+ufs2-write-inodes-write.patch
+ufs2-write-block-allocation-update.patch

 UFS2 write support.

+readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
+readahead-state-based-method-prevent-tiny-size.patch
+readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
+readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
+readahead-thrashing-recovery-method-fix.patch
+readahead-call-scheme-fix-thrashed-unaligned-read.patch
+readahead-laptop-mode-fix.patch

 Update readahead patches in -mm.

+sysctl-move-utsname-sysctls-to-their-own-file-fix.patch

 Fix sysctl-move-utsname-sysctls-to-their-own-file.patch



All 1487 patches:


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/patch-list


