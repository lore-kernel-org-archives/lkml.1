Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbXA2IMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbXA2IMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXA2IMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:12:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186AbXA2IML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:12:11 -0500
Date: Mon, 29 Jan 2007 00:12:07 -0800
From: Andrew Morton <akpm@osdl.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-rc6-mm2
Message-Id: <20070129001207.71ea3470.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm2/

Will appear later at

	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm2/



- Dropped git-block due to CFQ breakage

- Dropped the fsaio patches due to their dependence on git-block.

- Added the new hrtimers/dynticks patches.  This is an update of the
  2.6.20-rc4-mm1 patches, now apparently fixed.



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




Changes since 2.6.20-rc6-mm1:


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
 git-ioat.patch
 git-ocfs2.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-qla3xxx.patch
 git-unionfs.patch
 git-watchdog.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees

+use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
+netfilter-is-subscribers-only.patch
+fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
+m68k-uaccessh-needs-schedh.patch
+fs-lockd-clntlockc-add-missing-newlines-to-dprintks.patch
+knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch
+use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch

 2.6.20 queue.

+x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch

 Fix x86-fix-vdso-mapping-for-aout-executables.patch some more.

+sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x.patch

 ALSA fix

+drivers-media-video-convert-to-generic-boolean-values.patch

 DVB fix

+fix-gfs2-circular-dependency.patch

 GFS2 Kconfig fix

-ehca-avoid-crash-on-kthread_create-failure.patch

 Dropped

+sata_nv-use-adma-for-nodata-commands.patch
+fix-config_sata_sis=y-compile-error.patch

 SATA fixes

+hp100-convert-pci_module_init-to-pci_register_driver.patch

 netdev cleanup

+netfilter-warning-fix.patch
+nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch

 net fixes

+use-__u64-rather-than-u64-in-parisc-statfs-structs.patch

 Fix userspace api

-git-block.patch
-git-block-fixup.patch
-git-block-borkage.patch
-git-block-atomicity-fix.patch

 Droped.

+fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch

 USB fix

+pl2303-willcom-ws002in-support.patch
+use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch

 USB fixes

+remove-final-vestiges-of-config_unwind_info.patch

 x86 cleanup

+m68k-work-around-binutils-tokenizer-change.patch

 m68k fix

+ext-jbd-layer-function-called-instead-of-fs-specific-one.patch

 ext3/4-vs-JBD cleanup

+add-irq-flag-to-disable-balancing-for-an-interrupt.patch
+add-a-functions-to-handle-interrupt-affinity-setting.patch
+add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
+hz-free-ntp.patch
+fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
+fix-timeout-overflow-with-jiffies.patch
+gtod-persistent-clock-support.patch
+i386-use-gtod-persistent-clock-support.patch
+i386-remove-useless-code-in-tscc.patch
+simplify-the-registration-of-clocksources.patch
+x86-rewrite-smp-tsc-sync-code.patch
+clocksource-replace-is_continuous-by-a-flag-field.patch
+clocksource-replace-is_continuous-by-a-flag-field-fix.patch
+clocksource-fixup-is_continous-changes-on-arm.patch
+clocksource-fixup-is_continous-changes-on-avr32.patch
+clocksource-fixup-is_continous-changes-on-s390.patch
+clocksource-fixup-is_continous-changes-on-mips.patch
+clocksource-remove-the-update-callback.patch
+clocksource-add-verification-watchdog-helper.patch
+mark-tsc-on-geodelx-reliable.patch
+uninline-irq_enter.patch
+fix-cascade-lookup-of-next_timer_interrupt.patch
+extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
+hrtimers-namespace-and-enum-cleanup.patch
+hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
+hrtimers-cleanup-locking.patch
+hrtimers-add-state-tracking.patch
+hrtimers-clean-up-callback-tracking.patch
+hrtimers-move-and-add-documentation.patch
+acpi-fix-missing-include-for-up.patch
+acpi-keep-track-of-timer-broadcasting.patch
+allow-early-access-to-the-power-management-timer.patch
+i386-apic-clean-up-the-apic-code.patch
+clockevents-add-core-functionality.patch
+tick-management-core-functionality.patch
+tick-management-broadcast-functionality.patch
+tick-management-dyntick--highres-functionality.patch
+clockevents-i383-drivers.patch
+i386-rework-local-apic-timer-calibration.patch
+i386-prepare-for-dyntick.patch
+i386-prepare-nmi-watchdog-for-dynticks.patch
+i386-enable-dynticks-in-kconfig.patch
+hrtimers-add-high-resolution-timer-support.patch
+hrtimers-prevent-possible-itimer-dos.patch
+add-debugging-feature-proc-timer_stat.patch
+add-debugging-feature-proc-timer_list.patch
+add-sysrq-q-to-print-timer_list-debug-info.patch

 New hrtimers/dynticks patches

+generic-vsyscall-gtod-support-for-generic_time.patch
+generic-vsyscall-gtod-support-for-generic_time-tidy.patch
+time-x86_64-hpet_address-cleanup.patch
+revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
+time-x86_64-split-x86_64-kernel-timec-up.patch
+time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
+time-x86_64-split-x86_64-kernel-timec-up-fix.patch
+reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
+time-x86_64-convert-x86_64-to-use-generic_time.patch
+time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
+time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
+time-x86_64-hpet-fixup-clocksource-changes.patch
+time-x86_64-tsc-fixup-clocksource-changes.patch
+time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
+time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch

 Bring these back.

-kblockd-use-flush_work.patch

 temporarily dropped due to git-block droppage.

+isdn-rename-some-debugging-macros-to-not-resemble-config.patch
+isdn-rename-debug-option-config_serial_nopause_io.patch
+isdn-remove-defunct-test-emulator.patch
+isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
+drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
+drivers-isdn-hisax-convert-to-generic-boolean-values.patch

 ISDN cleanups

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

 temporarily dropped due to git-block droppage.

-sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-hack.patch

 Dropped

+sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch

 Fix sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch



All 1449 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm2/patch-list


