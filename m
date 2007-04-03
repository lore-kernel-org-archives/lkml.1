Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXDCFrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXDCFrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXDCFrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:47:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXDCFrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:47:49 -0400
Date: Mon, 2 Apr 2007 22:47:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc5-mm4
Message-Id: <20070402224745.71a25af7.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/

- The oops in git-net.patch has been fixed, so that tree has been restored. 
  It is huge.

- Added the device-mapper development tree to the -mm lineup (Alasdair
  Kergon).  It is a quilt tree, living at
  ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.

- Added davidel's signalfd stuff.



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




Changes since 2.6.21-rc5-mm3:


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
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-md-accel-fix.patch
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

-proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
-uml-fix-unreasonably-long-udelay.patch
-fix-firmware-sample-code.patch
-jdelvare-i2c-i2c-algo-bit-document-udelay.patch
-pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch
-gregkh-pci-pci-set-pci-bfsort-for-poweredge-r900.patch
-fix-gregkh-pci-pci-piggy-bus.patch
-drivers-scsi-dpt_i2oc-remove-dead-code.patch
-scsi-whitespace-cleanup-in-the-dpt-driver.patch
-drivers-scsi-aic7xxx-make-functions-static.patch
-remove-some-unused-scsi-related-kernel-config-variables.patch
-drivers-scsi-aacraid-cleanups.patch
-make-mptspi_target_destroy-static.patch
-qla2xxx-remove-duplicate-pci_disable_device-call.patch
-gregkh-usb-usb-gtcoc-fix-a-use-before-check.patch
-gregkh-usb-usb-ati_remote2-add-channel-support.patch
-usb-serial-whiteheat-convert-to-generic-boolean.patch
-x86_64-mm-dont-probe-for-ddc-on-vbe1_2.patch
-x86_64-mm-remove-hardcoding-of-hard_smp_processor_id-on-up-systems.patch
-drivers-mfd-sm501c-fix-an-off-by-one.patch

 Merged into mainline or a subsystem tree.

+md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch
+md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch
+revert-driver-core-do-not-wait-unnecessarily-in-driver_unregister.patch

 2.6.21 queue.

+vmi-paravirt-ops-bugfix-for-2621.patch

 Might be 2.6.21 queue.

+drivers-acpi-kconfig-formulation-fixpatch.patch

 ACPI fixlet

+pata_platform-for-arm-riscpc.patch

 ARM/pata fix

+cifs-use-mutexdiff.patch

 CIFS cleanup

+agk-dm-dm-merge-max_hw_sector.patch
+agk-dm-dm-raid1-one-kmirrord-per-mirror.patch
+agk-dm-dm-crypt-disable-barriers.patch
+agk-dm-dm-crypt-add-null-iv.patch
+agk-dm-dm-mpath-log-device-name.patch
+agk-dm-dm-allow-offline-devices.patch
+agk-dm-dm-log-fault-detection.patch
+agk-dm-dm-log-report-fault-status.patch
+agk-dm-dm-raid1-add-handle_errors-feature-flag.patch
+agk-dm-dm-io-delay-dec_count.patch
+agk-dm-dm-io-prepare-for-new-interface.patch
+agk-dm-dm-io-new-interface.patch
+agk-dm-dm-kcopyd-update-dm-io-interface.patch
+agk-dm-dm-exception-store-update-dm-io-interface.patch
+agk-dm-dm-log-update-dm-io-interface.patch
+agk-dm-dm-raid1-update-dm-io-interface.patch
+agk-dm-dm-io-remove-old-interface.patch

 Device mapper development tree.

+uevent-use-add_uevent_var-instead-of-open-coding-it.patch

 uevent cleanup

+jdelvare-i2c-i2c-algo-bit-50-50-duty-cycle-4.patch
+jdelvare-i2c-i2c-algo-bit-improve-debug-4.patch

 I2C tree updates

+hid-add-two-led-codes-to-hid-input-mapping.patch

 HID fixlet.

+convert-input-core-to-struct-device.patch
+add-locking-to-evdev.patch

 Input updates

-kbuild-override-build-timestamp.patch

 Dropped, I think.

+testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch

 Fix
 testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch

+git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch

 Fix git-mmc for the uevent changes in -mm.

+drivers-net-vioc-possible-cleanups.patch

 Netdev fixes

+2621-rc5-mm3-fix-e1000-compilation.patch

 Fix git-e1000.patch compilation.

+make-drivers-net-qla3xxxcphy_devices-static.patch
+forcedeth-improve-napi-logic.patch

 netdev fixes

+git-net-fixup.patch
+git-net-vs-git-netdev-all.patch

 Fix things due to git-net.patch.

+round_up-macro-cleanup-in-drivers-parisc.patch

 parisc cleanup

+gregkh-pci-pci-flush-msi-x-table-writes.patch
+gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch

 PCI tree updates

+fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch

 Remove now-dead code.

+pci-define-pci_request-release_regions-for-config_pci=n.patch
+round_up-macro-cleanup-in-drivers-pci.patch

 PCI updates

+gregkh-usb-usb-nikon-d80-unusual-device-patch.patch
+gregkh-usb-usb-cypress_cy7c63-race-disconnect-sysfs-read-write-leading-to-following-null-pointer.patch
+gregkh-usb-usb-fix-catc-error-handling.patch
+gregkh-usb-usb-fix-error-handling-in-kl5kusb.patch
+gregkh-usb-usb-fix-error-handling-for-mct_u232.patch
+gregkh-usb-usb-fix-omninet-write-vs-close-race.patch
+gregkh-usb-usb-whiteheat-convert-to-generic-boolean.patch
+gregkh-usb-usb-add-last_busy-field-for-use-in-autosuspend.patch

 USB tree updates

+git-wireless-debug-build-fixes.patch

 Fix git-wireless.patch

+git-wireless-vs-git-net.patch
+git-wireless-vs-git-net-2.patch

 Fix clashes between git-wireless and git-net.

+x86_64-mm-x86-64-eflags-header.patch

 x86_64 tree update

+fix-x86_64-mm-relocatable-kernel-support.patch

 Fix patch in x86_64 tree

+cxgb3-safeguard-tcam-size-usage.patch
+cxgb3-detect-nic-only-adapters.patch
+cxgb3-tighten-xgmac-workaround.patch
+cxgb3-firwmare-update.patch
+fix-hotplug-for-legacy-platform-drivers.patch
+update-documentation-driver-model-platformtxt.patch
+forcedeth-work-around-null-skb-dereference-crash.patch
+fix-scsi_send_eh_cmnd-scatterlist-handling.patch

 These are patches which I think should be in 2.6.21, but vie the relevant
 subsystem maintainers.

+slab-mark-set_up_list3s-__init.patch
+slab-mention-slab-name-when-listing-corrupt-objects.patch
+slub-core.patch
+slub-add-slabinfo-tool.patch

 Memory management updates

+blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
+blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch

 Blackfin updates

+uml-fix-umid-in-xterm-titles.patch
+uml-speed-up-exec.patch
+uml-no-locking-needed-in-tlsc.patch
+uml-tidy-processc.patch
+uml-remove-page_size.patch
+uml-kernel_thread-shouldnt-panic.patch

 UML updates

+provide-dummy-devm_ioport_-if-has_ioport.patch

 Needed for ARM pata support.

-add-an-anonymous-inode-source.patch
-add-an-anonymous-inode-source-tidy.patch
-epoll-use-anonymous.patch

 Dropped - new versions were merged.

+add-file-position-info-to-proc-fix.patch

 Fix add-file-position-info-to-proc.patch

+move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch

 Fix move-die-notifier-handling-to-common-code.patch some more.

+fix-82875-pci-setup.patch
+make-dev-port-conditional-on-config-symbol.patch
+clean-up-elf-note-generation.patch
+remove-artificial-software-max_loop-limit.patch
+kdump-kexec-calculate-note-size-at-compile-time.patch
+kdump-kexec-calculate-note-size-at-compile-time-update.patch
+fix-kevents-childs-priority-greediness.patch
+fix-kevents-childs-priority-greediness-fix.patch
+display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
+display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
+enhance-initcall_debug-measure-latency.patch
+kprobes-print-details-of-kretprobe-on-assertion-failure.patch
+reregister_binfmt-returns-with-ebusy.patch

 Misc

+sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch

 Staircase scheduler update

+rtc-cmos-wakeup-interface.patch
+acpi-wakeup-hooks-for-rtc-cmos.patch

 RTC stuff.

+sys_futex64-allows-64bit-futexes-workaround-for-uml.patch

 Fix sys_futex64-allows-64bit-futexes.patch some more.

+clocksource-arm-initialize-list-value.patch
+clocksource-parisc-initialize-list-value.patch
+clocksource-avr32-initialize-list-value.patch
+clocksource-mips-initialize-list-value.patch
+clocksource-i386-initialize-list-value.patch
+clocksource-x86_64-initialize-list-value.patch
+clocksource-s390-initialize-list-value.patch
+clocksource-driver-initialize-list-value.patch
+clocksource-refactor-duplicate-registration-checking.patch

 clocksource cleanup

+kprobes-use-hlist_for_each_entry.patch
+kprobes-codingstyle-cleanups.patch
+kprobes-kretprobes-simplifcations.patch

 kprobes cleanups

+utrace-uml-make-uml-compile-with-utrace-enabled.patch

 Fix utrace on UML

+signal-timer-event-fds-v9-anonymous-inode-source.patch
+signal-timer-event-fds-v9-signalfd-core.patch
+signal-timer-event-fds-v9-signalfd-core-fix.patch
+signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch
+signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch
+signal-timer-event-fds-v9-signalfd-compat-code.patch
+signal-timer-event-fds-v9-timerfd-core.patch
+signal-timer-event-fds-v9-timerfd-wire-up-i386-arch.patch
+signal-timer-event-fds-v9-timerfd-wire-up-x86_64-arch.patch
+signal-timer-event-fds-v9-timerfd-compat-code.patch
+signal-timer-event-fds-v9-eventfd-core.patch
+signal-timer-event-fds-v9-eventfd-core-fix.patch
+signal-timer-event-fds-v9-eventfd-wire-up-i386-arch.patch
+signal-timer-event-fds-v9-eventfd-wire-up-x86_64-arch.patch
+signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
+epoll-use-anonymous-inodes.patch

 New types of fds for delivering signals, timers and misc events.

+revoke-wire-up-i386-system-calls-x86_64-fix.patch

 Fix revoke for i386-on-x86_64

+nvidiafb-fix-reversed-ddc-port.patch
+vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
+vt-add-color-support-to-the-underline-and-italic-attributes.patch
+vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
+fbcon-dont-draw-cursor-when-its-disabled.patch
+vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch

 fbdev updates

-mm-only-hrtimers-debug-patch.patch
-mm-only-hrtimers-debug-patch-fix.patch

 This broke.



All 1254 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/patch-list


