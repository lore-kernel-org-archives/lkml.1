Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXLCNTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXLCNTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLCNTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:19:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:47712 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751393AbXLCNTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:19:45 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19mF9wFWmRmd7OMs4bOcfwTfoVxjbiV/GJ73G5UGK
	Myg623azM389s4
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Date: Mon, 3 Dec 2007 14:19:39 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9217650.Ej7ny0ML49";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712031419.41596.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9217650.Ej7ny0ML49
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Today I tried to hibernate my ThinkPad but got the following :

Dec  3 14:13:17 n22 ntpd[5504]: time reset +0.204868 s
Dec  3 14:14:06 n22 acpid: received event "ibm/hotkey HKEY 00000080 0000100=
c"
Dec  3 14:14:06 n22 acpid: notifying client 4693[0:0]
Dec  3 14:14:06 n22 acpid: executing action "/etc/acpi/default.sh ibm/hotke=
y HKEY 00000080 0000100c"
Dec  3 14:14:07 n22 swsusp: Marking nosave pages: 000000000009f000 - 000000=
0000100000
Dec  3 14:14:07 n22 swsusp: Basic memory bitmaps created
Dec  3 14:14:29 n22 c420 00000000=20
Dec  3 14:14:29 n22 dca29fb8 dca29f90 d30ad4c4 0851bf48 0851bf48 0851bfcb d=
ca29fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01c109d>] rb_erase+0x15d/0x280
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 linux-2.6.23  t 00000000     0 15474   9515
Dec  3 14:14:29 n22 c51c1f00 00200086 011c1fb8 00000000 00000000 00000000 0=
0000000 00000005=20
Dec  3 14:14:29 n22 c51c1fb8 c0120dc5 00000085 00000000 c012174c c51c1f18 0=
0000005 00000000=20
Dec  3 14:14:29 n22 00000085 00003c72 00000000 00000000 00000000 00000000 0=
0000000 00000000=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0120dc5>] ptrace_stop+0x95/0xf0
Dec  3 14:14:29 n22 [<c012174c>] ptrace_notify+0x5c/0x70
Dec  3 14:14:29 n22 [<c0106871>] do_syscall_trace+0xc1/0x140
Dec  3 14:14:29 n22 [<c01040f1>] syscall_trace_entry+0x11/0x30
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 linux-2.6.23  t caefc570     0 15486   9515
Dec  3 14:14:29 n22 c90c3f00 00200086 010c3fb8 caefc570 00000000 00000000 0=
0000000 00000005=20
Dec  3 14:14:29 n22 c90c3fb8 c0120dc5 00000085 00000000 c012174c c90c3f18 0=
0000005 00000000=20
Dec  3 14:14:29 n22 00000085 00003c7e 00000000 00000000 00000000 00000000 0=
0000000 00000000=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0120dc5>] ptrace_stop+0x95/0xf0
Dec  3 14:14:29 n22 [<c012174c>] ptrace_notify+0x5c/0x70
Dec  3 14:14:29 n22 [<c0106871>] do_syscall_trace+0xc1/0x140
Dec  3 14:14:29 n22 [<c01040f1>] syscall_trace_entry+0x11/0x30
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 linux-2.6.23  t caefc570     0 16074   9515
Dec  3 14:14:29 n22 dd8e3f00 00200082 018e3fb8 caefc570 00000000 00000000 0=
0000000 00000005=20
Dec  3 14:14:29 n22 dd8e3fb8 c0120dc5 00000085 00000000 c012174c dd8e3f18 0=
0000005 00000000=20
Dec  3 14:14:29 n22 00000085 00003eca 00000000 00000000 00000000 00000000 0=
0000000 00000000=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0120dc5>] ptrace_stop+0x95/0xf0
Dec  3 14:14:29 n22 [<c012174c>] ptrace_notify+0x5c/0x70
Dec  3 14:14:29 n22 [<c0106871>] do_syscall_trace+0xc1/0x140
Dec  3 14:14:29 n22 [<c01040f1>] syscall_trace_entry+0x11/0x30
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 linux-2.6.23  t caefc570     0 16148   9515
Dec  3 14:14:29 n22 c5f31f00 00200086 c032f26c caefc570 00000000 00000000 0=
0000000 00000005=20
Dec  3 14:14:29 n22 c5f31fb8 c0120dc5 00000085 00000000 c012174c c5f31f18 0=
0000005 00000000=20
Dec  3 14:14:29 n22 00000085 00003f14 00000000 00000000 00000000 00000000 0=
0000000 00000000=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0120dc5>] ptrace_stop+0x95/0xf0
Dec  3 14:14:29 n22 [<c012174c>] ptrace_notify+0x5c/0x70
Dec  3 14:14:29 n22 [<c0106871>] do_syscall_trace+0xc1/0x140
Dec  3 14:14:29 n22 [<c01040f1>] syscall_trace_entry+0x11/0x30
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 mozilla-launc D 0007b761     0 16219   5870
Dec  3 14:14:29 n22 db6bdeb0 00200082 00000000 0007b761 00000000 00000000 f=
fffffff 00000000=20
Dec  3 14:14:29 n22 db6bdf10 c0135fe5 ffffffff c0121b2a fff8489f 0003a2e0 0=
0fedace 00000001=20
Dec  3 14:14:29 n22 db6bdfb8 db6bdf90 c3d09a04 ffffffff ffffffff 00000000 d=
b6bdfb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c01202bb>] do_sigaction+0x11b/0x170
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c011a4b1>] sys_wait4+0x31/0x40
Dec  3 14:14:29 n22 [<c011a4e5>] sys_waitpid+0x25/0x30
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 [<c0280000>] zone_wait_table_init+0x0/0xd0
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000003     0 16228  16219
Dec  3 14:14:29 n22 e98e7eb0 00200082 00000001 00000003 00000000 00000000 0=
0000000 b75a7ff4=20
Dec  3 14:14:29 n22 e98e7f10 c0135fe5 08060428 c0121b2a e98e7ed8 e98e7f60 d=
13a9ec0 c0158aa6=20
Dec  3 14:14:29 n22 e98e7fb8 e98e7f90 d4cf2f44 08060428 00000000 b75a7ff4 e=
98e7fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0158aa6>] do_sync_read+0xc6/0x110
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0128550>] autoremove_wake_function+0x0/0x50
Dec  3 14:14:29 n22 [<c0126308>] __rcu_process_callbacks+0x108/0x180
Dec  3 14:14:29 n22 [<c01593d9>] vfs_read+0x129/0x130
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000009     0 16232  16219
Dec  3 14:14:29 n22 caf3feb0 00200082 00000002 00000009 00000000 00000000 0=
3e7fc18 b75a7ff4=20
Dec  3 14:14:29 n22 caf3ff10 c0135fe5 b70500c8 c0121b2a caf3fed4 f562305c c=
10daaa0 c02f1b00=20
Dec  3 14:14:29 n22 caf3ffb8 caf3ff90 dc559f44 b70500c8 03e7fc18 b75a7ff4 c=
af3ffb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0155650>] free_block+0x110/0x130
Dec  3 14:14:29 n22 [<c01c3256>] memmove+0x36/0x40
Dec  3 14:14:29 n22 [<c016859f>] d_kill+0x3f/0x60
Dec  3 14:14:29 n22 [<c01691d4>] dput+0x94/0x100
Dec  3 14:14:29 n22 [<c0159bbc>] __fput+0x11c/0x180
Dec  3 14:14:29 n22 [<c012bc31>] do_gettimeofday+0x31/0xf0
Dec  3 14:14:29 n22 [<c01c3c20>] copy_to_user+0x30/0x60
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 [<c0280000>] zone_wait_table_init+0x0/0xd0
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000000     0 16233  16219
Dec  3 14:14:29 n22 cc977eb0 00200082 00000000 00000000 00000000 00000000 b=
66482b8 00019f35=20
Dec  3 14:14:29 n22 cc977f10 c0135fe5 0807c6d8 c0121b2a 00000000 c1953030 0=
0000000 c1953030=20
Dec  3 14:14:29 n22 cc977fb8 cc977f90 c19534c4 0807c6d8 b66482b8 00019f35 c=
c977fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0128550>] autoremove_wake_function+0x0/0x50
Dec  3 14:14:29 n22 [<c01041cf>] common_interrupt+0x23/0x28
Dec  3 14:14:29 n22 [<c012c7b1>] getnstimeofday+0x31/0xc0
Dec  3 14:14:29 n22 [<c012b19d>] ktime_get_ts+0x1d/0x50
Dec  3 14:14:29 n22 [<c0131218>] sys_futex+0x98/0x100
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000000     0 16247  16219
Dec  3 14:14:29 n22 cd363eb0 00200082 00000000 00000000 00000000 00000000 0=
0000000 000001a7=20
Dec  3 14:14:29 n22 cd363f10 c0135fe5 0865efc8 c0121b2a cd363ed8 cd363f60 0=
0000000 c92c0ab0=20
Dec  3 14:14:29 n22 cd363fb8 cd363f90 c92c0f44 0865efc8 00000000 000001a7 c=
d363fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0128550>] autoremove_wake_function+0x0/0x50
Dec  3 14:14:29 n22 [<c0131218>] sys_futex+0x98/0x100
Dec  3 14:14:29 n22 [<c01597f8>] sys_write+0x68/0x70
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000000     0 16248  16219
Dec  3 14:14:29 n22 c57dbeb0 00200082 00000000 00000000 00000000 00000000 0=
0000000 00000001=20
Dec  3 14:14:29 n22 c57dbf10 c0135fe5 086aa708 c0121b2a 00000000 00000000 0=
0000000 c1969030=20
Dec  3 14:14:29 n22 c57dbfb8 c57dbf90 c19694c4 086aa708 00000000 00000001 c=
57dbfb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0148948>] handle_mm_fault+0x168/0x5c0
Dec  3 14:14:29 n22 [<c0111e2b>] do_page_fault+0x18b/0x6b0
Dec  3 14:14:29 n22 [<c0131218>] sys_futex+0x98/0x100
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000000     0 16250  16219
Dec  3 14:14:29 n22 da919eb0 00200082 00000000 00000000 00000000 00000000 0=
0000000 00000009=20
Dec  3 14:14:29 n22 da919f10 c0135fe5 08975798 c0121b2a c1bfe3e0 00000000 0=
0000000 f2ceb570=20
Dec  3 14:14:29 n22 da919fb8 da919f90 f2ceba04 08975798 00000000 00000009 d=
a919fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01a0ad2>] journal_stop+0x132/0x1b0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c0131218>] sys_futex+0x98/0x100
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 firefox-bin   D 00000000     0 16375  16219
Dec  3 14:14:29 n22 cb97beb0 00200082 00000000 00000000 00000000 00000000 0=
0000000 00000abd=20
Dec  3 14:14:29 n22 cb97bf10 c0135fe5 0908fb80 c0121b2a cb97bed8 cb97bf60 0=
0000000 e4f6b030=20
Dec  3 14:14:29 n22 cb97bfb8 cb97bf90 e4f6b4c4 0908fb80 00000000 00000abd c=
b97bfb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0128550>] autoremove_wake_function+0x0/0x50
Dec  3 14:14:29 n22 [<c0131218>] sys_futex+0x98/0x100
Dec  3 14:14:29 n22 [<c01597f8>] sys_write+0x68/0x70
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 gconfd-2      D 00000007     0 16245      1
Dec  3 14:14:29 n22 da6f9eb0 00200082 00000005 00000007 00000000 00000000 0=
0007530 b7e17ff4=20
Dec  3 14:14:29 n22 da6f9f10 c0135fe5 08064278 c0121b2a 00000003 00000000 0=
0000001 00000003=20
Dec  3 14:14:29 n22 da6f9fb8 da6f9f90 cff91f44 08064278 00007530 b7e17ff4 d=
a6f9fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01a0ad2>] journal_stop+0x132/0x1b0
Dec  3 14:14:29 n22 [<c0161e0d>] do_unlinkat+0x4d/0x150
Dec  3 14:14:29 n22 [<c012bc31>] do_gettimeofday+0x31/0xf0
Dec  3 14:14:29 n22 [<c01c3c20>] copy_to_user+0x30/0x60
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 make          D 00000000     0 26174   6174
Dec  3 14:14:29 n22 c4b05eb0 00000082 00000000 00000000 00000000 00000000 0=
0000000 40166ff4=20
Dec  3 14:14:29 n22 c4b05f10 c0135fe5 ffffffff c0121b2a c0113c61 00000000 0=
0000cc1 00000000=20
Dec  3 14:14:29 n22 c4b05fb8 c4b05f90 d11d0f44 ffffffff 00000000 40166ff4 c=
4b05fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c0280681>] wait_for_completion+0x81/0xb0
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 make          D 00000000     0 32574  26174
Dec  3 14:14:29 n22 dd4c5eb0 00000086 00000000 00000000 00000000 00000000 0=
0000000 40166ff4=20
Dec  3 14:14:29 n22 dd4c5f10 c0135fe5 ffffffff c0121b2a c0113c61 00000b02 0=
0000b02 00000000=20
Dec  3 14:14:29 n22 dd4c5fb8 dd4c5f90 c425c4c4 ffffffff 00000000 40166ff4 d=
d4c5fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c0280681>] wait_for_completion+0x81/0xb0
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 make          D 00000000     0  1979  32574
Dec  3 14:14:29 n22 d3ea5eb0 00000082 00000000 00000000 00000000 00000000 0=
0000000 40166ff4=20
Dec  3 14:14:29 n22 d3ea5f10 c0135fe5 ffffffff c0121b2a c0113c61 00000000 0=
0000db6 00000000=20
Dec  3 14:14:29 n22 d3ea5fb8 d3ea5f90 cfb2ef44 ffffffff 00000000 40166ff4 d=
3ea5fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c0280681>] wait_for_completion+0x81/0xb0
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 kio_http      D 00200286     0  2441   5870
Dec  3 14:14:29 n22 c3af9eb0 00200082 00b4ba23 00200286 00000000 00000000 0=
0000000 00000000=20
Dec  3 14:14:29 n22 c3af9f10 c0135fe5 00000004 c0121b2a 00000000 00000000 e=
4415e20 00000000=20
Dec  3 14:14:29 n22 c3af9fb8 c3af9f90 d30ada04 00000004 00000000 00000000 c=
3af9fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0147f61>] unmap_vmas+0x161/0x460
Dec  3 14:14:29 n22 [<c0149b35>] free_pgtables+0x85/0xb0
Dec  3 14:14:29 n22 [<c011147b>] check_pgt_cache+0x1b/0x20
Dec  3 14:14:29 n22 [<c014abd6>] unmap_region+0xd6/0x100
Dec  3 14:14:29 n22 [<c0164ffd>] sys_select+0x4d/0x1b0
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 make          D 00000000     0  3052   1979
Dec  3 14:14:29 n22 d1733eb0 00000082 00000000 00000000 00000000 00000000 0=
0000000 40166ff4=20
Dec  3 14:14:29 n22 d1733f10 c0135fe5 ffffffff c0121b2a c0113c61 00000dce 0=
0000dce 00000000=20
Dec  3 14:14:29 n22 d1733fb8 d1733f90 cfb2ea04 ffffffff 00000000 40166ff4 d=
1733fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c0280681>] wait_for_completion+0x81/0xb0
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 default.sh    R running      0  3125   3580
Dec  3 14:14:29 n22 sh            D 000162d1     0  3166   3052
Dec  3 14:14:29 n22 d8c3beb0 00000086 f7c8e740 000162d1 00000000 00000000 f=
fffffff 00000000=20
Dec  3 14:14:29 n22 d8c3bf10 c0135fe5 ffffffff c0121b2a fffe9d2f 00060a18 0=
12ad529 00000001=20
Dec  3 14:14:29 n22 d8c3bfb8 d8c3bf90 ebaef4c4 ffffffff ffffffff 00000000 d=
8c3bfb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c01202bb>] do_sigaction+0x11b/0x170
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c011a4b1>] sys_wait4+0x31/0x40
Dec  3 14:14:29 n22 [<c011a4e5>] sys_waitpid+0x25/0x30
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 [<c0280000>] zone_wait_table_init+0x0/0xd0
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 gcc           D 00008c83     0  3167   3166
Dec  3 14:14:29 n22 ca3afeb0 00000082 c0161713 00008c83 00000000 00000000 0=
0000000 00000c60=20
Dec  3 14:14:29 n22 ca3aff10 c0135fe5 00000c60 c0121b2a f1db0b00 c01c109d 0=
1c7a71b 00000001=20
Dec  3 14:14:29 n22 ca3affb8 ca3aff90 f1db0f44 00000c60 00000000 00000c60 c=
a3affb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0161713>] link_path_walk+0x63/0xc0
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c01c109d>] rb_erase+0x15d/0x280
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0119f12>] do_wait+0x522/0xa90
Dec  3 14:14:29 n22 [<c0114fa6>] __cond_resched+0x16/0x40
Dec  3 14:14:29 n22 [<c028053a>] cond_resched+0x2a/0x40
Dec  3 14:14:29 n22 [<c01170fc>] do_fork+0xec/0x240
Dec  3 14:14:29 n22 [<c0113f90>] default_wake_function+0x0/0x10
Dec  3 14:14:29 n22 [<c011a4b1>] sys_wait4+0x31/0x40
Dec  3 14:14:29 n22 [<c011a4e5>] sys_waitpid+0x25/0x30
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 cc1           D c1906080     0  3168   3167
Dec  3 14:14:29 n22 c2f67eb0 00000086 f7d735c0 c1906080 00000000 00000000 0=
86000b8 4071fb10=20
Dec  3 14:14:29 n22 c2f67f10 c0135fe5 086001e0 c0121b2a 1cc9b58e c2f67eec c=
011383b c032f26c=20
Dec  3 14:14:29 n22 c2f67fb8 c2f67f90 d4ac6a04 086001e0 086000b8 4071fb10 c=
2f67fb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c011383b>] __check_preempt_curr_fair+0x5b/0xa0
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c012aca5>] hrtimer_wakeup+0x15/0x20
Dec  3 14:14:29 n22 [<c012af11>] hrtimer_run_queues+0x121/0x150
Dec  3 14:14:29 n22 [<c0113c61>] update_curr+0x141/0x150
Dec  3 14:14:29 n22 [<c01136f7>] update_stats_wait_end+0xa7/0xe0
Dec  3 14:14:29 n22 [<c010314f>] __switch_to+0x11f/0x150
Dec  3 14:14:29 n22 [<c028031b>] schedule+0x13b/0x2e0
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 [<c0280000>] zone_wait_table_init+0x0/0xd0
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 as            D fffffe00     0  3169   3167
Dec  3 14:14:29 n22 eb6cbeb0 00000082 00000000 fffffe00 00000000 00000000 0=
0000000 00000400=20
Dec  3 14:14:29 n22 eb6cbf10 c0135fe5 00000000 c0121b2a eb6cbed8 eb6cbf60 d=
2297b40 c0158aa6=20
Dec  3 14:14:29 n22 eb6cbfb8 eb6cbf90 e56cdf44 00000000 00000000 00000400 e=
b6cbfb8 c01036f1=20
Dec  3 14:14:29 n22 Call Trace:
Dec  3 14:14:29 n22 [<c0135fe5>] refrigerator+0x55/0x80
Dec  3 14:14:29 n22 [<c0121b2a>] get_signal_to_deliver+0x3ca/0x3f0
Dec  3 14:14:29 n22 [<c0158aa6>] do_sync_read+0xc6/0x110
Dec  3 14:14:29 n22 [<c01036f1>] do_notify_resume+0x91/0x6e0
Dec  3 14:14:29 n22 [<c0128550>] autoremove_wake_function+0x0/0x50
Dec  3 14:14:29 n22 [<c0159351>] vfs_read+0xa1/0x130
Dec  3 14:14:29 n22 [<c01589e0>] do_sync_read+0x0/0x110
Dec  3 14:14:29 n22 [<c0159761>] sys_read+0x41/0x70
Dec  3 14:14:29 n22 [<c01040c2>] work_notifysig+0x13/0x19
Dec  3 14:14:29 n22 [<c0280000>] zone_wait_table_init+0x0/0xd0
Dec  3 14:14:29 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 linux-2.6.23
Dec  3 14:14:29 n22 Restarting tasks ... done.
Dec  3 14:14:29 n22 swsusp: Basic memory bitmaps freed
Dec  3 14:14:29 n22 acpid: action exited with status 0
Dec  3 14:14:29 n22 acpid: completed event "ibm/hotkey HKEY 00000080 000010=
0c"
Dec  3 14:14:29 n22 acpid: client connected from 4693[0:0]
Dec  3 14:14:29 n22 acpid: 1 client rule loaded


=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart9217650.Ej7ny0ML49
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHVAJrhyrlCH22naMRAk3WAJ0U1jyu2DgC/przFu0Qucrhinrw/gCgrw1d
VqpAbPCtG+a3oarnLqiC7KI=
=qobk
-----END PGP SIGNATURE-----

--nextPart9217650.Ej7ny0ML49--
