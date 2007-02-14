Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXBNAgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXBNAgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbXBNAgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:36:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbXBNAgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:36:51 -0500
Message-ID: <45D259C3.6070109@redhat.com>
Date: Tue, 13 Feb 2007 19:37:23 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Help! How do I debug oopsing kernel workqueue threads?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How the hell do I tell what kernel subsystem queued
a bogus work item?

BUG: unable to handle kernel paging request at virtual address 00002074
 printing eip:
c04f3b55
*pde = 71bb1067
Oops: 0000 [#1]
SMP
last sysfs file: /class/scsi_host/host2/proc_name
Modules linked in: hwmon i2c_isa eeprom sunrpc ipv6 ip_nat_sip ip_nat_pptp 
ip_nat_ftp ip_conntrack_sip ip_conntrack_pptp ip_conntrack_ftp xt_helper ipt_LOG 
xt_state xt_tcpudp iptable_mangle iptable_nat ip_nat ip_conntrack nfnetlink 
iptable_filter ip_tables x_tables dm_mirror dm_multipath dm_mod video sbs i2c_ec 
button battery asus_acpi ac lp snd_hda_intel snd_hda_codec snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss 
sg snd_pcm snd_timer ide_cd floppy snd serio_raw cdrom sky2 ohci1394 ieee1394 
soundcore pcspkr iTCO_wdt skge i2c_i801 snd_page_alloc i2c_core parport_pc 
parport ata_piix libata aacraid sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd 
uhci_hcd
CPU:    0
EIP:    0060:[<c04f3b55>]    Not tainted VLI
EFLAGS: 00010046   (2.6.19-1.2895.fc6 #1)
EIP is at list_del+0x2d/0x6c
eax: 00002070   ebx: f76f0f80   ecx: 00000001   edx: 00000000
esi: f7ff8dc0   edi: d6ca8000   ebp: f7e6f380   esp: f7fefef0
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 8, ti=f7fef000 task=f7e205d0 task.ti=f7fef000)
Stack: f7e205d0 d7ade040 f7ff8d40 f76f0f80 c04717fc f703e0c0 c07a2fc8 f703e0c0
       00000001 00000000 f7ff8e60 f7ff8e60 00000001 f7ff8e40 00000000 c04718ff
       00000000 00000000 f7e6f380 f7ff8de4 f7ff8dc0 f7e6f380 f7e0bac0 00000282
Call Trace:
 [<c04717fc>] free_block+0x77/0xf0
 [<c04718ff>] drain_array+0x8a/0xb5
 [<c0472e9c>] cache_reap+0x53/0x117
 [<c04368c7>] run_workqueue+0x97/0xdd
 [<c0437284>] worker_thread+0xd9/0x10d
 [<c0439810>] kthread+0xc0/0xec
 [<c0404c03>] kernel_thread_helper+0x7/0x10
