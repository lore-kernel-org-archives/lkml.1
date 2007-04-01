Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXDAQA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXDAQA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXDAQA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:00:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:9356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416AbXDAQA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UlIqQ4tPmsAaH1IMgQvwINhge7TQV0O5X0UNdFP6/ufzH1V3j2kfFUvsH1tneqwU8e6iDaIBjL/nIjTQBIETBLVUJmrKguVmML+pEtdESt5bGbaW2HTGX34zqCwkV/Wfv89OVXQKwPodphNRr/ArKvAtjfZX6hPa6aL7lY4AvTc=
Message-ID: <460FD70C.1040602@googlemail.com>
Date: Sun, 01 Apr 2007 18:00:12 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
> 

BUG: at /mnt/md0/devel/linux-mm/arch/i386/kernel/smp.c:571 native_smp_call_function_mask()
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c0105343>] show_trace_log_lvl+0x1a/0x30
 [<c0105f8a>] show_trace+0x12/0x14
 [<c0106027>] dump_stack+0x16/0x18
 [<c0113a92>] native_smp_call_function_mask+0x57/0x14b
 [<c0113c9b>] smp_call_function+0x1e/0x22
 [<c0129a60>] on_each_cpu+0x2a/0x73
 [<c013a12d>] clock_was_set+0x1b/0x1d
 [<c013b99d>] timekeeping_resume+0xb5/0xbb
 [<c027af35>] __sysdev_resume+0x17/0x5d
 [<c027b2aa>] sysdev_resume+0x19/0x4b
 [<c027fd12>] device_power_up+0xb/0x12
 [<c014f30b>] swsusp_suspend+0x55/0x63
 [<c014fad0>] pm_suspend_disk+0x163/0x28f
 [<c014e7be>] enter_state+0x54/0x1d5
 [<c014e9c5>] state_store+0x86/0x9c
 [<c01bfe47>] subsys_attr_store+0x23/0x2b
 [<c01bff89>] sysfs_write_file+0xc1/0xe9
 [<c0186485>] vfs_write+0xd1/0x15a
 [<c0186ab7>] sys_write+0x3d/0x72
 [<c010424c>] syscall_call+0x7/0xb
 [<b7f9b410>] 0xb7f9b410
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: swsusp_shutdown/3246
caller is setup_apic_nmi_watchdog+0x13/0x423
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c0105343>] show_trace_log_lvl+0x1a/0x30
 [<c0105f8a>] show_trace+0x12/0x14
 [<c0106027>] dump_stack+0x16/0x18
 [<c021a0ff>] debug_smp_processor_id+0xb3/0xc8
 [<c011633d>] setup_apic_nmi_watchdog+0x13/0x423
 [<c0116871>] lapic_nmi_resume+0x16/0x1f
 [<c027af35>] __sysdev_resume+0x17/0x5d
 [<c027b2aa>] sysdev_resume+0x19/0x4b
 [<c027fd12>] device_power_up+0xb/0x12
 [<c014f30b>] swsusp_suspend+0x55/0x63
 [<c014fad0>] pm_suspend_disk+0x163/0x28f
 [<c014e7be>] enter_state+0x54/0x1d5
 [<c014e9c5>] state_store+0x86/0x9c
 [<c01bfe47>] subsys_attr_store+0x23/0x2b
 [<c01bff89>] sysfs_write_file+0xc1/0xe9
 [<c0186485>] vfs_write+0xd1/0x15a
 [<c0186ab7>] sys_write+0x3d/0x72
 [<c010424c>] syscall_call+0x7/0xb
 [<b7f9b410>] 0xb7f9b410

 l *setup_apic_nmi_watchdog+0x13
0xc011633d is in setup_apic_nmi_watchdog (/mnt/md0/devel/linux-mm/arch/i386/kernel/nmi.c:793).
788             release_perfctr_nmi(wd->perfctr_msr);
789     }
790
791     void setup_apic_nmi_watchdog (void *unused)
792     {
793             struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
794
795             /* only support LOCAL and IO APICs for now */
796             if ((nmi_watchdog != NMI_LOCAL_APIC) &&
797                 (nmi_watchdog != NMI_IO_APIC))

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm3/mm-console3.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm3/mm-config2

Regards,
Michal

-- 
Michal K. K. Piotrowski
Hurd Testers Group
(http://www.hurdtestersgroup.org/)
