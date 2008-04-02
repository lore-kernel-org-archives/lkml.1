Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYDBOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYDBOFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYDBOF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:05:26 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4011 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbYDBOFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:05:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 02 Apr 2008 14:02:26.0820 (UTC) FILETIME=[2EB86440:01C894CA]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] Fix kernel thread names that might offend users.
Date: Wed, 2 Apr 2008 10:02:16 -0400
Message-ID: <Pine.LNX.4.61.0804021000210.19372@chaos.analogic.com>
In-Reply-To: <87r6dps3db.fsf@saeurebad.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix kernel thread names that might offend users.
Thread-Index: AciUyi7CaVpfvY7sSTKUCi3IQt5p+g==
References: <87r6dps3db.fsf@saeurebad.de>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 1 Apr 2008, Johannes Weiner wrote:

> More and more GNOME users (especially Ubuntu) get confused by their
> process list showing several process names that seem to indicate
> KDE-related services.
>
> To settle things down a bit on the bugtrackers, this patch renames all
> offending kernel threads into something that goes better with
> GNOME-based systems.
>
> Since KDE is essentially dead, the thread-names are not made
> compile-time configurable but rather just renamed completely here to
> fit modern distributions.
>
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>
> Please note that these hard-coded names are going to be removed soon
> completely in another patch series that makes kernel thread names more
> `themable' in the sense that users may supply a format string in
> /proc/sys/kernel/kthread_fmt which allows having customizable names
> like "-=[acpid]=-" or similar.
>
> Also, please let me know if I forgot something.
>
> arch/x86/kernel/apm_32.c                    |    2 +-
> arch/x86/kernel/io_apic_32.c                |    2 +-
> arch/x86/mach-voyager/voyager_thread.c      |    2 +-
> block/blk-core.c                            |    3 +--
> drivers/acpi/osl.c                          |    4 ++--
> drivers/char/apm-emulation.c                |    2 +-
> drivers/char/hvc_console.c                  |    2 +-
> drivers/char/hvcs.c                         |    2 +-
> drivers/char/ipmi/ipmi_si_intf.c            |    2 +-
> drivers/cpufreq/cpufreq_ondemand.c          |    2 +-
> drivers/ieee1394/ieee1394_core.c            |    2 +-
> drivers/ieee1394/nodemgr.c                  |    2 +-
> drivers/input/gameport/gameport.c           |    2 +-
> drivers/input/mouse/psmouse-base.c          |    2 +-
> drivers/input/serio/serio.c                 |    2 +-
> drivers/macintosh/adb.c                     |    2 +-
> drivers/macintosh/therm_adt746x.c           |    2 +-
> drivers/macintosh/therm_pm72.c              |    3 +--
> drivers/macintosh/windfarm_core.c           |    3 +--
> drivers/md/dm-crypt.c                       |    4 ++--
> drivers/md/dm-delay.c                       |    2 +-
> drivers/md/dm-exception-store.c             |    2 +-
> drivers/md/dm-mpath.c                       |    2 +-
> drivers/md/dm-raid1.c                       |    2 +-
> drivers/md/dm-snap.c                        |    2 +-
> drivers/md/dm-stripe.c                      |    2 +-
> drivers/md/dm.c                             |    2 +-
> drivers/md/kcopyd.c                         |    2 +-
> drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    2 +-
> drivers/media/dvb/dvb-core/dvb_frontend.c   |    2 +-
> drivers/mfd/ucb1x00-ts.c                    |    2 +-
> drivers/mmc/core/core.c                     |    2 +-
> drivers/mmc/core/sdio_irq.c                 |    3 +--
> drivers/parisc/power.c                      |    2 +-
> drivers/pnp/pnpbios/core.c                  |    2 +-
> drivers/s390/cio/device.c                   |    2 +-
> drivers/s390/crypto/ap_bus.c                |    2 +-
> drivers/s390/s390mach.c                     |    2 +-
> drivers/sbus/char/bbc_envctrl.c             |    2 +-
> drivers/sbus/char/envctrl.c                 |    2 +-
> drivers/usb/core/hub.c                      |    2 +-
> fs/afs/flock.c                              |    2 +-
> fs/afs/rxrpc.c                              |    2 +-
> fs/afs/vlocation.c                          |    2 +-
> fs/jbd/journal.c                            |    3 +--
> fs/jbd2/journal.c                           |    3 +--
> kernel/kmod.c                               |    2 +-
> kernel/softirq.c                            |    2 +-
> kernel/stop_machine.c                       |    2 +-
> mm/vmscan.c                                 |    2 +-
> net/bluetooth/rfcomm/core.c                 |    2 +-
> net/core/pktgen.c                           |    2 +-
> net/rxrpc/af_rxrpc.c                        |    2 +-
> 53 files changed, 55 insertions(+), 61 deletions(-)
>
> diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
> index d4438ef..536b7ce 100644
> --- a/arch/x86/kernel/apm_32.c
> +++ b/arch/x86/kernel/apm_32.c
> @@ -2326,7 +2326,7 @@ static int __init apm_init(void)
> 	if (apm_proc)
> 		apm_proc->proc_fops = &apm_file_ops;
>
> -	kapmd_task = kthread_create(apm, NULL, "kapmd");
> +	kapmd_task = kthread_create(apm, NULL, "gapmd");
> 	if (IS_ERR(kapmd_task)) {
> 		printk(KERN_ERR "apm: disabled - Unable to start kernel "
> 				"thread.\n");
> diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
> index 4ca5486..8dd4ab1 100644
> --- a/arch/x86/kernel/io_apic_32.c
> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -700,7 +700,7 @@ static int __init balanced_irq_init(void)
> 	}
>
> 	printk(KERN_INFO "Starting balanced_irq\n");
> -	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
> +	if (!IS_ERR(kthread_run(balanced_irq, NULL, "girqd")))
> 		return 0;
> 	printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
> failed:
> diff --git a/arch/x86/mach-voyager/voyager_thread.c b/arch/x86/mach-voyager/voyager_thread.c
> index c69c931..88b110f 100644
> --- a/arch/x86/mach-voyager/voyager_thread.c
> +++ b/arch/x86/mach-voyager/voyager_thread.c
> @@ -112,7 +112,7 @@ static int thread(void *unused)
>
> static int __init voyager_thread_start(void)
> {
> -	voyager_thread = kthread_run(thread, NULL, "kvoyagerd");
> +	voyager_thread = kthread_run(thread, NULL, "gvoyagerd");
> 	if (IS_ERR(voyager_thread)) {
> 		printk(KERN_ERR
> 		       "Voyager: Failed to create system monitor thread.\n");
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2a438a9..e78051f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2040,7 +2040,7 @@ int __init blk_dev_init(void)
> {
> 	int i;
>
> -	kblockd_workqueue = create_workqueue("kblockd");
> +	kblockd_workqueue = create_workqueue("gblockd");
> 	if (!kblockd_workqueue)
> 		panic("Failed to create kblockd\n");
>
> @@ -2058,4 +2058,3 @@ int __init blk_dev_init(void)
>
> 	return 0;
> }
> -
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 065819b..e4c5738 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -200,8 +200,8 @@ acpi_status __init acpi_os_initialize(void)
>
> acpi_status acpi_os_initialize1(void)
> {
> -	kacpid_wq = create_singlethread_workqueue("kacpid");
> -	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
> +	kacpid_wq = create_singlethread_workqueue("gacpid");
> +	kacpi_notify_wq = create_singlethread_workqueue("gacpi_notify");
> 	BUG_ON(!kacpid_wq);
> 	BUG_ON(!kacpi_notify_wq);
> 	return AE_OK;
> diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
> index 17d5431..729c96d 100644
> --- a/drivers/char/apm-emulation.c
> +++ b/drivers/char/apm-emulation.c
> @@ -584,7 +584,7 @@ static int __init apm_init(void)
> 		return -ENODEV;
> 	}
>
> -	kapmd_tsk = kthread_create(kapmd, NULL, "kapmd");
> +	kapmd_tsk = kthread_create(kapmd, NULL, "gapmd");
> 	if (IS_ERR(kapmd_tsk)) {
> 		ret = PTR_ERR(kapmd_tsk);
> 		kapmd_tsk = NULL;
> diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> index 44160d5..98a22f9 100644
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -849,7 +849,7 @@ static int hvc_init(void)
>
> 	/* Always start the kthread because there can be hotplug vty adapters
> 	 * added later. */
> -	hvc_task = kthread_run(khvcd, NULL, "khvcd");
> +	hvc_task = kthread_run(khvcd, NULL, "ghvcd");
> 	if (IS_ERR(hvc_task)) {
> 		printk(KERN_ERR "Couldn't create kthread for console.\n");
> 		err = PTR_ERR(hvc_task);
> diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
> index 786d518..b9e5476 100644
> --- a/drivers/char/hvcs.c
> +++ b/drivers/char/hvcs.c
> @@ -1534,7 +1534,7 @@ static int __init hvcs_module_init(void)
> 		goto buff_alloc_fail;
> 	}
>
> -	hvcs_task = kthread_run(khvcsd, NULL, "khvcsd");
> +	hvcs_task = kthread_run(khvcsd, NULL, "ghvcsd");
> 	if (IS_ERR(hvcs_task)) {
> 		printk(KERN_ERR "HVCS: khvcsd creation failed.  Driver not loaded.\n");
> 		rc = -EIO;
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 4f560d0..b3a9060 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1033,7 +1033,7 @@ static int smi_start_processing(void       *send_info,
>
> 	if (enable) {
> 		new_smi->thread = kthread_run(ipmi_thread, new_smi,
> -					      "kipmi%d", new_smi->intf_num);
> +					      "gipmi%d", new_smi->intf_num);
> 		if (IS_ERR(new_smi->thread)) {
> 			printk(KERN_NOTICE "ipmi_si_intf: Could not start"
> 			       " kernel thread due to error %ld, only using"
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index d2af20d..d6c3e74 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -589,7 +589,7 @@ EXPORT_SYMBOL(cpufreq_gov_ondemand);
>
> static int __init cpufreq_gov_dbs_init(void)
> {
> -	kondemand_wq = create_workqueue("kondemand");
> +	kondemand_wq = create_workqueue("gondemand");
> 	if (!kondemand_wq) {
> 		printk(KERN_ERR "Creation of kondemand failed\n");
> 		return -EFAULT;
> diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
> index 36c747b..f1b7483 100644
> --- a/drivers/ieee1394/ieee1394_core.c
> +++ b/drivers/ieee1394/ieee1394_core.c
> @@ -1162,7 +1162,7 @@ static int __init ieee1394_init(void)
> 		HPSB_ERR("Some features may not be available\n");
> 	}
>
> -	khpsbpkt_thread = kthread_run(hpsbpkt_thread, NULL, "khpsbpkt");
> +	khpsbpkt_thread = kthread_run(hpsbpkt_thread, NULL, "ghpsbpkt");
> 	if (IS_ERR(khpsbpkt_thread)) {
> 		HPSB_ERR("Failed to start hpsbpkt thread!\n");
> 		ret = PTR_ERR(khpsbpkt_thread);
> diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
> index 511e432..c37c1b4 100644
> --- a/drivers/ieee1394/nodemgr.c
> +++ b/drivers/ieee1394/nodemgr.c
> @@ -1876,7 +1876,7 @@ static void nodemgr_add_host(struct hpsb_host *host)
> 		return;
> 	}
> 	hi->host = host;
> -	hi->thread = kthread_run(nodemgr_host_thread, hi, "knodemgrd_%d",
> +	hi->thread = kthread_run(nodemgr_host_thread, hi, "gnodemgrd_%d",
> 				 host->id);
> 	if (IS_ERR(hi->thread)) {
> 		HPSB_ERR("NodeMgr: cannot start thread for host %d", host->id);
> diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
> index c5600ac..91a2055 100644
> --- a/drivers/input/gameport/gameport.c
> +++ b/drivers/input/gameport/gameport.c
> @@ -812,7 +812,7 @@ static int __init gameport_init(void)
> 		return error;
> 	}
>
> -	gameport_task = kthread_run(gameport_thread, NULL, "kgameportd");
> +	gameport_task = kthread_run(gameport_thread, NULL, "ggameportd");
> 	if (IS_ERR(gameport_task)) {
> 		bus_unregister(&gameport_bus);
> 		error = PTR_ERR(gameport_task);
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index f5a6be1..eac0ab8 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -1601,7 +1601,7 @@ static int __init psmouse_init(void)
> {
> 	int err;
>
> -	kpsmoused_wq = create_singlethread_workqueue("kpsmoused");
> +	kpsmoused_wq = create_singlethread_workqueue("gpsmoused");
> 	if (!kpsmoused_wq) {
> 		printk(KERN_ERR "psmouse: failed to create kpsmoused workqueue\n");
> 		return -ENOMEM;
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index 7f52938..93c2fe9 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -1007,7 +1007,7 @@ static int __init serio_init(void)
> 		return error;
> 	}
>
> -	serio_task = kthread_run(serio_thread, NULL, "kseriod");
> +	serio_task = kthread_run(serio_thread, NULL, "gseriod");
> 	if (IS_ERR(serio_task)) {
> 		bus_unregister(&serio_bus);
> 		error = PTR_ERR(serio_task);
> diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
> index 2895810..d5b3aaf 100644
> --- a/drivers/macintosh/adb.c
> +++ b/drivers/macintosh/adb.c
> @@ -242,7 +242,7 @@ adb_probe_task(void *x)
> static void
> __adb_probe_task(struct work_struct *bullshit)
> {
> -	kthread_run(adb_probe_task, NULL, "kadbprobe");
> +	kthread_run(adb_probe_task, NULL, "gadbprobe");
> }
>
> static DECLARE_WORK(adb_reset_work, __adb_probe_task);
> diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
> index 54f4942..1e77bdb 100644
> --- a/drivers/macintosh/therm_adt746x.c
> +++ b/drivers/macintosh/therm_adt746x.c
> @@ -443,7 +443,7 @@ static int attach_one_thermostat(struct i2c_adapter *adapter, int addr,
> 		write_both_fan_speed(th, -1);
> 	}
>
> -	thread_therm = kthread_run(monitor_task, th, "kfand");
> +	thread_therm = kthread_run(monitor_task, th, "gfand");
>
> 	if (thread_therm == ERR_PTR(-ENOMEM)) {
> 		printk(KERN_INFO "adt746x: Kthread creation failed\n");
> diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
> index 1e0a69a..713b6a2 100644
> --- a/drivers/macintosh/therm_pm72.c
> +++ b/drivers/macintosh/therm_pm72.c
> @@ -1976,7 +1976,7 @@ static void start_control_loops(void)
> {
> 	init_completion(&ctrl_complete);
>
> -	ctrl_task = kthread_run(main_control_loop, NULL, "kfand");
> +	ctrl_task = kthread_run(main_control_loop, NULL, "gfand");
> }
>
> /*
> @@ -2275,4 +2275,3 @@ module_exit(therm_pm72_exit);
> MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
> MODULE_DESCRIPTION("Driver for Apple's PowerMac G5 thermal control");
> MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
> index 075b4d9..5d01add 100644
> --- a/drivers/macintosh/windfarm_core.c
> +++ b/drivers/macintosh/windfarm_core.c
> @@ -127,7 +127,7 @@ static int wf_thread_func(void *data)
>
> static void wf_start_thread(void)
> {
> -	wf_thread = kthread_run(wf_thread_func, NULL, "kwindfarm");
> +	wf_thread = kthread_run(wf_thread_func, NULL, "gwindfarm");
> 	if (IS_ERR(wf_thread)) {
> 		printk(KERN_ERR "windfarm: failed to create thread,err %ld\n",
> 		       PTR_ERR(wf_thread));
> @@ -492,4 +492,3 @@ module_exit(windfarm_core_exit);
> MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
> MODULE_DESCRIPTION("Core component of PowerMac thermal control");
> MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index b04f98d..23f3dae 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1035,13 +1035,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> 	} else
> 		cc->iv_mode = NULL;
>
> -	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
> +	cc->io_queue = create_singlethread_workqueue("gcryptd_io");
> 	if (!cc->io_queue) {
> 		ti->error = "Couldn't create kcryptd io queue";
> 		goto bad_io_queue;
> 	}
>
> -	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
> +	cc->crypt_queue = create_singlethread_workqueue("gcryptd");
> 	if (!cc->crypt_queue) {
> 		ti->error = "Couldn't create kcryptd queue";
> 		goto bad_crypt_queue;
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index bdd37f8..cf1ecb4 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -333,7 +333,7 @@ static int __init dm_delay_init(void)
> {
> 	int r = -ENOMEM;
>
> -	kdelayd_wq = create_workqueue("kdelayd");
> +	kdelayd_wq = create_workqueue("gdelayd");
> 	if (!kdelayd_wq) {
> 		DMERR("Couldn't start kdelayd");
> 		goto bad_queue;
> diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
> index 5bbce29..5a49f6f 100644
> --- a/drivers/md/dm-exception-store.c
> +++ b/drivers/md/dm-exception-store.c
> @@ -621,7 +621,7 @@ int dm_create_persistent(struct exception_store *store)
> 	atomic_set(&ps->pending_count, 0);
> 	ps->callbacks = NULL;
>
> -	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
> +	ps->metadata_wq = create_singlethread_workqueue("gsnaphd");
> 	if (!ps->metadata_wq) {
> 		kfree(ps);
> 		DMERR("couldn't start header metadata update thread");
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index e7ee59e..c133d72 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1414,7 +1414,7 @@ static int __init dm_multipath_init(void)
> 		return -EINVAL;
> 	}
>
> -	kmultipathd = create_workqueue("kmpathd");
> +	kmultipathd = create_workqueue("gmpathd");
> 	if (!kmultipathd) {
> 		DMERR("failed to create workqueue kmpathd");
> 		dm_unregister_target(&multipath_target);
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index 5160587..28753bb 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -1540,7 +1540,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> 	ti->private = ms;
>  	ti->split_io = ms->rh.region_size;
>
> -	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
> +	ms->kmirrord_wq = create_singlethread_workqueue("gmirrord");
> 	if (!ms->kmirrord_wq) {
> 		DMERR("couldn't start kmirrord");
> 		r = -ENOMEM;
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index ae24eab..b6ed934 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1313,7 +1313,7 @@ static int __init dm_snapshot_init(void)
> 		goto bad5;
> 	}
>
> -	ksnapd = create_singlethread_workqueue("ksnapd");
> +	ksnapd = create_singlethread_workqueue("gsnapd");
> 	if (!ksnapd) {
> 		DMERR("Failed to create ksnapd workqueue.");
> 		r = -ENOMEM;
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 4de90ab..78e8cd8 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -323,7 +323,7 @@ int __init dm_stripe_init(void)
> 	if (r < 0)
> 		DMWARN("target registration failed");
>
> -	kstriped = create_singlethread_workqueue("kstriped");
> +	kstriped = create_singlethread_workqueue("gstriped");
> 	if (!kstriped) {
> 		DMERR("failed to create workqueue kstriped");
> 		dm_unregister_target(&stripe_target);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6617ce4..fec9df8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1062,7 +1062,7 @@ static struct mapped_device *alloc_dev(int minor)
> 	add_disk(md->disk);
> 	format_dev_t(md->name, MKDEV(_major, minor));
>
> -	md->wq = create_singlethread_workqueue("kdmflush");
> +	md->wq = create_singlethread_workqueue("gdmflush");
> 	if (!md->wq)
> 		goto bad_thread;
>
> diff --git a/drivers/md/kcopyd.c b/drivers/md/kcopyd.c
> index f3831f3..0dd4605 100644
> --- a/drivers/md/kcopyd.c
> +++ b/drivers/md/kcopyd.c
> @@ -624,7 +624,7 @@ static int kcopyd_init(void)
> 		return r;
> 	}
>
> -	_kcopyd_wq = create_singlethread_workqueue("kcopyd");
> +	_kcopyd_wq = create_singlethread_workqueue("gcopyd");
> 	if (!_kcopyd_wq) {
> 		jobs_exit();
> 		mutex_unlock(&kcopyd_init_lock);
> diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> index 89437fd..8f3d3a2 100644
> --- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> @@ -1669,7 +1669,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
> 	mb();
>
> 	/* create a kthread for monitoring this CA device */
> -	ca->thread = kthread_run(dvb_ca_en50221_thread, ca, "kdvb-ca-%i:%i",
> +	ca->thread = kthread_run(dvb_ca_en50221_thread, ca, "gdvb-ca-%i:%i",
> 				 ca->dvbdev->adapter->num, ca->dvbdev->id);
> 	if (IS_ERR(ca->thread)) {
> 		ret = PTR_ERR(ca->thread);
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 925cfa6..f59f443 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -685,7 +685,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
> 	mb();
>
> 	fe_thread = kthread_run(dvb_frontend_thread, fe,
> -		"kdvb-fe-%i", fe->dvb->num);
> +		"gdvb-fe-%i", fe->dvb->num);
> 	if (IS_ERR(fe_thread)) {
> 		ret = PTR_ERR(fe_thread);
> 		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
> diff --git a/drivers/mfd/ucb1x00-ts.c b/drivers/mfd/ucb1x00-ts.c
> index fdbaa77..39594f8 100644
> --- a/drivers/mfd/ucb1x00-ts.c
> +++ b/drivers/mfd/ucb1x00-ts.c
> @@ -311,7 +311,7 @@ static int ucb1x00_ts_open(struct input_dev *idev)
> 	ts->y_res = ucb1x00_ts_read_yres(ts);
> 	ucb1x00_adc_disable(ts->ucb);
>
> -	ts->rtask = kthread_run(ucb1x00_thread, ts, "ktsd");
> +	ts->rtask = kthread_run(ucb1x00_thread, ts, "gtsd");
> 	if (!IS_ERR(ts->rtask)) {
> 		ret = 0;
> 	} else {
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index b966674..2640493 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -786,7 +786,7 @@ static int __init mmc_init(void)
> {
> 	int ret;
>
> -	workqueue = create_singlethread_workqueue("kmmcd");
> +	workqueue = create_singlethread_workqueue("gmmcd");
> 	if (!workqueue)
> 		return -ENOMEM;
>
> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> index 3bd3021..1498006 100644
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -154,7 +154,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
> 	if (!host->sdio_irqs++) {
> 		atomic_set(&host->sdio_irq_thread_abort, 0);
> 		host->sdio_irq_thread =
> -			kthread_run(sdio_irq_thread, host, "ksdiorqd");
> +			kthread_run(sdio_irq_thread, host, "gsdiorqd");
> 		if (IS_ERR(host->sdio_irq_thread)) {
> 			int err = PTR_ERR(host->sdio_irq_thread);
> 			host->sdio_irqs--;
> @@ -264,4 +264,3 @@ int sdio_release_irq(struct sdio_func *func)
> 	return 0;
> }
> EXPORT_SYMBOL_GPL(sdio_release_irq);
> -
> diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
> index 90cca5e..7bb9d6b 100644
> --- a/drivers/parisc/power.c
> +++ b/drivers/parisc/power.c
> @@ -48,7 +48,7 @@
> #include <asm/led.h>
>
> #define DRIVER_NAME  "powersw"
> -#define KTHREAD_NAME "kpowerswd"
> +#define KTHREAD_NAME "gpowerswd"
>
> /* how often should the power button be polled ? */
> #define POWERSWITCH_POLL_PER_SEC 2
> diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
> index a8a5150..b271f2d 100644
> --- a/drivers/pnp/pnpbios/core.c
> +++ b/drivers/pnp/pnpbios/core.c
> @@ -596,7 +596,7 @@ static int __init pnpbios_thread_init(void)
> 		return 0;
> #ifdef CONFIG_HOTPLUG
> 	init_completion(&unload_sem);
> -	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> +	task = kthread_run(pnp_dock_thread, NULL, "gpnpbiosd");
> 	if (!IS_ERR(task))
> 		unloading = 0;
> #endif
> diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
> index fec004f..32b3478 100644
> --- a/drivers/s390/cio/device.c
> +++ b/drivers/s390/cio/device.c
> @@ -167,7 +167,7 @@ init_ccw_bus_type (void)
> 		ret = -ENOMEM; /* FIXME: better errno ? */
> 		goto out_err;
> 	}
> -	slow_path_wq = create_singlethread_workqueue("kslowcrw");
> +	slow_path_wq = create_singlethread_workqueue("gslowcrw");
> 	if (!slow_path_wq) {
> 		ret = -ENOMEM; /* FIXME: better errno ? */
> 		goto out_err;
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index 7b0b819..834a8b7 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -1279,7 +1279,7 @@ int __init ap_module_init(void)
> 	if (rc)
> 		goto out_bus;
>
> -	ap_work_queue = create_singlethread_workqueue("kapwork");
> +	ap_work_queue = create_singlethread_workqueue("gapwork");
> 	if (!ap_work_queue) {
> 		rc = -ENOMEM;
> 		goto out_root;
> diff --git a/drivers/s390/s390mach.c b/drivers/s390/s390mach.c
> index 644a06e..cf7afa7 100644
> --- a/drivers/s390/s390mach.c
> +++ b/drivers/s390/s390mach.c
> @@ -529,7 +529,7 @@ machine_check_crw_init (void)
> {
> 	struct task_struct *task;
>
> -	task = kthread_run(s390_collect_crw_info, &m_sem, "kmcheck");
> +	task = kthread_run(s390_collect_crw_info, &m_sem, "gmcheck");
> 	if (IS_ERR(task))
> 		return PTR_ERR(task);
> 	ctl_set_bit(14, 28);	/* enable channel report MCH */
> diff --git a/drivers/sbus/char/bbc_envctrl.c b/drivers/sbus/char/bbc_envctrl.c
> index 0bde269..0c29648 100644
> --- a/drivers/sbus/char/bbc_envctrl.c
> +++ b/drivers/sbus/char/bbc_envctrl.c
> @@ -577,7 +577,7 @@ int bbc_envctrl_init(void)
> 			attach_one_fan(echild, fan_index++);
> 	}
> 	if (temp_index != 0 && fan_index != 0) {
> -		kenvctrld_task = kthread_run(kenvctrld, NULL, "kenvctrld");
> +		kenvctrld_task = kthread_run(kenvctrld, NULL, "genvctrld");
> 		if (IS_ERR(kenvctrld_task))
> 			return PTR_ERR(kenvctrld_task);
> 	}
> diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
> index dadabef..f18d469 100644
> --- a/drivers/sbus/char/envctrl.c
> +++ b/drivers/sbus/char/envctrl.c
> @@ -1102,7 +1102,7 @@ done:
> 			i2c_childlist[i].addr, (0 == i) ? ("\n") : (" "));
> 	}
>
> -	kenvctrld_task = kthread_run(kenvctrld, NULL, "kenvctrld");
> +	kenvctrld_task = kthread_run(kenvctrld, NULL, "genvctrld");
> 	if (IS_ERR(kenvctrld_task)) {
> 		err = PTR_ERR(kenvctrld_task);
> 		goto out_deregister;
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 68fc521..d6491c1 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -2935,7 +2935,7 @@ int usb_hub_init(void)
> 		return -1;
> 	}
>
> -	khubd_task = kthread_run(hub_thread, NULL, "khubd");
> +	khubd_task = kthread_run(hub_thread, NULL, "ghubd");
> 	if (!IS_ERR(khubd_task))
> 		return 0;
>
> diff --git a/fs/afs/flock.c b/fs/afs/flock.c
> index 210acaf..e979a75 100644
> --- a/fs/afs/flock.c
> +++ b/fs/afs/flock.c
> @@ -38,7 +38,7 @@ static int afs_init_lock_manager(void)
> 		mutex_lock(&afs_lock_manager_mutex);
> 		if (!afs_lock_manager) {
> 			afs_lock_manager =
> -				create_singlethread_workqueue("kafs_lockd");
> +				create_singlethread_workqueue("gafs_lockd");
> 			if (!afs_lock_manager)
> 				ret = -ENOMEM;
> 		}
> diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
> index bde3f19..3f3b285 100644
> --- a/fs/afs/rxrpc.c
> +++ b/fs/afs/rxrpc.c
> @@ -71,7 +71,7 @@ int afs_open_socket(void)
>
> 	skb_queue_head_init(&afs_incoming_calls);
>
> -	afs_async_calls = create_singlethread_workqueue("kafsd");
> +	afs_async_calls = create_singlethread_workqueue("gafsd");
> 	if (!afs_async_calls) {
> 		_leave(" = -ENOMEM [wq]");
> 		return -ENOMEM;
> diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
> index 849fc31..b00aeb0 100644
> --- a/fs/afs/vlocation.c
> +++ b/fs/afs/vlocation.c
> @@ -596,7 +596,7 @@ static void afs_vlocation_reaper(struct work_struct *work)
> int __init afs_vlocation_update_init(void)
> {
> 	afs_vlocation_update_worker =
> -		create_singlethread_workqueue("kafs_vlupdated");
> +		create_singlethread_workqueue("gafs_vlupdated");
> 	return afs_vlocation_update_worker ? 0 : -ENOMEM;
> }
>
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 3943a89..6261029 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -214,7 +214,7 @@ static int journal_start_thread(journal_t *journal)
> {
> 	struct task_struct *t;
>
> -	t = kthread_run(kjournald, journal, "kjournald");
> +	t = kthread_run(kjournald, journal, "gjournald");
> 	if (IS_ERR(t))
> 		return PTR_ERR(t);
>
> @@ -1961,4 +1961,3 @@ static void __exit journal_exit(void)
> MODULE_LICENSE("GPL");
> module_init(journal_init);
> module_exit(journal_exit);
> -
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 96ba846..430fe49 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -215,7 +215,7 @@ static int jbd2_journal_start_thread(journal_t *journal)
> {
> 	struct task_struct *t;
>
> -	t = kthread_run(kjournald2, journal, "kjournald2");
> +	t = kthread_run(kjournald2, journal, "gjournald2");
> 	if (IS_ERR(t))
> 		return PTR_ERR(t);
>
> @@ -2336,4 +2336,3 @@ static void __exit journal_exit(void)
> MODULE_LICENSE("GPL");
> module_init(journal_init);
> module_exit(journal_exit);
> -
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 22be3ff..8d517ba 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -511,7 +511,7 @@ EXPORT_SYMBOL(call_usermodehelper_pipe);
>
> void __init usermodehelper_init(void)
> {
> -	khelper_wq = create_singlethread_workqueue("khelper");
> +	khelper_wq = create_singlethread_workqueue("ghelper");
> 	BUG_ON(!khelper_wq);
> 	register_pm_notifier_callback();
> }
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 31e9f2a..336e81d 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -596,7 +596,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
> 	switch (action) {
> 	case CPU_UP_PREPARE:
> 	case CPU_UP_PREPARE_FROZEN:
> -		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
> +		p = kthread_create(ksoftirqd, hcpu, "gsoftirqd/%d", hotcpu);
> 		if (IS_ERR(p)) {
> 			printk("ksoftirqd for %i failed\n", hotcpu);
> 			return NOTIFY_BAD;
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 6f4e0e1..9296dd3 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -183,7 +183,7 @@ struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
> 	if (cpu == NR_CPUS)
> 		cpu = raw_smp_processor_id();
>
> -	p = kthread_create(do_stop, &smdata, "kstopmachine");
> +	p = kthread_create(do_stop, &smdata, "gstopmachine");
> 	if (!IS_ERR(p)) {
> 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4571158..b4dbd9a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1925,7 +1925,7 @@ int kswapd_run(int nid)
> 	if (pgdat->kswapd)
> 		return 0;
>
> -	pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
> +	pgdat->kswapd = kthread_run(kswapd, pgdat, "gswapd%d", nid);
> 	if (IS_ERR(pgdat->kswapd)) {
> 		/* failure at boot is fatal */
> 		BUG_ON(system_state == SYSTEM_BOOTING);
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index 0c2c937..76a0503 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -2042,7 +2042,7 @@ static int __init rfcomm_init(void)
>
> 	hci_register_cb(&rfcomm_cb);
>
> -	rfcomm_thread = kthread_run(rfcomm_run, NULL, "krfcommd");
> +	rfcomm_thread = kthread_run(rfcomm_run, NULL, "grfcommd");
> 	if (IS_ERR(rfcomm_thread)) {
> 		hci_unregister_cb(&rfcomm_cb);
> 		return PTR_ERR(rfcomm_thread);
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index 20e63b3..cda3ffc 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -3617,7 +3617,7 @@ static int __init pktgen_create_thread(int cpu)
>
> 	list_add_tail(&t->th_list, &pktgen_threads);
>
> -	p = kthread_create(pktgen_thread_worker, t, "kpktgend_%d", cpu);
> +	p = kthread_create(pktgen_thread_worker, t, "gpktgend_%d", cpu);
> 	if (IS_ERR(p)) {
> 		printk(KERN_ERR "pktgen: kernel_thread() failed "
> 		       "for cpu %d\n", t->cpu);
> diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
> index 2d0c29c..a78989c 100644
> --- a/net/rxrpc/af_rxrpc.c
> +++ b/net/rxrpc/af_rxrpc.c
> @@ -803,7 +803,7 @@ static int __init af_rxrpc_init(void)
> 		goto error_call_jar;
> 	}
>
> -	rxrpc_workqueue = create_workqueue("krxrpcd");
> +	rxrpc_workqueue = create_workqueue("grxrpcd");
> 	if (!rxrpc_workqueue) {
> 		printk(KERN_NOTICE "RxRPC: Failed to allocate work queue\n");
> 		goto error_work_queue;
> -- 
> 1.5.4.3

But wasn't the "k" just for "kernel?" What on earth does "g"
stand for???  We shouldn't change names just because we don't
like them!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
