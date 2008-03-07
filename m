Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYCGHxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYCGHxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYCGHxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:53:40 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37008 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYCGHxi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:53:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Thu, 06 Mar 2008 22:16:02 PST."
             <20080306221602.790cd26e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu>
            <20080306221602.790cd26e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204876349_3634P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Mar 2008 02:52:29 -0500
Message-ID: <4954.1204876349@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204876349_3634P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Mar 2008 22:16:02 PST, Andrew Morton said:

> > [   74.254402] CPU 1 is now offline
> > [   74.255395] SMP alternatives: switching to UP code
> > [   74.256373] BUG: unable to handle kernel paging request at ffffffff8020a023
> > [   74.256373] IP: [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> > [   74.256373] PGD 203067 PUD 207063 PMD 7e4cc163 PTE 20a161
> > [   74.256373] Oops: 0003 [1] PREEMPT SMP 
> > [   74.256373] last sysfs file: /sys/devices/virtual/block/dm-14/dev
> > [   74.256373] CPU 0 
> > [   74.256373] Modules linked in: rtc sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 ecb pcmcia iwl3945 iTCO_wdt ohci1394 firmware_class iTCO_vendor_support yenta_socket watchdog_core thermal rsrc_nonstatic mac80211 snd_hda_intel intel_agp watchdog_dev ieee1394 pcmcia_core processor button ac battery cfg80211
> > [   74.256373] Pid: 1767, comm: halt Not tainted 2.6.25-rc3-mm1 #8
> > [   74.256373] RIP: 0010:[<ffffffff80211872>]  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> > [   74.256373] RSP: 0018:ffff81007ac63d10  EFLAGS: 00010093
> > [   74.256373] RAX: ffffffff80573190 RBX: ffff81007f83a8c0 RCX: ffffffff80563cec
> > [   74.256373] RDX: ffffffff8020a023 RSI: ffffffff8078a0b8 RDI: ffffffff80783018
> > [   74.256373] RBP: ffff81007ac63d28 R08: 0000000000000001 R09: ffffffff80563cec
> > [   74.256373] R10: ffffffff80200000 R11: ffff81007ac63d1f R12: 0000000000000000
> > [   74.256373] R13: 0000000000000001 R14: 0000000000000246 R15: ffff81007d156340
> > [   74.256373] FS:  00007f2d0ab206f0(0000) GS:ffffffff8076e000(0000) knlGS:0000000000000000
> > [   74.256373] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   74.256373] CR2: ffffffff8020a023 CR3: 000000007edf3000 CR4: 00000000000006e0
> > [   74.256373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   74.256373] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   74.256373] Process halt (pid: 1767, threadinfo ffff81007ac62000, task ffff81007db96300)
> > [   74.256373] Stack:  ffffffff8080df80 90ffffff8055ba3b ffff81007f83a8c0 ffff81007ac63d68
> > [   74.256374]  ffffffff80211a01 ffffffff807c6584 0000000000000001 ffffffff807c6584
> > [   74.256374]  0000000000000001 0000000000000001 0000000000000001 ffff81007ac63d98
> > [   74.256374] Call Trace:
> > [   74.256374]  [<ffffffff80211a01>] alternatives_smp_switch+0x17a/0x1b6
> > [   74.256374]  [<ffffffff80219dd3>] __cpu_die+0x58/0x87
> > [   74.256374]  [<ffffffff805498b2>] _cpu_down+0x1a4/0x28c
> > [   74.256374]  [<ffffffff80252e90>] disable_nonboot_cpus+0x60/0x108
> > [   74.256374]  [<ffffffff80241619>] kernel_power_off+0x21/0x3b
> > [   74.256374]  [<ffffffff80241863>] sys_reboot+0xf8/0x196
> > [   74.256374]  [<ffffffff8055b93f>] ? preempt_schedule+0x3c/0xaa
> > [   74.256374]  [<ffffffff8055b9a4>] ? preempt_schedule+0xa1/0xaa
> > [   74.256374]  [<ffffffff8023e7eb>] ? sys_kill+0xd8/0x1c1
> > [   74.256374]  [<ffffffff8055c112>] ? do_nanosleep+0x4b/0xd6
> > [   74.256374]  [<ffffffff8020c21b>] system_call_after_swapgs+0x7b/0x80
> > [   74.256374] 
> > [   74.256374] 
> > [   74.256374] Code: 57 80 48 0f 42 d0 48 8b 42 08 4c 8d 5d f7 8a 00 41 b8 01 00 00 00 88 45 f7 eb 1b 48 8b 17 4c 39 d2 72 0f 4c 39 ca 77 0a 41 8a 03 <88> 02 44 89 c0 0f a2 48 83 c7 08 48 39 f7 72 e0 5a 59 5b c9 c3 
> > [   74.256374] RIP  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> > [   74.256374]  RSP <ffff81007ac63d10>
> > [   74.256374] CR2: ffffffff8020a023
> 
> Yes, I hit a similar one during halt on the t61p.  But because of the
> netconsole bustage I was only able to see (on the screen) oops #2 - oops #1
> had scrolled off.  oops #2 had a simlar trace and the EIP was in
> text_poke().

OK, I finally managed to catch the *other* failure I was seeing at shutdown,
and it appears to be a variant on the same theme, so readers may feel free to
ignore the rest of this note unless they care about the gory details...

Apparently, if I booted with 'ignore_loglevel' (which is my default when using
netconsole), I hit the above traceback and I'm dead in the water, no alt-sysrq,
need to hold down the power button for 5 seconds.

If I boot with 'quiet' instead, I get the below set of tracebacks, which caused
the original BUG to go scrolling off-screen and obfuscating that it's the same
failure. Adding to the confusion, if it failed in this mode, alt-sysrq still
worked just fine, so alt-sysrq-S-S-U-B got me a reboot.

Now that I know that at least *part* of the issue is the same, I can go
bisecting.  Somebody *else* can ponder why ignore_loglevel/quiet causes the
big difference in behavior after the BUG, that part is beyond my ken...

[  168.036824] BUG: unable to handle kernel paging request at ffffffff8020a023
[  168.037300] IP: [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
[  168.037745] PGD 203067 PUD 207063 PMD 7f989163 PTE 20a161
[  168.037781] Oops: 0003 [1] PREEMPT SMP 
[  168.037781] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
[  168.037781] CPU 0 
[  168.037781] Modules linked in: rtc irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 ecb iwl3945 pcmcia nvidia(P)(U) firmware_class mac80211 ohci1394 snd_hda_intel cfg80211 yenta_socket ieee1394 iTCO_wdt iTCO_vendor_support thermal rsrc_nonstatic ac processor watchdog_core battery watchdog_dev button pcmcia_core intel_agp [last unloaded: x_tables]
[  168.037781] Pid: 3115, comm: halt Tainted: P          2.6.25-rc3-mm1 #8
[  168.037781] RIP: 0010:[<ffffffff80211872>]  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
[  168.037781] RSP: 0000:ffff81007dbebd10  EFLAGS: 00010093
[  168.037781] RAX: ffffffff80573190 RBX: ffff81007f83a8c0 RCX: ffffffff80563cec
[  168.037781] RDX: ffffffff8020a023 RSI: ffffffff8078a0b8 RDI: ffffffff80783018
[  168.037781] RBP: ffff81007dbebd28 R08: 0000000000000001 R09: ffffffff80563cec
[  168.037781] R10: ffffffff80200000 R11: ffff81007dbebd1f R12: 0000000000000000
[  168.037781] R13: 0000000000000001 R14: 0000000000000246 R15: ffff810073200440
[  168.037781] FS:  00007ffd6067a6f0(0000) GS:ffffffff8076e000(0000) knlGS:0000000000000000
[  168.037781] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  168.037781] CR2: ffffffff8020a023 CR3: 000000007306e000 CR4: 00000000000006e0
[  168.037781] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  168.037781] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  168.037781] Process halt (pid: 3115, threadinfo ffff81007dbea000, task ffff81007ef44440)
[  168.037781] Stack:  ffffffff8080df80 90ffffff8055ba3b ffff81007f83a8c0 ffff81007dbebd68
[  168.037781]  ffffffff80211a01 ffffffff807c6584 0000000000000001 ffffffff807c6584
[  168.037781]  0000000000000001 0000000000000001 0000000000000001 ffff81007dbebd98
[  168.037781] Call Trace:
[  168.037781]  [<ffffffff80211a01>] alternatives_smp_switch+0x17a/0x1b6
[  168.037781]  [<ffffffff80219dd3>] __cpu_die+0x58/0x87
[  168.037781]  [<ffffffff805498b2>] _cpu_down+0x1a4/0x28c
[  168.037781]  [<ffffffff80252e90>] disable_nonboot_cpus+0x60/0x108
[  168.037781]  [<ffffffff80241619>] kernel_power_off+0x21/0x3b
[  168.037781]  [<ffffffff80241863>] sys_reboot+0xf8/0x196
[  168.037781]  [<ffffffff80291233>] ? kfree+0x2b/0x1ac
[  168.037781]  [<ffffffff80265a44>] ? audit_syscall_entry+0x16e/0x1a2
[  168.037781]  [<ffffffff80213619>] ? syscall_trace_enter+0xa4/0xa9
[  168.037781]  [<ffffffff8020c32e>] ? tracesys+0x71/0xe1
[  168.037781]  [<ffffffff8020c399>] tracesys+0xdc/0xe1
[  168.037781] 
[  168.037781] 
[  168.037781] Code: 57 80 48 0f 42 d0 48 8b 42 08 4c 8d 5d f7 8a 00 41 b8 01 00 00 00 88 45 f7 eb 1b 48 8b 17 4c 39 d2 72 0f 4c 39 ca 77 0a 41 8a 03 <88> 02 44 89 c0 0f a2 48 83 c7 08 48 39 f7 72 e0 5a 59 5b c9 c3 
[  168.037781] RIP  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
[  168.037781]  RSP <ffff81007dbebd10>
[  168.037781] CR2: ffffffff8020a023
[  168.037781] ---[ end trace 72339cb91f92973c ]---
[  168.037781] note: halt[3115] exited with preempt_count 1
[  168.038182] BUG: scheduling while atomic: halt/3115/0x00000002
[  168.038789] Pid: 3115, comm: halt Tainted: P      D   2.6.25-rc3-mm1 #8
[  168.039791] 
[  168.039793] Call Trace:
[  168.040795]  [<ffffffff8055d761>] ? _spin_unlock_irqrestore+0x3a/0x45
[  168.041796]  [<ffffffff8022bc70>] __schedule_bug+0x5d/0x61
[  168.042801]  [<ffffffff8055ad42>] schedule+0x11a/0x9fd
[  168.043801]  [<ffffffff802e4dad>] ? release_sysfs_dirent+0x8c/0xac
[  168.044797]  [<ffffffff8055b9d5>] schedule_timeout+0x22/0xb4
[  168.045797]  [<ffffffff8037265e>] ? __list_add+0x62/0x9a
[  168.046796]  [<ffffffff8055ab53>] wait_for_common+0x109/0x152
[  168.047816]  [<ffffffff80228819>] ? default_wake_function+0x0/0xf
[  168.048800]  [<ffffffff8055ac26>] wait_for_completion+0x18/0x1a
[  168.049798]  [<ffffffff802428e2>] flush_cpu_workqueue+0x70/0x7c
[  168.050793]  [<ffffffff8024291c>] ? wq_barrier_func+0x0/0xf
[  168.051794]  [<ffffffff8024296e>] flush_workqueue+0x43/0x5d
[  168.052794]  [<ffffffff80242998>] flush_scheduled_work+0x10/0x12
[  168.053795]  [<ffffffff803bd0ce>] release_dev+0x529/0x6c6
[  168.054799]  [<ffffffff802894b5>] ? free_page_and_swap_cache+0x32/0x36
[  168.055794]  [<ffffffff80368bbe>] ? _atomic_dec_and_lock+0x5a/0x98
[  168.056793]  [<ffffffff80368bbe>] ? _atomic_dec_and_lock+0x5a/0x98
[  168.057795]  [<ffffffff803bd424>] tty_release+0x19/0x24
[  168.058792]  [<ffffffff8029630d>] __fput+0xc0/0x21d
[  168.059793]  [<ffffffff8029647e>] fput+0x14/0x16
[  168.060796]  [<ffffffff80292f7a>] filp_close+0x66/0x71
[  168.061793]  [<ffffffff802340a8>] put_files_struct+0x74/0xc3
[  168.062793]  [<ffffffff8023413e>] __exit_files+0x47/0x50
[  168.063792]  [<ffffffff80235c3b>] do_exit+0x39c/0x90b
[  168.064792]  [<ffffffff803ca25d>] ? do_unblank_screen+0x53/0x131
[  168.065792]  [<ffffffff8055e0ad>] oops_begin+0x0/0x90
[  168.066791]  [<ffffffff8020a023>] ? set_personality_64bit+0x14/0x32
[  168.067794]  [<ffffffff8055ff24>] do_page_fault+0x8b9/0x9ad
[  168.068793]  [<ffffffff8055d761>] ? _spin_unlock_irqrestore+0x3a/0x45
[  168.069790]  [<ffffffff80249e46>] ? up+0x42/0x47
[  168.070790]  [<ffffffff8055d761>] ? _spin_unlock_irqrestore+0x3a/0x45
[  168.071790]  [<ffffffff8023239e>] ? release_console_sem+0x1ae/0x1bb
[  168.072792]  [<ffffffff802329bb>] ? vprintk+0x377/0x3aa
[  168.073791]  [<ffffffff802329bb>] ? vprintk+0x377/0x3aa
[  168.074792]  [<ffffffff8055db19>] error_exit+0x0/0x51
[  168.075795]  [<ffffffff80563cec>] ? _etext+0x0/0x7b
[  168.076790]  [<ffffffff80563cec>] ? _etext+0x0/0x7b
[  168.077787]  [<ffffffff8020a023>] ? set_personality_64bit+0x14/0x32
[  168.078790]  [<ffffffff80211872>] ? alternatives_smp_unlock+0x66/0x7b
[  168.079791]  [<ffffffff80211a01>] ? alternatives_smp_switch+0x17a/0x1b6
[  168.080791]  [<ffffffff80219dd3>] ? __cpu_die+0x58/0x87
[  168.082780]  [<ffffffff805498b2>] ? _cpu_down+0x1a4/0x28c
[  168.083792]  [<ffffffff80252e90>] ? disable_nonboot_cpus+0x60/0x108
[  168.084792]  [<ffffffff80241619>] ? kernel_power_off+0x21/0x3b
[  168.085787]  [<ffffffff80241863>] ? sys_reboot+0xf8/0x196
[  168.086789]  [<ffffffff80291233>] ? kfree+0x2b/0x1ac
[  168.087790]  [<ffffffff80265a44>] ? audit_syscall_entry+0x16e/0x1a2
[  168.088791]  [<ffffffff80213619>] ? syscall_trace_enter+0xa4/0xa9
[  168.089787]  [<ffffffff8020c32e>] ? tracesys+0x71/0xe1
[  168.090788]  [<ffffffff8020c399>] ? tracesys+0xdc/0xe1
[  168.091788] 
[  168.092814] BUG: scheduling while atomic: halt/3115/0x00000002
[  168.093789] Pid: 3115, comm: halt Tainted: P      D   2.6.25-rc3-mm1 #8
[  168.094783] 
[  168.094785] Call Trace:
[  168.095787]  [<ffffffff8055d76a>] ? _spin_unlock_irqrestore+0x43/0x45
[  168.096786]  [<ffffffff80242721>] ? worker_thread+0xa9/0xee
[  168.097786]  [<ffffffff8022bc70>] __schedule_bug+0x5d/0x61
[  168.098787]  [<ffffffff8055ad42>] schedule+0x11a/0x9fd
[  168.099790]  [<ffffffff802e4dad>] ? release_sysfs_dirent+0x8c/0xac
[  168.100792]  [<ffffffff8055b9d5>] schedule_timeout+0x22/0xb4
[  168.101787]  [<ffffffff8037265e>] ? __list_add+0x62/0x9a
[  168.102787]  [<ffffffff8055ab53>] wait_for_common+0x109/0x152
[  168.103786]  [<ffffffff80228819>] ? default_wake_function+0x0/0xf
[  168.104788]  [<ffffffff8055ac26>] wait_for_completion+0x18/0x1a
[  168.105784]  [<ffffffff802428e2>] flush_cpu_workqueue+0x70/0x7c
[  168.106785]  [<ffffffff8024291c>] ? wq_barrier_func+0x0/0xf
[  168.107786]  [<ffffffff8024296e>] flush_workqueue+0x43/0x5d
[  168.108785]  [<ffffffff80242998>] flush_scheduled_work+0x10/0x12
[  168.109788]  [<ffffffff803bd0ce>] release_dev+0x529/0x6c6
[  168.110787]  [<ffffffff802894b5>] ? free_page_and_swap_cache+0x32/0x36
[  168.111791]  [<ffffffff80368bbe>] ? _atomic_dec_and_lock+0x5a/0x98
[  168.112785]  [<ffffffff80368bbe>] ? _atomic_dec_and_lock+0x5a/0x98
[  168.113786]  [<ffffffff803bd424>] tty_release+0x19/0x24
[  168.114784]  [<ffffffff8029630d>] __fput+0xc0/0x21d
[  168.115784]  [<ffffffff8029647e>] fput+0x14/0x16
[  168.116783]  [<ffffffff80292f7a>] filp_close+0x66/0x71
[  168.117785]  [<ffffffff802340a8>] put_files_struct+0x74/0xc3
[  168.118788]  [<ffffffff8023413e>] __exit_files+0x47/0x50
[  168.119784]  [<ffffffff80235c3b>] do_exit+0x39c/0x90b
[  168.120783]  [<ffffffff803ca25d>] ? do_unblank_screen+0x53/0x131
[  168.121784]  [<ffffffff8055e0ad>] oops_begin+0x0/0x90
[  168.122782]  [<ffffffff8020a023>] ? set_personality_64bit+0x14/0x32
[  168.123782]  [<ffffffff8055ff24>] do_page_fault+0x8b9/0x9ad
[  168.124784]  [<ffffffff8055d761>] ? _spin_unlock_irqrestore+0x3a/0x45
[  168.126773]  [<ffffffff80249e46>] ? up+0x42/0x47
[  168.127781]  [<ffffffff8055d761>] ? _spin_unlock_irqrestore+0x3a/0x45
[  168.128785]  [<ffffffff8023239e>] ? release_console_sem+0x1ae/0x1bb
[  168.129783]  [<ffffffff802329bb>] ? vprintk+0x377/0x3aa
[  168.130783]  [<ffffffff802329bb>] ? vprintk+0x377/0x3aa
[  168.131783]  [<ffffffff8055db19>] error_exit+0x0/0x51
[  168.132818]  [<ffffffff80563cec>] ? _etext+0x0/0x7b
[  168.133810]  [<ffffffff80563cec>] ? _etext+0x0/0x7b
[  168.134813]  [<ffffffff8020a023>] ? set_personality_64bit+0x14/0x32
[  168.135807]  [<ffffffff80211872>] ? alternatives_smp_unlock+0x66/0x7b
[  168.136783]  [<ffffffff80211a01>] ? alternatives_smp_switch+0x17a/0x1b6
[  168.137785]  [<ffffffff80219dd3>] ? __cpu_die+0x58/0x87
[  168.138781]  [<ffffffff805498b2>] ? _cpu_down+0x1a4/0x28c
[  168.139784]  [<ffffffff80252e90>] ? disable_nonboot_cpus+0x60/0x108
[  168.140780]  [<ffffffff80241619>] ? kernel_power_off+0x21/0x3b
[  168.141779]  [<ffffffff80241863>] ? sys_reboot+0xf8/0x196
[  168.142781]  [<ffffffff80291233>] ? kfree+0x2b/0x1ac
[  168.143781]  [<ffffffff80265a44>] ? audit_syscall_entry+0x16e/0x1a2
[  168.144783]  [<ffffffff80213619>] ? syscall_trace_enter+0xa4/0xa9
[  168.145779]  [<ffffffff8020c32e>] ? tracesys+0x71/0xe1
[  168.146782]  [<ffffffff8020c399>] ? tracesys+0xdc/0xe1
[  168.147779] 
[  168.148798] halt used greatest stack depth: 3304 bytes left
[  176.814710] SysRq : Emergency Sync
[  176.815397] Emergency Sync complete
[  177.804460] SysRq : Emergency Sync
[  177.806194] Emergency Sync complete
[  179.663923] SysRq : Emergency Remount R/O
[  179.664927] Emergency Remount complete
[  181.729629] SysRq : Emergency Sync
[  181.730654] Emergency Sync complete
[  184.781877] SysRq : Resetting

> I suppose one of us should bisect it.

I'll let you know what I find...


--==_Exmh_1204876349_3634P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH0PQ9cC3lWbTT17ARApCnAJ41eMBpncLkQLnMq5rYBpiLgMMxJACgvbPo
cC+VRM0KvLqGZnQQ72Weick=
=LzK4
-----END PGP SIGNATURE-----

--==_Exmh_1204876349_3634P--
