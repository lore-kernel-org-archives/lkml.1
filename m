Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbXEPDUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbXEPDUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXEPDUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:20:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759AbXEPDUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:20:20 -0400
Date: Tue, 15 May 2007 20:19:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc1-mm1
Message-Id: <20070515201914.16944e04.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/


- I found some time to look into some writeback problems in
  fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
  but more work (mainly testing) needs to be done.

  There's some new debug code in there which could be very expensive if
  there are a lot of dirty inodes in the machine (quadratic behaviour).  If
  the machine seems to be affected by this, the debugging may be disabled with

	echo 0 > /proc/sys/fs/inode_debug

- Added an i386 early-startup development tree, as git-newsetup.patch ("H. 
  Peter Anvin" <hpa@zytor.com>)

- Brought back git-sas.patch (Darrick J.  Wong <djwong@us.ibm.com>).  It got
  lost quite some time ago.



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



Changes since 2.6.21-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm-master.patch
 git-avr32.patch
 git-cpufreq.patch
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
 git-mips.patch
 git-mmc.patch
 git-ubi.patch
 git-battery.patch
 git-ioat.patch
 git-nfs.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-sh64.patch
 git-scsi-target.patch
 git-block.patch
 git-sas.patch
 git-unionfs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-newsetup-fixup.patch
 git-xfs.patch
 git-xtensa.patch
 git-gccbug.patch

 git trees

-fix-unnecesary-meminit.patch
-smaps-only-define-clear_refs-for-config_mmu.patch
-frv-miscellaneous-fixes.patch
-m68k-asm-scatterlisth-needs-linux-typesh.patch
-usb_gigaset-dont-kmalloc0.patch
-revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
-declare-compat_sys_utimensat.patch
-krealloc-fix-kerneldoc-comments.patch
-fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
-frv-replace-pgd-management-via-slabs-through-quicklists.patch
-disable-slub-on-powerpc.patch
-dm-raid1-one-kmirrord-per-mirror.patch
-dm-crypt-disable-barriers.patch
-dm-crypt-fix-call-to-clone_init.patch
-dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
-dm-crypt-fix-remove-first_clone.patch
-dm-crypt-use-smaller-bvecs-in-clones.patch
-dm-crypt-add-null-iv.patch
-dm-mpath-log-device-name.patch
-dm-allow-offline-devices.patch
-dm-log-fault-detection.patch
-dm-log-report-fault-status.patch
-dm-raid1-add-handle_errors-feature-flag.patch
-dm-io-delay-dec_count.patch
-dm-io-prepare-for-new-interface.patch
-dm-io-new-interface.patch
-dm-kcopyd-update-dm-io-interface.patch
-dm-exception-store-update-dm-io-interface.patch
-dm-log-update-dm-io-interface.patch
-dm-raid1-update-dm-io-interface.patch
-dm-io-remove-old-interface.patch
-dm-bio-list-helpers.patch
-dm-delay-target.patch
-dm-raid1-fix-to-commit-pending-clear-region-requests.patch
-dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
-dm-log-fix-resume-failed-log-device.patch
-iop13xx-msi-support-rev6.patch
-s390-fix-subsystem-removal-fallout.patch
-power-management-remove-some-useless-code-from-arm.patch
-scx200-use-mutex-instead-of-semaphore.patch
-drivers-hwmon-switch-to-using-input_dev-devparent.patch
-git-ia64-sa_interrupt-is-deprecated.patch
-sn-validate-smp_affinity-mask-on-intr-redirect.patch
-sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
-sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
-sbp2-include-fixes.patch
-ieee1394-iso-needs-schedh.patch
-libata-clean-up-sff-init-mess.patch
-pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
-fix-pata_qdic-probe-code.patch
-pata_scc-fix-compilation.patch
-ide-ide-fix-dma-masks-v3.patch
-ide-ide-max-dma-mode-v3.patch
-ide-ide-tune-dma-helper.patch
-ide-ide-proc-fs.patch
-ide-ide-split-off-ioctls-from-settings-v2.patch
-ide-ide-move-settings-to-ide-proc.patch
-ide-ide-register-hw-initializing-arg.patch
-ide-ide-proc-register-port.patch
-ide-ide-pci-pcibus-order.patch
-ide-ide-fix-pio-setup-on-resume-for-atapi.patch
-forcedeth-improve-napi-logic.patch
-ibmtr_cs-fix-hang-on-eject.patch
-2621-rc5-mm3-fix-e1000-compilation.patch
-link_watch-eliminate-potential-delay-on-wrap-around.patch
-link_watch-always-schedule-urgent-events.patch
-sunrpc-fix-crash-in-rpc_malloc.patch
-git-battery-fix.patch
-nfs-kill-the-obsolete-nfs_paranoia.patch
-nfs-use-__set_current_state.patch
-round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
-use-unchecked_isa_dma-in-sd_revalidate_disk.patch
-remove-the-broken-scsi_acornscsi_3-driver.patch
-fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
-unionfs-fix-slab-abuses-with-krealloc.patch
-maintainers-add-cxacru-website-mailing-list.patch
-use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
-i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
-fault-injection-disable-stacktrace-filter-for-x86-64.patch
-i386-add-support-for-picopower-irq-router-fix.patch
-x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
-xfs-fix-unmount-race.patch
-crypto-fix.patch
-fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch
-quicklist-support-for-ia64.patch
-swsusp-clean-up-print.patch
-pm-separate-hibernation-code-from-suspend-code.patch
-swsusp-use-reasonable-default-for-hibernation_mode.patch
-uml-fix-build-breakage.patch
-uml-turn-on-scsi-support.patch
-uml-mark-a-tt-only-function.patch
-fix-linuxdoc-comment.patch
-uml-turn-build-warnings-into-comments.patch
-getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
-display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
-remove-hardcoding-of-hard_smp_processor_id-on-up.patch
-use-the-apic-to-determine-the-hardware-processor-id-i386.patch
-use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
-upper-32-bits.patch
-mca-fix-bus-matching.patch
-mca-add-integrated-device-bus-matching.patch
-cm4000_cs-fix-error-paths.patch
-cm4000_cs-use-bitrev.patch
-use-simple_read_from_buffer-in-fs.patch
-use-simple_read_from_buffer-in-kernel.patch
-pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch
-lib-hexdump.patch
-lib-hexdump-fix.patch
-lib-hexdump-update-on-feedback.patch
-pasemi-hardware-rng-driver.patch
-pasemi-hardware-rng-driver-tidy.patch
-nbd-check-the-return-value-of-sysfs_create_file.patch
-nbd-check-the-return-value-of-sysfs_create_file-fix.patch
-move-sig_kernel_-et-al-macros-to-linux-signalh.patch
-tty_set_ldisc-receive_room-fix.patch
-mutex_lock_interruptible-add-__must_check.patch
-mutex_lock_interruptible-add-__must_check-must-fix.patch
-clocksource-spelling-error-in-watchdog-code.patch
-fs-fix-indentation-in-do_path_lookup.patch
-fs-use-path_walk-in-do_path_lookup.patch
-doc-what-a-patch-series-is.patch
-kernel-doc-small-kernel-doc-optimization.patch
-tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch
-fix-printk-format-warnings-in-timer_listc.patch
-tty-add-compat_ioctl.patch
-tty-add-compat_ioctl-fix.patch
-blacklist-dell-optiplex-320-from-using-the-hpet.patch
-blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
-consolidate-generic_writepages-and-mpage_writepages.patch
-use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
-mpc52xx-psc-spi-master-driver.patch
-schedule_on_each_cpu-use-preempt_disable.patch
-reimplement-flush_workqueue.patch
-implement-flush_work.patch
-flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
-flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
-kblockd-use-flush_work.patch
-tg3-use-flush_keventd_work.patch
-e1000-use-flush_keventd_work.patch
-libata-use-flush_work.patch
-phy-use-flush_work.patch
-relay-use-plain-timer-instead-of-delayed-work.patch
-extend-notifier_call_chain-to-count-nr_calls-made.patch
-define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
-eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
-call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
-call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
-slab-use-cpu_lock_.patch
-workqueue-fix-freezeable-workqueues-implementation.patch
-workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
-workqueue-dont-clear-cwq-thread-until-it-exits.patch
-workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
-workqueue-kill-run_scheduled_work.patch
-workqueue-dont-save-interrupts-in-run_workqueue.patch
-workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
-workqueue-introduce-cpu_singlethread_map.patch
-workqueue-introduce-workqueue_struct-singlethread.patch
-workqueue-make-init_workqueues-__init.patch
-workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
-make-queue_delayed_work-friendly-to-flush_fork.patch
-unify-queue_delayed_work-and-queue_delayed_work_on.patch
-workqueue-introduce-wq_per_cpu-helper.patch
-make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
-ipvs-flush-defense_work-before-module-unload.patch
-workqueue-kill-noautorel-works.patch
-worker_thread-dont-play-with-signals.patch
-worker_thread-fix-racy-try_to_freeze-usage.patch
-zap_other_threads-remove-unneeded-exit_signal-change.patch
-slab-shutdown-cache_reaper-when-cpu-goes-down.patch
-unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
-____call_usermodehelper-dont-flush_signals.patch
-freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
-freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
-freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
-freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
-freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
-kthread-dont-depend-on-work-queues-take-2.patch
-change-reparent_to_init-to-reparent_to_kthreadd.patch
-nlmclnt_recovery-dont-use-clone_sighand.patch
-usbatm_heavy_init-dont-use-clone_sighand.patch
-wait_for_helper-remove-unneeded-do_sigaction.patch
-worker_thread-dont-play-with-sigchld-and-numa-policy.patch
-change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
-fix-kthread_create-vs-freezer-theoretical-race.patch
-fix-pf_nofreeze-and-freezeable-race-2.patch
-freezer-document-task_lock-in-thaw_process.patch
-move-frozen_process-to-kernel-power-processc.patch
-remvoe-kthread_bind-call-from-_cpu_down.patch
-separate-freezer-from-pm-code-rev-2.patch
-introduce-freezer-flags-rev-2.patch
-make-cancel_rearming_delayed_work-reliable.patch
-make-cancel_rearming_delayed_work-reliable-spelling.patch
-make-cancel_rearming_delayed_work-reliable-fix.patch
-remove-obsolete-label-from-isdn4linux-v3.patch
-remove-nfs4_acl_add_ace.patch
-the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
-knfsd-rename-sk_defer_lock-to-sk_lock.patch
-nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
-rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
-rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
-sunrpc-fix-error-path-in-module_init.patch
-knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
-knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
-knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
-knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
-knfsd-simplify-a-while-condition-in-svcsockc.patch
-knfsd-trivial-makefile-cleanup.patch
-knfsd-various-nfsd-xdr-cleanups.patch
-knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch
-declare-struct-ktime.patch
-futex-priority-based-wakeup.patch
-make-futex_wait-use-an-hrtimer-for-timeout.patch
-futex_requeue_pi-optimization.patch
-futex-new-private-futexes.patch
-timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
-linux-kernel-markers-kconfig-menus.patch
-linux-kernel-markers-architecture-independant-code.patch
-linux-kernel-markers-powerpc-optimization.patch
-linux-kernel-markers-i386-optimization.patch
-markers-add-instrumentation-markers-menus-to-avr32.patch
-linux-kernel-markers-non-optimized-architectures.patch
-markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
-linux-kernel-markers-documentation.patch
-markers-define-the-linker-macro-extra_rwdata.patch
-markers-use-extra_rwdata-in-architectures.patch
-statically-initialize-struct-pid-for-swapper.patch
-explicitly-set-pgid-and-sid-of-init-process.patch
-use-struct-pid-parameter-in-copy_process.patch
-use-task_pgrp-task_session-in-copy_process.patch
-kill-unused-sesssion-and-group-values-in-rocket-driver.patch
-fix-some-coding-style-errors-in-autofs.patch
-replace-pid_t-in-autofs-with-struct-pid-reference.patch
-dont-init-pgrp-and-__session-in-init_signals.patch
-signal-timer-event-fds-v9-anonymous-inode-source.patch
-signal-timer-event-fds-v9-signalfd-core.patch
-signal-timer-event-signalfd-wire-up-x86-arches.patch
-signal-timer-event-fds-v9-signalfd-compat-code.patch
-signal-timer-event-fds-v9-timerfd-core.patch
-signal-timer-event-timerfd-wire-up-x86-arches.patch
-signal-timer-event-fds-v9-timerfd-compat-code.patch
-signal-timer-event-fds-v9-eventfd-core.patch
-signal-timer-event-eventfd-wire-up-x86-arches.patch
-signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
-epoll-use-anonymous-inodes.patch
-epoll-cleanups-epoll-no-module.patch
-epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch
-fs-convert-core-functions-to-zero_user_page.patch
-fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
-fs-convert-core-functions-to-zero_user_page-fix-2.patch
-ext3-use-zero_user_page.patch
-gfs2-use-zero_user_page.patch
-nfs-use-zero_user_page.patch
-ntfs-use-zero_user_page.patch
-ntfs-use-zero_user_page-fix.patch
-ocfs2-use-zero_user_page.patch
-reiserfs-use-zero_user_page.patch
-fs-deprecate-memclear_highpage_flush.patch
-microcode-use-suspend-related-cpu-hotplug-notifications.patch
-vmstat-use-our-own-timer-events.patch
-vmstat-use-our-own-timer-events-fix.patch
-make-vm-statistics-update-interval-configurable.patch
-make-vm-statistics-update-interval-configurable-fix.patch
-move-remote-node-draining-out-of-slab-allocators.patch
-clocksource-fix-resume-logic.patch
-wrap-access-to-thread_info.patch
-wrap-access-to-thread_info-fix.patch
-rename-thread_info-to-stack.patch
-rename-thread_info-to-stack-fix.patch
-rename-thread_info-to-stack-fix-2.patch
-compiler-introduce-__used-and-__maybe_unused.patch
-i386-pci-type-may-be-unused.patch
-sh-dma-use-__maybe_unused.patch
-frv-gdb-use-__maybe_unused.patch
-i386-voyager-use-__maybe_unused.patch
-mips-excite-use-__maybe_unused.patch
-mips-tlbex-use-__maybe_unused.patch
-i386-mmzone-use-__maybe_unused.patch
-vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
-vt8623fb-fix-compile-warnings.patch
-vt8623fb-fix-compile-error-if-config_mtrr=n.patch
-svgalib-move-fb_get_caps-to-svgalib.patch
-fbdev-add-support-for-avr32.patch
-frame-buffer-geforce-7300-gt.patch
-drivers-mdc-use-array_size-macro-when-appropriate.patch
-md-cleanup-use-seq_release_private-where-appropriate.patch
-md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch
-md-stop-using-csum_partial-for-checksum-calculation-in-md.patch
-md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
-md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch
-md-improve-partition-detection-in-md-array.patch
-md-dm-reduce-stack-usage-with-stacked-block-devices.patch
-timer_stats-slimmed-down-using-statistics-infrastucture.patch

 Merged into mainline or a subsystem tree

+spi-fix-spidev-for-sizeoflong-32-devices.patch
+parport_pc-needs-dma-mappingh.patch

 2.6.22 queue.

-ia64-race-flushing-icache-in-do_no_page-path.patch

 Dropped

+use-menuconfig-objects-ii-sound.patch

 alsa Kconfig update

+working-3d-dri-intel-agpko-resume-for-i815-chip-update.patch

 Update this DRI fix in -mm.

+fix-agk-dm-dm-io-fix-panic-on-large-request.patch

 Fix dud patch in the DM tree

+do-not-select-macintosh-drivers-by-default.patch
+powerpc-promc-remove-undef-printk.patch
+powerpc-fix-kconfig-select-warning-with-ucc_fast.patch
+8xx-mpc885ads-pcmcia-support.patch
+8xx-mpc885ads-pcmcia-support-fix.patch
+8xx-fix-whitespace-and-indentation.patch
+dts-kill-hardcoded-phandles.patch

 powerpc things

+gregkh-driver-driver-core-make-devt_attr-and-uevent_attr-static.patch

 Driver tree update

+saa7111-fix-picture-settings-cache-bug.patch
+saa7134-tvaudio-kthread-conversion.patch

 dvb things

+jdelvare-i2c-i2c-rpx-will-be-removed.patch
+jdelvare-i2c-i2c-fix-sparse-warning-in-i2c-h.patch
+jdelvare-i2c-scx200_acb-use-mutex-instead-of-semaphore.patch
+jdelvare-i2c-i2c-delete-outdated-x1205-doc.patch
+jdelvare-i2c-i2c-deprecate-rtc-drivers.patch
+jdelvare-i2c-i2c-s3c2410-fix-build-warning.patch
+jdelvare-i2c-i2c-kerneldoc.patch
+jdelvare-i2c-i2c_smbus_read_i2c_block_data-fixed-prototype.patch
+jdelvare-i2c-i2c-ds1628-new-driver.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-smsc47m192-use-mutex-instead-of-semaphore.patch
+jdelvare-hwmon-hwmon-lm90-spelling-fix-explicitly.patch
+jdelvare-hwmon-hwmon-coretemp-add-more-safety-checks.patch

 hwmon tree updates

-git-hid-fixup.patch

 Unneeded

+use-menuconfig-objects-ii-infiniband.patch
+pci-x-pci-express-read-control-interfaces-mthca.patch

 Infiniband things

+time-locale-in-gen_initramfs_listsh.patch
+powerpc64-symbols-start-with.patch

 kbuild updates

+use-menuconfig-objects-ii-kvm-virt.patch

 KVM Kconfig update

+git-leds-fixup.patch

 Fix rejects in git-leds.patch

+libata-check-for-an-support.patch
+genhd-expose-an-to-user-space.patch
+scsi-expose-an-to-user-space.patch
+libata-expose-an-to-user-space.patch
+genhd-send-async-notification-on-media-change.patch
+scsi-save-disk-in-scsi_device.patch
+libata-send-event-when-an-received.patch
+libata-fix-shutdown-warning-message-printing.patch
+fix-build-failure-for-drivers-ata-pata_sccc.patch
+drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver.patch
+drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch

 ata stuff

+libata-add-human-readable-error-value-decoding.patch
+libata-add-human-readable-error-value-decoding-v2.patch

 More ata stuff

+ide-pdc202xx_new-use-ide-tune-dma.patch
+ide-pdc202xx_old-rewrite-mode-programming-v2.patch
+ide-ide-tune-dma-2.patch
+ide-ide-dma-enable.patch
+ide-ide-remove-ide-use-dma.patch
+ide-ide-make-void-and-rename-ide_dma_lostirq-method.patch
+ide-ide-make-void-and-rename-ide_dma_timeout-method.patch
+ide-ide-use-mutex-instead-of-semaphore-in-ide-driver.patch
+ide-hpt366-simplify-ultradma-filtering-take2.patch

 IDE tree updates

+use-mutex-instead-of-semaphore-in-ide-driver.patch

 IDE tweak

+git-mips-fixup.patch

 Fix rejects in git-mips.patch

+use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
+use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
+use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch

 MTD cleanups

+git-ubi-fixup.patch

 Fix rejects in git-ubi.patch

-ppp_generic-fix-lockdep-warning.patch

 Dropped: dazed and confused

+use-menuconfig-objects-ii-netdev-general100mbit.patch
+pci-x-pci-express-read-control-interfaces-myrinet.patch
+pci-x-pci-express-read-control-interfaces-e1000.patch

 netdev things

-git-e1000.patch
-git-e1000-fixup-2.patch

 Temporarily dropped: the e1000 git tree got wrecked by other merges

+fix-race-condition-about-network-device-name-allocation.patch
+nf_conntrack-fix-use-after-free-in-helper-destroy-callback.patch

 net stuff

+git-battery-warning-fix.patch
+ds2760_battery-warning-fix.patch

 Fix git-battery

+bluetooth-postpone-hci_dev-unregistration.patch

 bluetooth maybe-fix.

+git-nfs-server-cluster-locking-api-fixup.patch

 Fix rejects in git-nfs-server-cluster-locking-api.patch

+ocfs2-fix-type-borkage.patch

 git-ocfs2 fix

+serial-use-resource_size_t-for-port-io-addresses.patch

 serial fix

+pci-quirks-disable-msi-on-rs400-200-and-rs480.patch

 MSI fix for PCI tree

+cpci_hotplug-convert-to-use-the-kthread-api.patch
+pci-x-pci-express-read-control-interfaces.patch
+pci-x-pci-express-read-control-interfaces-fix.patch

 PCI updates

+use-menuconfig-objects-ii-scsi.patch
+update-maintainer-email-id-for-megaraid-scsi-drivers.patch
+pci-x-pci-express-read-control-interfaces-qla2xxx.patch

 scsi updates

+use-menuconfig-objects-ib-block.patch
+use-menuconfig-objects-ii-block-devices.patch

 infiniband things

+gregkh-usb-usb-ehci-cpufreq-fix.patch

 USB tree update

+use-menuconfig-objects-ii-usb.patch
+usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch
+usb-dont-try-to-kzalloc-0-bytes.patch

 USB updates

+watchdog-documentation.patch

 watchdog docs

-git-wireless-fixup.patch

 Unneeded

+x86_64-mm-defconfig-update.patch
+x86_64-mm-i386-defconfig-update.patch
+x86_64-mm-unwinder.patch
+x86_64-mm-sched-clock-share.patch
+x86_64-mm-sched-clock64.patch
+x86_64-mm-paravirt-add-a-sched_clock-paravirt_op.patch
+x86_64-mm-build-tar-files.patch
+x86_64-mm-irq-migrate-report.patch
+x86_64-mm-define-and-use-local_distance-and-remote_distance.patch
+x86_64-mm-various-cleanups.patch

 x86 tree updates

-i386-irq-kill-irq-compression.patch

 Dropped

+x86_64-extract-helper-function-from-e820_register_active_regions.patch
+x86_64-fix-e820_hole_size-based-on-address-ranges.patch
+x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
+x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
+x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
+i386-hpet-check-if-the-counter-works.patch
+x86-use-elfnoteh-to-generate-vsyscall-notes.patch
+x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
+mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
+mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
+mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
+i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
+x86_64-fix-smp_call_function_single-return-value.patch
+x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
+x86_64-o_excl-on-dev-mcelog.patch
+x86_64-support-poll-on-dev-mcelog.patch
+i386-fix-machine-rebooting.patch
+i386-fix-machine-rebooting-fix.patch

 x86 updates

+slob-implement-rcu-freeing.patch
+i386-x86-64-fix-section-mismatch.patch
+slab-allocators-drop-support-for-destructors.patch
+remove-slab_ctor_constructor.patch
+remove-slab_ctor_constructor-fix.patch
+make-__vunmap-static.patch
+simplify-compat_sys_timerfd.patch
+let-smp_call_function_single-return-ebusy-on-up.patch
+let-smp_call_function_single-return-ebusy-on-up-fix.patch
+refine-screen_info-sanity-check-for-vgacon-initialization.patch
+make-freezeable-workqueues-singlethread.patch
+slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
+rtc-ds1307-cleanups.patch
+parport-mailing-list-is-subscribers-only.patch
+docbook-make-kernel-locking-table-readable.patch
+gpio-interface-loosens-call-restrictions.patch
+rtc-omap-build-fix.patch
+rtc-kconfig-clarification.patch
+icom-add-new-sub-device-id-to-support-new-adapter.patch
+make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size.patch
+slab-warn-on-zero-length-allocations.patch
+i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
+use-menuconfig-objects-ii-md.patch
+use-mutex-instead-of-semaphore-in-capi-20-driver.patch
+circular-locking-dependency-found-in-quota-off.patch
+swsusp-fix-sysfs-interface.patch
+compat_core_sys_select-avoid-kmalloc0.patch
+change-zonelist-order-zonelist-order-selection-logic.patch
+change-zonelist-order-v6-zonelist-fix.patch
+change-zonelist-order-v6-zonelist-fix-2.patch
+change-zonelist-order-auto-configuration.patch
+change-zonelist-order-documentaion.patch

 More of the 2.6.22 queue

+mm-more-rmap-checking-tidy.patch

 Clean up mm-more-rmap-checking.patch

+group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
+group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch

 Fix group-short-lived-and-reclaimable-kernel-allocations.patch

+dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch

 Fix dont-group-high-order-atomic-allocations.patch

+remove-alloc_zeroed_user_highpage.patch

 Remove dead code

-create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch

 Folded into create-the-zone_movable-zone.patch

+have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
+have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
+only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch

 Memory reclaim work

+fs-introduce-some-page-buffer-invariants.patch

 VFS debugging

+freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
+freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
+freezer-fix-pf_nofreeze-vs-freezeable-race.patch
+freezer-move-frozen_process-to-kernel-power-processc.patch

 Freezer fixes

-file-capabilities-accomodate-future-64-bit-caps.patch

 Folded into implement-file-posix-capabilities.patch

+implement-file-posix-capabilities-update.patch

 Update the file capabilities code in -mm.

-update-mtd-use-of-symbol_getput.patch
-update-dvb-use-of-symbol_getput.patch

 Dropped

+fix-rmmod-read-write-races-in-proc-entries-cleanup.patch

 Fix patch in -mm.

+introduce-write_trylock_irqsave.patch
+use-write_trylock_irqsave-in-ptrace_attach.patch
+use-write_trylock_irqsave-in-ptrace_attach-fix.patch
+use-menuconfig-objects-ii-auxdisplay.patch
+use-menuconfig-objects-ii-edac.patch
+use-menuconfig-objects-ii-ipmi.patch
+use-menuconfig-objects-ii-misc-strange-dev.patch
+use-menuconfig-objects-ii-module-menu.patch
+use-menuconfig-objects-ii-oprofile.patch
+use-menuconfig-objects-ii-telephony.patch
+use-menuconfig-objects-ii-tpm.patch
+fix-jvc-cdrom-drive-lockup.patch
+use-no_pci_devices-in-pci-searchc.patch
+introduce-boot-based-time.patch
+introduce-boot-based-time-fix.patch
+use-boot-based-time-for-process-start-time-and-boot-time.patch
+use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
+use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
+use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
+use-boot-based-time-for-uptime-in-proc.patch
+volatile-considered-harmful-take-3.patch
+udf-check-for-allocated-memory-for-data-of-new-inodes.patch
+split-usermodehelper-setup-from-execution.patch
+tidy-up-usermode-helper-waiting-a-bit.patch
+tidy-up-usermode-helper-waiting-a-bit-fix.patch
+prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
+udf-check-for-allocated-memory-for-inode-data-v2.patch
+fix-stop_machine_run-problem-with-naughty-real-time-process.patch
+cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
+cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
+use-mutexes-instead-of-semaphores-in-i2o-driver.patch

 Misc updates

+check_dirty_inode_list.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
+writeback-fix-comment-use-helper-function.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
+writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch

 Fix fs/fs-writeback.c

+ibmasm-whitespace-cleanup.patch
+ibmasm-dont-use-extern-in-function-declarations.patch
+ibmasm-miscellaneous-fixes.patch
+ibmasm-must-depend-on-config_input.patch

 ibmasm update

+crc7-support.patch
+crc7-support-fix.patch

 add crc7 library code

+use-menuconfig-objects-ii-isdn.patch

 i4l Kconfig update

+i2o_cfg_passthru-cleanup.patch
+i2o_cfg_passthru-cleanup-fix.patch
+i2o-message-leak-in-i2o_msg_post_wait_mem.patch
+i2o-proc-reading-oops.patch
+i2o-debug-output-cleanup.patch

 i2o fixes

+knfsd-exportfs-add-exportfsh-header.patch
+knfsd-exportfs-add-exportfsh-header-fix.patch
+knfsd-exportfs-remove-iget-abuse.patch
+knfsd-exportfs-remove-iget-abuse-fix.patch
+knfsd-exportfs-add-procedural-interface-for-nfsd.patch
+knfsd-exportfs-remove-call-macro.patch
+knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
+knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
+knfsd-exportfs-add-find_disconnected_root-helper.patch
+knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch

 knfsd updates

+couple-fixes-to-fs-ecryptfs-inodec.patch

 ecryptfs fixes

+mm-swap-prefetch-improvements.patch
+mm-swap-prefetch-more-improvements.patch

 Update swap prefetch patches in -mm.

-revoke-core-code-misc-fixes.patch
-revoke-core-code-fix-shared-mapping-revoke.patch
-revoke-core-code-move-magic.patch
-revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
-revoke-core-code-revoke-no-revoke-for-nommu.patch
-revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
-revoke-core-code-break-cow-for-private-mappings.patch
-revoke-core-code-generic_file_revoke-stub-for-nommu.patch
-revoke-core-code-break-cow-fixes.patch
-revoke-core-code-mapping-revocation.patch
-revoke-core-code-only-fput-unused-files.patch
-revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
-revoke-core-code-rename-to-can_revoke_filevma.patch
-revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
-revoke-core-code-do_revoke-error-handling.patch

 Folded into revoke-core-code.patch

-lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
-lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
-lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
-lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
-lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
+lguest-the-guest-code-tidyups.patch
+lguest-the-guest-code-tidyups-update.patch
-lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
-lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
-lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
-lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
-lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
-lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
-lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
+lguest-the-host-code-tidyups.patch
+lguest-the-host-code-tidyups-update.patch
+lguest-the-host-code-borkages.patch
+lguest-the-makefile-and-kconfig-tidyups.patch
+lguest-the-console-driver-tidyups.patch
-lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
-lguest-the-net-driver-two-net-bugfixes.patch
+lguest-the-net-driver-tidyups.patch
+lguest-the-net-driver-tidyups-update.patch
+lguest-the-block-driver-tidyups.patch
+lguest-the-block-driver-tidyups-update.patch
-lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
-lguest-documentation-and-example-updates.patch
-lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
-lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
-lguest-two-net-bugfixes-doc.patch
-lguest-the-host-code-vs-futex-new-private-futexes.patch

 Various lguest foldings and addings

+oss-trident-massive-whitespace-removal.patch
+oss-trident-fix-locking-around-write_voice_regs.patch
+oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch

 Trident OSS driver updates

-reiser4-fix-for-drop-unused-semaphorespatch.patch
-reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
-reiser4-use-simple_prepare_write-to-zero-page-data.patch

 Folded into reiser4.patch

+reiser4-fix.patch

 Fix reiser4 for the knfsd patches

-integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch

 Folded into integrity-service-api-and-dummy-provider.patch

-slim-main-lsm-getprocattr-hook-api-change.patch

 Folded into slim-main-patch.patch

-integrity-new-hooks-fix.patch

 Folded into integrity-new-hooks.patch

-integrity-evm-as-an-integrity-service-provider-tidy.patch
-integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
-integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch

 Folded into integrity-evm-as-an-integrity-service-provider.patch

-integrity-ima-integrity_measure-support-tidy.patch
-integrity-ima-integrity_measure-support-fix.patch
-integrity-ima-integrity_measure-support-fix-2.patch
-integrity-ima-integrity_measure-support-ima-exit.patch
-integrity-ima-integrity_measure-support-remove-spinlock.patch

 Folded into integrity-ima-integrity_measure-support.patch

-integrity-tpm-internal-kernel-interface-tidy.patch

 Folded into integrity-tpm-internal-kernel-interface.patch

+workaround-for-a-pci-restoring-bug.patch
+prio_tree-debugging-patch.patch

 New -mm-only debug patches

+git-gccbug-fixup.patch

 Fix rejects in git-gccbug.patch




All 706 patches:


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/patch-list


