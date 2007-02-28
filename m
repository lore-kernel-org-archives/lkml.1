Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXB1Aqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXB1Aqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXB1Aqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:46:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXB1Aqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:46:43 -0500
Date: Tue, 27 Feb 2007 19:46:41 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fwd: oprofile lockdep warning on rc1
Message-ID: <20070228004641.GC12600@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This happened on a 2.6.21rc1 kernel.

		Dave

-- 
http://www.codemonkey.org.uk

--E39vaYmALEf/7YXx
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <fedora-devel-list-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.1.8 (2007-02-13) on
	gelk.kernelslacker.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=5.0 tests=AWL,BAYES_00,
	UNPARSEABLE_RELAY autolearn=ham version=3.1.8
Received: from pobox.devel.redhat.com [10.11.255.8]
	by gelk.kernelslacker.org with IMAP (fetchmail-6.3.6)
	for <davej@localhost> (single-drop); Tue, 27 Feb 2007 17:01:26 -0500 (EST)
Received: from pobox.devel.redhat.com ([unix socket])
	 by pobox.devel.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-3.RHEL4.1) with LMTPA;
	 Tue, 27 Feb 2007 17:00:19 -0500
X-Sieve: CMU Sieve 2.2
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l1RM0JCQ032710;
	Tue, 27 Feb 2007 17:00:19 -0500
Received: from mx1.util.phx.redhat.com (mx1.util.phx.redhat.com [10.8.4.92])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1RM0EDL022983;
	Tue, 27 Feb 2007 17:00:14 -0500
Received: from hormel.redhat.com (hormel.util.phx.redhat.com [10.8.4.111])
	by mx1.util.phx.redhat.com (8.13.1/8.13.1) with ESMTP id l1RM09Yg023411;
	Tue, 27 Feb 2007 17:00:09 -0500
Received: from listman.util.phx.redhat.com (listman.util.phx.redhat.com [10.8.4.110])
	by hormel.redhat.com (Postfix) with ESMTP
	id 1554F735D9; Tue, 27 Feb 2007 17:00:08 -0500 (EST)
Received: from int-mx2.corp.redhat.com (nat-pool.util.phx.redhat.com
	[10.8.5.200])
	by listman.util.phx.redhat.com (8.13.1/8.13.1) with ESMTP id
	l1RM06mT005927 for <fedora-devel-list@listman.util.phx.redhat.com>;
	Tue, 27 Feb 2007 17:00:06 -0500
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1RM05DD021856
	for <fedora-devel-list@redhat.com>; Tue, 27 Feb 2007 17:00:05 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx2.redhat.com (8.13.1/8.13.1) with ESMTP id l1RM00vO028265
	for <fedora-devel-list@redhat.com>; Tue, 27 Feb 2007 17:00:01 -0500
Received: by ug-out-1314.google.com with SMTP id x30so1416233ugc
	for <fedora-devel-list@redhat.com>;
	Tue, 27 Feb 2007 14:00:00 -0800 (PST)
DKIM-Signature: a=rsa-sha1; c=relaxed/relaxed; d=gmail.com; s=beta;
	h=domainkey-signature:received:received:subject:from:to:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=OF8YAdGw9zWrIuOPFqsNOvT+gtDg5I+tBmM3QHLqnnAacRQ1qlmgr8SbG9robXxUTuuVLv4vAgh5CjfZ39Qqt/nD8cBNUBn/8FapNQKDpM4+aK/3UOXhVzQB95OOtwFKST6YIfR24z+I3NfBaklAX+JsuOwUrmw78gXNMaAdtFQ=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=gmail.com; s=beta;
	h=received:subject:from:to:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=cfEY4SmHujR0lHld6RpcfmXWP2r8dljCU5krTueYIeiOAEYgpEvA6K8ka8jyunz3NN2Y68brEykvCCgSkpkB3DdZFXjcmhQ2lpdc61tdkpHaZUtJMHocPBV3oCwHwpcwc8+MMMcMxwmFCKQxtmruKsbCimFggx9w5CgMvw9pHD8=
Received: by 10.67.100.17 with SMTP id c17mr8699193ugm.1172613600276;
	Tue, 27 Feb 2007 14:00:00 -0800 (PST)
Received: from ?10.0.0.11? ( [86.138.100.225])
	by mx.google.com with ESMTP id e9sm7538487muf.2007.02.27.13.59.59;
	Tue, 27 Feb 2007 13:59:59 -0800 (PST)
From: Richard Hughes <hughsient@gmail.com>
To: Development discussions related to Fedora Core <fedora-devel-list@redhat.com>
In-Reply-To: <1172605950.22136.18.camel@localhost.localdomain>
References: <1172605747.2688.14.camel@localhost.localdomain>
	<1172605950.22136.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 21:59:07 +0000
Message-Id: <1172613547.2699.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 (2.9.91-3.fc7) 
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: 0 
X-loop: fedora-devel-list@redhat.com
Subject: Re: XOrg weirdness
X-BeenThere: fedora-devel-list@redhat.com
X-Mailman-Version: 2.1.5
Precedence: junk
Reply-To: Development discussions related to Fedora Core <fedora-devel-list@redhat.com>
List-Id: Development discussions related to Fedora Core
	<fedora-devel-list.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-devel-list>, 
	<mailto:fedora-devel-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-devel-list>
List-Post: <mailto:fedora-devel-list@redhat.com>
List-Help: <mailto:fedora-devel-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-devel-list>,
	<mailto:fedora-devel-list-request@redhat.com?subject=subscribe>
Sender: fedora-devel-list-bounces@redhat.com
Errors-To: fedora-devel-list-bounces@redhat.com

On Tue, 2007-02-27 at 14:52 -0500, Adam Jackson wrote:
> 
> 
> Well it's at least partly Xorg's fault, but it would be helpful to
> know
> what the slow path is there; so if you do file a bug against Xorg,
> please accompany it with oprofile goodness.

Well, I get this:

CPU: Core Solo / Duo, speed 1662.57 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Unhalted clock cycles) with a unit mask
of 0x00 (Unhalted core cycles) count 860000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    12704 82.6330 /usr/bin/Xorg
        CPU_CLK_UNHALT...|
          samples|      %|
        ------------------
            12066 94.9780 /usr/lib/xorg/modules/libfb.so
              286  2.2513 /usr/bin/Xorg
              216  1.7003 /usr/lib/xorg/modules/drivers/nv_drv.so
               75  0.5904 /lib/libc-2.5.90.so
               48  0.3778 /usr/lib/xorg/modules/libxaa.so
                6  0.0472 /usr/lib/xorg/modules/extensions/libextmod.so
                3  0.0236 /lib/librt-2.5.90.so
                1  0.0079 /usr/lib/libXfont.so.1.4.1
                1  0.0079 /usr/lib/xorg/modules/input/mouse_drv.so
                1  0.0079 /usr/lib/xorg/modules/input/synaptics_drv.so
                1  0.0079 /usr/lib/xorg/modules/libramdac.so

But also I get this (!!!):

oprofile: using NMI interrupt.

=================================
[ INFO: inconsistent lock state ]
2.6.20-1.2949.fc7 #1
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (oprofilefs_lock){+-..}, at: [<f8c6db5e>] nmi_cpu_setup+0x15/0x4f
[oprofile]
{hardirq-on-W} state was registered at:
  [<c0442440>] __lock_acquire+0x448/0xba4
  [<c0442f8e>] lock_acquire+0x56/0x6f
  [<c0614949>] _spin_lock+0x2b/0x38
  [<f8c6d33c>] oprofilefs_ulong_from_user+0x4e/0x74 [oprofile]
  [<f8c6d38c>] ulong_write_file+0x2a/0x38 [oprofile]
  [<c047e20b>] vfs_write+0xaf/0x163
  [<c047e859>] sys_write+0x3d/0x61
  [<c0405134>] syscall_call+0x7/0xb
  [<ffffffff>] 0xffffffff
irq event stamp: 23424902
hardirqs last  enabled at (23424901): [<c0614d4d>]
_spin_unlock_irqrestore+0x36/0x3c
hardirqs last disabled at (23424902): [<c0405bb5>]
call_function_interrupt+0x29/0x38
softirqs last  enabled at (23424892): [<c042c0d8>] __do_softirq
+0xdc/0xe2
softirqs last disabled at (23424885): [<c04074dc>] do_softirq+0x61/0xd0

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:
 [<c04062a5>] show_trace_log_lvl+0x1a/0x2f
 [<c0406869>] show_trace+0x12/0x14
 [<c04068ed>] dump_stack+0x16/0x18
 [<c0440f67>] print_usage_bug+0x141/0x14b
 [<c0441620>] mark_lock+0xa2/0x419
 [<c04423b1>] __lock_acquire+0x3b9/0xba4
 [<c0442f8e>] lock_acquire+0x56/0x6f
 [<c0614949>] _spin_lock+0x2b/0x38
 [<f8c6db5e>] nmi_cpu_setup+0x15/0x4f [oprofile]
 [<c0417e6a>] smp_call_function_interrupt+0x3f/0x5b
 [<c0405bbf>] call_function_interrupt+0x33/0x38
 [<c0614896>] _spin_unlock+0x16/0x20
 [<c043ded6>] clockevents_notify+0x3e/0x42
 [<c0532f67>] acpi_state_timer_broadcast+0x2e/0x31
 [<c05338e8>] acpi_processor_idle+0x285/0x419
 [<c040348e>] cpu_idle+0xb7/0xdd
 [<c0418eef>] start_secondary+0x330/0x338
 [<00000000>] 0x0
 =======================

Why do the simplest bugs always turn into the most complicated ones ;-)

Richard.


-- 
fedora-devel-list mailing list
fedora-devel-list@redhat.com
https://www.redhat.com/mailman/listinfo/fedora-devel-list

--E39vaYmALEf/7YXx--
