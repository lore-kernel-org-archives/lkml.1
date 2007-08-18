Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXHRMxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXHRMxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 08:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbXHRMxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 08:53:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51260 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXHRMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 08:53:30 -0400
Date: Sat, 18 Aug 2007 14:53:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
In-Reply-To: <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
Message-ID: <Pine.LNX.4.64.0708181451130.5186@fbirervta.pbzchgretzou.qr>
References: <46C6C145.70506@abacustree.com> <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1384679659-1187441506=:5186"
Content-ID: <Pine.LNX.4.64.0708181452130.5186@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1384679659-1187441506=:5186
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0708181452131.5186@fbirervta.pbzchgretzou.qr>


On Aug 18 2007 13:31, Måns Rullgård wrote:
>>
>> BUG: unable to handle kernel paging request at virtual address b8af9d60
>> printing eip:
>> c0415974
>> *pde = 00000000
>> Oops: 0000 [#1]
>> SMP last sysfs file: /block/loop7/dev
>> Modules linked in: loop nfsd exportfs lockd nfs_acl iscsi_trgt(U)
>> autofs4 hidp nls_utf8 cifs ppdev rfcomm l2cap bluetooth vmnet(U)
>> vmmon(U) sunrpc ipv6 xfs(U) video sbs i2c_ec button battery asus_acpi
>> ac lp st sg floppy serio_raw intel_rng pcspkr e100 mii e7xxx_edac
>> i2c_i801 edac_mc i2c_core e1000 r8169 ide_cd cdrom parport_pc parport
>> dm_snapshot dm_zero dm_mirror dm_mod cciss mptspi mptscsih
>> scsi_transport_spi sd_mod scsi_mod mptbase ext3 jbd ehci_hcd ohci_hcd
>> uhci_hcd
>> CPU:    1
>> EIP:    0060:[<c0415974>]    Tainted: P      VLI
>> EFLAGS: 00010046   (2.6.18-8.1.8.el5 #1) EIP is at
>> smp_send_reschedule+0x3/0x53
>> eax: c213f000   ebx: c213f000   ecx: eef84000   edx: c213f000
>> esi: 00001086   edi: f668c000   ebp: f4f2fce8   esp: f4f2fc8c
>> ds: 007b   es: 007b   ss: 0068
>> Process crond (pid: 3146, ti=f4f2f000 task=f51faaa0 task.ti=f4f2f000)
>> Stack: 66d66b89 c041dc23 00000000 a9afbb0e fffffea5 01904500 00000000
>> 0000000f     00000000 00000001 00000001 c200c6e0 00000100 00000000
>> 00000069 00000180     018fc500 c200d240 00000003 00000292 f601efc0
>> f6027e00 00000000 00000050 Call Trace:
>> [<c041dc23>] try_to_wake_up+0x351/0x37b
>> [<f936884e>] xfsbufd_wakeup+0x28/0x49 [xfs]
>> [<c04572f9>] shrink_slab+0x56/0x13c
[...]
>
>Your Redhat kernel is probably built with 4k stacks and XFS+loop+ext3
>seems to be enough to overflow it.

I think we should include the vermagic string in oopses too, 
so that the flags SMP, PREEMPT, RT, 4KSTACKS, mod_unload, etc. are shown 
and the situation is a bit more apparent.



	Jan
-- 
---699020219-1384679659-1187441506=:5186--
