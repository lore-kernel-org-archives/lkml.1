Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXLWUkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXLWUkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXLWUkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:40:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbXLWUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:40:39 -0500
Date: Sun, 23 Dec 2007 12:39:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.24-rc6-mm1
Message-Id: <20071223123930.27f46d24.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 17:27:12 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Dec 23, 2007 8:30 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> [snip]
> > +agk-dm-dm-snapshot-use-uninitialized_var.patch
> > +agk-dm-dm-raid1-handle-write-failures.patch
> > +agk-dm-dm-raid1-report-fault-status.patch
> > +agk-dm-dm-raid1-fix-eio-after-log-failure.patch
> > +agk-dm-dm-raid1-handle-read-failures.patch
> > +agk-dm-dm-raid1-mark-and-clear-nosync-writes.patch
> >
> >  device-mapper tree updates
> [snip]
> > +gregkh-driver-kref-add-kref_set.patch
> > +gregkh-driver-kobject-convert-sys-firmware-acpi-to-use-kobject_create.patch
> > +gregkh-driver-kobject-change-net-bridge-to-use-kobject_create_and_add.patch
> > +gregkh-driver-kobject-change-gfs2-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-infiniband-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-firmware-eddc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-firmware-efivarsc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-cpufreq-cpufreqc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-edac-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-cpuidle-sysfsc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-pci-hotplug-pci_hotplug_corec-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-base-sysc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-arch-x86-kernel-cpu-intel_cacheinfoc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-acpi-systemc-to-use-kobject_create_and_add.patch
> > +gregkh-driver-kobject-change-drivers-block-pktcdvdc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-arch-sh-kernel-cpu-sh4-sqc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-net-ibmvethc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-parisc-pdc_stablec-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-arch-ia64-kernel-topologyc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-drivers-md-mdc-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_create_and_add.patch
> > +gregkh-driver-kobject-change-arch-x86-kernel-cpu-mcheck-mce_amd_64c-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-the-cris-iop_fw_loadc-code-is-broken.patch
> > +gregkh-driver-kobject-convert-drivers-base-classc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-drivers-base-corec-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-drivers-net-iseries_vethc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-fs-char_devc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-kernel-paramsc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-kernel-userc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-mm-slubc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-net-bridge-br_ifc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-driver-add-driver_add_kobj-for-looney-iseries_veth-driver.patch
> > +gregkh-driver-kobject-change-drivers-base-bus-to-use-kobject_init_and_add.patch
> > +gregkh-driver-kobject-convert-block-elevatorc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-block-ll_rw_blkc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-drivers-md-mdc-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-convert-kernel-modulec-to-use-kobject_init-add_ng.patch
> > +gregkh-driver-kobject-remove-kobject_add-as-no-one-uses-it-anymore.patch
> > +gregkh-driver-kobject-rename-kobject_add_ng-to-kobject_add.patch
> > +gregkh-driver-kobject-remove-kobject_init-as-no-one-uses-it-anymore.patch
> > +gregkh-driver-kobject-rename-kobject_init_ng-to-kobject_init.patch
> > +gregkh-driver-kobject-remove-kobject_register.patch
> > +gregkh-driver-kset-remove-kset_add-function.patch
> > +gregkh-driver-kobject-auto-cleanup-on-final-unref.patch
> > +gregkh-driver-kobject-convert-arch-from-kobject_unregister-to-kobject_put.patch
> > +gregkh-driver-kobject-convert-drivers-from-kobject_unregister-to-kobject_put.patch
> > +gregkh-driver-kobject-convert-fs-from-kobject_unregister-to-kobject_put.patch
> > +gregkh-driver-kobject-convert-remaining-kobject_unregister-to-kobject_put.patch
> > +gregkh-driver-kobject-remove-kobject_unregister-as-no-one-uses-it-anymore.patch
> > +gregkh-driver-driver-core-change-sysdev-classes-to-use-dynamic-kobject-names.patch
> > +gregkh-driver-kobject-remove-old-outdated-documentation.patch
> > +gregkh-driver-kobject-update-the-kobject-kset-documentation.patch
> > +gregkh-driver-kobject-add-sample-code-for-how-to-use-kobjects-in-a-simple-manner.patch
> > +gregkh-driver-kobject-add-sample-code-for-how-to-use-ksets-ktypes-kobjects.patch
> > +gregkh-driver-driver-core-use-list_head-instead-of-call-to-init_list_head-in-__init.patch
> [snip]
> > +md-support-external-metadata-for-md-arrays.patch
> > +md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
> > +md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
> > +md-allow-devices-to-be-shared-between-md-arrays.patch
> > +md-lock-address-when-changing-attributes-of-component-devices.patch
> > +md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
> >
> >  RAID updates
> 
> I have finally given up on using 2.6.24-rc3-mm2 with slub_debug=FZP to
> get more information out of the random crashes I had seen with that
> version. (Did not crash once with slub_debug, so no new information on
> what the cause was)
> 
> 2.6.24-rc6-mm1 does not boot for me.
> It starts my initrd, but when this wants to start the md devices it crashes:
> [   12.900887] Freeing unused kernel memory: 356k freed
> [   15.290320] Clocksource tsc unstable (delta = -558415384 ns)
> [   34.284845] md: Autodetecting RAID arrays.
> [   34.154076] md: Scanned 5 and added 5 devices.
> [   34.154076] md: autorun ...
> [   34.154080] md: considering sdc2 ...
> [   34.155472] md:  adding sdc2 ...
> [   34.156728] md:  adding sdb2 ...
> [   34.164080] md: sdb1 has different UUID to sdc2
> [   34.165836] md:  adding sda2 ...
> [   34.174080] md: sda1 has different UUID to sdc2
> [   34.175852] md: created md1
> [   34.176938] md: bind<sda2>
> [   34.184147] md: bind<sdb2>
> [   34.185219] md: bind<sdc2>
> [   34.186284] md: running: <sdc2><sdb2><sda2>
> [   34.194604] md: do_md_run() returned -22
> [   34.196123] md: md1 stopped.
> [   34.197267] md: unbind<sdc2>
> [   34.204105] md: export_rdev(sdc2)
> [   34.205426] md: unbind<sdb2>
> [   34.206548] md: export_rdev(sdb2)
> [   34.214102] md: unbind<sda2>
> [   34.215223] md: export_rdev(sda2)
> [   34.216544] md: considering sdb1 ...
> [   34.224083] md:  adding sdb1 ...
> [   34.225337] md:  adding sda1 ...
> [   34.226696] Unable to handle kernel paging request at 0000000034333545 RIP:
> [   34.228481]  [<ffffffff803b49a1>] kref_put+0x31/0x80
> [   34.231378] PGD 7e402067 PUD 7e924067 PMD 0
> [   34.233084] Oops: 0002 [1] SMP
> [   34.234076] last sysfs file: /sys/devices/virtual/block/md1/dev
> [   34.234076] CPU 3
> [   34.234076] Modules linked in:
> [   34.234076] Pid: 18, comm: events/3 Not tainted 2.6.24-rc6-mm1 #1
> [   34.234076] RIP: 0010:[<ffffffff803b49a1>]  [<ffffffff803b49a1>]
> kref_put+0x31/0x80
> [   34.234076] RSP: 0018:ffff81007ffd5e00  EFLAGS: 00010202
> [   34.234076] RAX: 0000000000000000 RBX: 0000000034333545 RCX: ffffffff80606270
> [   34.234076] RDX: 0000000000000040 RSI: ffffffff803b38b0 RDI: 0000000034333545
> [   34.234076] RBP: ffff81007ffd5e10 R08: 0000000000000001 R09: 0000000000000000
> [   34.234076] R10: ffffffff8094c430 R11: 0000000000000000 R12: ffffffff803b38b0
> [   34.234076] R13: ffff81011ed434d8 R14: ffffffff804d7d50 R15: ffff81011ff220f0
> [   34.234076] FS:  0000000000c7f870(0000) GS:ffff81011ff20280(0000)
> knlGS:0000000000000000
> [   34.234076] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   34.234076] CR2: 0000000034333545 CR3: 000000007e5bc000 CR4: 00000000000006e0
> [   34.234076] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   34.234076] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   34.234076] Process events/3 (pid: 18, threadinfo ffff81007ffd4000,
> task ffff81007ffd2000)
> [   34.234076] Stack:  ffff81011ed43460 ffff81011ff220c0
> ffff81007ffd5e20 ffffffff803b37e9
> [   34.234076]  ffff81007ffd5e40 ffffffff803b389b ffff81007ffd5e50
> ffff81011ed434e0
> [   34.234076]  ffff81007ffd5e50 ffffffff804d7d5d ffff81007ffd5eb0
> ffffffff80249775
> [   34.234076] Call Trace:
> [   34.234076]  [<ffffffff803b37e9>] kobject_put+0x19/0x20
> [   34.234076]  [<ffffffff803b389b>] kobject_del+0x2b/0x40
> [   34.234076]  [<ffffffff804d7d5d>] delayed_delete+0xd/0x10
> [   34.234076]  [<ffffffff80249775>] run_workqueue+0x175/0x210
> [   34.234076]  [<ffffffff8024a411>] worker_thread+0x71/0xb0
> [   34.234076]  [<ffffffff8024d9e0>] autoremove_wake_function+0x0/0x40
> [   34.234076]  [<ffffffff8024a3a0>] worker_thread+0x0/0xb0
> [   34.234076]  [<ffffffff8024d5fd>] kthread+0x4d/0x80
> [   34.234076]  [<ffffffff8020c4b8>] child_rip+0xa/0x12
> [   34.234076]  [<ffffffff8020bbcf>] restore_args+0x0/0x30
> [   34.234076]  [<ffffffff8024d5b0>] kthread+0x0/0x80
> [   34.234076]  [<ffffffff8020c4ae>] child_rip+0x0/0x12
> [   34.234076]
> [   34.234076]
> [   34.234076] Code: f0 ff 0b 0f 94 c0 31 d2 84 c0 74 0b 48 89 df 41 ff d4 ba 01
> [   34.234076] RIP  [<ffffffff803b49a1>] kref_put+0x31/0x80
> [   34.234076]  RSP <ffff81007ffd5e00>
> [   34.234076] CR2: 0000000034333545
> [   34.234080] ---[ end trace 303353bd9dfe95b0 ]---
> [   34.236037] md: created md0
> [   34.237125] md: bind<sda1>
> [   34.244088] md: bind<sdb1>
> [   34.245152] md: running: <sdb1><sda1>
> [   34.246626] md: do_md_run() returned -22
> [   34.254078] md: md0 stopped.
> [   45.657898] SysRq : Resetting
> 
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active raid1 sdb1[1] sda1[0]
>       9775424 blocks [2/2] [UU]
>       bitmap: 0/150 pages [0KB], 32KB chunk
> 
> md1 : active raid5 sdc2[2] sdb2[1] sda2[0]
>       605586048 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 2/145 pages [8KB], 1024KB chunk
> 
> unused devices: <none>
> 
> Should I blame the raid1 changes or the kobject changes?
> 

I don't know.  It could even be that both patch series are OK but when they
are combined, things fail.

Greg, Alasdair: the above looks like a preview of 2.6.25-rc1 :(

