Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYBDBQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYBDBQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYBDBQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:16:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbYBDBQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:16:25 -0500
Date: Sun, 3 Feb 2008 17:16:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-mm1
Message-Id: <20080203171634.58ab668b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/


- The x86 git tree has been dropped due to runtime failure on one of my test
  machines

- The kgdb tree remains dropped due to git-x86 clashes

- The git-newsetup tree remains dropped due to git-x86 clashes

- The git-perfmon tree remains dropped due to git-x86 clashes

- Andi's x86 quilt tree remains dropped due to git-x86 clashes

- The ext4 tree is dropped because it contains work which clashes with
  pending 2.6.25 material


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



Changes since 2.6.24-rc8-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cpufreq.patch
 git-drm.patch
 git-drm-fix.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hrt.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mmc.patch
 git-mtd.patch
 git-net.patch
 git-backlight.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-misc-gdth-fix.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-watchdog-fixup.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-xfs.patch
 git-xtensa.patch

 git trees

-cpufreq-initialise-default-governor-before-use.patch
-hfs-fix-coverity-found-null-deref.patch
-address-hfs-on-disk-corruption-robustness-review-comments.patch
-address-hfs-on-disk-corruption-robustness-review-comments-checkpatch-fixes.patch
-pnpacpi-print-resource-shortage-message-only-once-more.patch
-cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
-mm-fix-section-mismatch-warning-in-page_allocc.patch
-jbd-do-not-try-lock_acquire-after-handle-made-invalid.patch
-alpha-fix-conversion-from-denormal-float-to-double.patch
-ifdef-very-expensive-debug-check-in-page-fault-path.patch
-fix-radeonfb-regression-with-xpress-200m-5955.patch
-revert-local_t-documentation-update.patch
-fix-unbalanced-helper_lock-in-kernel-kmodc.patch
-acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch
-acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
-agk-dm-dm-raid1-report-fault-status.patch
-intel_agp-add-new-chipset-ids.patch
-intel_agp-add-new-chipset-ids-checkpatch-fixes.patch
-agk-dm-dm-raid1-mark-and-clear-nosync-writes.patch
-powerpc-add-fixed-phy-support-for-fs_enet.patch
-gregkh-driver-chinese-add-the-known_regression-uri-to-the-howto.patch
-gregkh-driver-chinese-rephrase-english-introduction-in-howto.patch
-gregkh-driver-chinese-change-man-pages-maintainer-address-in-howoto.patch
-gregkh-driver-chinese-add-translation-of-submittingpatches.patch
-gregkh-driver-chinese-add-translation-of-submittingdrivers.patch
-gregkh-driver-chinese-add-translation-of-oops-tracingtxt.patch
-gregkh-driver-chinese-add-translation-of-stable_kernel_rulestxt.patch
-gregkh-driver-chinese-add-translation-of-volatile-considered-harmfultxt.patch
-gregkh-driver-chinese-add-translation-of-sparsetxt.patch
-gregkh-driver-chinese-add-translation-of-codingstyle.patch
-gregkh-driver-sysfs-fix-a-copy-n-paste-typo-in-comment.patch
-gregkh-driver-nozomi.patch
-gregkh-driver-documentation-replace-obsolete-driverfs-with-sysfs.patch
-gregkh-driver-kobject-remove-incorrect-comment-in-kobject_rename.patch
-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
-gregkh-driver-kref-add-kref_set.patch
-gregkh-driver-aoechr-convert-from-class_device-to-device.patch
-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
-gregkh-driver-coda-convert-struct-class_device-to-struct-device.patch
-gregkh-driver-dma-convert-from-class_device-to-device-for-dma-engine.patch
-gregkh-driver-ide-convert-from-class_device-to-device-for-ide-tape.patch
-gregkh-driver-isdn-convert-from-class_device-to-device-for-isdn-capi.patch
-gregkh-driver-adb-convert-from-class_device-to-device.patch
-gregkh-driver-mcp_ucb1200-convert-from-class_device-to-device.patch
-gregkh-driver-mtd-convert-from-class_device-to-device-for-mtd-mtdchar.patch
-gregkh-driver-paride-convert-from-class_device-to-device-for-block-paride.patch
-gregkh-driver-pktcdvd-convert-from-class_device-to-device-for-block-pktcdvd.patch
-gregkh-driver-tifm-convert-from-class_device-to-device-for-ti-flash-media.patch
-gregkh-driver-cosa-convert-from-class_device-to-device-for-cosa-sync-driver.patch
-gregkh-driver-ecryptfs-sysfs-fixes.patch
-gregkh-driver-driver-core-make-the-dev_-family-of-macros-in-deviceh-complete.patch
-gregkh-driver-sysfs-create-optimal-relative-symlink-targets.patch
-gregkh-driver-sysfs-remove-spin_lock_unlocked.patch
-gregkh-driver-kobject-convert-ibmasm-to-use-kref-not-kobject.patch
-gregkh-driver-kobject-convert-hvc_console-to-use-kref-not-kobject.patch
-gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject.patch
-gregkh-driver-kobject-convert-icom-to-use-kref-not-kobject.patch
-gregkh-driver-kobject-fix-up-kobject_set_name-to-use-kvasprintf.patch
-gregkh-driver-kobject-make-kobject_cleanup-be-static.patch
-gregkh-driver-kobject-add-kobject_init_ng-function.patch
-gregkh-driver-kobject-add-kobject_add_ng-function.patch
-gregkh-driver-kobject-add-kobject_init_and_add-function.patch
-gregkh-driver-remove-struct-kobj_type-from-struct-kset.patch
-gregkh-driver-remove-kobj_set_kset_s.patch
-gregkh-driver-kset-add-kset_create_and_add-function.patch
-gregkh-driver-kobject-add-kobject_create_and_add-function.patch
-gregkh-driver-kobject-get-rid-of-kobject_add_dir-git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
.patch
-gregkh-driver-kobject-get-rid-of-kobject_kset_add_dir.patch
-gregkh-driver-kobject-convert-fuse-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-securityfs-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-debugfs-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-configfs-to-use-kobject_create.patch
-gregkh-driver-kset-convert-ecryptfs-to-use-kset_create.patch
-gregkh-driver-kobject-convert-main-fs-kobject-to-use-kobject_create.patch
-gregkh-driver-kset-convert-gfs2-to-use-kset_create.patch
-gregkh-driver-kset-convert-gfs2-dlm-to-use-kset_create.patch
-gregkh-driver-kset-convert-dlm-to-use-kset_create.patch
-gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_add.patch
-gregkh-driver-kset-remove-decl_subsys_name.patch
-gregkh-driver-kset-convert-kernel_subsys-to-use-kset_create.patch
-gregkh-driver-kset-convert-drivers-base-busc-to-use-kset_create.patch
-gregkh-driver-kset-convert-drivers-base-classc-to-use-kset_create.patch
-gregkh-driver-kset-convert-drivers-base-firmwarec-to-use-kset_create.patch
-gregkh-driver-kset-convert-sys-devices-to-use-kset_create.patch
-gregkh-driver-kobject-convert-sys-hypervisor-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-s390-hypervisor-to-use-kobject_create.patch
-gregkh-driver-kset-convert-sys-devices-system-to-use-kset_create.patch
-gregkh-driver-kset-convert-slub-to-use-kset_create.patch
-gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab.patch
-gregkh-driver-kset-convert-sys-module-to-use-kset_create.patch
-gregkh-driver-kset-convert-sys-power-to-use-kset_create.patch
-gregkh-driver-kset-convert-struct-bus_device-devices-to-use-kset_create.patch
-gregkh-driver-kset-convert-struct-bus_device-drivers-to-use-kset_create.patch
-gregkh-driver-kobject-kobj_attribute-handling.patch
-gregkh-driver-kset-convert-to-kobj_sysfs_ops.patch
-gregkh-driver-struct-user_info-sysfs.patch
-gregkh-driver-ecryptfs-remove-version_str-file-from-sysfs.patch
-gregkh-driver-efivars-make-new_var-and-del_var-binary-sysfs-files.patch
-gregkh-driver-kobject-convert-efivars-to-kobj_attr-interface.patch
-gregkh-driver-firmware-export-firmware_kset.patch
-gregkh-driver-kset-convert-efivars-to-use-kset_create-for-the-efi-subsystem.patch
-gregkh-driver-kset-convert-efivars-to-use-kset_create-for-the-vars-sub-subsystem.patch
-gregkh-driver-kobject-convert-arm-mach-omap1-pmc-to-kobj_attr-interface.patch
-gregkh-driver-kobject-convert-pseries-powerc-to-kobj_attr-interface.patch
-gregkh-driver-kobject-convert-s390-iplc-to-kobj_attr-interface.patch
-gregkh-driver-kset-convert-s390-iplc-to-use-kset_create.patch
-gregkh-driver-kobject-convert-parisc-pdc_stable-to-kobj_attr-interface.patch
-gregkh-driver-kset-convert-parisc-pdc_stablec-to-use-kset_create.patch
-gregkh-driver-kset-kill-subsys-attr.patch
-gregkh-driver-kset-convert-edd-to-use-kset_create.patch
-gregkh-driver-kobject-convert-sys-firmware-acpi-to-use-kobject_create.patch
-gregkh-driver-firmware-remove-firmware_register.patch
-gregkh-driver-firmware-change-firmware_kset-to-firmware_kobj.patch
-gregkh-driver-kset-convert-ocfs2-to-use-kset_create.patch
-gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch
-gregkh-driver-kset-remove-decl_subsys-macro.patch
-gregkh-driver-kobject-convert-kernel_kset-to-be-a-kobject.patch
-gregkh-driver-kobject-remove-subsystem_register-functions.patch
-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
-gregkh-driver-kobject-convert-ecryptfs-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-efivars-to-use-kobject_create.patch
-gregkh-driver-kobject-convert-parisc-pdc_stable-to-use-kobject_create.patch
-gregkh-driver-driver-core-clean-up-shutdownc.patch
-gregkh-driver-driver-core-clean-up-device_shutdown.patch
-gregkh-driver-driver-core-make-sys-power-a-kobject.patch
-gregkh-driver-kobject-grab-the-kset-reference-in-kobject_add-not-kobject_init.patch
-gregkh-driver-kobject-clean-up-debugging-messages.patch
-gregkh-driver-uio-fix-kobject-usage.patch
-gregkh-driver-kobject-change-net-bridge-to-use-kobject_create_and_add.patch
-gregkh-driver-kobject-change-gfs2-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-infiniband-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-firmware-eddc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-firmware-efivarsc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-cpufreq-cpufreqc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-edac-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-cpuidle-sysfsc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-pci-hotplug-pci_hotplug_corec-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-base-sysc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-arch-x86-kernel-cpu-intel_cacheinfoc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-acpi-systemc-to-use-kobject_create_and_add.patch
-gregkh-driver-kobject-change-drivers-block-pktcdvdc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-arch-sh-kernel-cpu-sh4-sqc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-net-ibmvethc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-parisc-pdc_stablec-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-arch-ia64-kernel-topologyc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-drivers-md-mdc-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_create_and_add.patch
-gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_init_and_add.patch
-gregkh-driver-kobject-the-cris-iop_fw_loadc-code-is-broken.patch
-gregkh-driver-kobject-convert-drivers-base-classc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-drivers-base-corec-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-drivers-net-iseries_vethc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-fs-char_devc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-kernel-paramsc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-kernel-userc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-mm-slubc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-net-bridge-br_ifc-to-use-kobject_init-add_ng.patch
-gregkh-driver-driver-core-remove-owner-field-from-struct-bus_type.patch
-gregkh-driver-driver-core-add-way-to-get-to-bus-kset.patch
-gregkh-driver-driver-core-add-way-to-get-to-bus-device-klist.patch
-gregkh-driver-driver-core-remove-fields-from-struct-bus_type.patch
-gregkh-driver-usb-use-proper-call-to-driver_create_file.patch
-gregkh-driver-pcmcia-use-proper-call-to-driver_create_file.patch
-gregkh-driver-pci-use-proper-call-to-driver_create_file.patch
-gregkh-driver-pci-remove-foolish-code-from-pci-driverc.patch
-gregkh-driver-driver-core-introduce-default-attribute-groups.patch
-gregkh-driver-netiucv-use-device_driver-default-attribute-groups.patch
-gregkh-driver-zfcp-use-device_driver-default-attribute-groups.patch
-gregkh-driver-infiniband-make-ipath-driver-use-default-driver-groups.patch
-gregkh-driver-driver-add-driver_add_kobj-for-looney-iseries_veth-driver.patch
-gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core.patch
-gregkh-driver-driver-core-move-the-static-kobject-out-of-struct-driver.patch
-gregkh-driver-driver-core-clean-up-debugging-messages.patch
-gregkh-driver-kobject-change-drivers-base-bus-to-use-kobject_init_and_add.patch
-gregkh-driver-driver-core-fix-race-in-__device_release_driver.patch
-gregkh-driver-driver-core-fix-class-glue-dir-cleanup-logic.patch
-gregkh-driver-sysfs-fix-sys-module-holders-after-sysfs-logic-change.patch
-gregkh-driver-kobject-drop-child-parent-ref-at-unregistration.patch
-gregkh-driver-block-device.patch
-gregkh-driver-kobject-convert-block-elevatorc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-block-ll_rw_blkc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-drivers-md-mdc-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-convert-kernel-modulec-to-use-kobject_init-add_ng.patch
-gregkh-driver-kobject-remove-kobject_add-as-no-one-uses-it-anymore.patch
-gregkh-driver-kobject-rename-kobject_add_ng-to-kobject_add.patch
-gregkh-driver-kobject-remove-kobject_init-as-no-one-uses-it-anymore.patch
-gregkh-driver-kobject-rename-kobject_init_ng-to-kobject_init.patch
-gregkh-driver-kobject-remove-kobject_register.patch
-gregkh-driver-kset-remove-kset_add-function.patch
-gregkh-driver-kobject-auto-cleanup-on-final-unref.patch
-gregkh-driver-modules-remove-unneeded-release-function.patch
-gregkh-driver-kobject-convert-arch-from-kobject_unregister-to-kobject_put.patch
-gregkh-driver-kobject-convert-drivers-from-kobject_unregister-to-kobject_put.patch
-gregkh-driver-kobject-convert-fs-from-kobject_unregister-to-kobject_put.patch
-gregkh-driver-kobject-convert-remaining-kobject_unregister-to-kobject_put.patch
-gregkh-driver-kobject-remove-kobject_unregister-as-no-one-uses-it-anymore.patch
-gregkh-driver-driver-core-change-sysdev-classes-to-use-dynamic-kobject-names.patch
-gregkh-driver-kobject-remove-old-outdated-documentation.patch
-gregkh-driver-kobject-update-the-kobject-kset-documentation.patch
-gregkh-driver-kobject-add-sample-code-for-how-to-use-kobjects-in-a-simple-manner.patch
-gregkh-driver-kobject-add-sample-code-for-how-to-use-ksets-ktypes-kobjects.patch
-gregkh-driver-driver-core-use-list_head-instead-of-call-to-init_list_head-in-__init.patch
-gregkh-driver-sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
-gregkh-driver-driver-core-fix-build-with-sysfs-n.patch
-gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
-revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
-pm-acquire-device-locks-on-suspend-rev-3.patch
-pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
-pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
-unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
-intel-agp-enable-i915-recognition.patch
-drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
-git-dvb-fix-drivers-media-video-bt8xx-bttv-driverc-build.patch
-jdelvare-i2c-i2c-nforce2-nforce2-supports-block-and-reset.patch
-jdelvare-i2c-i2c-pasemi-use-i2c_add_numbered_adapter.patch
-jdelvare-i2c-i2c-ibm_iic-whitespace-cleanups.patch
-jdelvare-i2c-i2c-pcf8575-new-driver.patch
-jdelvare-i2c-i2c-tsl2550-add-power-management.patch
-jdelvare-i2c-i2c-stub-mention-helper-script.patch
-jdelvare-i2c-i2c-stub-single-array.patch
-jdelvare-i2c-i2c-remove-deprecated-rtc-drivers.patch
-jdelvare-i2c-ixp4xx-i2c-gpio.patch
-jdelvare-i2c-i2c-remove-redundant-gpio-drivers.patch
-jdelvare-i2c-i2c-pxa-use-cpu_is_pxa27x.patch
-jdelvare-i2c-i2c-algo-bit-whitespace-cleanups.patch
-jdelvare-i2c-i2c-algo-bit-sendbyte-error-code.patch
-jdelvare-i2c-i2c-algo-pcf-kill-10bit-support.patch
-jdelvare-i2c-i2c-constify-client-address-data.patch
-jdelvare-i2c-i2c-constify-normal_i2c-rtc.patch
-jdelvare-i2c-i2c-constify-normal_i2c-other.patch
-jdelvare-i2c-i2c-kill-rogue-driver-ids.patch
-jdelvare-i2c-i2c-adapters-dont-set-retries.patch
-jdelvare-i2c-i2c-deprecate-video-bus-drivers.patch
-jdelvare-i2c-i2c-drop-redundant-client-usage-count.patch
-jdelvare-i2c-i2c-change-refcounting-prototypes.patch
-jdelvare-i2c-i2c-remove-redundant-i2c_adapter-list.patch
-jdelvare-i2c-i2c-remove-redundant-i2c_driver-list.patch
-jdelvare-i2c-i2c-core-rename-lock.patch
-jdelvare-i2c-i2c-tps65010-move-header.patch
-jdelvare-i2c-i2c-i801-01-document-features.patch
-jdelvare-i2c-i2c-i801-02-features-as-a-bitfield.patch
-jdelvare-i2c-i2c-i801-03-clear-block-buffer-mode.patch
-jdelvare-i2c-i2c-i801-04-add-support-for-i2c-block-read.patch
-jdelvare-i2c-i2c-id-delete-unused.patch
-jdelvare-i2c-i2c-sibyte-remove-bus-scan-parameter.patch
-jdelvare-i2c-i2c-transfer-support-atomic.patch
-jdelvare-i2c-i2c-pxa-add-polling-transfer.patch
-fix-jdelvare-i2c-i2c-constify-client-address-data.patch
-git-infiniband-versus-driver-tree.patch
-git-infiniband-fix-build-with-config_infiniband_ipoib_cm=n.patch
-ide-mm-hpt366-change-timing-register-masks.patch
-ide-mm-hpt366-kill-set_dma_mode-method-wrapper.patch
-ide-mm-hpt366-merge-set_dma_mode-methods.patch
-ide-mm-ide-remove-dma-master-field-from-ide-hwif-t-take-5.patch
-ide-mm-ide-remove-task-ioreg-t-typedef-take-2.patch
-ide-mm-ide-add-struct-ide_taskfile-take-2.patch
-ide-mm-ide-disk-merge-lba28-and-lba48-host-protected-area-support-code-take-2.patch
-ide-mm-ide-disk-fix-taskfile-registers-loading-order-in-__ide_do_rw_disk.patch
-ide-mm-ide-disk-use-struct-ide_taskfile-in-__ide_do_rw_disk.patch
-ide-mm-ide-add-ide_tf_load-helper.patch
-ide-mm-ide-add-ide_no_data_taskfile-helper.patch
-ide-mm-ide-use-do-rw-taskfile-in-flagged-taskfile.patch
-ide-mm-ide-pmac-fix-pmac_ide_init_hwif_ports.patch
-ide-mm-ide-remove-irqf_disabled-from-irq-flags-for-ide-irq-handler.patch
-ide-mm-ide-remove-config_idepci_share_irq-config-option.patch
-ide-mm-ide-remove-stale-ide-h-configuration-options.patch
-ide-mm-ide-tape-remove-dead-use_iotrace-code.patch
-ide-mm-ide-fix-registers-loading-order-for-win_smart-in-execute_drive_cmd.patch
-ide-mm-ide-fix-registers-loading-order-for-ide_nsector_reg-in-execute_drive_cmd.patch
-ide-mm-ide-execute_drive_cmd-cleanup.patch
-ide-mm-ide-remove-ide_cmd-helper.patch
-ide-mm-ide-use-ide_tf_load-in-execute_drive_cmd.patch
-ide-mm-ide-use-ide_tflag_lba48-for-req_type_ata_taskfile-requests.patch
-ide-mm-ide-remove-unnecessary-writes-to-hob-taskfile-registers.patch
-ide-mm-ide-extend-timeout-for-req_type_ata_cmd_task-requests.patch
-ide-mm-ide-switch-idedisk_prepare_flush-to-use-req_type_ata_taskfile-requests.patch
-ide-mm-ide-switch-ide_task_ioctl-to-use-req_type_ata_taskfile-requests.patch
-ide-mm-ide-remove-req_type_ata_task.patch
-ide-mm-ide-floppy-remove-dead-code.patch
-ide-mm-ide-cpu-endianness-doesn-t-matter-for-special_t.patch
-ide-mm-ide-remove-ata_status_t-and-atapi_status_t.patch
-ide-mm-ide-remove-atapi_error_t-take-2.patch
-ide-mm-ide-remove-atapi_feature_t.patch
-ide-mm-ide-remove-ata_nsector_t-ata_data_t-and-atapi_bcount_t.patch
-ide-mm-ide-remove-atapi_ireason_t-take-3.patch
-ide-mm-ide-cd-fix-register-loading-order-in-cdrom_start_packet_command.patch
-ide-mm-ide-floppy-tape-scsi-fix-register-loading-order-when-issuing-packet-command.patch
-ide-mm-ide-add-ide_pktcmd_tf_load-helper.patch
-ide-mm-ide-remove-quirk_list.patch
-ide-mm-ide-remove-select_interrupt.patch
-ide-mm-ide-remove-hwif-intrproc.patch
-ide-mm-ide-remove-command-type-field-from-ide_task_t.patch
-ide-mm-ide-remove-tf_in_flags-field-from-ide_task_t.patch
-ide-mm-sc1200-remove-pointless-hwif-lookup-loop.patch
-ide-mm-ide-disk-fix-__ide_do_rw_disk-to-use-outbsync.patch
-ide-mm-ide-disk-guarantee-400ns-delay-after-writing-command-register.patch
-ide-mm-ide-merge-flagged_taskfile-into-do_rw_taskfile.patch
-ide-mm-ide-convert-do_rw_taskfile-to-use-data_phase.patch
-ide-mm-ide-use-data_phase-to-set-handler-in-do_rw_taskfile.patch
-ide-mm-ide-remove-handler-field-from-ide_task_t-take-2.patch
-ide-mm-ide-disk-extend-timeout-for-pio-out-commands.patch
-ide-mm-ide-disk-add-ide_tf_set_cmd-helper.patch
-ide-mm-ide-disk-use-do_rw_taskfile.patch
-ide-mm-ide-fix-registers-loading-order-in-ide_dump_ata_status.patch
-ide-mm-ide-add-ide_tf_read-helper.patch
-ide-mm-ide-printk-fix.patch
-ide-mm-ide-disk-use-ide_get_lba_addr.patch
-ide-mm-ide-kill-duplicate-code-in-ide_dump_ata_atapi_status.patch
-ide-mm-ide-make-extra-field-in-struct-ide_port_info-u8.patch
-ide-mm-pdc202xx_new-move-pio-programming-code-to-pdcnew_set_pio_mode.patch
-ide-mm-sis5513-factor-out-udma-programming-code.patch
-ide-mm-ide-add-ide_hflag_abuse_set_dma_mode-host-flag.patch
-ide-mm-sc1200-move-dma-timings-to-timing-tables.patch
-ide-mm-ide-remove-redundant-ide_dma_on-call-from-set_using_dma.patch
-ide-mm-ide-cleanup-ide_set_dma.patch
-ide-mm-ide-remove-redundant-dma-blacklist-check-from-__ide_dma_on.patch
-ide-mm-sl82c105-program-dma-pio-timings-in-dma_start-and-ide_dma_end.patch
-ide-mm-sl82c105-remove-no-longer-needed-selectproc-method.patch
-ide-mm-serverworks-cleanup-set_dma_mode-method.patch
-ide-mm-ide-disk-add-idedisk_set_doorlock-helper.patch
-ide-mm-ide-hopefully-fix-vdma-for-cs5520.patch
-ide-mm-cy82c693-correct-dma-modes-clipping.patch
-ide-mm-cy82c693-add-set_dma_mode-method.patch
-ide-mm-sgiioc4-add-ide_toggle_bounce-calls.patch
-ide-mm-icside-add-ide_toggle_bounce-calls.patch
-ide-mm-au1xxx-ide-add-ide_toggle_bounce-calls.patch
-ide-mm-ide-remove-ide_dma_on-and-dma_off_quietly-methods-from-ide_hwif_t.patch
-ide-mm-ide-cris-fix-dma-methods.patch
-ide-mm-atiixp-remove-dma_host_on-and-dma_host_off-methods.patch
-ide-mm-ide-move-drive-using_dma-check-to-callers-of-dma_host_on-method.patch
-ide-mm-ide-merge-dma_host_-on-off-methods-into-dma_host_set-method.patch
-ide-mm-ide-dump-taskfile-hob-registers-in-ide_tf_load-if-debug-is-defined.patch
-ide-mm-ide-merge-fixup-and-quirkproc-methods.patch
-ide-mm-ide-dont-try-to-unregister-interfaces-if-initializing-in-ide_register_hw.patch
-ide-mm-ide-kill-probe_hwif_init.patch
-ide-mm-ide-fix-probing-for-hosts-with-serialized-or-irq-sharing-interfaces.patch
-ide-mm-rapide-set-hwif-chipset.patch
-ide-mm-swarm-set-hwif-chipset.patch
-ide-mm-ide-add-hwif-chipset-fixup-to-ide_device_add.patch
-ide-mm-ide-remove-ideprobe_init.patch
-ide-mm-ide-fix-build-break-caused-by-ide-remove-ideprobe_init.patch
-ide-mm-sgiioc4-always-init-hwif-io_ports.patch
-ide-mm-ide-add-ide_init_port_hw-helper.patch
-ide-mm-ide-drop-initializing-argument-from-ide_register_hw.patch
-ide-mm-ide-move-ide_arm_init-call-from-init_ide_data-to-ide_init.patch
-ide-mm-cmd640-fix-dependency-on-ide_generic.patch
-ide-mm-ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces-take-2.patch
-ide-mm-ide-make-remaining-built-in-only-ide-host-drivers-modular.patch
-ide-mm-au1xxx-ide-au_ide_probe-fix.patch
-ide-mm-au1xxx-ide-use-ide_init_port_hw.patch
-ide-mm-ide-always-use-ide_std_init_ports-in-setup-pci-c.patch
-ide-mm-ide-use-ide_init_port_hw-in-setup-pci-c.patch
-ide-mm-rapide-remove-write-only-hwif-hwif_data.patch
-ide-mm-ide-pmac-use-custom-hwif-sg_max_nents-only-if-dma-support-is-enabled.patch
-ide-mm-ide-add-ide_set_irq-inline-helper.patch
-ide-mm-ide-print-banner-message-once-per-controller-in-m68k-host-drivers.patch
-ide-mm-ide-move-config_idepci_pcibus_order-code-to-ide-scan-pci-c.patch
-ide-mm-ide-make-config_idepci_pcibus_order-visible-and-deprecate-it.patch
-ide-mm-ide-add-ide_busy_sleep-helper.patch
-ide-mm-ide-remove-broken-disk-byte-swapping-support.patch
-ide-mm-cmd64x-remove-proc-ide-cmd64x.patch
-ide-mm-ide-fix-io_32bit-race-in-ide_taskfile_ioctl.patch
-ide-mm-ide-clear-hob-bit-for-req_type_ata_cmd-requests-in-ide_end_drive_cmd.patch
-ide-mm-ide-fix-final-status-check-in-task_in_intr.patch
-ide-mm-ide-tape-fix-handling-of-non-special-requests-in-end_request-method.patch
-ide-mm-ide-set-ide_tflag_in-flags-before-queuing-executing-command.patch
-ide-mm-ide-remove-needless-cursg-clearing-from-task_end_request.patch
-ide-mm-ide-use-rq-nr_sectors-in-task_end_request.patch
-ide-mm-ide-task_end_request-fix.patch
-ide-mm-ide-kill-data_ready-define.patch
-ide-mm-ide-use-wait_drive_not_busy-in-drive_cmd_intr-take-2.patch
-ide-mm-ide-initialize-rq-cmd_type-in-ide_init_drive_cmd-callers.patch
-ide-mm-ide-convert-empty-req_type_ata_cmd-requests-to-use-req_type_ata_taskfile.patch
-ide-mm-ide-dont-enable-local-irqs-for-pio-in-in-driver_cmd_intr-take-2.patch
-ide-mm-ide-check-busy-and-error-status-bits-before-reading-data-in-drive_cmd_intr.patch
-ide-mm-ide-fix-final-status-check-in-drive_cmd_intr.patch
-ide-mm-ide-switch-set_xfer_rate-to-use-req_type_ata_taskfile-requests.patch
-ide-mm-ide-switch-ide_cmd_ioctl-to-use-req_type_ata_taskfile-requests.patch
-ide-mm-ide-remove-req_type_ata_cmd.patch
-ide-mm-ide-cd-use-xfer_func_t-in-cdrom_pc_intr.patch
-ide-mm-ide-cd-add-ide_cd_pad_transfer-helper.patch
-ide-mm-ide-cd-fix-missing-data-handling-in-cdrom_pc_intr.patch
-ide-mm-ide-cd-fix-dma-error-handling-in-cdrom_newpc_intr.patch
-ide-mm-ide-cd-fix-trailing-whitespaces-in-changelog.patch
-ide-mm-ide-cd-move-historical-changelog-to-documentation-ide-changelog-ide-cd-1994-2004.patch
-ide-mm-ide-cd-remove-stale-cdrom_transfer_packet_command-comment.patch
-ide-mm-ide-cd-remove-unused-defines-from-ide-cd-h.patch
-ide-mm-ide-cd-remove-dead-code-from-cdrom_pc_intr.patch
-ide-mm-ide-cd-remove-unused-struct-atapi_cdrom_subchnl.patch
-ide-mm-ide-cd-remove-needless-zeroing-of-info-fields-from-ide_cdrom_setup.patch
-ide-mm-ide-cd-remove-unused-and-write-only-struct-ide_cd_config_flags-fields.patch
-ide-mm-ide-cd-remove-struct-atapi_mechstat_header-changer_info-slot.patch
-ide-mm-ide-cd-cleanup-ide_cdrom_update_speed.patch
-ide-mm-ide-cd-add-ide_cd_capabilities-define.patch
-ide-mm-ide-cd-remove-redundant-config-flags.patch
-ide-mm-ide-cd-kill-cdrom_config_flags-macro.patch
-ide-mm-ide-cd-kill-cdrom_state_flags-macro.patch
-ide-mm-ide-cd-remove-struct-atapi_capabilities_page-take-2.patch
-ide-mm-ide-cd-remove-struct-ide_cd_config-state_flags.patch
-ide-mm-ide-cd-remove-no_door_locking-define.patch
-ide-mm-ide-cd-remove-standard_atapi-define.patch
-ide-mm-ide-cd-use-bcd2bin-bin2bcd-macros-from-linux-bcd-h.patch
-ide-mm-ide-cd-re-organize-handling-of-quirky-devices.patch
-ide-mm-ide-cd-remove-duplicate-sense-keys-definitions-from-ide-cd-h.patch
-ide-mm-ide-cd-coding-style-fixes-for-verbose_ide_cd_errors-code.patch
-ide-mm-ide-cd-move-verbose_ide_cd_errors-code-to-ide-cd_verbose-c.patch
-ide-mm-ide-cd-factor-out-ioctl-handlers-from-ide_cdrom_audio_ioctl.patch
-ide-mm-ide-cd-merge-cdrom_play_audio-into-ide_cd_fake_play_trkind.patch
-ide-mm-ide-cd-merge-cdrom_read_subchannel-into-ide_cdrom_get_mcn.patch
-ide-mm-ide-cd-merge-cdrom_select_speed-into-ide_cdrom_select_speed.patch
-ide-mm-ide-cd-move-lba_to_msf-and-msf_to_lba-to-linux-cdrom-h.patch
-ide-mm-ide-cd-coding-style-fixes-for-cdrom_get_toc_entry.patch
-ide-mm-ide-cd-rename-cdrom_-functions-to-ide_cd_.patch
-ide-mm-ide-cd-move-code-handling-cdrom-c-ioctls-to-ide-cd_ioctl-c.patch
-ide-mm-ide-cd-remove-bug_on-from-cdrom_newpc_intr.patch
-ide-mm-ide-cd-call-blk_dump_rq_flags-on-missing-data-in-cdrom_newpc_intr.patch
-ide-mm-ide-cd-factor-out-request-sense-fixup-from-cdrom_pc_intr.patch
-ide-mm-ide-cd-unify-request-end-exit-path-in-cdrom_pc_intr.patch
-ide-mm-ide-cd-merge-cdrom_pc_intr-and-cdrom_newpc_intr.patch
-ide-mm-ide-cd-remove-cdrom_do_pc_continuation.patch
-ide-mm-ide-cd-merge-cdrom_do_packet_command-and-cdrom_do_block_pc.patch
-ide-mm-ide-cd-add-ide_cd_drain_data-helper.patch
-ide-mm-ide-cd-factor-out-transfer-size-checking-from-cdrom_read_intr.patch
-ide-mm-ide-cd-merge-cdrom_read_intr-and-cdrom_write_intr.patch
-ide-mm-ide-cd-merge-cdrom_start_read_continuation-and-cdrom_start_write_cont.patch
-ide-mm-ide-cd-merge-cdrom_start_read-and-cdrom_start_write.patch
-ide-mm-ide-cd-unify-moving-to-the-next-buffer-in-cdrom_rw_intr.patch
-ide-mm-ide-cd-prepare-cdrom_rw_intr-and-cdrom_newpc_intr-to-be-merged.patch
-ide-mm-ide-cd-call-blk_dump_rq_flags-on-missing-data-in-cdrom_rw_intr.patch
-ide-mm-ide-cd-merge-cdrom_rw_intr-and-cdrom_newpc_intr.patch
-ide-mm-ide-cd-merge-cdrom_write_check_ireason-and-cdrom_read_check_ireason.patch
-ide-mm-ide-cd-unify-request-end-exit-path-in-cdrom_decode_status.patch
-ide-mm-ide-cd-update-driver-version-comments-and-copyrights.patch
-ide-mm-ide-add-ide_dump_identify-debug-helper.patch
-ide-mm-ide-floppy-tape-remove-debug-code-for-dumping-identify-data.patch
-ide-mm-ide-cd-move-the-remaining-cdrom-c-ioctl-handling-code-to-ide-cd_ioctl-c-v2.patch
-ide-mm-trm290-cannot-call-ide_setup_dma.patch
-ide-mm-ide-ide_setup_dma-assumes-8-ports.patch
-ide-mm-amd74xx-remove-amd_ide_chips-table.patch
-ide-mm-ide-add-ide_hflag_clear_simplex-host-flag.patch
-ide-mm-ide-add-ide_hflag_no_dsc-host-flag.patch
-ide-mm-piix-remove-stale-comments.patch
-ide-mm-ide-fix-ide_intr-for-non-pci-devices-and-config_blk_dev_idepci-y.patch
-ide-mm-ide-remove-bug_on-from-ide_build_sglist.patch
-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
-ide-mm-ide-keep-pointer-to-struct-device-instead-of-struct-pci_dev-in-ide_hwif_t.patch
-ide-mm-au1xxx-ide-use-hwif-dev.patch
-ide-mm-icside-use-hwif-dev.patch
-ide-mm-ide-switch-to-dma-mapping-api.patch
-ide-mm-ide-use-ide_build_sglist-and-ide_destroy_dmatable-in-non-pci-host-drivers.patch
-ide-mm-au1xxx-ide-device-tree-bugfix.patch
-ide-mm-ide-pmac-macio-resource-freeing-bugfix.patch
-ide-mm-au1xxx-ide-rapide-use-hwif-index-for-ide_unregister.patch
-ide-mm-ide-delete-filenames-versions-from-comments.patch
-ide-mm-ide-update-add-my-copyrights.patch
-ide-mm-ide-floppy-cleanup-header.patch
-ide-mm-ide-dont-include-linux-hdsmart-h.patch
-ide-mm-linux-hdsmart-h-is-not-used-by-kernel-code.patch
-ide-mm-ide-fix-handling-of-busy-io-resources-in-probe_hwif.patch
-ide-mm-ide-move-wait_hwif_ready-documentation-in-the-right-place.patch
-ide-mm-ide-remove-hwif-present-manipulations-from-hwif_init.patch
-ide-mm-ide_platform-remove-struct-hwif_prop.patch
-ide-mm-ide-remove-unused-ide_hwgroup_t-fields.patch
-ide-mm-ide-remove-needless-zeroing-of-hwgroup-fields-from-init_irq.patch
-ide-mm-ide-cleanup-ide_system_bus_speed.patch
-ide-mm-ide-io-resources-are-released-too-early-in-ide_unregister.patch
-ide-mm-ide-factor-out-code-removing-port-from-hwgroup-from-ide_unregister.patch
-ide-mm-ide-prepare-init_irq-for-using-ide_remove_port_from_hwgroup.patch
-ide-mm-ide-use-ide_remove_port_from_hwgroup-in-init_irq.patch
-ide-mm-ide-make-probe_hwif-return-an-error-value.patch
-ide-mm-ide-move-handling-of-io-resources-out-of-ide_probe_port.patch
-ide-mm-ide-factor-out-code-for-tuning-devices-from-ide_probe_port.patch
-ide-mm-ide-move-hwif_register-call-out-of-ide_probe_port.patch
-ide-mm-dtc2278-fix-io_32bit-handling.patch
-ide-mm-au1xxx-ide-fix-io_32bit-handling.patch
-ide-mm-atiixp-cs5535-scc_pata-fix-idex-ata66-parameter-handling.patch
-ide-mm-macide-remove-drive-capacity64-quirk.patch
-ide-mm-ide-always-set-dma-masks-in-ide_pci_setup_ports.patch
-ide-mm-ide-separate-pci-specific-init-from-generic-init-in-ide_pci_setup_ports.patch
-ide-mm-ide-add-struct-ide_port_info-instances-to-legacy-host-drivers.patch
-ide-mm-ide-add-cable-detect-method-to-ide_hwif_t.patch
-ide-mm-ide-remove-needless-includes-from-pci-host-drivers.patch
-ide-mm-ide-floppy-convert-to-generic-packet-commands.patch
-ide-mm-ide-floppy-replace-ntoh-s-l-and-hton-s-l-calls-with-the-generic-byteorder.patch
-ide-mm-ide-floppy-remove-unnecessary-handler-ne-null-check.patch
-ide-mm-ide-floppy-disambiguate-function-names.patch
-ide-mm-ide-floppy-include-the-proper-headers.patch
-ide-mm-ide-floppy-cleanup-and-unify-debugging-macro-calls.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_capabilities_page.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_inquiry_result.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_request_sense_result.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_mode_parameter_header.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_flexible_disk_page.patch
-ide-mm-ide-floppy-remove-struct-idefloppy_capacity_descriptor.patch
-ide-mm-ide-floppy-factor-out-ioctl-handlers-from-idefloppy_ioctl.patch
-ide-mm-ide-floppy-report-dma-handling-in-idefloppy_pc_intr-properly.patch
-ide-mm-ide-floppy-mv-idefloppy_-should_-report_error.patch
-ide-mm-ide-floppy-remove-idefloppy_debug_bugs-macro.patch
-ide-mm-ide-floppy-use-an-xfer_func_t-and-io_buf_t-typedefs-in-order-to-unify-rw.patch
-ide-mm-ide-floppy-merge-idefloppy_-input-output-_buffers.patch
-ide-mm-ide-floppy-remove-unused-idefloppy_use_read12.patch
-ide-mm-ide-floppy-remove-idefloppy_debug_info.patch
-fix-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
-fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch
-drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
-drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
-drivers-mtd-ubi-cdevc-unused-var.patch
-ucc_geth-fix-module-removal.patch
-ucc_geth-add-support-for-netpoll.patch
-pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
-gregkh-pci-pci-make-pci_restore_bars-static.patch
-gregkh-pci-pci-drivers-pci-romc-if-0-two-functions.patch
-gregkh-pci-pci-drivers-pci-remove-unused-exports.patch
-gregkh-pci-pcie-port-driver-correctly-detect-native-pme-feature.patch
-gregkh-pci-pcie-utilize-pcie-transaction-pending-bit.patch
-gregkh-pci-pci-hotplug-switch-to-pci_get_bus_and_slot.patch
-gregkh-pci-pci-hotplug-remove-experimental.patch
-gregkh-pci-pci-hotplug-acpiphp-remove-unused-variable-from-acpiphp.patch
-gregkh-pci-pci-hotplug-pci_hotplug_core-whitespace-fix.patch
-gregkh-pci-pci-hotplug-link-fakephp-last.patch
-gregkh-pci-pci-quirk_vialatency-omit-reading-pci-revision-id.patch
-gregkh-pci-pci-via-cx700-quirk-to-disable-pci-bus-parking.patch
-gregkh-pci-pci-mem-policy-fix-mempolicy-usage-in-pci-driver.patch
-gregkh-pci-pci-get-rid-of-pci_dev-vendor-device-_compatible-fields.patch
-gregkh-pci-pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch
-gregkh-pci-pci-always-export-pci_scan_single_device.patch
-gregkh-pci-pci-remove-additional-pci_scan_child_bus-prototype.patch
-gregkh-pci-pci-drivers-pci-quirksc-coding-style-cleanup.patch
-gregkh-pci-pci-more-sanity-checks-for-dmar.patch
-gregkh-pci-pci-unhide-the-smbus-on-the-hp-xw4100.patch
-gregkh-pci-pci-hotplug-fix-rpaphp-directory-naming.patch
-gregkh-pci-pci-export-pci_restore_msi_state.patch
-gregkh-pci-pci-add-missing-space-in-printk-messages.patch
-gregkh-pci-pcie-fix-pcie-hotplug-so-that-it-works-with-expresscard-slots-on-dell-notebooks-in-conjunction-with-modparam-of-pciehp_force-1.patch
-gregkh-pci-pci-more-fixes-for-pcie-hotplug-so-that-it-works-with-expresscard-slots-on-dell-notebooks-in-conjunction-with-modparam-of-pciehp_force-1.patch
-gregkh-pci-pcie-make-use-of-the-previously-split-out-pcie_init_enable_events-function.patch
-gregkh-pci-pcie-fix-double-initialization-bug.patch
-gregkh-pci-pci-hotplug-acpiphp-fix-trivial-typos.patch
-gregkh-pci-pci-hotplug-acpiphp-remove-unneeded-acpi_get_name-function-call.patch
-gregkh-pci-pci-hotplug-pciehp-remove-needless-members-from-struct-controller.patch
-gregkh-pci-pci-hotplug-pciehp-remove-needless-hp_slot-calculation.patch
-gregkh-pci-pci-hotplug-pciehp-use-generic-function-to-find-ext-capability.patch
-gregkh-pci-pci-hotplug-pciehp-fix-some-whitespace-damage.patch
-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
-gregkh-pci-pci-fix-warning-in-setup-resc-on-32-bit-platforms-with-64-bit-resources.patch
-gregkh-pci-pci-remove-default-pci-expansion-rom-memory-allocation.patch
-gregkh-pci-pci-quirk-enable-msi-mapping-on-ht1000.patch
-gregkh-pci-pci-drivers-pci-msic-move-arch-hooks-to-the-top.patch
-gregkh-pci-pci-kconfig-help-don-t-refer-to-the-pci-howto.patch
-gregkh-pci-pci-spelling-fixes.patch
-gregkh-pci-pci-fix-for-quirk_e100_interrupt.patch
-gregkh-pci-pci-print-quirk-name-in-debug-messages.patch
-gregkh-pci-pci-use-dev_printk-in-quirk-messages.patch
-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
-gregkh-pci-pci-fix-typo-in-pci_save_pcix_state.patch
-gregkh-pci-pci-correctly-initialize-a-structure-for-pcie_save_pcix_state.patch
-gregkh-pci-pci-avoid-save-the-same-type-of-cap-multiple-times.patch
-gregkh-pci-pci-add-pci_enable_device_-io-mem-intefaces.patch
-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
-gregkh-pci-pci-remove-pci_enable_device_bars.patch
-gregkh-pci-pci-remove-pci_enable_device_bars-from-documentation.patch
-gregkh-pci-pciehp-wait-for-1000ms-before-led-operation-after-power-off.patch
-gregkh-pci-pciehp-workaround-against-bad-dllp-during-power-off.patch
-gregkh-pci-pciehp-block-new-requests-from-the-device-before-power-off.patch
-gregkh-pci-pci-convert-drivers-pci-procc-to-use-unlocked_ioctl.patch
-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
-gregkh-pci-pci_bridge-device.patch
-fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
-pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch
-adapt-sclp_cpi_sysc-to-the-kobject-kset-changes.patch
-scsi-qla2xxx-possible-cleanups.patch
-scsi-pending-arm-convert-to-accessors.patch
-powerpc-export-copy_page-on-32bit.patch
-gregkh-usb-usb-keyspan-fix-oops.patch
-gregkh-usb-usb-gadget-fix-fsl_usb2_udc-potential-oops.patch
-gregkh-usb-usb-cp2101-new-device-ids.patch
-gregkh-usb-usb-add-support-for-4348-5523-winchiphead-usb-rs-232-adapter.patch
-gregkh-usb-usb-sierra-add-support-for-aircard-881u.patch
-gregkh-usb-usb-adding-yc-cable-usb-serial-device-to-pl2303.patch
-gregkh-usb-usb-sierra-driver-add-devices.patch
-gregkh-usb-usb-correct-comments-in-usb-core-notifyc.patch
-gregkh-usb-usb-ftdi_sio-enabling-multiple-elv-devices-adding-em1010pc.patch
-gregkh-usb-usb-ftdi-sio-patch-to-add-vendor-device-id-for-atk_16ic-ccd.patch
-gregkh-usb-usb-use-gfp_noio-in-reset-path.patch
-gregkh-usb-usb-convert-from-class_device-to-device-for-usb-core.patch
-gregkh-usb-usb-remove-unnecessary-zeroing-from-ub.patch
-gregkh-usb-usb-autosuspend-for-cdc-acm.patch
-gregkh-usb-usb-isd200-don-t-include-linux-ideh.patch
-gregkh-usb-usb-add-iuu_phoenix-driver.patch
-gregkh-usb-usb-sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
-gregkh-usb-usb-sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
-gregkh-usb-usb-s3c2410_udc-minor-irq-handler-cleanups.patch
-gregkh-usb-usb-usb-mon-mon_binc-cleanups.patch
-gregkh-usb-usb-device-dma-support-on-omap2.patch
-gregkh-usb-usb-ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch
-gregkh-usb-usb-m66592-udc-add-support-for-sh7722-usbf.patch
-gregkh-usb-usb-add-missing-space-to-printk-messages.patch
-gregkh-usb-usb-usb-storage-new-lockable-subclass-0x07.patch
-gregkh-usb-usb-add-printer-gadget-driver.patch
-gregkh-usb-usb-cypress_cy7c63-updated-contact-usage-information.patch
-gregkh-usb-usb-usb_serial_console-fix-command-line-parsing.patch
-gregkh-usb-usb-usb_serial-clean-tty-reference-in-the-last-close.patch
-gregkh-usb-usb-usb_serial_console-allocate-fake-tty-and-termios-before-calling-driver-open-method.patch
-gregkh-usb-usb-linux-usb-kbuild-needs-only-header-y-not-unifdef-y.patch
-gregkh-usb-usb-drop-unnecessary-continue-in-a-few-drivers.patch
-gregkh-usb-usb-make-ksuspend_usbd-thread-non-freezable.patch
-gregkh-usb-usb-don-t-change-hc-power-state-for-a-freeze.patch
-gregkh-usb-usb-gadget-code-switches-to-pr_err-and-friends.patch
-gregkh-usb-usb-prepare-serial-core-for-autosuspend.patch
-gregkh-usb-usb-cyberjack-remove-a-unnecessary-variable.patch
-gregkh-usb-usb-usb-peripheral-controller-driver-oops-avoidance.patch
-gregkh-usb-usb-force-handover-port-to-companion-when-hub_port_connect_change-fails.patch
-gregkh-usb-usb-dummy_hcd-don-t-register-drivers-on-the-platform-bus.patch
-gregkh-usb-always-announce-new-usb-devices.patch
-gregkh-usb-usb-convert-ohci-debug-files-to-use-debugfs-instead-of-sysfs.patch
-gregkh-usb-usb-convert-ehci-debug-files-to-use-debugfs-instead-of-sysfs.patch
-gregkh-usb-usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
-gregkh-usb-usb-repair-usbdevfs_connect-ioctl.patch
-gregkh-usb-usb-updates-to-usb_reset_composite_device.patch
-gregkh-usb-usb-edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
-gregkh-usb-usb-add-usbfs-stubs-for-suspend-and-resume.patch
-gregkh-usb-usb-ehci-add-separate-iaa-watchdog-timer.patch
-gregkh-usb-usb-dummy_hcd-change-the-default-power-budget.patch
-gregkh-usb-usb-pl2303-cleanup-fish-and-soup-macros-in-pl2303-driver.patch
-gregkh-usb-usb-pl2303-move-pl2303-vendor-specific-init-to-probe-function.patch
-gregkh-usb-usb-pl2303-add-autosuspend-support-to-pl2303-usb-serial-converter.patch
-gregkh-usb-usb-belkin_sa-clean-up-for-new-style-termios-and-speed-handling-plus-style.patch
-gregkh-usb-usb-keyspan_pda-clean-up-speed-handling.patch
-gregkh-usb-usb-mct232-speed-new-termios-and-compliance-cleanups.patch
-gregkh-usb-usb-mon-nopage.patch
-gregkh-usb-usb-testing-driver-convert-dev-sem-to-mutex.patch
-gregkh-usb-usb-testing-driver-don-t-free-a-locked-mutex.patch
-gregkh-usb-usb-gadget-pxa2xx_udc-supports-inverted-vbus.patch
-gregkh-usb-usb-spelling-fixes.patch
-gregkh-usb-usb-ps3-fix-ehci-iso-transfer-bug.patch
-gregkh-usb-usb-usb-storage-initializersc-fix-signedness-difference.patch
-gregkh-usb-usb-usbdevfs_urb-__user-annotation.patch
-gregkh-usb-usb-ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch
-gregkh-usb-usb-add-marvell-orion-usb-host-support.patch
-gregkh-usb-usb-ehci-potential-oops-fix-on-arc-tdi-cores.patch
-gregkh-usb-usb-gadget-ethernet-error-path-potential-oops-fix.patch
-gregkh-usb-usb-fix-null-pointer-dereference-on-drivers-usb-serial-whiteheatc.patch
-gregkh-usb-usb-gadget-at91_udc-minor-fix.patch
-gregkh-usb-usb-fix-hcd-kconfig-goofage.patch
-gregkh-usb-usb-tosa_udc_use_gpio_vbuspatch.patch
-gregkh-usb-usb-mos7720-clean-up-termios.patch
-gregkh-usb-usb-ti_usb-termios-cleanups.patch
-gregkh-usb-usb-io_ti-clean-up-termios-handling.patch
-gregkh-usb-usb-ftdi_sio-support-for-more-jtag-adaptors.patch
-gregkh-usb-usb-sierra-driver-add-update-dtr-logic.patch
-gregkh-usb-usb-export-suspend-statistics.patch
-gregkh-usb-usb-ohci-at91-uses-generic-gpio-calls.patch
-gregkh-usb-usb-at91_udc-uses-generic-gpio-calls-minor-cleanup.patch
-gregkh-usb-usb-pxa2xx_udc-use-debugfs-not-procfs.patch
-gregkh-usb-usb-add-ehci-ppc-of-bus-glue.patch
-gregkh-usb-usb-misc-legousbtower-semaphore-to-mutex.patch
-gregkh-usb-usb-add-ehci-ixp-bus-glue.patch
-gregkh-usb-usb-ehci-saves-some-memory-in-iso-transfer-descriptors.patch
-gregkh-usb-usb-ehci-minor-iso-updates-always-support-split-iso.patch
-gregkh-usb-usb-ehci-completes-high-speed-iso-urbs-sooner.patch
-gregkh-usb-usb-usbfs-struct-async-is-a-fixed-size-structure.patch
-gregkh-usb-usb-ehci-move-del_timer_sync-calls-outside-spinlocked-region.patch
-gregkh-usb-usb-ehci-add-a-short-delay-to-the-bus_suspend-routine.patch
-fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
-9p-util-fix-semaphore-handling.patch
-wdt-fix-locking.patch
-wdt-fix-locking-checkpatch-fixes.patch
-prism54-remove-questionable-down_interruptible-usage.patch
-iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch
-hostap-section-mismatch-warning.patch
-ssb-add-ssb_pcihost_set_power_state-function.patch
-b44-power-down-phy-when-interface-down.patch
-drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
-drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
-drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
-git-x86-fix-doubly-merged-patch.patch
-bonding-locking-fix.patch
-usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
-keyspan-fix-oops.patch
-sky2-wake-on-lan-configuration-issues.patch
-m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
-m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
-m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
-add-build-support-for-new-coldfire-serial-driver.patch
-add-configure-support-for-new-coldfire-serial-driver.patch
-m68knommu-platform-setup-for-5206-coldfire-uarts.patch
-m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
-m68knommu-platform-setup-for-520x-coldfire-uarts.patch
-m68knommu-platform-setup-for-5249-coldfire-uarts.patch
-m68knommu-platform-setup-for-5272-coldfire-uarts.patch
-m68knommu-remove-vestiges-of-non-existent-disktel.patch
-use-wake_up_locked-in-eventpoll.patch
-use-macros-instead-of-task_-flags.patch
-use-macros-instead-of-task_-flags-checkpatch-fixes.patch
-add-task_wakekill.patch
-add-lock_page_killable.patch
-remove-__attribute_used__.patch
-remove-__attribute_used__-checkpatch-fixes.patch
-linux-inith-simplify-__meminitexit-dependencies.patch
-printk-trivial-optimizations.patch
-printk-trivial-optimizations-fix.patch
-ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
-ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
-kernel-add-mutex_lock_killable.patch
-vfs-use-mutex_lock_killable-in-vfs_readdir.patch
-fix-missing-n-in-checkpatchpl.patch
-xen-fiddle_vdso-must-be-__init.patch
-export-iov_shorten-for-ext4s-use.patch
-export-iov_shorten-for-ext4s-use-fix.patch
-create-arch-kconfig.patch
-add-have_oprofile.patch
-add-have_kprobes.patch
-add-buffer-head-related-helper-functions.patch
-ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
-ext4-check-for-return-value-from-sb_set_blocksize.patch
-modules-make-module_address_lookup-safe.patch
-efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
-dont-error-on-higher-hz-values.patch
-make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch

 Merged into mainline or a subsystem tree

+kvm-i386-fix.patch
+sys_remap_file_pages-fix-vm_file-accounting.patch
+drivers-net-wireless-b43-mainc-needs-ioh.patch
+adb-add-missing-include-linux-platform_deviceh.patch

 Fixes..

+lockdep-annotate-epoll.patch

 Prevent bogus lockdep warnings from epoll

+drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
+drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements-checkpatch-fixes.patch

 Make a USB driver play nicer with my workflow.

+acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch

 Update acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

+acpi-backlight-reset-brightness-on-resume.patch
+acpi-backlight-reset-brightness-on-resume-checkpatch-fixes.patch

 ACPI backlight driver update

-git-alsa-fixup.patch

 Unneeded

+git-agpgart-fix.patch

 Make it compile

-working-3d-dri-intel-agpko-resume-for-i815-chip.patch

 I got sick of sending this to the maintainer and fixing it up whenever he
 broke it so I just dropped it.

+convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch

 unlocked_ioctl() conversion

+at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch

 at91 fix

+git-audit-master-fix-git-rejects.patch

 Fix rejects in git-audit-master.patch (actually this tree is empty)

+audit-let-userspace-fully-control-tty-input-auditing.patch
+use-find_task_by_vpid-in-audit-code.patch

 audit stuff

+fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch

 avr32 fix

+cifs-fix-warning.patch
+bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch

 cifs things

+agk-dm-dm-raid1-handle-recovery-failures.patch
+agk-dm-dm-raid1-report-fault-status.patch

 device-mapper tree updates

-git-powerpc-fixup.patch

 Unneeded

+include-asm-powerpc-nvramh-needs-listh.patch
+include-asm-powerpc-nvramh-needs-listh-fix.patch

 powerpc build fix

+gregkh-driver-kobject-always-build-in-kernel-ksysfso.patch
+gregkh-driver-kobject-kerneldoc-comment-fix.patch
+gregkh-driver-add-ja_jp-translation-of-stable_kernel_rulestxt.patch
+gregkh-driver-nozomi-driver-update.patch
+gregkh-driver-nozomi-constify-driver.patch
+gregkh-driver-nozomi-finish-constification.patch
+gregkh-driver-pm-export-device_pm_schedule_removal.patch
+gregkh-driver-driver-core-convert-to-use-class_find_device-api.patch
+gregkh-driver-driver-core-update-some-prototypes-in-platformtxt.patch
+gregkh-driver-driver-core-remove-unneeded-get_-device-driver-calls.patch
+gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

 driver tree updates

-revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch

 Unneeded

+git-drm-fix.patch

 Fix git-drm build

+jdelvare-i2c-i2c-algos-fix-typos.patch
+jdelvare-i2c-i2c-pca-01-removing-trailing-whitespace.patch

 i2c tree updates

-i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch

 Folded into i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch

+adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
+adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch

 New sensor driver

-hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
-hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
-hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch

 Dropped, I think.

+gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch
+gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch

 gfs interface fixes

+ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch
+ia64-fix-userspace-compile-error-in-gcc_intrinh.patch
+ia64-make-pfm_get_task-work-with-virtual-pids.patch
+ia64-fix-ptrace-inside-a-namespace.patch
+ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch
+ia64-slim-down-__clear_bit_unlock.patch

 ia64 stuff I accumulated.

+infiniband-is-scrogged-again.patch

 Make infiniband compile

+i8042-non-x86-build-fix.patch

 Fix breakage in git-input.patch

+ata-drivers-ata-sata_mvc-needs-dmapoolh.patch

 Fix breakage in git-libata-all.patch

+ide-mm-ppc-fix-ifdefs-in-mediabay-driver.patch
+ide-mm-ide-remove-write-only-sata_misc-from-ide_hwif_t.patch
+ide-mm-ide-remove-redundant-bug_on-from-atapi_-reset_pollfunc.patch
+ide-mm-ide-remove-ide_setup_ports.patch
+ide-mm-ide-add-ide_read_-alt-status-inline-helpers.patch
+ide-mm-ide-add-ide_read_error-inline-helper.patch

 IDE tree updates

+fix-ide-mm-ppc-fix-ifdefs-in-mediabay-driver.patch

 Fix it

+updates-for-the-memstick-driver.patch

 Update the memstick driver

+memstick-git-busted.patch

 And disable it.  It might now miss the merge window: a direct consequence of
 the way in which the git-block tree is being "managed".

+mips-use-find_task_by_vpid-in-system-calls.patch

 Mips interface fixup

+drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch

 Make MTD build

+mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch

 MTD fix

-git-net-fix-conflicts.patch
-git-net-vs-git-lblnet.patch
-git-net-vs-git-lblnet-2.patch

 Now unneeded

+hamradio-fix-dmascc-section-mismatch.patch
+tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch

 Some net fixes

-git-netdev-all-fix-conflicts.patch
-git-net-vs-git-netdev-all.patch

 Now unneeded

+mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled.patch
+8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
+drivers-net-tlanc-compilation-warning-fix.patch
+drivers-net-dm9000c-vague-probably-wrong-build-fix.patch

 netdev things

-bluetooth-rfcomm-tty_close-before-destruct.patch

 Dropped

+hci_ldisc-fix-null-pointer-deref.patch
+rfcomm-tty-destroy-before-tty_close.patch

 New bluetooth things

-net-sunrpc-schedc-revert-git-net-changes.patch
-net-sunrpc-schedc-reapply-git-net-changes.patch

 Now unneeded

+parisc-new-termios-definitions.patch

 parisc update

+serial-mpsc-set-baudrate-when-brg-divider-is-set.patch

 serial driver fix

+gregkh-pci-pci-pci_enable_device_bars-fix-for-lpfc-driver.patch
+gregkh-pci-pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch
+gregkh-pci-pci-fix-4x-section-mismatch-warnings.patch

 PCI tree updates

-revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch

 Now unneeded

+fix-gregkh-pci-pci-pcie-aspm-support.patch

 Fix PCIE dependencies

-git-sched-fixup.patch

 Now unneeded

+sh-termios-ioctl-definitions.patch

 sh update

-git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch

 Now unneeded

+scsi-fix-isa-pcmcia-compile-problem.patch
+scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch

 scsi fix

+usb-ohci-sm501-driver-v2-fix.patch
+usb-yet-another-dell-wireless-cdma-evdo-modem.patch

 USB updates

+9p-fix-p9_printfcall-export.patch

 Fix v8fs build

+b43-fix-build-with-config_ssb_pcihost=n.patch

 wireless config fix

-revert-kvm-stuff-to-make-git-x86-apply.patch

 Now unneeded

-git-x86-fixup.patch
-git-x86-fixup-2.patch

 Now unneeded

+x86-amd-thermal-interrupt-support.patch
+x86-amd-thermal-interrupt-support-fix-2.patch
+x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch

 x86 updates

+x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
+x86-mmconf-enable-mcfg-early.patch
+x86-mmconf-enable-mcfg-early-cleanup.patch
+x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
+x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
+x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch

 Some things which straddle x86 and PCI.

-git-cryptodev-fixup.patch

 Now unneeded

+slub-fix-sysfs-refcounting.patch

 slub fix

+maps4-add-proc-pid-pagemap-interface-fix.patch

 Fix maps4-add-proc-pid-pagemap-interface.patch

-add-remove_memory-for-ppc64-2.patch
+add-remove_memory-for-ppc64-3.patch

 memory hot-remove update

+add-mm-argument-to-pte-pmd-pud-pgd_free-checkpatch-fixes.patch

 Fix add-mm-argument-to-pte-pmd-pud-pgd_free.patch

-config_highpte-vs-sub-page-page-tables.patch
-config_highpte-vs-sub-page-page-tables-fix.patch
-config_highpte-vs-sub-page-page-tables-fix-2.patch

 Dropped due to git-x86 churn

+document-about-lowmem_reserve_ratio.patch
+page-migraton-handle-orphaned-pages.patch
+page-migraton-handle-orphaned-pages-fix.patch
+mm-fix-pageuptodate-data-race.patch
+mm-fix-section-mismatch-warning-in-sparsec.patch
+writeback-speed-up-writeback-of-big-dirty-files.patch

 MM updates

+slob-fix-free-block-merging-at-head-of-subpage.patch
+slob-reduce-external-fragmentation-by-using-three-free-lists.patch
+slob-correct-kconfig-description.patch

 slob updates

+smack-version-11c-simplified-mandatory-access-control-kernel-fix.patch

 Fix smack-version-11c-simplified-mandatory-access-control-kernel.patch

+smack-socket-label-setting-fix.patch

 Another smack fix

+frv-use-find_task_by_vpid-in-cxn_pin_by_pid.patch

 frv interface update

+misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch
+hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch
+leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch
+b43-avoid-unregistering-device-objects-during-suspend.patch

 suspend/resume fixes

+uml-smp-locking-commentary.patch
+uml-implement-o_append.patch
+uml-remove-fakehd.patch
+uml-debug_shirq-fixes.patch
+uml-add-back-config_hz.patch
+uml-style-fixes-in-arch-um-sys-x86_64.patch
+uml-add-newlines-to-printks.patch
+uml-move-register-initialization.patch
+uml-remove-unused-fields-from-mm_context.patch
+uml-remove-topdir.patch
+uml-spelling-fix.patch
+uml-remove-map_cb.patch
+uml-fix-infinite-mconsole-loop.patch
+uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
+uml-ldt-mutex-conversion.patch
+uml-mconsole-mutex-conversion.patch
+uml-port-mutex-conversion.patch
+uml-defconfig-tweaks.patch
+uml-redo-the-calculation-of-nr_syscalls.patch
+uml-make-mconsole_stack-namespace-aware.patch

 UML updates

+address-hfs-on-disk-corruption-robustness-review-comments.patch

 HFS fix

+synclink_gt-fix-missed-serial-input-signal-changes.patch

 serial driver fix

+fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch

 Fix fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch

+drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch
+w1-w1_thermc-standardize-units-to-millidegrees-c.patch
+atari-floppy-rename-disk_type-to-atari_disk_type.patch

 Misc

+spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
+spi-superh-spi-using-sci.patch
+spi_imx-spelling-fixes.patch
+spi-omap2_mcspi-handles-omap3-too.patch
+spi_bfin-remove-useless-fault-path.patch
+spi_bfin-use-more-useful-gpio-labels.patch
+spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
+spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
+spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
+spi_bfin-headers-are-not-for-changelogs.patch

 SPI updates

+kprobes-kretprobe-user-entry-handler-updated.patch

 kprobes update

+fuse-fix-attribute-caching-after-create.patch
+fuse-save-space-in-struct-fuse_req.patch
+fuse-limit-queued-background-requests.patch

 fuse updates

-restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility.patch

 Unneeded

-rtc-add-support-for-the-s-35390a-rtc-chip.patch
-rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
-rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch

 Dropped

+add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
+add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
+driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
+rtc-add-support-for-epson-rtc-9701je-v2.patch
+rtc-add-support-for-epson-rtc-9701je-v4.patch
+rtc-ds1307-ds_1340-change-init.patch
+rtc-update-documentation-wrt-irq_set_freq.patch
+rtc-cleanup-example-code.patch

 RTC updates

+sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
+sm501fb-clear-framebuffer-memory-and-palette.patch
+atmel_lcdfb-backlight-control.patch
+atmel_lcdfb-backlight-control-tiny-rework.patch
+#
+ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
+ps3-use-symbolic-names-for-video-modes.patch
+ps3fb-kill-ps3fb_full_mode_bit.patch
+ps3fb-inline-macros-that-are-used-only-once.patch
+ps3fb-kill-ps3fb_res.patch
+ps3fb-make-frame-buffer-offsets-unsigned-int.patch
+ps3fb-add-support-for-configurable-black-borders.patch
+ps3fb-reorganize-modedb-handling.patch
+ps3fb-round-up-video-modes.patch
+ps3fb-cleanup-sweep.patch
+ps3fb-fix-modedb-typos.patch
+pm2fb-big-endian-fix.patch
+fb-sm501-ensure-console-suspended-before-saving-state.patch
+fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
+fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
+fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
+fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
+#
+fbcon-fix-color-generation-for-monochrome-framebuffer.patch
+i810fb-module-parameter-mode_option-inconsistent-with-other-framebuffer-modules.patch

 fbdev updates

+md-set-and-test-the-persistent-flag-for-md-devices-more-consistently.patch
+md-change-interate_mddev-to-for_each_mddev-fix.patch
+md-change-iterate_rdev-to-rdev_for_each-fix.patch
+md-fix-an-occasional-deadlock-in-raid5-fix.patch

 RAID fixes

+pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars.patch

 pnp fix

+bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
+bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
+bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch

 bkl removal

+jbdh-hide-kernel-only-code.patch
+ext3-fix-lock-inversion-in-direct-io.patch
+ext3-fix-lock-inversion-in-direct-io-fix.patch

 ext3 updates

+keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch
+keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch

 Fix keep-track-of-mnt_writer-state-of-struct-file.patch

+kernel-doc-prevent-duplicate-description-output.patch
+kernel-doc-warn-on-badly-formatted-short-description.patch
+email-clientstxt-sylpheed-is-ok-at-imap.patch
+doc-use-correct-debugfs-mountpoint.patch

 Documentation

+memcontrol-move-mm_cgroup-to-header-file-fix.patch
+memcontrol-move-mm_cgroup-to-header-file-fix-2.patch

 Fix memcontrol-move-mm_cgroup-to-header-file.patch

+cgroups-update-comments-in-cpusetc.patch
+handle-pid-namespaces-in-cgroups-code.patch

 cgroups updates

+drivers-edac-i3000-document-type-promotion.patch

 edac fix

+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch

 More
 embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
 fallout

+introduce-path_put-cifs-fix.patch

 Fix introduce-path_put.patch

+d_path-make-d_path-use-a-struct-path-fix.patch

 Fix d_path-make-d_path-use-a-struct-path.patch

+char-mxser-remove-special-baudrate-processing.patch
+char-mxser-0-to-null-in-pointer.patch
+char-mxser-reorder-mxser_cardinfo-fields.patch
+char-mxser-simplify-mxser_get_serial_info.patch
+char-mxser-ioctl-cleanup.patch
+char-mxser-remove-it.patch
+char-mxser-add-support-for-cp-114ul.patch

 serial driver updates

+proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch

 Fix
 proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
 again

+wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch

 Fix wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch

+pidns-make-full-use-of-xxx_vnr-calls.patch
+pidns-fix-badly-converted-mqueues-pid-handling.patch

 PID namespace updates

+rewrite-rd-fix-2.patch

 Fix rewrite-rd.patch some more

+udf-cleanup-directory-offset-handling.patch
+udf-fix-adding-entry-to-a-directory.patch
+change-udf-maintainer.patch

 UDF updates

+update-checkpatchpl-to-version-013.patch

 checkpatch update

+remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch

 Remove deprecated exports

+random-clean-up-checkpatch-complaints.patch
+random-consolidate-wakeup-logic.patch
+random-use-unlocked_ioctl.patch
+random-reuse-rand_initialize.patch
+random-improve-variable-naming-clear-extract-buffer.patch
+random-make-backtracking-attacks-harder.patch
+random-remove-cacheline-alignment-for-locks.patch
+random-eliminate-redundant-new_rotate-variable.patch
+random-remove-some-prefetch-logic.patch
+random-simplify-add_ptr-logic.patch
+random-make-mixing-interface-byte-oriented.patch
+random-simplify-and-rename-credit_entropy_store.patch
+random-add-async-notification-support-to-dev-random.patch

 random driver updates

+the-scheduled-time-option-removal.patch

 Remove "time" boot option

+parport_ieee1284_epp_read_addr-patch.patch
+smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch

 DMI things

+maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
+atmel_serial-clean-up-the-code.patch
+atmel_serial-use-cpu_relax-when-busy-waiting.patch
+atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
+atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
+atmel_serial-split-the-interrupt-handler.patch
+atmel_serial-add-dma-support.patch
+atmel_serial-add-dma-support-fix.patch
+atmel_serial-fix-broken-rx-buffer-allocation.patch
+atmel_serial-use-container_of-instead-of-direct-cast.patch
+atmel_serial-show-tty-name-in-proc-interrupts.patch

 atmel_serial updates

+workqueue-make-delayed_work_timer_fn-static.patch
+isofs-implement-dmode-option.patch
+isofs-implement-dmode-option-fix.patch
+reiserfs-constify-function-pointer-tables.patch
+procfs-constify-function-pointer-tables.patch
+oss-constify-function-pointer-tables.patch

 Cleanups

+basic-pwm-driver-for-avr32-and-at91.patch
+basic-pwm-driver-for-avr32-and-at91-fix.patch
+pwm-led-driver.patch

 PWM driver

+bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch

 Cleanup

+remove-__strict_ansi__-from-linux-typesh.patch
+kill-do_generic_mapping_read.patch
+printk_ratelimit-functions-should-use-config_printk.patch

 Cleanups

+avoid-overflows-in-kernel-timec.patch

 time management fix

+drop-linux-ufs_fsh-from-userspace-export-and-relocate-it-to-fs-ufs-ufs_fsh.patch

 header file cleanup

+mount-options-add-documentation.patch
+mount-options-add-generic_show_options.patch
+mount-options-fix-adfs.patch
+mount-options-fix-affs.patch
+mount-options-fix-afs.patch
+mount-options-fix-autofs4.patch
+mount-options-fix-autofs.patch
+mount-options-fix-befs.patch
+mount-options-fix-capifs.patch
+mount-options-fix-devpts.patch
+mount-options-fix-ext2.patch
+mount-options-fix-fat.patch
+mount-options-fix-fuse.patch
+mount-options-fix-hostfs.patch
+mount-options-fix-hpfs.patch
+mount-options-fix-hugetlbfs.patch
+mount-options-fix-isofs.patch
+mount-options-fix-ncpfs.patch
+mount-options-fix-reiserfs.patch
+mount-options-fix-spufs.patch
+mount-options-fix-tmpfs.patch
+mount-options-fix-tmpfs-fix.patch
+mount-options-fix-udf.patch

 Fiddle with mount options

+char-applicom-use-pci_resource_start.patch
+char-applicom-use-pci_match_id.patch
+char-applicom-use-pci_match_id-fix.patch

 applicom driver updates

+nbd-remove-limit-on-max-number-of-nbd-devices.patch

 nbd update

+vfs-create-proc-pid-mountinfo.patch

 Add /proc/<pid>/mountinfo

+mm-bdi-export-bdi-attributes-in-sysfs.patch
+mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
+mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
+mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
+mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
+mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
+mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
+mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
+mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
+mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
+mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
+mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
+mm-bdi-move-statistics-to-debugfs.patch

 Export backing-dev_info things to userspace

+use-find_task_by_vpid-in-posix-timers.patch
+use-find_task_by_vpid-in-taskstats.patch
+dont-operate-with-pid_t-in-rtmutex-tester.patch
+deprecate-find_task_by_pid.patch
+remove-aout-interpreter-support-in-elf-loader.patch
+use-__u32-in-linux-reiserfs_fsh.patch

 Misc

+cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
+cpu-fix-section-mismatch-related-to-cpu_chain.patch
+cpu-do-not-annotate-exported-register_cpu_notifier.patch
+cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch

 CPU management updates

+getdelays-fix-gcc-warnings.patch
+add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
+add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
+convert-loglevel-related-kernel-boot-parameters-to-early_param.patch

 Misc

+reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch

 reiser4 fix

+page-owner-tracking-leak-detector-broken-on-s390.patch

 page-owner-tracking-leak-detector.patch broke on s390




3708 commits in 1565 patch files


All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/patch-list


