Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXGJIcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXGJIcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXGJIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:32:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXGJIcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:32:13 -0400
Date: Tue, 10 Jul 2007 01:31:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: -mm merge plans for 2.6.23
Message-Id: <20070710013152.ef2cd200.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When replying, please rewrite the subject suitably and try to Cc: the
appropriate developer(s).



add-lzo1x-algorithm-to-the-kernel.patch
make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch

 Merge

serial-assert-dtr-for-serial-console-devices.patch

 Don't know.  I worry about Russell's concern (see the changelog)

git-acpi-s390-struct-bin_attribute-changes.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
fix-empty-macros-in-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch

 Sent to lenb

working-3d-dri-intel-agpko-resume-for-i815-chip.patch

 Sent to davej

cifs-use-simple_prepare_write-to-zero-page-data.patch
cifs-zero_user_page-conversion.patch

 Sent to sfrench

bugfix-cpufreq-in-combination-with-performance-governor.patch
restore-previously-used-governor-on-a-hot-replugged-cpu.patch

 Sent to davej

kcopyd-use-mutex-instead-of-semaphore.patch

 Sent to agk

powerpc-promc-remove-undef-printk.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
powerpc-tlb_32c-build-fix.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch

 Sent to paulus

revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
driver-core-coding-style-cleanup.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
nozomi-remove-termios-checks-from-various-old-char-serial-drivers.patch

 Sent to greg

git-dvb-saa7134-tvaudio-fix.patch
dvb_en_50221-convert-to-kthread-api.patch

 Sent to mchehab

hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
applesmc-add-temperature-sensors-set-for-macbook.patch
ams-switch-to-using-input-polldev.patch

 Sent to mhoffman

sn-correct-rom-resource-length-for-bios-copy.patch

 Sent to Tony

make-input-layer-use-seq_list_xxx-helpers.patch
touchscreen-fujitsu-touchscreen-driver.patch
serio_raw_read-warning-fix.patch
tsdev-fix-broken-usecto-millisecs-conversion.patch

 Sent to Dmitry

use-posix-bre-in-headers-install-target.patch
modpost-white-list-pattern-adjustment.patch
strip-config_-automatically-in-kernel-configuration-search.patch
fix-the-warning-when-running-make-tags.patch
kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch

 Sent to Sam

led_colour_show-warning-fix.patch

 Sent to rpurdie

libata-config_pm=n-compile-fix.patch
pata_acpi-restore-driver.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
libata-implement-ata_wait_after_reset.patch
sata_promise-sata-hotplug-support.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
sata_nv-allow-changing-queue-depth.patch
pata_hpt3x3-major-reworking-and-testing.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch

 Sent to jgarzik

libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch

 Am sitting on these due to confusion regarding the status of the ata-ahci
 patches.

ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch

 These appear to need some work.

libata-add-human-readable-error-value-decoding.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch

 Dead/dying/abandoned ata things.  Might drop.

mips-make-resources-for-ds1742-static-__initdata.patch

 Sent to Ralf.

tty-add-the-new-ioctls-and-definitionto-the-mips.patch

 Awaiting merge of
 lots-of-architectures-enable-arbitary-speed-tty-support.patch

mmc-at91_mci-typo.patch

 Sent to drzeus

mtd-onenand-build-fix.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
mtd-add-module-license-to-mtdbdi.patch

 Sent to dvmw2

8139too-force-media-setting-fix.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch
sundance-phy-address-form-0-only-for-device-id-0x0200.patch
use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
3csoho100-tx-needs-extra_preamble.patch

 Sent to jgarzik

3x59x-fix-pci-resource-management.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch

 netdev patches which are stuck in limbo land.

make-atm-driver-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
net-ipv4-netfilter-ip_tablesc-lower-printk-severity.patch
rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch

 Sent to davem (mostly merged now, I think)

bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch

 Sent to Marcel

git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
fix-i-oat-for-kexec.patch

 I don't seem to be able to get rid of these.  Chris Leech appears to have
 vanished.

auth_gss-unregister-gss_domain-when-unloading-module.patch

 Sent to Trond and Bruce, needs work.

pa-risc-use-page-allocator-instead-of-slab-allocator.patch

 Sent to Kyle

pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
use-menuconfig-objects-pcmcia.patch

 Am a bit stuck with the pcmcia patches.  Dominik has disappeared.

pcmcia-pccard-deadlock-fix.patch

 I think this isn't a good patch.  Am holding onto it as a reminder that
 pcmcia deadlocks.

dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch

 Serial stuff.  Will run these past rmk and Alan and will merge them if they
 survive.

revert-gregkh-pci-pci_bridge-device.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
pci-x-pci-express-read-control-interfaces-fix.patch
remove-pci_dac_dma_-apis.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
add-pci_try_set_mwi.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
pci_set_power_state-check-for-pm-capabilities-earlier.patch

 Sent to Greg

s390-rename-cpu_idle-to-s390_cpu_idle.patch

 Sent to Martin.

restore-acpi-change-for-scsi.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
aacraid-rename-check_reset.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
drivers-scsi-small-cleanups.patch
sym53c8xx_2-claims-cpqarray-device.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
pci-error-recovery-symbios-scsi-base-support.patch
pci-error-recovery-symbios-scsi-first-failure.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
use-menuconfig-objects-ii-scsi.patch
remove-dead-references-to-module_parm-macro.patch
ppa-coding-police-and-printk-levels.patch
remove-the-dead-cyberstormiii_scsi-option.patch
config_scsi_fd_8xx-no-longer-exists.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch

 Sent to James.

scsi-lpfc-lpfc_initc-remove-unused-variable.patch

 Will add to the James queue once add-pci_try_set_mwi.patch is merged.

use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
update-documentation-block-barriertxt.patch

 Sent to Jens.

videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch

 Sent to davem

fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
drivers-block-ubc-use-list_for_each_entry.patch
ftdi_sio-fix-something.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
mos7840c-turn-this-into-a-serial-driver.patch
pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch
visor-and-whiteheat-remove-bogus-termios-change-checks.patch
mos7720-remove-bogus-no-termios-change-check.patch
io_-remove-bogus-termios-no-change-checks.patch
usb-remove-makefile-reference-to-obsolete-ohci_at91.patch

 Sent to Greg.

use-list_for_each_entry-for-iteration-in-prism-54-driver.patch

 Sent to linville

revert-x86_64-mm-verify-cpu-rename.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
update-x86_64-mm-xen-use-iret-directly-where-possible.patch
i386-add-support-for-picopower-irq-router.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
quicklist-support-for-x86_64.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
x86_64-mcelog-tolerant-level-cleanup.patch
x86_64-mce-poll-at-idle_start-and-printk-fix.patch
i386-fix-machine-rebooting.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
x86_64-ratelimit-segfault-reporting-rate.patch
x86_64-pm_trace-support.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-remove-support-for-the-rise-cpu.patch
x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
paravirt-helper-to-disable-all-io-space-fix.patch
dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
i386-hpet-check-if-the-counter-works.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
kprobes-x86_64-fix-for-mark-ro-data.patch
kprobes-i386-fix-for-mark-ro-data.patch
divorce-config_x86_pae-from-config_highmem64g.patch
remove-unneeded-test-of-task-in-dump_trace.patch
i386-move-the-kernel-to-16mb-for-numa-q.patch
i386-show-unhandled-signals.patch
i386-minor-nx-handling-adjustment.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
move-functions-declarations-to-header-file.patch
x86_64-during-vm-oom-condition.patch
i386-during-vm-oom-condition.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-fix-wrong-comment-regarding-set_fixmap.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
clockevents-fix-typo-in-acpi_pmc.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
xen-fix-x86-config-dependencies.patch
x86_64-get-mp_bus_to_node-as-early.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch

 Sent to Andi

fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch
fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch
fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch

 Sent to Tim & David.

xtensa-enable-arbitary-tty-speed-setting-ioctls.patch

 Sent to czankel

kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
kgdb-section-fix.patch
kgdb_skipexception-warning-fix.patch
kgdb-ia64-fixes.patch
kgdb-bust-on-ia64.patch
kgdb-build-fix-2.patch

 Sent to Jason

pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch

 Will send these to maintainers once
 gregkh-pci-pci-add-pci-x-pci-express-read-control-interfaces.patch gets
 merged.

gen_estimator-fix-locking-and-timer-related-bugs.patch
netpoll-fix-a-leak-n-bug-in-netpoll_cleanup.patch

 I think these might be defunct.  Will let the net guys sort that out.

vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch

 This is scary.  Will sit and admire it until it has been demonstrated
 to be a net gain.

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch

 Merge

x86-initial-fixmap-support.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
change-zonelist-order-zonelist-order-selection-logic.patch
hugetlb-remove-unnecessary-nid-initialization.patch
mm-use-div_round_up-in-mm-memoryc.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
mm-alloc_large_system_hash-can-free-some-memory-for.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
vmscan-fix-comments-related-to-shrink_list.patch

 mm stuff: will merge.

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
invalidate_mapping_pages-add-cond_resched.patch
ocfs2-release-page-lock-before-calling-page_mkwrite.patch
document-page_mkwrite-locking.patch

 The fault-vs-invalidate race fix.  I have belatedly learned that these need
 more work, so their state is uncertain.

slub-support-slub_debug-on-by-default.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch
numa-mempolicy-trivial-debug-fixes.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
kill-vmalloc_earlyreserve.patch
mm-more-__meminit-annotations.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
madvise_need_mmap_write-usage.patch
slob-initial-numa-support.patch
mm-page_allocc-lower-printk-severity.patch
mm-avoid-tlb-gather-restarts.patch
mm-remove-ptep_establish.patch
mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch

 mm misc: will merge.

mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
gfs2-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
#adfs-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch

 pagefault-in-write deadlock fixes.  Will hold for 2.6.24.

fix-read-truncate-race.patch
make-sure-readv-stops-reading-when-it-hits-end-of-file.patch
fs-remove-some-aop_truncated_page.patch
remove-alloc_zeroed_user_highpage.patch

 Will merge if they're mergeable.

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch

 Mel's page allocator work.  Might merge this, but I'm still not hearing
 sufficiently convincing noises from a sufficient number of people over this.

create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch

 Mel's moveable-zone work.  In a similar situation.  We need to stop whatever
 we're doing and get down and work out what we're going to do with all this
 stuff.

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch

 The advanced process-memory-inspection interfaces.

 These weren't quite ready for 2.6.22 and nothing has changed in the past
 month or two.  Not looking like 2.6.23 material either.

lumpy-reclaim-v4.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch

 Lumpy reclaim.  In a similar situation to Mel's patches.  Stuck due to
 general lack or interest and effort.

mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch

 Merge.

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-document-fault_data-and-flags.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch

 Merge.

slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch

 These are slub changes which are dependent on Mel's stuff, and I have a note
 here that there were reports of page allocation failures with these.  What's
 up with that?


 Maybe I should just drop the 100-odd marginal-looking MM patches?  We're
 simply not showing compelling reasons for merging them and quite a lot of them
 are stuck in a 90% complete state.


slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch

 Slub stuff.  Will merge whatever's mergeable after the above droppage and
 stalls.

add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch

 Merge

fs-introduce-some-page-buffer-invariants.patch
nfs-invariant-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch

 Re-review, maybe merge.

memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch

 These are new, and are dependent on Mel's stuff.  Not for 2.6.23.

freezer-make-kernel-threads-nonfreezable-by-default.patch

 Merge, subject to re-review.

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch

 file-caps seems to be stuck.  There has been some movement lately, might
 merge it subject to suiable acks from suitable parties.

frv-connect-up-new-syscalls.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch

 Merge

blackfin-enable-arbitary-speed-serial-setting.patch

 Will send to Bryan when
 lots-of-architectures-enable-arbitary-speed-tty-support.patch is merged

nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch

 Merge

h8300-enable-arbitary-speed-tty-port-setup.patch
h8300-zimage-support-update.patch

 Merge

alpha-fix-trivial-section-mismatch-warnings.patch
fix-alpha-isa-support.patch

 Merge

arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
arm26-remove-broken-and-unused-macro.patch

 Will send to Ian

freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch

 Merge

m32r-enable-arbitary-speed-tty-rate-setting.patch

 Merge

etrax-enable-arbitary-speed-setting-on-tty-ports.patch
cris-replace-old-style-member-inits-with-designated-inits.patch

 Merge

uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
uml-debug_shirq-fixes.patch
uml-xterm-driver-tidying.patch
uml-pty-channel-tidying.patch
uml-handle-errors-on-opening-host-side-of-consoles.patch
uml-sigio-support-cleanup.patch
uml-simplify-helper-stack-handling.patch
uml-eliminate-kernel-allocator-wrappers.patch

 Merge

v850-enable-arbitary-speed-tty-ioctls.patch

 Merge

deprecate-smbfs-in-favour-of-cifs.patch

 Send to sfrench

cpuset-remove-sched-domain-hooks-from-cpusets.patch

 Stuck.

clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch

 ebiederm no likee.  Stuck.

cache-pipe-buf-page-address-for-non-highmem-arch.patch

 Ugly, will probably drop.

fix-rmmod-read-write-races-in-proc-entries.patch

 Merge

more-scheduled-oss-driver-removal.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
fix-jvc-cdrom-drive-lockup.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-uptime-in-proc.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
make-afs-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
fat-gcc-43-warning-fix.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drivers-block-z2ram-remove-true-false-defines.patch
fix-compiler-warnings-in-acornc.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
fix-up-codingstyle-in-isofs.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
mpu401-warning-fixes.patch
introduce-config_virt_to_bus.patch
pie-randomization.patch
remove-unused-tif_notify_resume-flag.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
only-send-sigxfsz-when-exceeding-rlimits.patch
procfs-directory-entry-cleanup.patch
8xx-fix-whitespace-and-indentation.patch
vdso-print-fatal-signals.patch
rtc-ratelimit-lost-interrupts-message.patch
reduce-cpusetc-write_lock_irq-to-read_lock.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
afs-implement-file-locking.patch
tty_io-use-kzalloc.patch
remove-clockevents_releaserequest_device.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
remove-useless-tolower-in-isofs.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
udf-coding-style-conversion-lindent.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
mutex_unlock-later-in-seq_lseek.patch
zs-move-to-the-serial-subsystem.patch
fs-block_devc-use-list_for_each_entry.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
remove-odd-and-misleading-comments-from-uioh.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
buffer-kill-old-incorrect-comment.patch
introduce-o_cloexec-take-2.patch
o_cloexec-for-scm_rights.patch
init-wait-for-asynchronously-scanned-block-devices.patch
atmel_serial-fix-break-handling.patch
documentation-proc-pid-stat-files.patch
seq_file-more-atomicity-in-traverse.patch
lib-add-idr_for_each.patch
lib-add-idr_remove_all.patch
remove-capabilityh-from-mmh.patch
kernel-utf-8-handling.patch
remove-sonypi_camera_command.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
ext3-ext4-orphan-list-check-on-destroy_inode.patch
ext3-ext4-orphan-list-corruption-due-bad-inode.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
taskstats-add-context-switch-counters.patch
sony-laptop-use-null-for-pointer.patch
undeprecate-raw-driver.patch
hfsplus-change-kmalloc-memset-to-kzalloc.patch
submitchecklist-update-fix-spelling-error.patch
add-support-for-xilinx-systemace-compactflash-interface.patch
fix-typo-in-prefetchh.patch
zsc-drain-the-transmission-line.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
remove-config_uts_ns-and-config_ipc_ns.patch

 Merge, subject to re-review.

user-namespace-add-the-framework.patch

 I still think the magical root-user thing in here is odd and perhaps poorly
 thought-out.

user-namespace-add-unshare.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
allow-softlockup-to-be-runtime-disabled.patch
dirty_writeback_centisecs_handler-cleanup.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
adjust-nosmp-handling.patch
ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
remove-unused-lock_cpu_hotplug_interruptible-definition.patch
kerneldoc-fix-in-audit_core_dumps.patch
introduce-compat_u64-and-compat_s64-types.patch
diskquota-32bit-quota-tools-on-64bit-architectures.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
update-procfs-guide-doc-of-read_func.patch
ext3-remove-extra-is_rdonly-check.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
doc-oops-tracing-add-code-decode-info.patch
drop-obsolete-sys_ioctl-export.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-jbd.patch

 Merge, subject to re-review

sys_time-speedup.patch

 Am skeptical about this one.

cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch
futex-tidy-up-the-code-v2.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
# drivers-pmc-msp71xx-gpio-char-driver.patch: david-b panned it
drivers-pmc-msp71xx-gpio-char-driver.patch
mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch
hfs-refactor-ascii-to-unicode-conversion-routine.patch
hfs-add-custom-dentry-hash-and-comparison-operations.patch
sprint_symbol-cleanup.patch

 Merge, svbject to re-review.

hwrng-add-type-categories.patch

 This generated a flamewar.  Wil probably drop.

fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
replace-obscure-constructs-in-fs-block_devc.patch
bd_claim_by_disk-fix-warning.patch
fs-reiserfs-cleanups.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
nbdcsock_xmit-cleanup-signal-related-code.patch
move-seccomp-from-proc-to-a-prctl.patch
make-seccomp-zerocost-in-schedule.patch
is_power_of_2-kernel-kfifoc.patch
parport_pc-it887x-fix.patch
is_power_of_2-ufs-superc.patch
codingstyle-add-information-about-trailing-whitespace.patch
codingstyle-add-information-about-editor-modelines.patch
uninline-check_signature.patch
add-werror-implicit-function-declaration.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch
add-missing-files-and-dirs-to-00-index-in-documentation.patch
remove-the-last-few-umsdos-leftovers.patch
update-documentation-filesystems-vfstxt-second-part.patch
rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch
make-cancel_xxx_work_sync-return-a-boolean.patch
ext3-fix-error-handling-in-ext3_create_journal.patch
ext4-fix-error-handling-in-ext4_create_journal.patch
modules-remove-modlist_lock.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
docs-static-initialization-of-spinlocks-is-ok.patch
kernel-printkc-document-possible-deadlock-against-scheduler.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
gitignore-update.patch
isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch
fix-trivial-typos-in-anon_inodesc-comments.patch
vsprintfc-optimizing-part-1-easy-and-obvious-stuff.patch
vsprintfc-optimizing-part-2-base-10-conversion-speedup-v2.patch
drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch
drivers-char-ipmi-ipmi_si_intfc-lower-printk-severity.patch
drivers-block-rdc-lower-printk-severity.patch
ext2-statfs-speed-up.patch
ext3-statfs-speed-up.patch
ext4-statfs-speed-up.patch
permit-mempool_freenull.patch
nls-remove-obsolete-makefile-entries.patch
compat32-ignore-the-loop_clr_fd-ioctl.patch
ia64-arbitary-speed-tty-ioctl-support.patch

 Merge, subject to re-review.

writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch

 I guess these should be merged.  There are still bugs in there which I think
 Ken Chen has fixed, but I haven't got onto that yet.

introduce-i_sync.patch
introduce-i_sync-fix.patch

 Merge, I guess.

ibmasm-whitespace-cleanup.patch
ibmasm-dont-use-extern-in-function-declarations.patch
ibmasm-miscellaneous-fixes.patch
ibmasm-must-depend-on-config_input.patch

 Merge.

sync_sb_inodes-propagate-errors.patch

 Needs work.

spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
crc7-support.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-tle620x-power-switch-driver.patch
spi-master-driver-for-xilinx-virtex.patch
spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x.patch
spi-omap2_mcspi-driver.patch
spi_txx9-controller-driver.patch

 Merge

move-page-writeback-acounting-out-of-macros.patch
ext2-balloc-use-io_error-label.patch

 Might merge.

ext2-reservations.patch

 Still needs decent testing.

use-mutex-instead-of-semaphore-in-capi-20-driver.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
update-isdn-tree-to-use-pci_get_device.patch
sane-irq-initialization-in-sedlbauer-hisax.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
isdn-capi-warning-fixes.patch
i4l-leak-in-eicon-idifuncc.patch

 Merge

use-menuconfig-objects-isdn-config_isdn_i4l.patch

 tilman didn't like it - might drop

i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch

 Merge

knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch

 Merge

couple-fixes-to-fs-ecryptfs-inodec.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch

 Merge

rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc_class-is-no-longer-considered-experimental.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-driver-for-ds1216-chips.patch
rtc-driver-for-ds1216-chips-fix.patch
rtc-ds1307-oscillator-restart-for-ds1337383940.patch

 Merge.

revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
revoke-vs-git-block.patch

 Don't know.  Need to ping suitable developers over this work.

lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch

 Merge

oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
remove-options-depending-on-oss_obsolete.patch

 Merge

unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch

 Don't know.  Need to ping suitable developers over this work.
 
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch

 Merge

fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
nvidiafb-add-proper-support-for-geforce-7600-chipset.patch
pm2fb-white-spaces-clean-up.patch
fbcon-set_con2fb_map-fixes.patch
fbcon-revise-primary-device-selection.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
vt-add-comment-for-unbind_con_driver.patch
68328fb-the-pseudo_palette-is-only-16-elements-long.patch
controlfb-the-pseudo_palette-is-only-16-elements-long.patch
cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
epson1355fb-color-setting-fixes.patch
fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
gbefb-the-pseudo_palette-is-only-16-elements-long.patch
macfb-fix-pseudo_palette-size-and-overrun.patch
offb-the-pseudo_palette-is-only-16-elements-long.patch
platinumfb-the-pseudo_palette-is-only-16-elements.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
q40fb-the-pseudo_palette-is-only-16-elements-long.patch
sgivwfb-the-pseudo_palette-is-only-16-elements-long.patch
tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch
atyfb-the-pseudo_palette-is-only-16-elements-long.patch
radeonfb-the-pseudo_palette-is-only-16-elements-long.patch
i810fb-the-pseudo_palette-is-only-16-elements-long.patch
intelfb-the-pseudo_palette-is-only-16-elements-long.patch
sisfb-fix-pseudo_palette-array-size-and-overrun.patch
matroxfb-color-setting-fixes.patch
pm3fb-fillrect-acceleration.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
matroxfb-color-setting-fixes-fix.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
fix-the-graphic-corruption-issue-on-ia64-machines.patch

 Merge

omap-add-ti-omap-framebuffer-driver.patch
omap-add-ti-omap1610-accelerator-entry.patch
omap-add-ti-omap1-internal-lcd-controller.patch
omap-add-ti-omap2-internal-display-controller-support.patch
omap-add-ti-omap1-external-lcd-controller-support-sossi.patch
omap-add-ti-omap2-external-lcd-controller-support-rfbi.patch
omap-add-external-epson-hwa742-lcd-controller-support.patch
omap-add-external-epson-blizzard-lcd-controller-support.patch
omap-lcd-panel-support-for-the-ti-omap-h4-board.patch
omap-lcd-panel-support-for-the-ti-omap-h3-board.patch
omap-lcd-panel-support-for-the-palm-tungsten-e.patch
omap-lcd-panel-support-for-palm-tungstent.patch
omap-lcd-panel-support-for-the-palm-zire71.patch
omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch
omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch
omap-lcd-panel-support-for-the-ti-omap-osk-board.patch
omap-lcd-panel-support-for-the-siemens-sx1-mobile-phone.patch

 Merge

use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch

 Merge

raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch

 Ping Neil

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch

 Merge

fallocate-implementation-on-i86-x86_64-and-powerpc.patch
fallocate-on-s390.patch
fallocate-on-ia64.patch
fallocate-on-ia64-fix.patch

 Merge.

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch

 Merge.

intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch

 Don't know.  I don't think there were any great objections, but I don't
 think much benefit has been demonstrated?

define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch

 Merge

arch-personality-independent-stack-top.patch
audit-rework-execve-audit.patch
mm-variable-length-argument-support.patch

 Merge.

ext4-zero_user_page-conversion.patch
ext4-remove-extra-is_rdonly-check.patch
is_power_of_2-ext4-superc.patch

 Send to tytso

fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch

 Merge, after poking suitable maintainers

kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch

 Merge

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch

 Merge

kernel-relayc-make-functions-static.patch

 Merge

configfsdlm-separate-out-__configfs_attr-into-configfsh.patch
configfsdlmocfs2-convert-subsystem-semaphore-to-mutex.patch
configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly.patch

 Merge, subject to Joel acks

use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch

 Merge

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-core-make-functions-static.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-new-intel-5000-mc-driver.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-mod-pci-poll-names.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
driver-edac-i5000-code-tidying.patch
driver-edac-edac_device-code-tidying.patch
driver-edac-mod-edac_align_ptr-function.patch
driver-edac-mod-edac_opt_state_to_string-function.patch
driver-edac-remove-file-edac_mc-h.patch

 Probably hold - there are sysfs issues and a large number of update patches
 in my inbox.  Might merge, undecided.

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-basic-container-framework-fix-3.patch
containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-tasks-file-interface-fix-2.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-make-cpusets-a-client-of-containers-whitespace.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
update-getdelays-to-become-containerstats-aware.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch

 Container stuff.  Hold, I guess.  I was expecting updates from Paul.

fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch

 Merge

lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch

 Merge

some-kmalloc-memset-kzalloc-tree-wide.patch

 Merge

reiser4-sb_sync_inodes.patch
reiser4-export-remove_from_page_cache.patch
reiser4-export-radix_tree_preload.patch
reiser4-export-find_get_pages.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch

 Hold.

make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
page-owner-tracking-leak-detector.patch
releasing-resources-with-children.patch
nr_blockdev_pages-in_interrupt-warning.patch
detect-atomic-counter-underflows.patch
device-suspend-debug.patch
#slab-cache-shrinker-statistics.patch
mm-debug-dump-pageframes-on-bad_page.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
add-debugging-aid-for-memory-initialisation-problems.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
keep-track-of-network-interface-renaming.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
squash-ipc-warnings.patch
random-warning-squishes.patch
w1-build-fix.patch

 -mm only things.

