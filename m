Return-Path: <linux-kernel-owner+w=401wt.eu-S934194AbXC0TRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbXC0TRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934195AbXC0TRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:17:30 -0400
Received: from staging.airflowsciences.com ([66.178.220.191]:46341 "EHLO
	staging.airflowsciences.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934194AbXC0TR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:17:29 -0400
X-Greylist: delayed 3533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 15:17:29 EDT
Message-ID: <46095FF7.3070407@airflowsciences.com>
Date: Tue, 27 Mar 2007 14:18:31 -0400
From: "Robert K. Nelson" <rnelson@airflowsciences.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.18.2 kernel NULL pointer dereference at virtual address 00000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting a BUG report on the following SuSE 10.2 system:

$ uname -a
Linux ascbackup 2.6.18.2-34-default #1 SMP Mon Nov 27 11:46:27 UTC 2006
i686 i686 i386 GNU/Linux

The only clear effect I'm seeing is that the system beeps and dumps the
following message in /var/log/messages every 5 to 15 seconds for some
period of time.  Eventually this stops for a while, and then starts up
again.  Any input is appreciated, and if I can help trace it down, let
me know.  Please cc: me with any response.

Mar 27 12:46:50 ascbackup kernel:  <1>BUG: unable to handle kernel NULL
pointer dereference at virtual address 00000000
Mar 27 12:46:50 ascbackup kernel:  printing eip:
Mar 27 12:46:50 ascbackup kernel: c0102005
Mar 27 12:46:50 ascbackup kernel: *pde = 00000000
Mar 27 12:46:50 ascbackup kernel: Oops: 0002 [#11361]
Mar 27 12:46:50 ascbackup kernel: SMP
Mar 27 12:46:50 ascbackup kernel: last sysfs file:
/class/scsi_host/host0/stats
Mar 27 12:46:50 ascbackup kernel: Modules linked in: nls_utf8 cifs nfs
ipv6 nfsd autofs4 exportfs lockd nfs_acl sunrpc button battery ac
apparmor aamatch_pcre loop dm_mod e1000 ide_cd i8xx_tco cdrom intel_rng
i2c_i801 uhci_hcd usbcore i2c_core e7xxx_edac shpchp edac_mc pci_hotplug
parport_pc lp parport ext3 mbcache jbd edd fan thermal processor st
aic7xxx scsi_transport_spi sg 3w_xxxx piix sd_mod scsi_mod ide_disk ide_core
Mar 27 12:46:50 ascbackup kernel: CPU:    0
Mar 27 12:46:50 ascbackup kernel: EIP:    0060:[<c0102005>]    Tainted:
G     U VLI
Mar 27 12:46:50 ascbackup kernel: EFLAGS: 00010246  
(2.6.18.2-34-default #1)
Mar 27 12:46:50 ascbackup kernel: EIP is at kernel_thread_helper+0x5/0xb
Mar 27 12:46:50 ascbackup kernel: eax: 00000000   ebx: c0131360   ecx:
ffffffff   edx: ffffffff
Mar 27 12:46:50 ascbackup kernel: esi: 00000000   edi: 00000000   ebp:
00000000   esp: f3365fec
Mar 27 12:46:50 ascbackup kernel: ds: 007b   es: 007b   ss: 0068
Mar 27 12:46:50 ascbackup kernel: Process pdflush (pid: 29556,
ti=f3364000 task=c3a372c0 task.ti=f3364000)
Mar 27 12:46:50 ascbackup kernel: Stack: db0bbf60 00000000 00000000
61053c48 fe154007
Mar 27 12:46:50 ascbackup kernel: Call Trace:
Mar 27 12:46:50 ascbackup kernel: Code: 90 90 90 90 90 90 90 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
90 90 90 89 d0 52 ff d3 <00> 00 40 3b ff 53 4d 42 2e 00 00 00 00 40 3b
ff 53 4d 42 2e 00
Mar 27 12:46:50 ascbackup kernel: EIP: [<c0102005>]
kernel_thread_helper+0x5/0xb SS:ESP 0068:f3365fec

P.S. A user of Unix since I worked on an OS in 1976 at Cornell, moved my
company to HP-UX in 1983, and moved us over to Linux in 1998.  Many
thanks to all who have been a part of this proud heritage.

-- 
Robert K. Nelson
President
Airflow Sciences Corporation
12190 Hubbard Street, Livonia, MI  48150-1737
(734) 525-0300   FAX (734) 525-0303  www.airflowsciences.com

