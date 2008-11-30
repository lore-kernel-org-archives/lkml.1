Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbYK3Nsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbYK3Nsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYK3Nsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:48:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:57198 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751394AbYK3Nsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:48:30 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+lhJ4NEaWlmAthXId3rLT+CaGr7DZjDSLawi+Heu
	6aKcFHT46O4JoI
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-gentoo-r4 suspend/hibernate issues with ThinkPad T41
Date: Sun, 30 Nov 2008 14:48:18 +0100
User-Agent: KMail/1.9.10
Cc: dsd@gentoo.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14288460.WiAdOWrp9x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811301448.21932.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14288460.WiAdOWrp9x
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

testing that kernel (based on 2.6.27.7) w/ a  .config from a working=20
2.6.26-gentoo-r3 kernel I run into issues after the system should be wake u=
p=20
from hibernation.
If I startx (from init level 2), suspend the system (FN + F4), wake it up a=
nd=20
then try to hibernate (FN + F12) I get in my syslog the following entries:

Nov 30 14:27:02 n22 acpid: received event "ibm/hotkey HKEY 00000080 0000100=
c"
Nov 30 14:27:02 n22 acpid: notifying client 2796[0:0]
Nov 30 14:27:02 n22 acpid: executing action "/etc/acpi/default.sh ibm/hotke=
y=20
HKEY 00000080 0000100c"
Nov 30 14:27:22 n22 PM: Syncing filesystems ... +0x30/0x60
Nov 30 14:27:22 n22 [<c016ee01>] sys_select+0x181/0x1b0
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kthreadd      S 0000030c     0     2      0
Nov 30 14:27:22 n22 f7837790 00000046 00000286 0000030c f7b56ed4 00000000=20
c0318e50 0000030c=20
Nov 30 14:27:22 n22 f7b56ed4 00000000 c012aa35 00000000 c012a9c0 00000000=20
00000000 00000000=20
Nov 30 14:27:22 n22 c0103267 00000000 00000000 00000000 00000000 ffffffff=20
fdbfffff=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012aa35>] kthreadd+0x75/0x100
Nov 30 14:27:22 n22 [<c012a9c0>] kthreadd+0x0/0x100
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 ksoftirqd/0   S c0310300     0     3      2
Nov 30 14:27:22 n22 f78373e0 00000046 c0310180 c0310300 00000000 00000000=20
00000000 00000000=20
Nov 30 14:27:22 n22 c011e390 00000000 c011e40c fffffffc c012a992 c012a950=20
00000000 00000000=20
Nov 30 14:27:22 n22 c0103267 f7838f18 00000000 00000000 00000000 ffffffff=20
ffffffff=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c011e390>] ksoftirqd+0x0/0xb0
Nov 30 14:27:22 n22 [<c011e40c>] ksoftirqd+0x7c/0xb0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 watchdog/0    S 00000000     0     4      2
Nov 30 14:27:22 n22 f7837030 00000046 00000246 00000000 c013f320 00000000=20
fffffffc 00000000=20
Nov 30 14:27:22 n22 c013f320 00000000 c013f379 c0310180 c029436a 00000292=20
f78373e0 c013f320=20
Nov 30 14:27:22 n22 00000063 fffffffc 00000000 c013f320 00000000 c012a992=20
c012a950 00000000=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013f320>] watchdog+0x0/0x1b0
Nov 30 14:27:22 n22 [<c013f320>] watchdog+0x0/0x1b0
Nov 30 14:27:22 n22 [<c013f379>] watchdog+0x59/0x1b0
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c013f320>] watchdog+0x0/0x1b0
Nov 30 14:27:22 n22 [<c013f320>] watchdog+0x0/0x1b0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 events/0      S f786b0b0     0     5      2
Nov 30 14:27:22 n22 f7840b80 00000046 c0127b84 f786b0b0 f7840b80 c0310180=20
f780a948 f780a940=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7840b80 c012ad00=20
f780a948 f780a948=20
Nov 30 14:27:22 n22 fffffffc f780a940 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 khelper       S f7ab0b80     0     6      2
Nov 30 14:27:22 n22 f78407d0 00000046 c0127b84 f7ab0b80 f78407d0 c0310180=20
f780a908 f780a900=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f78407d0 c012ad00=20
f780a908 f780a908=20
Nov 30 14:27:22 n22 fffffffc f780a900 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kblockd/0     S c0310300     0    31      2
Nov 30 14:27:22 n22 f78724a0 00000046 c0127b84 c0310300 f787007b c031007b=20
f7861ac8 f7861ac0=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f78724a0 c012ad00=20
f7861ac8 f7861ac8=20
Nov 30 14:27:22 n22 fffffffc f7861ac0 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kacpid        S c0310300     0    33      2
Nov 30 14:27:22 n22 f7883b40 00000046 c0127b84 c0310300 f7883b40 c0310180=20
f78618c8 f78618c0=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7883b40 c012ad00=20
f78618c8 f78618c8=20
Nov 30 14:27:22 n22 fffffffc f78618c0 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kacpi_notify  S f7883b40     0    34      2
Nov 30 14:27:22 n22 f7883790 00000046 c0127b84 f7883b40 f7883790 c0310180=20
f7861888 f7861880=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7883790 c012ad00=20
f7861888 f7861888=20
Nov 30 14:27:22 n22 fffffffc f7861880 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kseriod       S f7abae00     0   110      2
Nov 30 14:27:22 n22 f785eb40 00000046 c02320cd f7abae00 f7abae70 f7bdfda0=20
f78a3fb0 c012ad00=20
Nov 30 14:27:22 n22 00000000 00000286 c022b7a5 00000000 f78570f0 f785eb40=20
c0310180 00000000=20
Nov 30 14:27:22 n22 f785eb40 c012ad00 c0321d7c c0321d7c fffffffc 00000000=20
c022b6e0 00000000=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c02320cd>] atkbd_reconnect+0xad/0xc0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c022b7a5>] serio_thread+0xc5/0x2f0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c022b6e0>] serio_thread+0x0/0x2f0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kondemand/0   S f7ace7d0     0   128      2
Nov 30 14:27:22 n22 f786b0b0 00000046 c0127b84 f7ace7d0 f786b0b0 c0310180=20
f78a1cc8 f78a1cc0=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f786b0b0 c012ad00=20
f78a1cc8 f78a1cc8=20
Nov 30 14:27:22 n22 fffffffc f78a1cc0 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 pdflush       S f78720f0     0   139      2
Nov 30 14:27:22 n22 f7857c00 00000046 c0113992 f78720f0 00000000 00000000=20
f78e1fc4 00000000=20
Nov 30 14:27:22 n22 c014a800 00000000 c014a892 00000292 f7857c00 00000000=20
00000000 c0319eb0=20
Nov 30 14:27:22 n22 f78e2fc4 fffcaba2 fffffffc c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0113992>] enqueue_task+0x12/0x30
Nov 30 14:27:22 n22 [<c014a800>] pdflush+0x0/0x190
Nov 30 14:27:22 n22 [<c014a892>] pdflush+0x92/0x190
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 pdflush       S 00000000     0   140      2
Nov 30 14:27:22 n22 f78720f0 00000046 00000000 00000000 00000000 00000025=20
f78e2fc4 00000000=20
Nov 30 14:27:22 n22 c014a800 00000000 c014a892 00000292 f78720f0 00000000=20
00000000 f78e1fc4=20
Nov 30 14:27:22 n22 c0319eb0 fffd20d3 fffffffc c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c014a800>] pdflush+0x0/0x190
Nov 30 14:27:22 n22 [<c014a892>] pdflush+0x92/0x190
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kswapd0       S f7aa4c00     0   141      2
Nov 30 14:27:22 n22 f7872850 00000046 00000000 f7aa4c00 00000000 c0326640=20
00000000 c0326640=20
Nov 30 14:27:22 n22 00000000 00000000 c014db8a c0367258 f78377bc f78e3f74=20
00000000 c03270e8=20
Nov 30 14:27:22 n22 00000000 f787287c 06905433 00000000 f7872850 c01141ed=20
00000000 f78377bc=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c014db8a>] kswapd+0x43a/0x450
Nov 30 14:27:22 n22 [<c01141ed>] update_curr+0x3d/0x60
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c014d750>] kswapd+0x0/0x450
Nov 30 14:27:22 n22 [<c014d750>] kswapd+0x0/0x450
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 aio/0         S f78377bc     0   142      2
Nov 30 14:27:22 n22 f785e3e0 00000046 c0115208 f78377bc f785e3e0 c0310180=20
f78a1348 f78a1340=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f785e3e0 c012ad00=20
f78a1348 f78a1348=20
Nov 30 14:27:22 n22 fffffffc f78a1340 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kjournald     S 00000000     0   246      2
Nov 30 14:27:22 n22 f7ace420 00000046 00000286 00000000 f7ac0e40 00000286=20
f7ac0e00 f7ac0ec4=20
Nov 30 14:27:22 n22 00000000 f7ac0e40 c01b25c4 00000000 00000005 f7ac0e50=20
00000000 f7ace420=20
Nov 30 14:27:22 n22 c012ad00 f7ac0e50 f7ac0e50 fffffffc f7ac0e00 c01b2430=20
00000000 c012a992=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c01b25c4>] kjournald+0x194/0x1b0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01b2430>] kjournald+0x0/0x1b0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 udevd         D f780d340     0   351      1
Nov 30 14:27:22 n22 f7ad80b0 00000086 f7afeee8 f780d340 00000001 f6964011=20
00000000 f7afef10=20
Nov 30 14:27:22 n22 f7a670c0 f7afefb8 c013b1f5 00000007 c0124fea 08dd4c82=20
00000246 00000000=20
Nov 30 14:27:22 n22 00000000 f7afef90 f7a82040 00000007 00000000 00000000=20
f7afefb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c0177253>] mntput_no_expire+0x13/0x90
Nov 30 14:27:22 n22 [<c01726dc>] shrink_dcache_parent+0x2c/0xd0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c015e2a5>] shmem_rmdir+0x15/0x50
Nov 30 14:27:22 n22 [<c01730dd>] dput+0x9d/0x110
Nov 30 14:27:22 n22 [<c016eccd>] sys_select+0x4d/0x1b0
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 kpsmoused     S f78724cc     0   674      2
Nov 30 14:27:22 n22 f7a9cbc0 00000046 c0115208 f78724cc f7a9cbc0 f7037080=20
f7bb95c8 f7bb95c0=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7a9cbc0 c012ad00=20
f7bb95c8 f7bb95c8=20
Nov 30 14:27:22 n22 fffffffc f7bb95c0 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 ktpacpid      S f7ace09c     0   724      2
Nov 30 14:27:22 n22 f7a95070 00000046 c0115208 f7ace09c f7a95070 f7b3acc0=20
f70699c8 f70699c0=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7a95070 c012ad00=20
f70699c8 f70699c8=20
Nov 30 14:27:22 n22 fffffffc f70699c0 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 ksuspend_usbd S c0310300     0   778      2
Nov 30 14:27:22 n22 f7aa4c00 00000046 c0127b84 c0310300 00000000 f7042d80=20
f7042d88 f7042d80=20
Nov 30 14:27:22 n22 c012ad00 00000000 c01283b7 00000000 f7aa4c00 c012ad00=20
f7042d88 f7042d88=20
Nov 30 14:27:22 n22 fffffffc f7042d80 c01282f0 c012a992 c012a950 00000000=20
00000000 c0103267=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0127b84>] run_workqueue+0x64/0xe0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01283b7>] worker_thread+0xc7/0xf0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c01282f0>] worker_thread+0x0/0xf0
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 khubd         S 00000000     0   780      2
Nov 30 14:27:22 n22 f7ab0420 00000046 00000000 00000000 f893b2db f7bc570c=20
f7b2dfa4 00000000=20
Nov 30 14:27:22 n22 f7112d80 00000003 f89357e4 f7b2dfbc f8944995 f7b026a8=20
00000002 33c001e3=20
Nov 30 14:27:22 n22 340001e3 f7bc5508 f708dd08 f7a7ca00 00000000 f7a7ca1c=20
f7bc5400 f7b12000=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<f893b2db>] usb_autopm_do_interface+0x7b/0xd0 [usbcore]
Nov 30 14:27:22 n22 [<f89357e4>] hub_thread+0xd4/0xda0 [usbcore]
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<f8935710>] hub_thread+0x0/0xda0 [usbcore]
Nov 30 14:27:22 n22 [<c012a992>] kthread+0x42/0x70
Nov 30 14:27:22 n22 [<c012a950>] kthread+0x0/0x70
Nov 30 14:27:22 n22 [<c0103267>] kernel_thread_helper+0x7/0x10
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 syslog-ng     D 00000003     0  2496      1
Nov 30 14:27:22 n22 f7ab8810 00000082 00000001 00000003 00000001 00000009=20
00000000 f702df10=20
Nov 30 14:27:22 n22 f7a678c0 f702dfb8 c013b1f5 08d50f48 c0124fea c016b54d=20
c016a8b3 f7a87a00=20
Nov 30 14:27:22 n22 0000000a f702df90 f7aae580 08d50f48 00124f80 b7dd9ff4=20
f702dfb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c016b54d>] do_path_lookup+0x5d/0x110
Nov 30 14:27:22 n22 [<c016a8b3>] getname+0xb3/0xe0
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c012ffed>] getnstimeofday+0x3d/0xe0
Nov 30 14:27:22 n22 [<c011dd08>] ns_to_timespec+0x48/0x60
Nov 30 14:27:22 n22 [<c012d88f>] __remove_hrtimer+0x4f/0x80
Nov 30 14:27:22 n22 [<c011d4a3>] do_setitimer+0xb3/0x280
Nov 30 14:27:22 n22 [<c010ff6a>] read_hpet+0xa/0x10
Nov 30 14:27:22 n22 [<c012ffed>] getnstimeofday+0x3d/0xe0
Nov 30 14:27:22 n22 [<c016e0e5>] sys_poll+0x35/0x80
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 acpid         D 000000f4     0  2553      1
Nov 30 14:27:22 n22 f7ab0070 00000082 00000000 000000f4 00000000 00000010=20
00000000 f7048f10=20
Nov 30 14:27:22 n22 f700f480 f7048fb8 c013b1f5 00000b5a c0124fea 00000001=20
f7ace7fc c0367258=20
Nov 30 14:27:22 n22 f7ace7d0 f7048f90 f701aac0 00000b5a 00000000 00000000=20
f7048fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c011c865>] sys_waitpid+0x25/0x30
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 dnsmasq       D c012293a     0  2619      1
Nov 30 14:27:22 n22 f7ad8810 00000082 f7b1ff10 c012293a c01240f8 09b5fc68=20
00000000 f7b1ff10=20
Nov 30 14:27:22 n22 f7bf0a40 f7b1ffb8 c013b1f5 00000007 c0124fea 00000000=20
00000000 00000003=20
Nov 30 14:27:22 n22 c02b03a0 f7b1ff90 f7bee040 00000007 bf988c24 00000000=20
f7b1ffb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c0282d5e>] inet_sock_destruct+0xde/0x190
Nov 30 14:27:22 n22 [<c016eccd>] sys_select+0x4d/0x1b0
Nov 30 14:27:22 n22 [<c0177253>] mntput_no_expire+0x13/0x90
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 login         D c012293a     0  2753      1
Nov 30 14:27:22 n22 f7ac83e0 00000082 f7a88f10 c012293a c01240f8 bff44000=20
00000000 f7a88f10=20
Nov 30 14:27:22 n22 f7a676c0 f7a88fb8 c013b1f5 ffffffff c0124fea f7ab8bf4=20
f7ad8844 f7acebb4=20
Nov 30 14:27:22 n22 c01cef9d f7a88f90 f7aae040 ffffffff 00000000 b7edfff4=20
f7a88fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c01cef9d>] rb_erase+0x15d/0x280
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 agetty        D c012293a     0  2755      1
Nov 30 14:27:22 n22 f7ab07d0 00000082 c029436a c012293a f7aaa790 1a131100=20
00000000 f7af2f10=20
Nov 30 14:27:22 n22 f7b52b40 f7af2fb8 c013b1f5 00000000 c0124fea 00000000=20
7f1c0300 00000002=20
Nov 30 14:27:22 n22 c17e5300 f7af2f90 f7aea040 00000000 bfed0d44 bfed0d44=20
f7af2fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 agetty        D c012293a     0  2757      1
Nov 30 14:27:22 n22 f7aaa790 00000082 c029436a c012293a f7ac24a0 1a131100=20
00000000 f705af10=20
Nov 30 14:27:22 n22 f7b03580 f705afb8 c013b1f5 00000000 c0124fea 00000000=20
7f1c0300 00000002=20
Nov 30 14:27:22 n22 c17ec220 f705af90 f7bc0ac0 00000000 bf7ffb84 bf7ffb84=20
f705afb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 agetty        D c012293a     0  2759      1
Nov 30 14:27:22 n22 f7ac24a0 00000086 c029436a c012293a f7aa40f0 1a131100=20
00000000 f7088f10=20
Nov 30 14:27:22 n22 f7b03980 f7088fb8 c013b1f5 00000000 c0124fea 00000000=20
7f1c0300 00000002=20
Nov 30 14:27:22 n22 c17f8f00 f7088f90 f7bb1580 00000000 bf8ea2e4 bf8ea2e4=20
f7088fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 agetty        D c012293a     0  2760      1
Nov 30 14:27:22 n22 f7aa40f0 00000082 c029436a c012293a f7ac8030 1a131100=20
00000000 f711ff10=20
Nov 30 14:27:22 n22 f7a672c0 f711ffb8 c013b1f5 00000000 c0124fea 00000000=20
7f1c0300 00000002=20
Nov 30 14:27:22 n22 c17fb160 f711ff90 f7a82580 00000000 bfbb9d64 bfbb9d64=20
f711ffb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 agetty        D c012293a     0  2761      1
Nov 30 14:27:22 n22 f7ac8030 00000082 c029436a c012293a f7ad8bc0 1a131100=20
00000000 f7009f10=20
Nov 30 14:27:22 n22 f7b52d40 f7009fb8 c013b1f5 00000000 c0124fea 00000000=20
7f1c0300 00000002=20
Nov 30 14:27:22 n22 c17fbcc0 f7009f90 f7aea580 00000000 bfe04b84 bfe04b84=20
f7009fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 bash          D c012293a     0  2772   2753
Nov 30 14:27:22 n22 f7ad8bc0 00000086 f700cf10 c012293a c01240f8 f7ad8bc0=20
00000000 f700cf10=20
Nov 30 14:27:22 n22 f7bd41c0 f700cfb8 c013b1f5 ffffffff c0124fea 00000001=20
f7ac805c c0367258=20
Nov 30 14:27:22 n22 f7ac8030 f700cf90 f7beeac0 ffffffff ffffffff 00000000=20
f700cfb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c011c865>] sys_waitpid+0x25/0x30
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 startx        D c012293a     0  2779   2772
Nov 30 14:27:22 n22 f7ac20f0 00000082 f7b3cf10 c012293a c01240f8 00000000=20
00000000 f7b3cf10=20
Nov 30 14:27:22 n22 f7bd4bc0 f7b3cfb8 c013b1f5 ffffffff c0124fea 00000001=20
f7aa411c c0367258=20
Nov 30 14:27:22 n22 f7aa40f0 f7b3cf90 f7bcf580 ffffffff ffffffff 00000000=20
f7b3cfb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c011c865>] sys_waitpid+0x25/0x30
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 xinit         D c012293a     0  2795   2779
Nov 30 14:27:22 n22 f78570f0 00000082 f7282f10 c012293a c01240f8 c029d420=20
00000000 f7282f10=20
Nov 30 14:27:22 n22 f7a674c0 f7282fb8 c013b1f5 ffffffff c0124fea c0115090=20
7096c176 0000000d=20
Nov 30 14:27:22 n22 77ed9dc1 f7282f90 f7a82ac0 ffffffff 00000000 b7e73ff4=20
f7282fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0115090>] __dequeue_entity+0x50/0xc0
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c0115208>] pick_next_task_fair+0x98/0xd0
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 X             R running      0  2796   2795
Nov 30 14:27:22 n22 f7ab0b80 00200082 00200286 f7286b48 fffecec4 00200286=20
f7286b48 fffecec4=20
Nov 30 14:27:22 n22 00000304 00000000 c029479a 00203086 00000000 c0370da0=20
c0370da0 fffecec4=20
Nov 30 14:27:22 n22 c0121f50 f7ab0b80 c03701c0 c0294795 696e0058 00000074=20
00000000 00000000=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c029479a>] schedule_timeout+0x4a/0xc0
Nov 30 14:27:22 n22 [<c0121f50>] process_timeout+0x0/0x10
Nov 30 14:27:22 n22 [<c0294795>] schedule_timeout+0x45/0xc0
Nov 30 14:27:22 n22 [<c016e54e>] do_select+0x3ae/0x490
Nov 30 14:27:22 n22 [<c016eb90>] __pollwait+0x0/0xf0
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c01a1554>] ext3_mark_iloc_dirty+0x174/0x330
Nov 30 14:27:22 n22 [<c01a1ad2>] ext3_mark_inode_dirty+0x32/0x50
Nov 30 14:27:22 n22 [<c01a9854>] __ext3_journal_stop+0x24/0x50
Nov 30 14:27:22 n22 [<c01ae058>] journal_stop+0xc8/0x170
Nov 30 14:27:22 n22 [<c01a9854>] __ext3_journal_stop+0x24/0x50
Nov 30 14:27:22 n22 [<c01a3cb2>] ext3_ordered_write_end+0xe2/0x140
Nov 30 14:27:22 n22 [<c011dd83>] current_fs_time+0x13/0x20
Nov 30 14:27:22 n22 [<c0144440>] generic_file_buffered_write+0x1a0/0x640
Nov 30 14:27:22 n22 [<c011dd83>] current_fs_time+0x13/0x20
Nov 30 14:27:22 n22 [<c0191617>] proc_alloc_inode+0x47/0x70
Nov 30 14:27:22 n22 [<c0174495>] alloc_inode+0xc5/0x140
Nov 30 14:27:22 n22 [<c0174579>] iget_locked+0x69/0x120
Nov 30 14:27:22 n22 [<c019173e>] proc_get_inode+0xce/0xe0
Nov 30 14:27:22 n22 [<c0195cb4>] proc_lookup_de+0xa4/0xb0
Nov 30 14:27:22 n22 [<c0172e3b>] d_alloc+0x1b/0x160
Nov 30 14:27:22 n22 [<c0169785>] do_lookup+0x65/0x1a0
Nov 30 14:27:22 n22 [<c016e7f8>] core_sys_select+0x1c8/0x2f0
Nov 30 14:27:22 n22 [<c0117df2>] check_preempt_wakeup+0xd2/0x140
Nov 30 14:27:22 n22 [<c0113c0e>] __wake_up_common+0x3e/0x70
Nov 30 14:27:22 n22 [<c01e7bc4>] vt_ioctl+0x8c4/0x1960
Nov 30 14:27:22 n22 [<c023a500>] raw_pci_write+0x90/0xa0
Nov 30 14:27:22 n22 [<c0183519>] invalidate_inode_buffers+0x9/0x40
Nov 30 14:27:22 n22 [<c016ed62>] sys_select+0xe2/0x1b0
Nov 30 14:27:22 n22 [<c01d1c90>] copy_to_user+0x30/0x60
Nov 30 14:27:22 n22 [<c0102fa9>] sysenter_do_call+0x12/0x25
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 sh            D c012293a     0  2813   2795
Nov 30 14:27:22 n22 f7a9c460 00000086 f7ab7f10 c012293a c01240f8 f7a9c460=20
00000000 f7ab7f10=20
Nov 30 14:27:22 n22 f7ae4d00 f7ab7fb8 c013b1f5 ffffffff c0124fea 00000001=20
f7ac840c c0367258=20
Nov 30 14:27:22 n22 f7ac83e0 f7ab7f90 f7a6fac0 ffffffff ffffffff 00000000=20
f7ab7fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c012293a>] recalc_sigpending+0xa/0x30
Nov 30 14:27:22 n22 [<c01240f8>] dequeue_signal+0x48/0x140
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c029436a>] schedule+0x16a/0x2b0
Nov 30 14:27:22 n22 [<c011c62b>] do_wait+0x1eb/0x340
Nov 30 14:27:22 n22 [<c0114ba0>] default_wake_function+0x0/0x10
Nov 30 14:27:22 n22 [<c011c7fc>] sys_wait4+0x7c/0xc0
Nov 30 14:27:22 n22 [<c011c865>] sys_waitpid+0x25/0x30
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 xclock        D f6963ea0     0  2814   2813
Nov 30 14:27:22 n22 f7aceb80 00000086 00000001 f6963ea0 00000000 00000000=20
00000000 f6963f10=20
Nov 30 14:27:22 n22 f7ae4300 f6963fb8 c013b1f5 09a97ba8 c0124fea f6963edc=20
f6963f60 f7292bc0=20
Nov 30 14:27:22 n22 c0162576 f6963f90 f7a6f580 09a97ba8 09a7faa8 b7bfcff4=20
f6963fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0162576>] do_sync_write+0xc6/0x110
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c0151437>] handle_mm_fault+0xe7/0x510
Nov 30 14:27:22 n22 [<c028a949>] unix_ioctl+0x89/0xc0
Nov 30 14:27:22 n22 [<c023b52f>] sock_ioctl+0xcf/0x250
Nov 30 14:27:22 n22 [<c023b460>] sock_ioctl+0x0/0x250
Nov 30 14:27:22 n22 [<c016d48f>] vfs_ioctl+0x1f/0x70
Nov 30 14:27:22 n22 [<c010ff6a>] read_hpet+0xa/0x10
Nov 30 14:27:22 n22 [<c012ffed>] getnstimeofday+0x3d/0xe0
Nov 30 14:27:22 n22 [<c016e0e5>] sys_poll+0x35/0x80
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 xterm         D f6982ea0     0  2815   2813
Nov 30 14:27:22 n22 f7ab8bc0 00000086 00000001 f6982ea0 00000000 00000000=20
00000000 f6982f10=20
Nov 30 14:27:22 n22 f7ae4900 f6982fb8 c013b1f5 00000005 c0124fea f6982edc=20
f6982f60 f7aec0c0=20
Nov 30 14:27:22 n22 c0162686 f6982f90 f7a6f040 00000005 00000000 00000000=20
f6982fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0162686>] do_sync_read+0xc6/0x110
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c028a949>] unix_ioctl+0x89/0xc0
Nov 30 14:27:22 n22 [<c023b52f>] sock_ioctl+0xcf/0x250
Nov 30 14:27:22 n22 [<c016eccd>] sys_select+0x4d/0x1b0
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 mwm           D f6976ea0     0  2817   2813
Nov 30 14:27:22 n22 f7ab80b0 00000082 00000001 f6976ea0 00000000 00000000=20
00000000 f6976f10=20
Nov 30 14:27:22 n22 f7ae4700 f6976fb8 c013b1f5 08c3e6c0 c0124fea f6976edc=20
f6976f60 f7ac1a40=20
Nov 30 14:27:22 n22 c0162576 f6976f90 f7bb1040 08c3e6c0 08c07bf0 b7b27ff4=20
f6976fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0162576>] do_sync_write+0xc6/0x110
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c012ad00>] autoremove_wake_function+0x0/0x50
Nov 30 14:27:22 n22 [<c0151437>] handle_mm_fault+0xe7/0x510
Nov 30 14:27:22 n22 [<c028a949>] unix_ioctl+0x89/0xc0
Nov 30 14:27:22 n22 [<c023b52f>] sock_ioctl+0xcf/0x250
Nov 30 14:27:22 n22 [<c023b460>] sock_ioctl+0x0/0x250
Nov 30 14:27:22 n22 [<c016d48f>] vfs_ioctl+0x1f/0x70
Nov 30 14:27:22 n22 [<c010ff6a>] read_hpet+0xa/0x10
Nov 30 14:27:22 n22 [<c012ffed>] getnstimeofday+0x3d/0xe0
Nov 30 14:27:22 n22 [<c016e0e5>] sys_poll+0x35/0x80
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 bash          D c011e5d7     0  2819   2815
Nov 30 14:27:22 n22 f7aaa3e0 00000082 f6994ea4 c011e5d7 c01050e6 1a131100=20
00000000 f6994f10=20
Nov 30 14:27:22 n22 f7ae4100 f6994fb8 c013b1f5 00000000 c0124fea c0103177=20
f69849c0 00000000=20
Nov 30 14:27:22 n22 00000001 f6994f90 f7bb1ac0 00000000 b7ef2420 083fd150=20
f6994fb8 c0102324=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c011e5d7>] irq_exit+0x27/0x70
Nov 30 14:27:22 n22 [<c01050e6>] do_IRQ+0x76/0xc0
Nov 30 14:27:22 n22 [<c013b1f5>] refrigerator+0x55/0x80
Nov 30 14:27:22 n22 [<c0124fea>] get_signal_to_deliver+0x1fa/0x310
Nov 30 14:27:22 n22 [<c0103177>] common_interrupt+0x23/0x28
Nov 30 14:27:22 n22 [<c0102324>] do_notify_resume+0x74/0x740
Nov 30 14:27:22 n22 [<c01e4ba7>] read_chan+0x227/0x5f0
Nov 30 14:27:22 n22 [<c01e0de0>] tty_read+0x90/0xc0
Nov 30 14:27:22 n22 [<c01e4980>] read_chan+0x0/0x5f0
Nov 30 14:27:22 n22 [<c0162fa1>] vfs_read+0xa1/0x160
Nov 30 14:27:22 n22 [<c01e0d50>] tty_read+0x0/0xc0
Nov 30 14:27:22 n22 [<c01632e1>] sys_read+0x41/0x70
Nov 30 14:27:22 n22 [<c01030a2>] work_notifysig+0x13/0x19
Nov 30 14:27:22 n22 [<c0290000>] pci_bus_size_bridges+0x1e0/0x3b0
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 default.sh    R running      0  2906   2553
Nov 30 14:27:22 n22 00000001 c0103f76 00000000 c02d670b f7ace7d0 f7ace7d0=20
c0117746 c02dd260=20
Nov 30 14:27:22 n22 00000000 00000004 00989680 c013b09f c02de824 00000014=20
00000000 00000001=20
Nov 30 14:27:22 n22 f74022fc 01000000 fffd4a57 493294ba 000ee7bf 493294a6=20
000ee783 00000000=20
Nov 30 14:27:22 n22 Call Trace:
Nov 30 14:27:22 n22 [<c0103f76>] show_stack+0x36/0x50
Nov 30 14:27:22 n22 [<c0117746>] show_state_filter+0x56/0x80
Nov 30 14:27:22 n22 [<c013b09f>] try_to_freeze_tasks+0x21f/0x2a0
Nov 30 14:27:22 n22 [<c013b13a>] freeze_processes+0x1a/0x80
Nov 30 14:27:22 n22 [<c013b7c5>] prepare_processes+0x5/0x20
Nov 30 14:27:22 n22 [<c013bfde>] hibernate+0x9e/0x190
Nov 30 14:27:22 n22 [<c013ac80>] state_store+0x0/0xf0
Nov 30 14:27:22 n22 [<c013ad58>] state_store+0xd8/0xf0
Nov 30 14:27:22 n22 [<c013ac80>] state_store+0x0/0xf0
Nov 30 14:27:22 n22 [<c01cc2e4>] kobj_attr_store+0x24/0x30
Nov 30 14:27:22 n22 [<c019b651>] sysfs_write_file+0xa1/0x110
Nov 30 14:27:22 n22 [<c0162e46>] vfs_write+0xa6/0x160
Nov 30 14:27:22 n22 [<c019b5b0>] sysfs_write_file+0x0/0x110
Nov 30 14:27:22 n22 [<c0163351>] sys_write+0x41/0x70
Nov 30 14:27:22 n22 [<c0102fa9>] sysenter_do_call+0x12/0x25
Nov 30 14:27:22 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Nov 30 14:27:22 n22 Sched Debug Version: v0.07, 2.6.27-gentoo-r4 #3
Nov 30 14:27:22 n22 now at 122425.888230 msecs
Nov 30 14:27:22 n22 .sysctl_sched_latency                    : 20.000000
Nov 30 14:27:22 n22 .sysctl_sched_min_granularity            : 4.000000
Nov 30 14:27:22 n22 .sysctl_sched_wakeup_granularity         : 5.000000
Nov 30 14:27:22 n22 .sysctl_sched_child_runs_first           : 0.000001
Nov 30 14:27:22 n22 .sysctl_sched_features                   : 7807
Nov 30 14:27:22 n22=20
Nov 30 14:27:22 n22 cpu#0, 1694.489 MHz
Nov 30 14:27:22 n22 .nr_running                    : 2
Nov 30 14:27:22 n22 .load                          : 2301
Nov 30 14:27:22 n22 .nr_switches                   : 31404
Nov 30 14:27:22 n22 .nr_load_updates               : 33822
Nov 30 14:27:22 n22 .nr_uninterruptible            : 19
Nov 30 14:27:22 n22 .jiffies                       : 4294789721
Nov 30 14:27:22 n22 .next_balance                  : 0.000000
Nov 30 14:27:22 n22 .curr->pid                     : 2906
Nov 30 14:27:22 n22 .clock                         : 300033.896000
Nov 30 14:27:22 n22 .cpu_load[0]                   : 2301
Nov 30 14:27:22 n22 .cpu_load[1]                   : 2301
Nov 30 14:27:22 n22 .cpu_load[2]                   : 2301
Nov 30 14:27:22 n22 .cpu_load[3]                   : 2301
Nov 30 14:27:22 n22 .cpu_load[4]                   : 2301
Nov 30 14:27:22 n22=20
Nov 30 14:27:22 n22 cfs_rq[0]:
Nov 30 14:27:22 n22 .exec_clock                    : 0.000000
Nov 30 14:27:22 n22 .MIN_vruntime                  : 58523.502990
Nov 30 14:27:23 n22 .min_vruntime                  : 58543.502966
Nov 30 14:27:23 n22 .max_vruntime                  : 58523.502990
Nov 30 14:27:23 n22 .spread                        : 0.000000
Nov 30 14:27:23 n22 .spread0                       : 0.000000
Nov 30 14:27:23 n22 .nr_running                    : 2
Nov 30 14:27:23 n22 .load                          : 2301
Nov 30 14:27:23 n22 .nr_spread_over                : 0
Nov 30 14:27:23 n22=20
Nov 30 14:27:23 n22 rt_rq[0]:
Nov 30 14:27:23 n22 .rt_nr_running                 : 0
Nov 30 14:27:23 n22 .rt_throttled                  : 0
Nov 30 14:27:23 n22 .rt_time                       : 0.000000
Nov 30 14:27:23 n22 .rt_runtime                    : 950.000000
Nov 30 14:27:23 n22=20
Nov 30 14:27:23 n22 runnable tasks:
Nov 30 14:27:23 n22 task   PID         tree-key  switches  prio    =20
exec-runtime         sum-exec        sum-sleep
Nov 30 14:27:23=20
n22 -----------------------------------------------------------------------=
=2D----------------------------------
Nov 30 14:27:23 n22 X  2796     58523.502990      1428   119               =
0              =20
0               0.000000               0.000000               0.000000
Nov 30 14:27:23 n22 R     default.sh  2906     58523.502966        50   120=
              =20
0               0               0.000000               0.000000            =
  =20
0.000000
Nov 30 14:27:23 n22=20
Nov 30 14:27:23 n22 X
Nov 30 14:27:23 n22=20
Nov 30 14:27:23 n22 Restarting tasks ... done.
Nov 30 14:27:23 n22 acpid: action exited with status 0
Nov 30 14:27:23 n22 acpid: completed event "ibm/hotkey HKEY 00000080 000010=
0c"
Nov 30 14:27:23 n22 acpid: client connected from 2796[0:0]
Nov 30 14:27:23 n22 acpid: 1 client rule loaded




=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--nextPart14288460.WiAdOWrp9x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkymaUACgkQhyrlCH22naOkzwCfUA8fn18HpBEnwb4oHT7kS+Xf
/PgAoJICcaPN210lRTPy3ZJaVyyHmrSD
=ogvA
-----END PGP SIGNATURE-----

--nextPart14288460.WiAdOWrp9x--
