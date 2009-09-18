Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbZIRD04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbZIRD04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIRD0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:26:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:22587 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZIRD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=A3uJueD6rfp3no/JvF+GiriwuaEKkAx3EH2En5QRvdwaqAzggwbsN1FuPJIQagQj43
         75ErYCnenAXVEqrMXFRVfJ0VYE3ri67kg/foH1MeknQIjbYO0Hl/BeQlZyhcPGdJSHaI
         cT6zumrJZmTY87ZB1FcBwp+kNXPIjiUDMR5E0=
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 11:26:56 +0800
Message-ID: <2375c9f90909172026o6095f0adx46df2bb05c46ff89@mail.gmail.com>
Subject: hugetlbfs warning in mmtom
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: William Irwin <wli@holomorphy.com>, James Morris <jmorris@namei.org>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that this one is not reported yet.

Please feel free to ask more info from me if you need.

Here it is:

Sep 17 16:07:24 dhcp-66-70-5 kernel: ------------[ cut here ]------------
Sep 17 16:07:24 dhcp-66-70-5 kernel: WARNING: at
fs/hugetlbfs/inode.c:957 hugetlb_file_setup+0x136/0x398()
Sep 17 16:07:24 dhcp-66-70-5 kernel: Hardware name: PowerEdge T105
Sep 17 16:07:24 dhcp-66-70-5 kernel: Using mlock ulimits for
SHM_HUGETLB deprecated
Sep 17 16:07:24 dhcp-66-70-5 kernel: Modules linked in: ib_iser
rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand
powernow_k8 freq_table dm_multipath scsi_dh video output sbs sbshc
battery acpi_memhotplug ac parport_pc lp parport sg dcdbas sr_mod
cdrom serio_raw tg3 libphy button rtc_cmos rtc_core rtc_lib
i2c_nforce2 i2c_core shpchp pcspkr dm_snapshot dm_zero dm_mirror
dm_region_hash dm_log dm_mod sata_nv libata sd_mod scsi_mod ext3 jbd
uhci_hcd ohci_hcd ehci_hcd
Sep 17 16:07:24 dhcp-66-70-5 kernel: Pid: 3240, comm: auditd Tainted:
G        W  2.6.31-mm1 #1
Sep 17 16:07:24 dhcp-66-70-5 kernel: Call Trace:
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff811d8414>] ?
hugetlb_file_setup+0x136/0x398
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8106352a>] ?
warn_slowpath_common+0xb8/0xe5
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff810635e5>] ?
warn_slowpath_fmt+0x66/0x7c
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff811f92f4>] ?
security_capable+0x4b/0x54
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff81070d26>] ? capable+0x3e/0x79
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8111aeb9>] ?
user_shm_lock+0x9b/0xf1
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff811d8414>] ?
hugetlb_file_setup+0x136/0x398
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8111e75a>] ?
do_mmap_pgoff+0x28c/0x608
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8108d896>] ? up_read+0x10/0x19
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8101246d>] ? sys_mmap+0xcb/0x124
Sep 17 16:07:24 dhcp-66-70-5 kernel:  [<ffffffff8100c7ab>] ?
system_call_fastpath+0x16/0x1b
Sep 17 16:07:24 dhcp-66-70-5 kernel: ---[ end trace d386d7615cf4b03d ]---
