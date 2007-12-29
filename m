Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXL3DIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXL3DIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXL3DIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:08:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54670 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXL3DII (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:08:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - crash in tick_sched_timer/update_process_times
In-Reply-To: Your message of "Thu, 27 Dec 2007 12:54:34 EST."
             <18487.1198778074@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20071222233056.d652743e.akpm@linux-foundation.org>
            <18487.1198778074@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198944128_3550P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Dec 2007 11:02:08 -0500
Message-ID: <4103.1198944128@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198944128_3550P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4068.1198944090.1@turing-police.cc.vt.edu>

On Thu, 27 Dec 2007 12:54:34 EST, Valdis.Kletnieks@vt.edu said:

> [15345.901919] Unable to handle kernel paging request at 000000af008c00cd RIP:
> [15345.901934]  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.901952] PGD 0
> [15345.901959] Oops: 0000 [1] PREEMPT SMP
> [15345.901972] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
> [15345.901978] CPU 1
> [15345.901984] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic acpi_cpufreq tpm_tis pcmcia gspca(U) iwl3945 firmware_class iTCO_wdt yenta_socket compat_ioctl32 ohci1394 rsrc_nonstatic iTCO_vendor_support mac80211 ieee1394 pcmcia_core nvidia(P)(U) watchdog_core battery videodev ac watchdog_dev v4l2_common snd_hda_intel v4l1_compat thermal power_supply cfg80211 button intel_agp processor rtc
> [15345.902170] Pid: 0, comm: Eterm Tainted: P        2.6.24-rc6-mm1 #4
> [15345.902176] RIP: 0010:[<ffffffff802310d9>]  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.902189] RSP: 0018:ffff81007f8a3eb8  EFLAGS: 00010083
> [15345.902195] RAX: 000000af008c005d RBX: 00000df4fefac7d9 RCX: 0000000000000004
> [15345.902202] RDX: 0000000000000004 RSI: ffff81007e405600 RDI: ffff810001011180
> [15345.902208] RBP: ffff81007f8a3ed8 R08: 0000000000000010 R09: 0000000000000001
> [15345.902214] R10: ffff8100808f4000 R11: ffffffff8071d180 R12: ffff810001011180
> [15345.902219] R13: 0000000000000001 R14: ffff81007e405600 R15: 0000000000000001
> [15345.902226] FS:  0000000000000000(0000) GS:ffff81007f86f9c0(0063) knlGS:00000000f7dab6c0
> [15345.902233] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [15345.902238] CR2: 000000af008c00cd CR3: 00000000766c8000 CR4: 00000000000006e0
> [15345.902244] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [15345.902249] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [15345.902256] Process Eterm (pid: 0, threadinfo 4394404dffffffff, task ffff81007e405600)
> [15345.902261] Stack:  0000000000000001 0000000000000000 ffff81007e405600 00000c71d7bbe7da
> [15345.902279]  ffff81007f8a3f08 ffffffff8023f913 ffff81007f8a3f08 ffff81000100e060
> [15345.902293]  ffff810077161b08 ffff81000100df60 ffff81007f8a3f38 ffffffff80251b7d
> [15345.902306] Call Trace:
> [15345.902312]  <IRQ>  [<ffffffff8023f913>] update_process_times+0x4a/0x5b
> [15345.902334]  [<ffffffff80251b7d>] tick_sched_timer+0x8e/0xcb
> [15345.902345]  [<ffffffff8024ce2c>] hrtimer_interrupt+0x111/0x1a1
> [15345.902357]  [<ffffffff8022733e>] ia32_setup_frame+0xb5/0x1b7
> [15345.902367]  [<ffffffff8021f174>] smp_apic_timer_interrupt+0x86/0xa6
> [15345.902377]  [<ffffffff8020cca6>] apic_timer_interrupt+0x66/0x70
> [15345.902383]  <EOI>
> [15345.902389]
> [15345.902390] Code: ff 50 70 4c 89 e7 e8 4a 2d 2f 00 44 89 ef e8 85 9f ff ff 41
> [15345.902445] RIP  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.902455]  RSP <ffff81007f8a3eb8>
> [15345.902461] CR2: 000000af008c00cd

In case it makes a difference, the Eterm that causes the issue on exit is
a 32-bit binary, with a 64-bit kernel (though I did have one kernel lockup
with xpdf, which is a 64-bit binary, but I can't prove that was/wasn't this
same issue)....

Bisection says:

git-ipwireless_cs.patch GOOD
#
git-x86.patch
git-x86-fixup.patch
git-x86-arch-x86-math-emu-errorsc-fix-printk-warnings.patch
git-x86-drivers-pnp-pnpbios-bioscallsc-build-fix.patch
git-x86-fix-doubly-merged-patch.patch
git-x86-export-leave_mm.patch   BAD

and that's where bisection comes to a halt...

Time to bisect through git-x86, or somebody got a better idea?  Looking at
the commits listed in git-x86.patch, I didn't see anything that jumped out,
but I'm pretty sure the problem is in there somewhere...

--==_Exmh_1198944128_3550P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdm+AcC3lWbTT17ARAte4AKCRFNxVTYSbaD7CD+i97PQoq1XbxwCg4757
w7nomM/lywuLZLLJ8ljbnWs=
=J44v
-----END PGP SIGNATURE-----

--==_Exmh_1198944128_3550P--
