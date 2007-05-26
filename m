Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXEZQ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXEZQ0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbXEZQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:26:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47849 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760242AbXEZQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:reply-to:to:subject:user-agent:mime-version:date:content-type:content-transfer-encoding:message-id;
        b=ZIYsVXc4jwq8Q7xbDKcowkrWMzLU9UruQuhbt0/OTOxTIrs1uyYjZJz8XxGbj190aPnANKVYMyJ2ilhPaS2K00mW4eP1FF0HfhaWVMKwWHpJWVitfzzMgXMjBKkku3X26SIP4iO6lakWjgW6jiLi9PJLVUQj8mHDYEpU8JPZWHw=
From: Bjoern Olausson <spamsuxx@gmail.com>
Reply-To: spamsuxx@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.3] [pata_jmicron] BUG: soft lockup detected on CPU#0!
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Date: Sat, 26 May 2007 18:26:08 +0200
Content-Type: multipart/signed;
  boundary="nextPart6218941.Ddyf02FktG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261826.11785.spamsuxx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6218941.Ddyf02FktG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dear list members,

I am posting to this list just to get additional help for the bug I=20
reported here:
http://bugzilla.kernel.org/show_bug.cgi?id=3D8259 =20

So the problem is the following:

I have a Asus P5W-DH Delux Mainboard with an onboard JMicron 20360/20363 AH=
CI=20
Controller.
As soon as I enable this controller my system freezes after some time.

I captured some of the soft lockups with and without the closed source Nvid=
ia=20
drivers. =20

As no one has answered for some time now on my bug, I am seeking help on th=
is=20
list.

My major question is: Does it look like a hardware issue or is it a bug in =
the=20
driver?


Thanks for your help in advance. =20

Best regards
Bjoern


Below I will provide all logs/dmsg/lspci .... which could be from interest.=
 If=20
you need more info, blease let me kno
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The soft lockup occurs still on  2.6.21.3
All logs/lspci/dmsg... can be found here http://olausson.name/bug/

The latest, captured today is
http://olausson.name/bug/2007.05.25-freax-bug-nvidia.log

Usefull information can be found on the following lines:
=2D-Line 764 lspci --vv
=2D-Line 1167 dmsg
=2D-Line 1803 lsmod
=2D-Line 1841 cat /proc/interrupts
=2D-Line 1865 lsusb
=2D-Line 1883 uname -a
=2D-Line 1886 cat /usr/src/linux/.config

May 25 18:53:45 freax BUG: soft lockup detected on CPU#0!
May 25 18:53:45 freax
May 25 18:53:45 freax Call Trace:
May 25 18:53:45 freax <IRQ>  [<ffffffff802558d4>] softlockup_tick+0xda/0xf5
May 25 18:53:45 freax [<ffffffff8023b301>] update_process_times+0x42/0x68
May 25 18:53:45 freax [<ffffffff8021772d>] smp_local_timer_interrupt+0x34/0=
x52
May 25 18:53:45 freax [<ffffffff80217e36>] smp_apic_timer_interrupt+0x44/0x=
5e
May 25 18:53:45 freax [<ffffffff8020a086>] apic_timer_interrupt+0x66/0x70
May 25 18:53:45 freax [<ffffffff80255b95>] handle_IRQ_event+0x1a/0x53
May 25 18:53:45 freax [<ffffffff80256d07>] handle_edge_irq+0xe4/0x128
May 25 18:53:45 freax [<ffffffff8020ba7d>] do_IRQ+0xf1/0x160
May 25 18:53:45 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
May 25 18:53:45 freax [<ffffffff80459072>] ata_scsi_qc_complete+0x0/0x385
May 25 18:53:45 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28
May 25 18:53:45 freax [<ffffffff80237509>] __do_softirq+0x3e/0xb8
May 25 18:53:45 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28
May 25 18:53:45 freax [<ffffffff8020b93b>] do_softirq+0x2c/0x7d
May 25 18:53:45 freax [<ffffffff802374bf>] irq_exit+0x36/0x42
May 25 18:53:45 freax [<ffffffff8020bac9>] do_IRQ+0x13d/0x160
May 25 18:53:45 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
May 25 18:53:45 freax <EOI>  [<ffffffff805bf694>]=20
_spin_unlock_irqrestore+0xc/0x31
May 25 18:53:45 freax [<ffffffff8043a7d6>] scsi_dispatch_cmd+0x1f1/0x236
May 25 18:53:45 freax [<ffffffff8043f373>] scsi_request_fn+0x26c/0x337
May 25 18:53:45 freax [<ffffffff8039de56>] generic_unplug_device+0x18/0x25
May 25 18:53:45 freax [<ffffffff8029bb5f>] sync_buffer+0x36/0x40
May 25 18:53:45 freax [<ffffffff805be1c2>] __wait_on_bit+0x40/0x6e
May 25 18:53:45 freax [<ffffffff8029bb29>] sync_buffer+0x0/0x40
May 25 18:53:45 freax [<ffffffff805be25c>] out_of_line_wait_on_bit+0x6c/0x78
May 25 18:53:45 freax [<ffffffff80244f63>] wake_bit_function+0x0/0x23
May 25 18:53:45 freax [<ffffffff802e1d75>]=20
journal_commit_transaction+0x68b/0x11fe
May 25 18:53:45 freax [<ffffffff8023b0dc>] lock_timer_base+0x1b/0x3c
May 25 18:53:45 freax [<ffffffff805bf69e>] _spin_unlock_irqrestore+0x16/0x31
May 25 18:53:45 freax [<ffffffff80244b96>] keventd_create_kthread+0x0/0x6a
May 25 18:53:45 freax [<ffffffff802e6014>] kjournald+0xba/0x217
May 25 18:53:45 freax [<ffffffff80244f35>] autoremove_wake_function+0x0/0x2e
May 25 18:53:45 freax [<ffffffff80244b96>] keventd_create_kthread+0x0/0x6a
May 25 18:53:45 freax [<ffffffff802e5f5a>] kjournald+0x0/0x217
May 25 18:53:45 freax [<ffffffff80244df1>] kthread+0xd1/0x100
May 25 18:53:45 freax [<ffffffff8020a268>] child_rip+0xa/0x12
May 25 18:53:45 freax [<ffffffff80244b96>] keventd_create_kthread+0x0/0x6a
May 25 18:53:45 freax [<ffffffff80244d20>] kthread+0x0/0x100
May 25 18:53:45 freax [<ffffffff8020a25e>] child_rip+0x0/0x12
May 25 18:53:45 freax
=2D------------------------------------------------------------------------=
=2D-------------------------------------

Older Soft Lockups:

(NV in the filenames means the xorg's nvidia driver)
(nvidia in the fienames means Nvidias closed source driver)

Heres a soft-lockup without NVIDIA driver (using the xorgs NV driver instea=
d)

Apr 13 22:33:59 freax BUG: soft lockup detected on CPU#0!
Apr 13 22:33:59 freax =20
Apr 13 22:33:59 freax Call Trace:
Apr 13 22:33:59 freax <IRQ> [<ffffffff802559c8>] softlockup_tick+0xda/0xf5
Apr 13 22:33:59 freax [<ffffffff8023b42d>] update_process_times+0x42/0x68
Apr 13 22:33:59 freax [<ffffffff80217775>] smp_local_timer_interrupt+0x34/0=
x52 =20
Apr 13 22:33:59 freax [<ffffffff80217e7e>] smp_apic_timer_interrupt+0x44/0x=
5e
Apr 13 22:33:59 freax [<ffffffff8020a086>] apic_timer_interrupt+0x66/0x70
Apr 13 22:33:59 freax [<ffffffff80255c89>] handle_IRQ_event+0x1a/0x53 =20
Apr 13 22:33:59 freax [<ffffffff80256dfb>] handle_edge_irq+0xe4/0x128
Apr 13 22:33:59 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28
Apr 13 22:33:59 freax [<ffffffff8020baa9>] do_IRQ+0xf1/0x160 =20
Apr 13 22:33:59 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
Apr 13 22:33:59 freax <EOI>


And this one is WITH the CS NVIDIA driver:

Apr 13 18:14:09 freax BUG: soft lockup detected on CPU#0! =20
Apr 13 18:14:09 freax
Apr 13 18:14:09 freax Call Trace:
Apr 13 18:14:09 freax <IRQ> [<ffffffff802559c8>] softlockup_tick+0xda/0xf5
Apr 13 18:14:09 freax [<ffffffff8023b42d>] update_process_times+0x42/0x68 =
=20
Apr 13 18:14:09 freax [<ffffffff80217775>] smp_local_timer_interrupt+0x34/0=
x52
Apr 13 18:14:09 freax [<ffffffff80217e7e>] smp_apic_timer_interrupt+0x44/0x=
5e
Apr 13 18:14:09 freax [<ffffffff8020a086>] apic_timer_interrupt+0x66/0x70 =
=20
Apr 13 18:14:09 freax [<ffffffff80255c89>] handle_IRQ_event+0x1a/0x53
Apr 13 18:14:09 freax [<ffffffff80256dfb>] handle_edge_irq+0xe4/0x128
Apr 13 18:14:09 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28 =20
Apr 13 18:14:09 freax [<ffffffff8020baa9>] do_IRQ+0xf1/0x160
Apr 13 18:14:09 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
Apr 13 18:14:09 freax <EOI> [<ffffffff80584cf4>] _spin_unlock_irqrestore+0x=
c/ =20
0x31
Apr 13 18:14:09 freax [<ffffffff80450f70>] ata_hsm_move+0x216/0x66a
Apr 13 18:14:09 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a
Apr 13 18:14:09 freax [<ffffffff804540be>] ata_pio_task+0x0/0xe9 =20
Apr 13 18:14:09 freax [<ffffffff8045419a>] ata_pio_task+0xdc/0xe9
Apr 13 18:14:09 freax [<ffffffff80241669>] run_workqueue+0x8f/0x137
Apr 13 18:14:09 freax [<ffffffff802420e8>] worker_thread+0x0/0x14a =20
Apr 13 18:14:09 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a
Apr 13 18:14:09 freax [<ffffffff802421fc>] worker_thread+0x114/0x14a
Apr 13 18:14:09 freax [<ffffffff8022ccce>] default_wake_function+0x0/0xe =20
Apr 13 18:14:09 freax [<ffffffff80244f1d>] kthread+0xd1/0x100
Apr 13 18:14:09 freax [<ffffffff8020a268>] child_rip+0xa/0x12
Apr 13 18:14:09 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a =
=20
Apr 13 18:14:09 freax [<ffffffff802420e8>] worker_thread+0x0/0x14a
Apr 13 18:14:09 freax [<ffffffff80244e4c>] kthread+0x0/0x100
Apr 13 18:14:09 freax [<ffffffff8020a25e>] child_rip+0x0/0x12
 Apr 13 18:14:09 freax


More logs, dmsg, interupts etc. can be found here:
http://olausson.name/bug/
Hope there is some usfull info in them.

=20
Here the next two softlocks: =20
(Again, _without_ the CS NVIDIA driver)

(http://olausson.name/bug/minicom_nv-1.log)
Apr 14 09:46:13 freax Call Trace:
Apr 14 09:46:13 freax <IRQ> [<ffffffff802559c8>] softlockup_tick+0xda/0xf5 =
=20
Apr 14 09:46:13 freax [<ffffffff8023b42d>] update_process_times+0x42/0x68
Apr 14 09:46:13 freax [<ffffffff80217775>] smp_local_timer_interrupt+0x34/0=
x52
Apr 14 09:46:13 freax [<ffffffff80217e7e>] smp_apic_timer_interrupt+0x44/0x=
5e =20
Apr 14 09:46:13 freax [<ffffffff8020a086>] apic_timer_interrupt+0x66/0x70
Apr 14 09:46:13 freax [<ffffffff80255c89>] handle_IRQ_event+0x1a/0x53
Apr 14 09:46:13 freax [<ffffffff80256dfb>] handle_edge_irq+0xe4/0x128 =20
Apr 14 09:46:13 freax [<ffffffff8020baa9>] do_IRQ+0xf1/0x160
Apr 14 09:46:13 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
Apr 14 09:46:13 freax [<ffffffff804553ee>] ata_scsi_qc_complete+0x0/0x385 =
=20
Apr 14 09:46:13 freax [<ffffffff80255c89>] handle_IRQ_event+0x1a/0x53
Apr 14 09:46:13 freax [<ffffffff80256dfb>] handle_edge_irq+0xe4/0x128
Apr 14 09:46:13 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28 =20
Apr 14 09:46:13 freax [<ffffffff8020baa9>] do_IRQ+0xf1/0x160
Apr 14 09:46:13 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
Apr 14 09:46:13 freax <EOI>

( http://olausson.name/bug/minicom_nv-2.log)
=2D-More--Apr 14 16:53:21 freax BUG: soft lockup detected on CPU#0!
Apr 14 16:53:21 freax
Apr 14 16:53:21 freax Call Trace:
Apr 14 16:53:21 freax <IRQ> [<ffffffff802559c8>] softlockup_tick+0xda/0xf5 =
=20
Apr 14 16:53:21 freax [<ffffffff8023b42d>] update_process_times+0x42/0x68
Apr 14 16:53:21 freax [<ffffffff80217775>] smp_local_timer_interrupt+0x34/0=
x52
Apr 14 16:53:21 freax [<ffffffff80217e7e>] smp_apic_timer_interrupt+0x44/0x=
5e =20
Apr 14 16:53:21 freax [<ffffffff8020a086>] apic_timer_interrupt+0x66/0x70
Apr 14 16:53:21 freax [<ffffffff80255c89>] handle_IRQ_event+0x1a/0x53
Apr 14 16:53:21 freax [<ffffffff80256dfb>] handle_edge_irq+0xe4/0x128 =20
Apr 14 16:53:21 freax [<ffffffff8020a5dc>] call_softirq+0x1c/0x28
Apr 14 16:53:21 freax [<ffffffff8020baa9>] do_IRQ+0xf1/0x160
Apr 14 16:53:21 freax [<ffffffff80209931>] ret_from_intr+0x0/0xa
 Apr 14 16:53:21 freax <EOI> [<ffffffff802420e8>] worker_thread+0x0/0x14a
Apr 14 16:53:21 freax [<ffffffff8058264b>] __sched_text_start+0x14b/0x7bc
Apr 14 16:53:21 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a =
=20
Apr 14 16:53:21 freax [<ffffffff8022a3aa>] __wake_up+0x38/0x4f
Apr 14 16:53:21 freax [<ffffffff80584cfe>] _spin_unlock_irqrestore+0x16/0x31
Apr 14 16:53:21 freax [<ffffffff802420e8>] worker_thread+0x0/0x14a =20
Apr 14 16:53:21 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a
Apr 14 16:53:21 freax [<ffffffff802420e8>] worker_thread+0x0/0x14a
Apr 14 16:53:21 freax [<ffffffff802421cc>] worker_thread+0xe4/0x14a =20
Apr 14 16:53:21 freax [<ffffffff8022ccce>] default_wake_function+0x0/0xe
Apr 14 16:53:21 freax [<ffffffff80244f1d>] kthread+0xd1/0x100
Apr 14 16:53:21 freax [<ffffffff8020a268>] child_rip+0xa/0x12 =20
Apr 14 16:53:21 freax [<ffffffff80244cc2>] keventd_create_kthread+0x0/0x6a
Apr 14 16:53:21 freax [<ffffffff80244e4c>] kthread+0x0/0x100
Apr 14 16:53:21 freax [<ffffffff8020a25e>] child_rip+0x0/0x12 =20
Apr 14 16:53:21 freax

--nextPart6218941.Ddyf02FktG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGWF+gdxYXZjyxLUsRAhEKAJ9PkebonWiM3gjC1AyLv6ARCJQK3wCfQBDU
3yuZsQfnR+eJV/VXja/q9gk=
=qwxX
-----END PGP SIGNATURE-----

--nextPart6218941.Ddyf02FktG--
