Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXK3Rf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXK3Rf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbXK3Rf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:35:26 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:63536 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756662AbXK3RfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:35:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Fri, 30 Nov 2007 12:35:00 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0B8998E@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071130091239.708173db.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: AcgzdE4LjpGHr0NBT9KnB7mPvlgHegAAt08g
References: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca> <20071130091239.708173db.randy.dunlap@oracle.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Nov 2007 17:35:00.0836 (UTC) FILETIME=[557BCA40:01C83377]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> Envoyé : 30 novembre 2007 12:13
> 
> On Fri, 30 Nov 2007 13:02:54 +0000 Vincent Fortier wrote:
> 
> > Hi all,
> > 
> > I'm using a 2.6.22.14 + CFS v24 and I got theses errors 
> when starting 
> > up my commvault galaxy client...  Do anybody know what this could mean?
> 
> Can you provide a few lines of syslog before the Oops: line, 
> which should contain some info about what happened, e.g.:
> 
> Unable to handle kernel paging request at virtual address 
> e4a85017 printing eip:
> c01d915a
> *pde = 37d0d067
> *pte = 00000000

Would this be better?
[766535.379600] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
[766535.379636]  printing eip:
[766535.379652] c01a920c
[766535.379665] *pdpt = 000000001cc2c001
[766535.379681] *pde = 0000000000000000
[766535.379698] Oops: 0000 [#1]
[766535.379713] SMP
[766535.379729] Modules linked in: xfs drbd cn nfs nfsd exportfs lockd nfs_acl sunrpc ppdev parport_pc lp parport button ac battery ipv6 fuse ide_cd ide_generic usbkbd usbmouse tsdev sg iTCO_wdt iTCO_vendor_support psmouse e752x_edac shpchp serio_raw edac_mc pcspkr evdev sr_mod pci_hotplug floppy cdrom ext3 jbd mbcache dm_mirror dm_snapshot dm_mod generic piix ide_core ehci_hcd uhci_hcd ata_piix tg3 usbcore thermal processor fan mptscsih mptbase megaraid_sas megaraid_mbox megaraid_mm cciss aacraid
[766535.379956] CPU:    0
[766535.379957] EIP:    0060:[<c01a920c>]    Not tainted VLI
[766535.379959] EFLAGS: 00010202   (2.6.22.14-cfs-etch-686-envcan #1)
[766535.380011] EIP is at sysfs_open_file+0x78/0x1e4
[766535.380028] eax: 00000000   ebx: f7f02e58   ecx: 0000000d   edx: 000000c8
[766535.380049] esi: f7e7ec8c   edi: defadf30   ebp: c01a9194   esp: defadedc
[766535.380070] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[766535.380091] Process clBackup (pid: 22085, ti=defac000 task=de01ac60 task.ti=defac000)
[766535.380110] Stack: de093300 dd2ce408 f7e7ec48 de093300 dd2ce408 defadf30 c01a9194 c017048c
[766535.380155]        dfe8a180 dd2cbd48 de093300 00008000 defadf30 0000000d c01705bd de093300
[766535.380202]        00000000 00000000 c01705fe 00000000 defadf30 dd2cbd48 dfe8a180 e0bd6f00
[766535.380246] Call Trace:
[766535.380276]  [<c01a9194>] sysfs_open_file+0x0/0x1e4
[766535.380296]  [<c017048c>] __dentry_open+0xc1/0x178
[766535.380321]  [<c01705bd>] nameidata_to_filp+0x24/0x33
[766535.380343]  [<c01705fe>] do_filp_open+0x32/0x39
[766535.380367]  [<c017036b>] get_unused_fd+0x4a/0xaa
[766535.380390]  [<c0170647>] do_sys_open+0x42/0xc3
[766535.380413]  [<c0170701>] sys_open+0x1c/0x1e
[766535.380434]  [<c0103d8a>] syscall_call+0x7/0xb
[766535.380460]  =======================
[766535.380476] Code: 14 24 83 7c 24 08 00 8b 42 0c 8b 40 54 8b 70 14 0f 84 70 01 00 00 85 f6 0f 84 68 01 00 00 8b 56 04 85 d2 74 19 64 a1 08 50 3d c0 <83> 3a 02 0f 84 42 01 00 00 c1 e0 05 ff 84 10 20 01 00 00 8b 54
[766535.380644] EIP: [<c01a920c>] sysfs_open_file+0x78/0x1e4 SS:ESP 0068:defadedc

Again,

> > 
> > thnx very much!
> 

- vin
