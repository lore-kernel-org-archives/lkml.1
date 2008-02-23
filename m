Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbYBWTUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbYBWTUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYBWTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:20:26 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYBWTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:20:25 -0500
Date: Sat, 23 Feb 2008 11:20:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: mgross@linux.intel.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] copyright owner and author clean up for intel iommu and
 related files
Message-Id: <20080223112022.8e4fdde2.akpm@linux-foundation.org>
In-Reply-To: <20080223190649.GA8641@kroah.com>
References: <20080221181555.GA9593@linux.intel.com>
	<20080223000443.da075061.akpm@linux-foundation.org>
	<20080223190649.GA8641@kroah.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 11:06:49 -0800 Greg KH <greg@kroah.com> wrote:

> On Sat, Feb 23, 2008 at 12:04:43AM -0800, Andrew Morton wrote:
> > On Thu, 21 Feb 2008 10:15:55 -0800 mark gross <mgross@linux.intel.com> wrote:
> > 
> > > Index: linux-2.6.24-mm1/drivers/pci/dmar.c
> > 
> > I guess this is strictly a greg-pci-tree thing.  Greg, how do you want
> > to play intel-iommu?
> 
> Yes, I'll take those.  I'm pretty sure I even have the hardware here to
> test that the code doesn't crash :)
> 

ok..

I have another one queued for 2.6.26-via-greg:
pci-iova-rb-tree-setup-tweak.patch

And one queued for 2.6.25: iova-lockdep-false-alarm-fix.patch which
according to my current processes will be sent to you after I've tested it
a bit with "for 2.6.25?" in its Subject:

My list of for-2.6.25-after-a-bit-of-testing patches is large:


rtc-cmos-display-hpet-emulation-mode.patch
register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch
dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
uml-remove-unused-sigcontext-accessors.patch
uml-fix-helper_wait-calls-in-watchdog.patch
uml-fix-fp-register-corruption.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
nbd-make-nbd-default-to-deadline-i-o-scheduler.patch
efs-move-headers-out-of-include-linux.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
proc-add-rlimit_rttime-to-proc-pid-limits.patch
drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch
dmi-prevent-linked-list-corruption-resent.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
futex-fix-init-order.patch
futex-runtime-enable-pi-and-robust-functionality.patch
h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
kernel-doc-fix-function-pointer-parameter-parsing.patch
mpt-fusion-dont-oops-if-numphys==0.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
e100-do-suspend-shutdown-like-e1000.patch
dm-raid1-bitops-bug.patch
alloc_percpu-fails-to-allocate-percpu-data.patch
scsi-qla4xxx-ql4_isrc-unchangelogged-patch.patch
iova-lockdep-false-alarm-fix.patch
cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch
kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch
sh-revert-dreamcast-pci-change.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch
message-fusion-mptbasec-fix-use-after-frees.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
smack-update-for-file-capabilities.patch
fix-typo-in-tick-broadcastc.patch
dm-raid1c-fix-null-dereferences.patch
usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch
i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch
solve-section-mismatch-for-free_area_init_core.patch
#
cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
#
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch
#
#kernel-irq-chipc-irq-disable-shutdown-bug.patch: needs acks
kernel-irq-chipc-irq-disable-shutdown-bug.patch
#
#revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch: being worked on
#revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch
#
kthread-synchronization-issues.patch
#kthread-add-a-missing-memory-barrier-to-kthread_stop.patch: nop, do it in wake_up
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
fix-b43-driver-build-for-arm.patch
vt-notifier-fix-for-vt-switch.patch

