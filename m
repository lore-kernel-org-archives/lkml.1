Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbXBHXHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbXBHXHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXBHXHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:07:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359AbXBHXHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:07:16 -0500
Date: Thu, 8 Feb 2007 15:07:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: -mm merge plans for 2.6.21
Message-Id: <20070208150710.1324f6b4.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting fed up of holding onto hundreds of patches against subsystem
trees, sending them over and over again seeing and nothing happen.  I sent 242
patches out to subsystem maintainers on Monday and look at what's still here.



rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
ufs-restore-back-support-of-openstep.patch
hugetlb-preserve-hugetlb-pte-dirty-state.patch
md-fix-various-bugs-with-aligned-reads-in-raid5.patch
knfsd-fix-a-race-in-closing-nfsd-connections.patch
md-avoid-possible-bug_on-in-md-bitmap-handling.patch
v9fs_vfs_mkdir-fix-a-double-free.patch
enable-mouse-button-23-emulation-for-x86-macs.patch
mm-show-bounce-pages-in-oom-killer-output.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
sh-vdso-use-install_special_mappingpatch.patch

  Submitted.

x86-fix-vdso-mapping-for-aout-executables.patch

  a.out executables are presently non-functional.  This patch needs more work.

use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch

  -> neilb

acpi-bay-remove-acpi-driver-struct.patch
acpi-bay-driver-warning-fix.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
asus_acpi-add-support-for-asus-z81sp.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
ifdef-acpi_future_usage-acpi_os_readable.patch

  -> lenb

agpgart-allow-drm-populated-agp-memory-types-tidy.patch

  -> davej

arm-imx-serial-fix-tx-buffer-overflows.patch
arm-imx-serial-fix-irq-allocation.patch
amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch
at91-correct-value-for-at91_rstc_key.patch
arch-arm-use-array_size-macro-when-appropriate.patch

  -> rmk

avr32-fix-build-breakage.patch
arch-avr32-use-array_size-macro-when-appropriate.patch

  -> hskinnemoen

remove-hotplug-cpu-crap-from-cpufreq.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch

  -> davej

powerpc-rtas-msi-support.patch

  -> paulus, I guess.  The MSI people still need to argue about this.

fix-gregkh-driver-sys-modules-holders.patch
kobject-kobj-k_name-verification-fix.patch
spider-fix-gregkh-driver-network-device.patch
driver-core-per-subsystem-multithreaded-probing.patch
powerpc-make-it-compile.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
fix-warning-in-device_add_attrs.patch

  -> gregkh

drivers-char-drm-drm_mmc-remove-unused-exports.patch
update-readmedrm-bugzilla-7933.patch
drm-use-array_size-macro-when-appropriate.patch

  -> airlied

avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch

  -> mchehab

i2c-tsl2550-support.patch

  -> khali

infiniband-work-around-gcc-bug-on-sparc64.patch
ehca-fix-memleak-on-module-unloading.patch

  -> roland

crash-on-evdev-disconnect.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
hil-small-fix.patch
wistron-button-support-for-fujitsu-siemens-amilo-d88x0.patch
setstream-param-for-psmouse.patch
input-schedule-removal-of-compaq-touchscreen.patch

  -> dtor

search-a-little-harder-for-mkimage.patch
make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
add-mailmap-for-proper-git-shortlog-output.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
qconf-relocate-search-command.patch
qconf-fix-showing-help-info-on-failed-search.patch
qconf-back-button-behaviour-normalization.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
new-toplevel-target-headers_check_all.patch

  kbuild stuff.  Will merge.

sis-warning-fixes.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch

  -> jeff

libata-fix-hopefully-all-the-remaining-problems-with.patch

  Hold.

git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch

  -> dan.j.williams

mips-eisa-registration-with-config_eisa.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-update-to-the-driver-model-fix.patch
mips-turbochannel-support-for-the-decstation.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
mips-remove-smp_tune_scheduling.patch

  umm, not sure.  I thought Ralf was going to merge these but he got shy. 
  They'll get into 2.6.21 somehow.

mtd_ck804xrom-must-depend-on-pci.patch
mtd-add-missing-kernel-doc-item.patch

  -> dwmw2

8139too-force-media-setting-fix.patch
sundance-change-phy-address-search-from-phy=1-to-phy=0.patch
user-of-the-jiffies-rounding-code-e1000.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch

  -> jeff

3x59x-fix-pci-resource-management.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
natsemi-add-support-for-using-mii-port-with-no-phy.patch

 Hold.

tulip-fix-shutdown-dma-irq-race.patch
tulip-fix-for-64-bit-mips.patch
tulip-natsemi-dp83840a-phy-fix.patch

 -> val_henson

atm-use-array_size-macro-when-appropriate.patch

 -> davem

ioat-warning-fix.patch
fix-i-oat-for-kexec.patch

 -> christopher.leech

auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
nfs-fix-congestion-control-v4.patch

 -> trond.myklebust

parisc-fix-module_param-iommu-permission.patch
pa-risc-fix-bogus-warnings-from-modpost.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch

 -> kyle

remove-useless-find_first_bit-macro-from-cardbusc.patch

 -> Dominik

r8169-warning-fixes.patch

 -> romieu

8250-uart-backup-timer.patch
serial-trivial-code-flow-simplification.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
serial-replace-kmallocmemset-with-kzalloc.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
8250-make-probing-for-txen-bug-a-config-option.patch

 argh, serial patches.  I'll rereview these and will likely submit most or
 all of them.

make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
pci-add-systems-for-automatic-breadth-first-device-sorting.patch
pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch

 -> greg

pci-device-ensure-sysdata-initialised-v2.patch
x86-fix-dev_to_node-for-x86-and-x86_64.patch

 -> jeff

s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch

 -> schwidefsky

drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
remove-unnecessary-check-in-drivers-scsi-sgc.patch
remove-extra-newline-from-info-message.patch
fix-scsi-scsi_transporth-compile-error.patch
pci_module_init-convertion-in-the-legacy-megaraid-driver.patch
pci_module_init-convertion-in-tmscsimc.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
scsi-whitespace-cleanup-in-the-dpt-driver.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
drivers-scsi-aic7xxx-make-functions-static.patch
sym53c8xx_2-claims-cpqarray-device.patch
drivers-scsi-wd33c93c-cleanups.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
fix-the-reproducible-oops-in-scsi.patch
scsi-handle-bad-inquiry-responses.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
drivers-scsi-aacraid-cleanups.patch
scsi-megaraid_sas-stop-cmd-processing-if.patch
scsi-megaraid_sas-added-bios_param-in.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-update-version-and-author-info.patch

 -> James.Bottomley

git-block-dupe-definitions.patch
git-block-xfs-barriers-broke.patch

 -> jens.axboe

fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch
nokia-e70-is-an-unusual-device.patch
usb_rtl8150-must-select-mii.patch
input-hid-add-cidc-usb-device-to-hid-blacklist.patch
usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
fix-apparent-typo-config_usb_cdcether.patch
pl2303-willcom-ws002in-support.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
usb-p990i-is-an-unusual-device.patch
usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
ueagle-atmc-needs-schedh.patch

 -> greg

replace-incorrect-macro-name-wireless_ext-with.patch

 -> linville

x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
x86-64-system-crashes-when-no-memory-populating-node-0.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
#i386-modpost-apic-related-warning-fixes.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
i386-probe_roms-cleanup.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
fix-mtrr-compat-ioctl.patch

 -> ak

xfs-remove-useless-wmb-memory-barrier.patch

 -> dcg

slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch
slab-cache-alloc-cleanups.patch
use-parameter-passed-to-cache_reap-to-determine-pointer-to.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
add-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
add-nopfn_refault-result-from-vm_ops-nopfn.patch
avoid-excessive-sorting-of-early_node_map.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
page_mkwrite-race-fix.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-inactive-and-active-counts-up-fix.patch
use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix.patch
use-zvc-for-free_pages-fix-2.patch
use-zvc-for-free_pages-fix-3.patch
use-zvc-for-free_pages-fix-4.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-free_pages-fix.patch
drop-free_pages-sparc64-fix.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch

 MM.  Will merge.

lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
lumpy-reclaim-cleanup.patch

 Needs more work.

deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
optional-zone_dma-in-the-vm-tidy.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

 barf.  Will probably merge.

simplify-shmem_aopsset_page_dirty-method.patch
convert-ramfs-to-use-__set_page_dirty_no_writeback.patch
do-not-disturb-page-referenced-state-when-unmapping-memory-range.patch

 Will merge.  The third patch here might perturb page aging a bit and needs
 monitoring.

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch

 I don't know.  Need to poke the security guys again.

make-reading-proc-sys-kernel-cap-bould-not-require.patch

 Will merge.

alpha-increase-percpu_enough_room.patch

 Will merge.

arch-arm26-use-array_size-macro-when-appropriate.patch

 Will merge.

pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-order-in-diskc-fix.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
swsusp-change-pm_ops-handling-by-userland-interface-fix.patch

 Will merge

m32r-build-fix-for-processors-without-isa_dsp_level2.patch
m32r-fix-do_page_fault-and-update_mmu_cache.patch
m32r-update-defconfig-files-for-v2619.patch
m32r-fix-kernel-entry-address-of-vmlinux.patch
m32r-cosmetic-updates-and-trivial-fixes.patch

 Will merge.

m68k-work-around-binutils-tokenizer-change.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh.patch

 Will merge.

cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
arch-cris-user-array_size-macro-when-appropriate.patch

 Will merge.

uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch

 Will merge.

arch-v850-user-array_size-macro-when-appropriate.patch

 Will merge.

deprecate-smbfs-in-favour-of-cifs.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch

 Will re-poll sfrench.  Probably no-merge.

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-update-4.patch
drivers-add-lcd-support-update-5.patch
drivers-add-lcd-support-update6.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch

 Will merge.

cpuset-remove-sched-domain-hooks-from-cpusets.patch

 Hold.

doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch

 Might hold.

add-retain_initrd-boot-option.patch
add-retain_initrd-boot-option-tweak.patch

 Vivek didn't like this.  I need to re-poll.

vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
remove-include-linux-byteorder-pdp_endianh.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
count_vm_events-warning-fix.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
disable-init-initramfsc-updated.patch
disable-init-initramfsc-updated-fix.patch
disable-init-initramfsc-architectures.patch
usr-gen_init_cpioc-support-for-hard-links.patch
ioc3-ioc4-pci-mem-space-resources.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch
avoid-one-conditional-branch-in-touch_atime.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
igrab-should-check-for-i_clear.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
drivers-char-vc_screenc-proper-prototypes.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
serial-serial_txx9-driver-update.patch
relay-add-cpu-hotplug-support.patch
ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
consolidate-default-sched_clock.patch
pktcdvd-cleanup.patch
pnp-export-pnp_bus_type.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-mxser_new-upgrade-to-1915-fix.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
docbook-html-generate-chapter-section-level-tocs-for-functions.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
export-invalidate_mapping_pages-to-modules.patch
remove-invalidate_inode_pages.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
fix-sparse-warnings-from-asmnet-checksumh.patch
add-an-rcu-version-of-list-splicing.patch
add-an-rcu-version-of-list-splicing-fix.patch
ipmi-fix-some-rcu-problems.patch
ipmi-fix-some-rcu-problems-update.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
factor-outstanding-i-o-error-handling.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch
add-const-for-timespecval_compare-arguments.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
kernel-doc-allow-a-little-whitespace.patch
proc-remove-useless-and-buggy-nlink-settings.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
tty-improve-encode_baud_rate-logic.patch
simplify-the-stacktrace-code.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
common-compat_sys_sysinfo-v2.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
local_t-documentation.patch
local_t-documentation-fix.patch
rtc-framework-driver-for-cmos-rtcs.patch
rtc-framework-driver-for-cmos-rtcs-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix-2.patch
acpi-updates-rtc-cmos-device-platform_data.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
serial-support-for-new-board.patch
cleanup-linux-byteorder-swabbh.patch
ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
seq_file-conversion-coda.patch
fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch
seq_file-conversion-toshibac.patch
return-enoent-from-ext3_link-when-racing-with-unlink.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
remove-ext_inc_count-and-_dec_count.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
documentation-rbtreetxt-updated.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
buffer-memorder-fix.patch
remove-final-reference-to-superfluous-smp_commence.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
some-rtc-documentation-updates.patch
drivers-block-dac960-converted-boolean-to-bool.patch
mxser-remove-useless-fields.patch
fix-apparent-typo-config_lockdep_debug.patch
ext-jbd-layer-function-called-instead-of-fs-specific-one.patch
highmem-catch-illegal-nesting.patch
change-constant-zero-to-notify_done-in-ratelimit_handler.patch
fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch
_proc_do_string-fix-short-reads.patch
move-task_xacct-task_io_accounting-up-in-menus.patch
ifdef-rchar-wchar-syscr-syscw-from-task_struct.patch
tty-cleanup-release_mem.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy-fixes.patch
rapidio-fix-multi-switch-enumeration.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232.patch
fix-d_path-for-lazy-unmounts.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
include-linux-kernelh-remove-labs.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
maintainers-remove-two-dead-e-mail.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
fix-the-defaults-mentioned-in-documentation-nfsroottxt.patch
scnprintf-fix-comment.patch
move-remove_dquot_ref-to-dqoutc.patch
remove-sb-s_files-and-file_list_lock-usage-in-dquotc.patch
inotify-read-return-val-fix.patch
debug-shared-irqs.patch
debug-shared-irqs-kconfig-fix.patch
kernel-shut-up-the-irq-mismatch-messages.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch
ipc-save-the-ipc-namespace-while-reading-proc-files.patch
warning-fix-unsigned-signed.patch
atmel_serial-use-__raw-i-o-register-access.patch
swiotlb-uninlinings.patch
kexec-fix-references-to-init-in-documentation-for-kexe.patch
lockdep-forward-declare-struct-task_struct.patch
com20020-build-fix.patch
fs-speedup-rw_verify_area.patch
drivers-isdn-gigaset-reduce-mutex-scope.patch
drivers-isdn-gigaset-reduce-kernel-message-spam.patch
close_files-add-scheduling-point.patch

 Misc.  Will mostly-merge.  A few of the above need people to be re-polled.

spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-bis.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
spi-remove-return-in-spi_unregister_driver.patch
spi_bitbang-use-overridable-setup_transfer-method.patch
spi-cleanup-method-param-becomes-non-const.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
spi-eeprom-driver-cleanups.patch
spi-eeprom-learns-about-8-and-24-bit-addressing.patch

 Will merge.

add-shared-version-of-apm-emulation.patch
arm-convert-to-use-shared-apm-emulation.patch
mips-convert-to-use-shared-apm-emulation.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
sh-convert-to-use-shared-apm-emulation.patch

 Will merge.

minix-v3-support.patch

 Will merge.

make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch

 Am a bit wobbly about this due to the additional overhead.  Opinions are
 sought.


tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch

 Will merge.

vmi-versus-hrtimers.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
#tick-management-dyntick--highres-functionality-fix.patch
#tick-management-dyntick--highres-functionality-fix-2.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch

 hrtimers, dynticks, use generic-time on x86_64: will merge.

genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch

 Will merge.

schedule_on_each_cpu-use-preempt_disable.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch

 umm, not sure.  Need to re-review and poke Oleg.


extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch

 Will merge.

slab-shutdown-cache_reaper-when-cpu-goes-down.patch

 Will merge.

move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
per-backing_dev-dirty-and-writeback-page-accounting-fix.patch

 Hold.

ext2-reservations.patch
ext2-fix-reservation-extension.patch
make-ext2_get_blocks-static.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch

 I don't know how much testing this has had.  Will hold.

edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-fix-in-e752x-mc-driver.patch
edac-add-memory-scrubbing-controls-api-to-core.patch
edac-add-fully-buffered-dimm-apis-to-core.patch

 Will merge.

edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-edac-make-code-static.patch
pci_module_init-convertion-for-k8_edacc.patch
edac-k8-driver-coding-tidy.patch
edac-k8-memory-scrubbing-patch.patch

 Can't seem to get Andi and Alan to agree over this.  Help.

gpio-core.patch
omap-gpio-wrappers.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers.patch
at91-gpio-wrappers-tidy.patch
pxa-gpio-wrappers.patch
sa1100-gpio-wrappers.patch
s3c2410-gpio-wrappers.patch

 Will merge.

drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
workaround-capi-subsystem-locking-issue.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch

 Will merge.

knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch

 Will merge.

ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-xattr-flags-and-mount-options.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-generalize-metadata-read-write-fix.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
ecryptfs-encrypted-passthrough.patch
ecryptfs-convert-f_op-write-to-vfs_write.patch
ecryptfs-convert-kmap-to-kmap_atomic.patch
ecryptfs-open-code-flag-checking-and-manipulation.patch
ecryptfs-add-flush_dcache_page-calls.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch

 Will merge.

fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch

 Will wait to see what happens with febrils.

aio-is-unlikely.patch

 Will merge.

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch

 I guess these are dependent upon fsaio.

sched-avoid-div-in-rebalance_tick.patch

 Will merge.

mm-only-sched-add-a-few-scheduler-event-counters.patch
sched2-sched-domain-sysctl.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch

 -mm only.

sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch

 Hold.

dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-alpha.patch
dynamic-kernel-command-line-arm.patch
dynamic-kernel-command-line-arm26.patch
dynamic-kernel-command-line-avr32.patch
dynamic-kernel-command-line-cris.patch
dynamic-kernel-command-line-frv.patch
dynamic-kernel-command-line-h8300.patch
dynamic-kernel-command-line-i386.patch
dynamic-kernel-command-line-ia64.patch
dynamic-kernel-command-line-ia64-fix.patch
dynamic-kernel-command-line-m32r.patch
dynamic-kernel-command-line-m68k.patch
dynamic-kernel-command-line-m68knommu.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
dynamic-kernel-command-line-s390.patch
dynamic-kernel-command-line-sh.patch
dynamic-kernel-command-line-sh64.patch
dynamic-kernel-command-line-sparc.patch
dynamic-kernel-command-line-sparc64.patch
dynamic-kernel-command-line-um.patch
dynamic-kernel-command-line-v850.patch
dynamic-kernel-command-line-x86_64.patch
dynamic-kernel-command-line-xtensa.patch
dynamic-kernel-command-line-fixups.patch
i386-2048-byte-command-line.patch
x86_64-2048-byte-command-line.patch
ia64-2048-byte-command-line.patch

 Will merge.

rcutorture-use-array_size-macro-when-appropriate.patch
rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

 Will merge.

rcu-split-classic-rcu.patch
rcu-softirq-for-rcu.patch
rcu-fix-barriers.patch

 Will merge.

#rcu-preemptible-rcu.patch
#rcu-debug-trace-for-rcu.patch

 These are in disgrace because some code is assuming that rcu_read_lock()
 implies preempt_disable(), and these patches make that untrue.

lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch

 Do we want this?  Ulrich says so.  Will merge, I guess.

ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch

 Will merge.

kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch

 Will merge.

utrace-utrace-tracehook.patch
utrace-utrace-tracehook-ia64.patch
utrace-utrace-tracehook-sparc64.patch
utrace-utrace-tracehook-s390.patch
utrace-utrace-regset.patch
utrace-utrace-regset-ia64.patch
utrace-utrace-regset-sparc64.patch
utrace-utrace-regset-s390.patch
utrace-utrace-core.patch
utrace-utrace-ptrace-compat.patch
utrace-utrace-ptrace-compat-ia64.patch
utrace-utrace-ptrace-compat-sparc64.patch
utrace-utrace-ptrace-compat-s390.patch

 utrace just got added to -mm.

readahead-kconfig-options.patch
readahead-kconfig-options-fix.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-sysctl-parameters-fix.patch
readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-remove-get_readahead_bounds.patch
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch

 Hold.

reiser4-sb_sync_inodes.patch
reiser4-sb_sync_inodes-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-radix_tree_preload.patch
reiser4-export-find_get_pages.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
reiser4-configh.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
reiser4-reiser4_drop_page-dont-call-remove_from_page_cache.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-bug-fixes.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch
reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch
reiser4-use-generic-file-read.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-possible-cleanups-2.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
#reiser4-fix-write_extent.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-fix-freeze-and-corruption.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
reiser4-vs-git-block3.patch

 Hold.

proper-backlight-selection-for-fbdev-drivers.patch
fbdev-driver-for-s3-trio-virge.patch
fbdev-driver-for-s3-trio-virge-update.patch
remove-broken-video-drivers-v4.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
remove-bogus-con_is_present-prototypes.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
proper-prototype-for-tosh_smm.patch
recognize-video=gx1fb-option.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
pm3fb-kill-pci_find_device-usage.patch
drivers-video-sis-convert-to-generic-boolean.patch
matroxfb-use-kzalloc.patch
remove-the-broken-fb_s3trio-driver.patch

 Will merge.

drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

 -> neilb

 (The second one is getting idiotic.  When are we going to fix this??)

remove-555-unneeded-includes-of-schedh.patch

 Will merge.

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
statistics-infrastructure-adapt-output-format-of-utilisation-indicator.patch
statistics-use-the-enhanced-percpu-interface.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
statistics-infrastructure-exploitation-zfcp.patch
zfcp-gather-hba-specific-latencies-in-statistics.patch

 Hold.

mark-pci_module_init-deprecated.patch

 Will merge.

oss-replace-kmallocmemset-combos-with-kzalloc.patch

 Will merge.

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
integrity-service-api-and-dummy-provider-cleanup-use-of-configh.patch
integrity-service-api-and-dummy-provider-compilation-warning-fix.patch
integrity-service-api-and-dummy-provider-fix.patch
slim-main-patch.patch
slim-main-patch-socket_post_create-hook-return-code.patch
slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch
slim-main-patch-handle-failure-to-register.patch
slim-main-patch-fix-bug-with-mm_users-usage.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-secfs-patch-slim-correct-use-of-snprintf.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch
panic-on-slim-selinux.patch

 Hold.

mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-4-fix.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
mark-struct-super_operations-const.patch

 Will merge.

scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch

 This removes SA_INTERRUPT and friends, so 10000000 external drivers won't
 compile any more.  I think I'd prefer to find a way to get usage of SA_* to
 spit a deprecated warning.

sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh-fix.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch

 Will merge if we can sort out the selinux problems.

make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
page-owner-tracking-leak-detector.patch
firestream-warnings.patch
releasing-resources-with-children.patch
nr_blockdev_pages-in_interrupt-warning.patch
detect-atomic-counter-underflows.patch
device-suspend-debug.patch
#slab-cache-shrinker-statistics.patch
mm-debug-dump-pageframes-on-bad_page.patch
make-frame_pointer-default=y.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000_7033_dump_ring.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

 -mm only stuff.


