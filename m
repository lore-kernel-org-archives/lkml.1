Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbXLLNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbXLLNGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXLLNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:06:10 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:25838 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbXLLNGJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:06:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Wed, 12 Dec 2007 08:05:46 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0015201F7@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: Acg8jfiUfoMfIWNGT/Wuvcw+dxRQZwALQCRQAAEWzuA=
References: <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com> <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Greg KH" <gregkh@suse.de>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>, <kay.sievers@vrfy.org>,
       "Balbir Singh" <balbir@in.ibm.com>
X-OriginalArrivalTime: 12 Dec 2007 13:05:46.0973 (UTC) FILETIME=[B5FCE8D0:01C83CBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Fortier,Vincent [Montreal]
> 
> > -----Message d'origine-----
> > De : Dhaval Giani [mailto:dhaval@linux.vnet.ibm.com]
> > 
> > On Tue, Dec 11, 2007 at 10:06:53PM +0100, Ingo Molnar wrote:
> > > 
> > > * Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:
> > > 
> > > > > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > > > 
> > > > Here is my config.
> > > > 
> > > > Maybie I should give it a shot without CFS at all and see what 
> > > > happends ?
> 
> It got triggerred also using a 2.6.22.14:

Just to clarify... this is a non CFS kernel oops...

> [57560.396000] BUG: unable to handle kernel paging request at 
> virtual address 80000000 [57560.396000]  printing eip:
> [57560.396000] c01d6c56
> [57560.396000] *pdpt = 0000000008d02001
> [57560.396000] *pde = 0000000000000000
> [57560.396000] Oops: 0000 [#34]
> [57560.396000] SMP
> [57560.396000] last sysfs file: 
> /devices/platform/floppy.0/uevent [57560.396000] Modules 
> linked in: xfs drbd cn nfs nfsd exportfs lockd nfs_acl sunrpc 
> ppdev parport_pc lp parport button ac battery ipv6 fuse 
> ide_cd ide_generic usbkbd usbmouse tsdev iTCO_wdt 
> iTCO_vendor_support psmouse e752x_edac edac_mc serio_raw 
> evdev pcspkr sg floppy shpchp pci_hotplug sr_mod cdrom ext3 
> jbd mbcache dm_mirror dm_snapshot dm_mod generic piix 
> ide_core tg3 ata_piix ehci_hcd uhci_hcd usbcore thermal 
> processor fan mptscsih mptbase megaraid_sas megaraid_mbox 
> megaraid_mm cciss aacraid
> [57560.396000] CPU:    2
> [57560.396000] EIP:    0060:[<c01d6c56>]    Not tainted VLI
> [57560.396000] EFLAGS: 00010297   (2.6.22.14-etch-686-envcan #1)
> [57560.396000] EIP is at vsnprintf+0x2af/0x48c
> [57560.396000] eax: 80000000   ebx: ffffffff   ecx: 80000000   edx:
> fffffffe
> [57560.396000] esi: edf37017   edi: edf09eac   ebp: ffffffff   esp:
> edf09e4c
> [57560.396000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [57560.396000] Process clBackup (pid: 31421, ti=edf08000 task=f7d36530
> task.ti=edf08000)
> [57560.396000] Stack: c852b000 00001000 c0338c78 f895b56c 
> c0233bf5 c852b000 120c8fe8 edf37017
> [57560.396000]        00c3bd08 00000000 ffffffff ffffffff 00000000
> c03354eb 00000003 00000017
> [57560.396000]        c0376dc0 c852b000 c01d6eb4 edf09eac edf09eac
> c0233170 edf37017 c03354ea
> [57560.396000] Call Trace:
> [57560.396000]  [<c0233bf5>] dev_uevent+0x189/0x1e0 
> [57560.396000]  [<c01d6eb4>] sprintf+0x20/0x23 [57560.396000] 
>  [<c0233170>] show_uevent+0xad/0xd5 [57560.396000]  
> [<c0154f48>] get_page_from_freelist+0x296/0x32d
> [57560.396000]  [<c012e6f0>] group_send_sig_info+0x12/0x56 
> [57560.396000]  [<c0155031>] __alloc_pages+0x52/0x294 
> [57560.396000]  [<c02330c3>] show_uevent+0x0/0xd5 
> [57560.396000]  [<c0232c82>] dev_attr_show+0x15/0x18 
> [57560.396000]  [<c01a6979>] sysfs_read_file+0x87/0xd8 
> [57560.396000]  [<c0185f04>] sys_getxattr+0x46/0x4e 
> [57560.396000]  [<c01a68f2>] sysfs_read_file+0x0/0xd8 
> [57560.396000]  [<c016fe03>] vfs_read+0xa6/0x128 
> [57560.396000]  [<c01701ff>] sys_read+0x41/0x67 
> [57560.396000]  [<c0103d8a>] syscall_call+0x7/0xb 
> [57560.396000]  ======================= [57560.396000] Code: 
> 74 24 28 73 03 c6 06 20 4d 46 85 ed 7f f1 e9 b9 00 00 00 8b 
> 0f b8 79 e0 32 c0 8b 54 24 2c 81 f9 ff 0f 00 00 0f 46 c8 89 
> c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 f6 44 24 
> 30 10 89 c3 [57560.396000] EIP: [<c01d6c56>] 
> vsnprintf+0x2af/0x48c SS:ESP 0068:edf09e4c
> 
> > > 
> > > and also with CFS but without CONFIG_FAIR_GROUP_SCHED.
> > > 
> 
> Is it still required since it now does not seems to be CFS related?
> 
> > 
> > Hi Ingo,
> > 
> > I am able to reproduce the oops here on my system with
> > 2.6.22.14 + CFS backport. I am not able to reproduce it with
> > 2.6.22.13 + CFS backport. I believe the CFS backport is 
> just exposing 
> > the bug. Can't find an obvious culprit and am looking into 
> this issue.
> > 
> > Vincent, could you please confirm if you are able to reproduce this 
> > with
> > 2.6.22.13 + CFS?
> 
> Using 2.6.13 + CFS v24 I was also able to reproduce the bug 
> (I already had one built in my depot without the 
> display_most-recently-opened_sysfs_file_name_when_oopsing.patc
> h).  So it looks like it is at least related to >= 2.6.22.13 
> and probably not directly CFS related.  Note that to get a 
> oops on a 2.6.13 it seems to need a full backup since it 
> usually works with incremental.  The backup does start 
> properly then, in this case, at around 70% it oopsed.  Using
> 2.6.22.14 it seems to oops right at startup.  Here is the 
> 2.6.22.13 CFS v24 oops:

Again, just to clarify, I'm not even sure the backup worked at all using
a 2.6.22.13 CFS v24 since I already had a previous pending full backup
at 70% ... so it may simply had tried to finalize that one and crash
right at startup?

> [  170.152908] SGI XFS Quota Management subsystem [  
> 170.168443] Filesystem "drbd0": Disabling barriers, not 
> supported by the underlying device [  170.174964] XFS 
> mounting filesystem drbd0 [  170.232455] Ending clean XFS 
> mount for filesystem: drbd0 [  170.318614] Filesystem 
> "drbd1": Disabling barriers, not supported by the underlying 
> device [  170.327708] XFS mounting filesystem drbd1 [  
> 170.380481] Ending clean XFS mount for filesystem: drbd1 [  
> 947.493764] BUG: unable to handle kernel NULL pointer 
> dereference at virtual address 000000c8 [  947.493797]  printing eip:
> [  947.493810] c01a922c
> [  947.493823] *pdpt = 000000002a97a001
> [  947.493837] *pde = 0000000000000000
> [  947.493852] Oops: 0000 [#1]
> [  947.493865] SMP
> [  947.493881] Modules linked in: xfs drbd cn nfs nfsd 
> exportfs lockd nfs_acl sunrpc ppdev parport_pc lp parport 
> button ac battery ipv6 fuse ide_cd ide_generic usbkbd 
> usbmouse tsdev iTCO_wdt iTCO_vendor_support sg e752x_edac 
> psmouse edac_mc pcspkr evdev shpchp pci_hotplug serio_raw 
> sr_mod floppy cdrom ext3 jbd mbcache dm_mirror dm_snapshot 
> dm_mod generic piix ide_core ehci_hcd uhci_hcd ata_piix 
> usbcore tg3 thermal processor fan mptscsih mptbase 
> megaraid_sas megaraid_mbox megaraid_mm cciss aacraid
> [  947.494099] CPU:    0
> [  947.494100] EIP:    0060:[<c01a922c>]    Not tainted VLI
> [  947.494102] EFLAGS: 00010202   (2.6.22.13-cfs-etch-686-envcan #1)
> [  947.494148] EIP is at sysfs_open_file+0x78/0x1e4
> [  947.494163] eax: 00000000   ebx: dff18440   ecx: 0000000d   edx:
> 000000c8
> [  947.494181] esi: f7fc118c   edi: eb385f30   ebp: c01a91b4   esp:
> eb385edc
> [  947.494199] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [  947.494217] Process clBackup (pid: 5273, ti=eb384000 task=f6558000
> task.ti=eb384000)
> [  947.494235] Stack: ec339cc0 eafae158 f7fc1148 ec339cc0 
> eafae158 eb385f30 c01a91b4 c01704ac
> [  947.494278]        dfaa8080 eafad220 ec339cc0 00008000 eb385f30
> 00000010 c01705dd ec339cc0
> [  947.494321]        00000000 00000000 c017061e 00000000 eb385f30
> eafad220 dfaa8080 f711dd00
> [  947.494364] Call Trace:
> [  947.494389]  [<c01a91b4>] sysfs_open_file+0x0/0x1e4 [  
> 947.494407]  [<c01704ac>] __dentry_open+0xc1/0x178 [  
> 947.494429]  [<c01705dd>] nameidata_to_filp+0x24/0x33 [  
> 947.494450]  [<c017061e>] do_filp_open+0x32/0x39 [  
> 947.494475]  [<c017038b>] get_unused_fd+0x4a/0xaa [  
> 947.494496]  [<c0170667>] do_sys_open+0x42/0xc3 [  
> 947.494518]  [<c0170721>] sys_open+0x1c/0x1e [  947.494537]  
> [<c0103d8a>] syscall_call+0x7/0xb [  947.494561]  
> ======================= [  947.494577] Code: 14 24 83 7c 24 
> 08 00 8b 42 0c 8b 40 54 8b 70 14 0f
> 84 70 01 00 00 85 f6 0f 84 68 01 00 00 8b 56 04 85 d2 74 19 
> 64 a1 08 50 3d c0 <83> 3a 02 0f 84 42 01 00 00 c1 e0 05 ff 84 
> 10 20 01 00 00 8b 54 [  947.494743] EIP: [<c01a922c>] 
> sysfs_open_file+0x78/0x1e4 SS:ESP 0068:eb385edc
> 

Regards,

- vin
