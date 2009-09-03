Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZICWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZICWya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932423AbZICWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:54:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54838 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbZICWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:54:28 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=35ISBW3HG1kA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=BNNSShRC4YudbXsHAQ4A:9 a=nLtD96UXWlejgksZr-AA:7
 a=2eDXP2hTPMBWthnATu20uQWL3i8A:4 a=LfycJkTYaN0oI_6H:21 a=kvFYlvp-cRYyhU-L:21
Date: Thu, 3 Sep 2009 16:54:19 -0600
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: BIOS update == more errors (was Re: sata exception frozen timeout?)
In-reply-to: <200909031411.59191.tfjellstrom@shaw.ca>
To: linux-kernel@vger.kernel.org
Reply-To: tfjellstrom@shaw.ca
Message-Id: <200909031654.19859.tfjellstrom@shaw.ca>
MIME-version: 1.0
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=35ISBW3HG1kA:10
 a=w4iE+TBsmj5y1WloLYF40w==:17 a=BNNSShRC4YudbXsHAQ4A:9
 a=nLtD96UXWlejgksZr-AA:7 a=2eDXP2hTPMBWthnATu20uQWL3i8A:4
 a=LfycJkTYaN0oI_6H:21 a=kvFYlvp-cRYyhU-L:21
References: <200909010316.58715.tfjellstrom@shaw.ca>
 <200909031338.39785.tfjellstrom@shaw.ca>
 <200909031411.59191.tfjellstrom@shaw.ca>
User-Agent: KMail/1.12.90 (Linux/2.6.31-rc5; KDE/4.3.64; x86_64; svn-1004284;
 2009-07-29)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu September 3 2009, Thomas Fjellstrom wrote:
> On Thu September 3 2009, Thomas Fjellstrom wrote:
> > I've updated my bios to try and see if it would help at all (it did seem
> > to fix other issues).
> >
> > But now I'm getting the following warnings and errors from dmesg on boot:
> > (debian sid 2.6.30, with "noapic" to see if the original problem was an
> > interupt issue, as everyone seems to have hinted at).
> >
> > [    1.024337] ------------[ cut here ]------------
> > [    1.024408] WARNING: at /build/buildd-linux-2.6_2.6.30-6-amd64-
> > s9DPiZ/linux-2.6-2.6.30/debian/build/source_amd64_none/drivers/ata/libata
> >- core.c:6174 ata_host_activate+0x47/0xe0 [libata]()
> > [    1.024492] Hardware name: GA-MA790FXT-UD5P
> > [    1.024546] Modules linked in: crc_itu_t atiixp(+) ide_core
> > pata_jmicron ahci(+) ehci_hcd(+) libata scsi_mod r8169 mii thermal fan
> > thermal_sys [    1.025196] Pid: 796, comm: work_for_cpu Not tainted
> > 2.6.30-1-amd64 #1 [    1.025252] Call Trace:
> > [    1.025318]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0
> > [libata] [    1.025385]  [<ffffffffa0056101>] ?
> > ata_host_activate+0x47/0xe0 [libata] [    1.025445]  [<ffffffff8024237f>]
> > ? warn_slowpath_common+0x77/0xa3 [    1.025505]  [<ffffffffa008e598>] ?
> > ahci_interrupt+0x0/0x454 [ahci] [    1.025572]  [<ffffffffa0056101>] ?
> > ata_host_activate+0x47/0xe0 [libata] [    1.025632]  [<ffffffffa008e578>]
> > ? ahci_init_one+0xbb4/0xbd4 [ahci] [    1.025691]  [<ffffffff8025136e>] ?
> > do_work_for_cpu+0x0/0x1b
> > [    1.025749]  [<ffffffff8035fa16>] ? local_pci_probe+0x12/0x16
> > [    1.025806]  [<ffffffff80251379>] ? do_work_for_cpu+0xb/0x1b
> > [    1.025862]  [<ffffffff80254382>] ? kthread+0x54/0x80
> > [    1.025918]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
> > [    1.025975]  [<ffffffff8025432e>] ? kthread+0x0/0x80
> > [    1.026030]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
> > [    1.026085] ---[ end trace 54d3fd405814ad85 ]---
> > ...
> > [   14.872233] ata10.15: qc timeout (cmd 0xe4)
> > [   14.872925] ata10.15: failed to read PMP GSCR[0] (Emask=0x4)
> > [   14.873256] ata9.15: qc timeout (cmd 0xe4)
> > [   14.873344] ata10: limiting SATA link speed to 1.5 Gbps
> > [   14.874008] ata9.15: failed to read PMP GSCR[0] (Emask=0x4)
> > [   14.874271] ata9: limiting SATA link speed to 1.5 Gbps
> > [   15.548002] irq 7: nobody cared (try booting with the "irqpoll"
> > option) [   15.548121] Pid: 0, comm: swapper Tainted: G        W 
> > 2.6.30-1-amd64 #1 [   15.548240] Call Trace:
> > [   15.548346]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
> > [   15.548569]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
> > [   15.548689]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
> > [   15.548809]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
> > [   15.548929]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
> > [   15.549044]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
> > [   15.549161]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
> > [   15.549379]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
> > [   15.549497]  [<ffffffff80216995>] ? default_idle+0x40/0x68
> > [   15.549612]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
> > [   15.549730]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
> > [   15.549848]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
> > [   15.549963]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
> > [   15.550081]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
> > [   15.550199] handlers:
> > [   15.550311] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> > [   15.550630] Disabling IRQ #7
> > [   15.636304] irq 11: nobody cared (try booting with the "irqpoll"
> > option) [   15.636377] Pid: 0, comm: swapper Tainted: G        W 
> > 2.6.30-1-amd64 #1 [   15.636434] Call Trace:
> > [   15.636486]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
> > [   15.636586]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
> > [   15.636643]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
> > [   15.636699]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
> > [   15.636755]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
> > [   15.636811]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
> > [   15.636866]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
> > [   15.636966]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
> > [   15.637022]  [<ffffffff80216995>] ? default_idle+0x40/0x68
> > [   15.637078]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
> > [   15.637135]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
> > [   15.637191]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
> > [   15.637247]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
> > [   15.637304]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
> > [   15.637359] handlers:
> > [   15.637411] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> > [   15.637549] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> > [   15.637687] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> > [   15.637825] Disabling IRQ #11
> > [   17.536129] usb-storage: device scan complete
> > ...
> > [   21.388126] ata9.15: qc timeout (cmd 0xe4)
> > [   21.388194] ata9.15: failed to read PMP GSCR[0] (Emask=0x4)
> > [   21.588135] ata10.15: qc timeout (cmd 0xe4)
> > [   21.588204] ata10.15: failed to read PMP GSCR[0] (Emask=0x4)
> > [   24.832135] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > [   25.632183] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > ...
> > [  198.322072] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [  198.322080] ata8.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [  198.322081]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [  198.322083] ata8.00: status: { DRDY }
> > [  198.322088] ata8: hard resetting link
> > [  198.916035] ata8: softreset failed (device not ready)
> > [  198.916039] ata8: failed due to HW bug, retry pmp=0
> > [  199.080024] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  199.092059] ata8.00: configured for UDMA/133
> > [  199.092072] ata8: EH complete
> > [  227.900583] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [  227.900590] ata8.00: cmd b0/d8:00:01:4f:c2/00:00:00:00:00/00 tag 0
> > [  227.900591]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4
> > (timeout)
> > [  227.900594] ata8.00: status: { DRDY }
> > [  227.900598] ata8: hard resetting link
> > [  228.384016] ata8: softreset failed (device not ready)
> > [  228.384020] ata8: failed due to HW bug, retry pmp=0
> > [  228.548024] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  228.560372] ata8.00: configured for UDMA/133
> > [  228.560385] ata8: EH complete
> > [  238.805198] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [  238.805218] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [  238.805221]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [  238.805229] ata8.00: status: { DRDY }
> > [  238.805241] ata8: hard resetting link
> > [  239.404154] ata8: softreset failed (device not ready)
> > [  239.404163] ata8: failed due to HW bug, retry pmp=0
> > [  239.568186] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  239.580343] ata8.00: configured for UDMA/133
> > [  239.580374] ata8: EH complete
> > [  246.808086] ata8.00: NCQ disabled due to excessive errors
> > [  246.808099] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [  246.808115] ata8.00: cmd b0/d8:00:01:4f:c2/00:00:00:00:00/00 tag 0
> > [  246.808119]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4
> > (timeout)
> > [  246.808126] ata8.00: status: { DRDY }
> > [  246.808138] ata8: hard resetting link
> > [  247.292158] ata8: softreset failed (device not ready)
> > [  247.292167] ata8: failed due to HW bug, retry pmp=0
> > [  247.456174] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  247.468955] ata8.00: configured for UDMA/133
> > [  247.468984] ata8: EH complete
> > [  272.804207] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [  272.804227] ata8.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [  272.804231]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4
> > (timeout)
> > [  272.804238] ata8.00: status: { DRDY }
> > [  272.804250] ata8: hard resetting link
> > [  273.292161] ata8: softreset failed (device not ready)
> > [  273.292169] ata8: failed due to HW bug, retry pmp=0
> > [  273.456173] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  273.468892] ata8.00: configured for UDMA/133
> > [  273.468916] ata8: EH complete
> >
> > On boot, it seemed to hang the disk up for a good few minutes, even
> > though nothing is using it at the moment (I have to manually bring up the
> > mdraid0 array, so it can't possibly be mounted), and smartctl was
> > erroring out for a while, but now its fine, and smart shows no issues.
> >
> > I'm going to try without noapic on 2.6.30, and 2.6.31-rc5 and see what
> > happens.
>
> back with 2.6.30 apic enabled, all the traces are gone, but I still get the
> SATA errors, and a new message: ata8: SError: { HostInt }
>
> [  415.781659] ata8.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x6
> frozen
> [  415.781672] ata8: SError: { HostInt }
> [  415.781687] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [  415.781690]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x44
> (timeout)
> [  415.781697] ata8.00: status: { DRDY }
> [  415.781708] ata8: hard resetting link
> [  416.264190] ata8: softreset failed (device not ready)
> [  416.264199] ata8: failed due to HW bug, retry pmp=0
> [  416.428196] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  416.440517] ata8.00: configured for UDMA/133
> [  416.440544] ata8: EH complete
> [  424.781778] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  424.781798] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [  424.781801]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [  424.781809] ata8.00: status: { DRDY }
> [  424.781820] ata8: hard resetting link
> [  425.265677] ata8: softreset failed (device not ready)
> [  425.265686] ata8: failed due to HW bug, retry pmp=0
> [  425.429546] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  425.442153] ata8.00: configured for UDMA/133
> [  425.442179] ata8: EH complete
> [  458.482002] CE: hpet increasing min_delta_ns to 15000 nsec
> [  499.780213] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  499.780233] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [  499.780237]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [  499.780244] ata8.00: status: { DRDY }
> [  499.780256] ata8: hard resetting link
> [  500.320191] ata8: softreset failed (device not ready)
> [  500.320200] ata8: failed due to HW bug, retry pmp=0
> [  500.485084] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  500.497235] ata8.00: configured for UDMA/133
> [  500.497256] ata8: EH complete
>
> And now with 2.6.31-rc5, instant ata exceptions, same as before (just no
> SError line this time).

I think I have an answer finally. Bad drive. I've plugged a new sata 
controller in, and I get the following from it:

[ 1581.172316] ata15: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 
0xb/00/00
[ 1581.172325] ata15: status=0x01 { Error }
[ 1581.172333] ata15: error=0x04 { DriveStatusError }

I assume that means the drive is at fault.

(one system lock up later...)

shortly after I wrote the above this appeared in dmesg:

Sep  3 16:33:59 natasha kernel: [ 1679.334788] ------------[ cut here 
]------------
Sep  3 16:33:59 natasha kernel: [ 1679.334864] WARNING: at drivers/ata/libata-
core.c:4910 __ata_qc_complete+0x5a/0xe1 [libata]()
Sep  3 16:33:59 natasha kernel: [ 1679.334870] Hardware name: GA-MA790FXT-UD5P
Sep  3 16:33:59 natasha kernel: [ 1679.334874] Modules linked in: fuse raid0 
kvm_amd kvm powernow_k8 cpufreq_conservative cpufreq_stats cpufreq_userspace 
cpufreq_powersave nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc 
bridge stp ext4 jbd2 crc16 md_mod it87 hwmon_vid adt7473 firewire_sbp2 loop 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event 
amd64_edac_mod snd_seq edac_core snd_timer snd_seq_device evdev snd soundcore 
i2c_piix4 snd_page_alloc i2c_core parport_pc parport wmi processor button ext3 
jbd mbcache dm_mod usbhid hid sd_mod ata_generic pata_jmicron crc_t10dif 
atiixp firewire_ohci mvsas firewire_core crc_itu_t libsas scsi_transport_sas 
ohci_hcd ide_pci_generic ehci_hcd ide_core ahci libata scsi_mod r8169 mii 
floppy thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Sep  3 16:33:59 natasha kernel: [ 1679.334995] Pid: 0, comm: swapper Tainted: 
G        W  2.6.31-rc5 #1
Sep  3 16:33:59 natasha kernel: [ 1679.335001] Call Trace:
Sep  3 16:33:59 natasha kernel: [ 1679.335006]  <IRQ>  [<ffffffffa006a2ca>] ? 
__ata_qc_complete+0x5a/0xe1 [libata]
Sep  3 16:33:59 natasha kernel: [ 1679.335097]  [<ffffffffa006a2ca>] ? 
__ata_qc_complete+0x5a/0xe1 [libata]
Sep  3 16:33:59 natasha kernel: [ 1679.335109]  [<ffffffff8104a57b>] ? 
warn_slowpath_common+0x77/0xa3
Sep  3 16:33:59 natasha kernel: [ 1679.335154]  [<ffffffffa006a2ca>] ? 
__ata_qc_complete+0x5a/0xe1 [libata]
Sep  3 16:33:59 natasha kernel: [ 1679.335178]  [<ffffffffa00ed9d3>] ? 
sas_ata_task_done+0x178/0x210 [libsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335199]  [<ffffffffa01042ce>] ? 
mvs_slot_complete+0x3df/0x41b [mvsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335209]  [<ffffffff810610fa>] ? 
ktime_get+0xc/0x41
Sep  3 16:33:59 natasha kernel: [ 1679.335218]  [<ffffffff81023a86>] ? 
lapic_next_event+0x18/0x1d
Sep  3 16:33:59 natasha kernel: [ 1679.335236]  [<ffffffffa010439c>] ? 
mvs_int_rx+0x92/0x101 [mvsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335254]  [<ffffffffa01072b6>] ? 
mvs_int_full+0x25/0x88 [mvsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335272]  [<ffffffffa010734a>] ? 
mvs_64xx_isr+0x31/0x40 [mvsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335289]  [<ffffffffa01030e5>] ? 
mvs_interrupt+0x61/0x78 [mvsas]
Sep  3 16:33:59 natasha kernel: [ 1679.335298]  [<ffffffff81089ea8>] ? 
handle_IRQ_event+0x58/0x135
Sep  3 16:33:59 natasha kernel: [ 1679.335306]  [<ffffffff8108b595>] ? 
handle_fasteoi_irq+0x7d/0xb5
Sep  3 16:33:59 natasha kernel: [ 1679.335314]  [<ffffffff8101388d>] ? 
handle_irq+0x17/0x1d
Sep  3 16:33:59 natasha kernel: [ 1679.335321]  [<ffffffff81012ee5>] ? 
do_IRQ+0x57/0xb6
Sep  3 16:33:59 natasha kernel: [ 1679.335329]  [<ffffffff81011413>] ? 
ret_from_intr+0x0/0x11
Sep  3 16:33:59 natasha kernel: [ 1679.335333]  <EOI>  [<ffffffff8102b518>] ? 
native_safe_halt+0x2/0x3
Sep  3 16:33:59 natasha kernel: [ 1679.335349]  [<ffffffff81017c3d>] ? 
default_idle+0x40/0x68
Sep  3 16:33:59 natasha kernel: [ 1679.335357]  [<ffffffff8106790c>] ? 
clockevents_notify+0x2b/0x75
Sep  3 16:33:59 natasha kernel: [ 1679.335365]  [<ffffffff8101804c>] ? 
c1e_idle+0xe5/0x10d
Sep  3 16:33:59 natasha kernel: [ 1679.335374]  [<ffffffff8100fd9b>] ? 
cpu_idle+0x50/0x91
Sep  3 16:33:59 natasha kernel: [ 1679.335380] ---[ end trace 56631d4c7d46fc1b 
]---
Sep  3 16:34:00 natasha kernel: [ 1679.792256] CPU 2 
Sep  3 16:34:00 natasha kernel: [ 1679.792260] Modules linked in: fuse raid0 
kvm_amd kvm powernow_k8 cpufreq_conservative cpufreq_stats cpufreq_userspace 
cpufreq_powersave nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc 
bridge stp ext4 jbd2 crc16 md_mod it87 hwmon_vid adt7473 firewire_sbp2 loop 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event 
amd64_edac_mod snd_seq edac_core snd_timer snd_seq_device evdev snd soundcore 
i2c_piix4 snd_page_alloc i2c_core parport_pc parport wmi processor button ext3 
jbd mbcache dm_mod usbhid hid sd_mod ata_generic pata_jmicron crc_t10dif 
atiixp firewire_ohci mvsas firewire_core crc_itu_t libsas scsi_transport_sas 
ohci_hcd ide_pci_generic ehci_hcd ide_core ahci libata scsi_mod r8169 mii 
floppy thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Sep  3 16:34:00 natasha kernel: [ 1679.792384] Pid: 17, comm: events/2 
Tainted: G        W  2.6.31-rc5 #1 GA-MA790FXT-UD5P
Sep  3 16:34:00 natasha kernel: [ 1679.792390] RIP: 0010:[<ffffffff810d23c3>]  
[<ffffffff810d23c3>] free_block+0x59/0x11e
Sep  3 16:34:00 natasha kernel: [ 1679.792407] RSP: 0018:ffff88012fb97d90  
EFLAGS: 00010046
Sep  3 16:34:00 natasha kernel: [ 1679.792413] RAX: ffffea0001be4700 RBX: 
ffff88007f8201c0 RCX: 0000000000000000
Sep  3 16:34:00 natasha kernel: [ 1679.792419] RDX: ffffea0000000000 RSI: 
ffff88012b96ca18 RDI: ffff88007f8201c0
Sep  3 16:34:00 natasha kernel: [ 1679.792425] RBP: ffff88012ad7c6c0 R08: 
0000000000000000 R09: 00000000000000fa
Sep  3 16:34:00 natasha kernel: [ 1679.792430] R10: 0000000000000000 R11: 
ffff88002806bf20 R12: 0000000000000000
Sep  3 16:34:00 natasha kernel: [ 1679.792435] R13: ffff88012b96ca18 R14: 
000000000000020c R15: 0000000000000001
Sep  3 16:34:00 natasha kernel: [ 1679.792443] FS:  00007fe13b44e750(0000) 
GS:ffff88002805c000(0000) knlGS:00000000f65ffbb0
Sep  3 16:34:00 natasha kernel: [ 1679.792449] CS:  0010 DS: 0018 ES: 0018 
CR0: 000000008005003b
Sep  3 16:34:00 natasha kernel: [ 1679.792454] CR2: 00007f5d72294000 CR3: 
00000000cb536000 CR4: 00000000000006e0
Sep  3 16:34:00 natasha kernel: [ 1679.792460] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep  3 16:34:00 natasha kernel: [ 1679.792465] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep  3 16:34:00 natasha kernel: [ 1679.792472] Process events/2 (pid: 17, 
threadinfo ffff88012fb96000, task ffff88012fb740c0)
Sep  3 16:34:00 natasha kernel: [ 1679.792480]  ffff88012e1ed500 
ffff88012b96ca18 0000000000000001 ffff88012b96ca00
Sep  3 16:34:00 natasha kernel: [ 1679.792488] <0> ffff88012b9bb4c0 
0000000000000000 ffff88012ad7c6c0 ffffffff810d25b2
Sep  3 16:34:00 natasha kernel: [ 1679.792498] <0> ffffffffa03d6840 
0000000000011ab0 ffff88012b9bb4c0 ffff88012ad7c6c0
Sep  3 16:34:00 natasha kernel: [ 1679.792517]  [<ffffffff810d25b2>] ? 
drain_array+0x89/0xc1
Sep  3 16:34:00 natasha kernel: [ 1679.792526]  [<ffffffff810d299c>] ? 
cache_reap+0xde/0x212
Sep  3 16:34:00 natasha kernel: [ 1679.792535]  [<ffffffff810d28be>] ? 
cache_reap+0x0/0x212
Sep  3 16:34:00 natasha kernel: [ 1679.792545]  [<ffffffff8105a3da>] ? 
worker_thread+0x174/0x211
Sep  3 16:34:00 natasha kernel: [ 1679.792553]  [<ffffffff8105e326>] ? 
autoremove_wake_function+0x0/0x2e
Sep  3 16:34:00 natasha kernel: [ 1679.792561]  [<ffffffff8105a266>] ? 
worker_thread+0x0/0x211
Sep  3 16:34:00 natasha kernel: [ 1679.792568]  [<ffffffff8105dfd3>] ? 
kthread+0x84/0x8c
Sep  3 16:34:00 natasha kernel: [ 1679.792577]  [<ffffffff81011aea>] ? 
child_rip+0xa/0x20
Sep  3 16:34:00 natasha kernel: [ 1679.792587]  [<ffffffff81027574>] ? 
flat_send_IPI_mask+0x0/0x5
Sep  3 16:34:00 natasha kernel: [ 1679.792594]  [<ffffffff8105df4f>] ? 
kthread+0x0/0x8c
Sep  3 16:34:00 natasha kernel: [ 1679.792600]  [<ffffffff81011ae0>] ? 
child_rip+0x0/0x20
Sep  3 16:34:00 natasha kernel: [ 1679.792675]  RSP <ffff88012fb97d90>
Sep  3 16:34:00 natasha kernel: [ 1679.792681] ---[ end trace 56631d4c7d46fc1c 
]---

fun times. It seems as though the mvsas driver is a little less robust than 
the ahci driver.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
