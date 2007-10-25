Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXJYRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXJYRr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXJYRrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:47:45 -0400
Received: from mx39.mail.ru ([194.67.23.35]:62421 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXJYRrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:47:36 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-pm@lists.linux-foundation.org
Subject: [2.6.24-rc1 regression] suspend fails
Date: Thu, 25 Oct 2007 21:47:21 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1851810.lKSTslhpdd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710252147.22814.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1851810.lKSTslhpdd
Content-Type: multipart/mixed;
  boundary="Boundary-01=_qaNIHV31Ak5siLp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_qaNIHV31Ak5siLp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I can no more suspend with 2.6.24-rc1. 2.6.23 is fine. Here is kernel log;=
=20
config attached

[ 1021.446900] Syncing filesystems ... done.
[ 1021.458569] Freezing user space processes ...=20
[ 1041.454780] Freezing of tasks failed after 20.00 seconds (1 tasks refusi=
ng=20
to freeze):
[ 1041.455007]   task                PC stack   pid father
[ 1041.455155] init          D 000000ed     0     1      0
[ 1041.455325]        c1833e94 00000046 d3b08502 000000ed c1832000 c02da620=
=20
00000000 0025779c=20
[ 1041.455658]        00000000 d3d5fc9e 000000ed 00000000 c1833fb8 bfa0dbe8=
=20
c1833ea0 c014543b=20
[ 1041.456001]        0000000b c1833ed4 c0126c1c c03988c0 00000246 c1833ebc=
=20
c02d110d c1833fb8=20
[ 1041.456340] Call Trace:
[ 1041.456425]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1041.456425]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1041.456598]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1041.456598]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1041.456783]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1041.456783]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1041.456945]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1041.456945]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1041.457099]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.457202] kthreadd      S 000000d1     0     2      0
[ 1041.457366]        c19dbfcc 00000046 343182f1 000000d1 c19da000 c02da620=
=20
00000000 00002ee0=20
[ 1041.457691]        00000000 3431b1d1 000000d1 c03924e0 00000e83 c2c2bc54=
=20
c19dbfe0 c012e492=20
[ 1041.458077]        c012e3a0 00000000 00000000 00000000 c01044e3 00000000=
=20
00000000 00000000=20
[ 1041.458414] Call Trace:
[ 1041.458495]  [kthreadd+242/256] kthreadd+0xf2/0x100
[ 1041.458495]  [<c012e492>] kthreadd+0xf2/0x100
[ 1041.458645]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.458645]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.458808]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.458911] ksoftirqd/0   S 00000000     0     3      2
[ 1041.459074]        c19e1fc4 00000046 00000000 00000000 c19e0000 c02da620=
=20
00000000 00000000=20
[ 1041.459398]        00000000 6963297c 000000ed fffffffc 00000000 c0120540=
=20
c19e1fcc c01205bc=20
[ 1041.459734]        c19e1fe0 c012e372 c012e330 00000000 00000000 00000000=
=20
c01044e3 c1833ee8=20
[ 1041.460071] Call Trace:
[ 1041.460154]  [ksoftirqd+124/128] ksoftirqd+0x7c/0x80
[ 1041.460154]  [<c01205bc>] ksoftirqd+0x7c/0x80
[ 1041.460314]  [kthread+66/112] kthread+0x42/0x70
[ 1041.460314]  [<c012e372>] kthread+0x42/0x70
[ 1041.460447]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.460447]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.460607]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.460709] watchdog/0    S 000000f2     0     4      2
[ 1041.460872]        c19e3fc0 00000046 1d96ece2 000000f2 c19e2000 c02da620=
=20
00000292 000036ee=20
[ 1041.461197]        00000000 1d9723d0 000000f2 fffffffc 00000000 c0152830=
=20
c19e3fcc c015286b=20
[ 1041.461578]        00000063 c19e3fe0 c012e372 c012e330 00000000 00000000=
=20
00000000 c01044e3=20
[ 1041.461913] Call Trace:
[ 1041.461996]  [watchdog+59/80] watchdog+0x3b/0x50
[ 1041.461996]  [<c015286b>] watchdog+0x3b/0x50
[ 1041.462139]  [kthread+66/112] kthread+0x42/0x70
[ 1041.462139]  [<c012e372>] kthread+0x42/0x70
[ 1041.462273]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.462273]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.462432]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.462536] events/0      S 000000f2     0     5      2
[ 1041.462698]        c19e7fa0 00000046 7102c870 000000f2 c19e6000 c02da620=
=20
00000000 0000e0d3=20
[ 1041.463022]        00000000 7103a943 000000f2 c180d148 c180d120 c19e7fac=
=20
c19e7fcc c012b155=20
[ 1041.463359]        c180d140 00000000 c19e4000 c012e610 c180d168 c180d168=
=20
fffffffc c180d120=20
[ 1041.463695] Call Trace:
[ 1041.463777]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.463777]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.463938]  [kthread+66/112] kthread+0x42/0x70
[ 1041.463938]  [<c012e372>] kthread+0x42/0x70
[ 1041.464071]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.464071]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.469782]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.475341] khelper       S 00000000     0     6      2
[ 1041.480918]        c19e9fa0 00000046 00000000 00000000 c19e8000 c02da620=
=20
00000000 00000000=20
[ 1041.481247]        00000000 95259283 000000e3 c180d0e8 c180d0c0 c19e9fac=
=20
c19e9fcc c012b155=20
[ 1041.486958]        c180d0e0 00000000 c19e4d60 c012e610 c180d108 c180d108=
=20
fffffffc c180d0c0=20
[ 1041.492725] Call Trace:
[ 1041.503631]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.503631]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.509196]  [kthread+66/112] kthread+0x42/0x70
[ 1041.509196]  [<c012e372>] kthread+0x42/0x70
[ 1041.514650]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.514650]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.520122]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.525546] kblockd/0     S 000000ed     0    34      2
[ 1041.531030]        c1a41fa0 00000046 d30f148c 000000ed c1a40000 c02da620=
=20
00000000 00020b8a=20
[ 1041.531404]        00000000 d3112016 000000ed c180d508 c180d4e0 c1a41fac=
=20
c1a41fcc c012b155=20
[ 1041.537143]        c180d500 00000000 c1a3e000 c012e610 c180d528 c180d528=
=20
fffffffc c180d4e0=20
[ 1041.542932] Call Trace:
[ 1041.553990]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.553990]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.559607]  [kthread+66/112] kthread+0x42/0x70
[ 1041.559607]  [<c012e372>] kthread+0x42/0x70
[ 1041.565135]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.565135]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.570597]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.576028] kacpid        S 000000f2     0    37      2
[ 1041.581532]        c1a49fa0 00000046 52ab22cb 000000f2 c1a48000 c02da620=
=20
00000286 000e6ee1=20
[ 1041.581861]        00000000 52b991ac 000000f2 c180d5c8 c180d5a0 c1a49fac=
=20
c1a49fcc c012b155=20
[ 1041.587599]        c180d5c0 00000000 c1a44d60 c012e610 c180d5e8 c180d5e8=
=20
fffffffc c180d5a0=20
[ 1041.593403] Call Trace:
[ 1041.604356]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.604356]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.609950]  [kthread+66/112] kthread+0x42/0x70
[ 1041.609950]  [<c012e372>] kthread+0x42/0x70
[ 1041.615432]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.615432]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.620942]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.626440] kacpi_notify  S 00000000     0    38      2
[ 1041.632020]        c1a4dfa0 00000046 00000000 00000000 c1a4c000 c1a4df8c=
=20
00000000 00000000=20
[ 1041.632347]        00000000 52bcff81 000000f2 c180d628 c180d600 c1a4dfac=
=20
c1a4dfcc c012b155=20
[ 1041.638198]        c180d620 00000000 c1a4a000 c012e610 c180d648 c180d648=
=20
fffffffc c180d600=20
[ 1041.644043] Call Trace:
[ 1041.655081]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.655081]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.660725]  [kthread+66/112] kthread+0x42/0x70
[ 1041.660725]  [<c012e372>] kthread+0x42/0x70
[ 1041.666258]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.666258]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.671833]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.677364] kseriod       S c03a4a20     0   113      2
[ 1041.682973]        c19f9f8c 00000046 c03a4a20 c03a4a20 c19f8000 c02da5a0=
=20
00000286 c19f9fac=20
[ 1041.683301]        c03a4a20 c19f9f8c c012e7d2 c03a4a00 c03a4a48 c19f9fac=
=20
c19f9fcc c0259c3a=20
[ 1041.689154]        c19f9fcc c02cf424 9a482846 000000c2 c2c72a80 00000286=
=20
00000000 c1a3ed60=20
[ 1041.695058] Call Trace:
[ 1041.706215]  [serio_thread+218/864] serio_thread+0xda/0x360
[ 1041.706215]  [<c0259c3a>] serio_thread+0xda/0x360
[ 1041.711920]  [kthread+66/112] kthread+0x42/0x70
[ 1041.711920]  [<c012e372>] kthread+0x42/0x70
[ 1041.717498]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.717498]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.723093]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.728679] pdflush       S 000000ed     0   138      2
[ 1041.734319]        c20e3fa4 00000046 cbae0b9e 000000ed c20e2000 c02da620=
=20
00000000 005760da=20
[ 1041.734691]        00000000 cc056c78 000000ed c20e3fbc 00000000 c015dba0=
=20
c20e3fcc c015dc45=20
[ 1041.740560]        c1833f00 c20e0000 00000000 0000029b c0397ae0 c0397ae0=
=20
0000ad67 fffffffc=20
[ 1041.746486] Call Trace:
[ 1041.757669]  [pdflush+165/448] pdflush+0xa5/0x1c0
[ 1041.757669]  [<c015dc45>] pdflush+0xa5/0x1c0
[ 1041.763350]  [kthread+66/112] kthread+0x42/0x70
[ 1041.763350]  [<c012e372>] kthread+0x42/0x70
[ 1041.768909]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.768909]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.774488]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.780037] pdflush       R running      0   139      2
[ 1041.785654] kswapd0       S 000000c2     0   140      2
[ 1041.791240]        c20ebf44 00000046 ad72ed38 000000c2 c20ea000 c20ebf30=
=20
00000296 000113d6=20
[ 1041.791569]        00000000 ad74010e 000000c2 00000000 c03970c0 c0160ae0=
=20
c20ebfcc c0160eda=20
[ 1041.797403]        00000282 c03eb000 c20ebf7c c03979c4 00000000 00000000=
=20
c03eb000 c0389160=20
[ 1041.803210] Call Trace:
[ 1041.814227]  [kswapd+1018/1040] kswapd+0x3fa/0x410
[ 1041.814227]  [<c0160eda>] kswapd+0x3fa/0x410
[ 1041.819801]  [kthread+66/112] kthread+0x42/0x70
[ 1041.819801]  [<c012e372>] kthread+0x42/0x70
[ 1041.825332]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.825332]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.830900]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.836429] aio/0         S 000000c2     0   184      2
[ 1041.842022]        c20dbfa0 00000046 ae8859cf 000000c2 c20da000 c20dbf8c=
=20
00000286 0000750d=20
[ 1041.842351]        00000000 ae88cedc 000000c2 c180d988 c180d960 c20dbfac=
=20
c20dbfcc c012b155=20
[ 1041.848167]        c180d980 00000000 c20d8000 c012e610 c180d9a8 c180d9a8=
=20
fffffffc c180d960=20
[ 1041.853965] Call Trace:
[ 1041.864939]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.864939]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.870508]  [kthread+66/112] kthread+0x42/0x70
[ 1041.870508]  [<c012e372>] kthread+0x42/0x70
[ 1041.876031]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.876031]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.881588]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.887107] reiserfs/0    S 00000000     0   845      2
[ 1041.892690]        c216bfa0 00000046 00000000 00000000 c216a000 c216bf8c=
=20
00000000 00000000=20
[ 1041.893022]        00000000 e6494fec 000000ed c180df28 c180df00 c216bfac=
=20
c216bfcc c012b155=20
[ 1041.898840]        c180df20 00000000 c20e8d60 c012e610 c180df48 c180df48=
=20
fffffffc c180df00=20
[ 1041.904671] Call Trace:
[ 1041.915683]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1041.915683]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1041.921256]  [kthread+66/112] kthread+0x42/0x70
[ 1041.921256]  [<c012e372>] kthread+0x42/0x70
[ 1041.926794]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1041.926794]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1041.932380]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.937914] udevd         D 000000cc     0   994      1
[ 1041.943505]        c1843e94 00000046 75ef9074 000000cc c1842000 c02da620=
=20
00000000 5de6f2e5=20
[ 1041.943833]        00000021 d3d68359 000000ed 00000000 c1843fb8 00000000=
=20
c1843ea0 c014543b=20
[ 1041.949658]        00000007 c1843ed4 c0126c1c 00000000 c216cd60 c02d1847=
=20
00000005 c1843fb8=20
[ 1041.955445] Call Trace:
[ 1041.966381]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1041.966381]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1041.971907]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1041.971907]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1041.977462]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1041.977462]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1041.983035]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1041.983035]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1041.988589]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1041.994091] ksuspend_usbd S 00000000     0  1252      2
[ 1041.999661]        c28b9fa0 00000046 00000000 00000000 c28b8000 c02da620=
=20
00000286 00000000=20
[ 1041.999989]        00000000 aa9a1fca 000000c7 c2194508 c21944e0 c28b9fac=
=20
c28b9fcc c012b155=20
[ 1042.005729]        c2194500 00000000 c224cd60 c012e610 c2194528 c2194528=
=20
fffffffc c21944e0=20
[ 1042.011462] Call Trace:
[ 1042.022291]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1042.022291]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1042.027849]  [kthread+66/112] kthread+0x42/0x70
[ 1042.027849]  [<c012e372>] kthread+0x42/0x70
[ 1042.033399]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.033399]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.038966]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.044494] khubd         S 000000c7     0  1253      2
[ 1042.050076]        c23e7f34 00000046 d39c474c 000000c7 c23e6000 c02da620=
=20
00000000 00034daa=20
[ 1042.050405]        00000000 d39f94f6 000000c7 dfea8d40 00000000 c186c800=
=20
c23e7fcc dfe8972e=20
[ 1042.056244]        c23e7fb8 c21be000 c23e7f64 c013b2e0 c21be000 00000001=
=20
00000046 c186ca00=20
[ 1042.062058] Call Trace:
[ 1042.073077]  [<dfe8972e>] hub_thread+0xce/0xc90 [usbcore]
[ 1042.078903]  [kthread+66/112] kthread+0x42/0x70
[ 1042.078903]  [<c012e372>] kthread+0x42/0x70
[ 1042.084484]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.084484]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.090106]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.095689] pccardd       S 000000c7     0  1277      2
[ 1042.101328]        c2935f8c 00000046 de001faa 000000c7 c2934000 c02da620=
=20
00000000 000a8c98=20
[ 1042.101656]        00000000 de0aac42 000000c7 c22e4840 00000000 c22e4a38=
=20
c2935fcc df874df5=20
[ 1042.107546]        c2935fcc c02cf424 c22e4998 c22e4a94 c22e4a10 00000000=
=20
c18ac000 c0114720=20
[ 1042.113419] Call Trace:
[ 1042.124547]  [<df874df5>] pccardd+0x125/0x250 [pcmcia_core]
[ 1042.130289]  [kthread+66/112] kthread+0x42/0x70
[ 1042.130289]  [<c012e372>] kthread+0x42/0x70
[ 1042.135930]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.135930]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.141609]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.147238] pccardd       S 00000000     0  1297      2
[ 1042.152931]        c21fff8c 00000046 00000000 00000000 c21fe000 c02da620=
=20
00000000 00000000=20
[ 1042.153260]        00000000 c33a718b 000000c7 c22e5040 00000000 c22e5238=
=20
c21fffcc df874df5=20
[ 1042.159202]        c21fffcc c02cf424 c22e5198 c22e5294 c22e5210 00000000=
=20
c1950d60 c0114720=20
[ 1042.165116] Call Trace:
[ 1042.176352]  [<df874df5>] pccardd+0x125/0x250 [pcmcia_core]
[ 1042.182091]  [kthread+66/112] kthread+0x42/0x70
[ 1042.182091]  [<c012e372>] kthread+0x42/0x70
[ 1042.187781]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.187781]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.193502]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.199187] pccardd       S 000000c7     0  1318      2
[ 1042.204929]        c22ddf8c 00000046 cb478cd3 000000c7 c22dc000 c02da620=
=20
00000000 00661243=20
[ 1042.205257]        00000000 cbad9f16 000000c7 c22e5840 00000000 c22e5a38=
=20
c22ddfcc df874df5=20
[ 1042.211290]        c22ddfcc c02cf424 c22e5998 c22e5a94 c22e5a10 00000000=
=20
c22ded60 c0114720=20
[ 1042.217265] Call Trace:
[ 1042.228645]  [<df874df5>] pccardd+0x125/0x250 [pcmcia_core]
[ 1042.234462]  [kthread+66/112] kthread+0x42/0x70
[ 1042.234462]  [<c012e372>] kthread+0x42/0x70
[ 1042.240227]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.240227]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.246005]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.251732] kpsmoused     S 00000000     0  2013      2
[ 1042.257536]        c23edfa0 00000046 00000000 00000000 c23ec000 c02da620=
=20
00000286 00000000=20
[ 1042.257908]        00000000 662a8fbf 000000c9 c28d91a8 c28d9180 c23edfac=
=20
c23edfcc c012b155=20
[ 1042.263941]        c28d91a0 00000000 c191cd60 c012e610 c28d91c8 c28d91c8=
=20
fffffffc c28d9180=20
[ 1042.270023] Call Trace:
[ 1042.281528]  [worker_thread+197/240] worker_thread+0xc5/0xf0
[ 1042.281528]  [<c012b155>] worker_thread+0xc5/0xf0
[ 1042.287402]  [kthread+66/112] kthread+0x42/0x70
[ 1042.287402]  [<c012e372>] kthread+0x42/0x70
[ 1042.293151]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1042.293151]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1042.298920]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.304663] syslogd       D 000000ed     0  2623      1
[ 1042.310484]        c2c1be94 00000046 d3ba773f 000000ed c2c1a000 c02da620=
=20
00000000 0053073f=20
[ 1042.310813]        00000000 d40d7e7e 000000ed 00000000 c2c1bfb8 00000000=
=20
c2c1bea0 c014543b=20
[ 1042.316860]        00000018 c2c1bed4 c0126c1c c2c1bebc c0138a5c c2a82d60=
=20
c1e051f8 c2c1bfb8=20
[ 1042.322947] Call Trace:
[ 1042.334500]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.334500]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.340370]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.340370]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.346182]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.346182]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.351966]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.351966]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.357730]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.363456] atd           D 000000ed     0  2649      1
[ 1042.369236]        c2b93e94 00000046 d3c27056 000000ed c2b92000 c02da620=
=20
00000000 00146a05=20
[ 1042.369564]        00000000 d3d6da5b 000000ed 00000000 c2b93fb8 00000000=
=20
c2b93ea0 c014543b=20
[ 1042.375576]        bfdec1f4 c2b93ed4 c0126c1c 00000000 c2bc6000 c02d1847=
=20
00000001 c2b93fb8=20
[ 1042.381546] Call Trace:
[ 1042.392853]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.392853]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.398573]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.398573]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.404302]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.404302]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.410061]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.410061]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.415768]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.421426] dbus-daemon   D 000000ed     0  2728      1
[ 1042.427140]        c2e59e94 00000046 d3ba52c7 000000ed c2e58000 c02da620=
=20
00000000 000b9778=20
[ 1042.427468]        00000000 d3c5ea3f 000000ed 00000000 c2e59fb8 b7f7bff4=
=20
c2e59ea0 c014543b=20
[ 1042.433354]        bfd7e180 c2e59ed4 c0126c1c 00000008 00000001 00000009=
=20
00000001 c2e59fb8=20
[ 1042.439245] Call Trace:
[ 1042.450369]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.450369]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.456044]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.456044]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.461746]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.461746]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.467452]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.467452]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.473133]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.478776] irattach      D 000000ed     0  2799      1
[ 1042.484407]        c29dbe94 00000046 d3b1788d 000000ed c29da000 c02da620=
=20
00000000 00263869=20
[ 1042.484734]        00000000 d3d7b0f6 000000ed 00000000 c29dbfb8 0804ba84=
=20
c29dbea0 c014543b=20
[ 1042.490547]        00000000 c29dbed4 c0126c1c c013bdca 00000000 c2d53a00=
=20
c2d539f0 c29dbfb8=20
[ 1042.496364] Call Trace:
[ 1042.507329]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.507329]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.512979]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.512979]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.518664]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.518664]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.524339]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.524339]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.529991]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.535522] klogd         D 000000ed     0  2808      1
[ 1042.541073]        c2ecfe94 00000046 d3c24db7 000000ed c2ece000 c02da620=
=20
00000000 0012832d=20
[ 1042.541401]        00000000 d3d4d0e4 000000ed 00000000 c2ecffb8 8000498d=
=20
c2ecfea0 c014543b=20
[ 1042.547143]        00000000 c2ecfed4 c0126c1c 00000000 c2b3c000 c2b3c000=
=20
c2b3c658 c2ecffb8=20
[ 1042.552853] Call Trace:
[ 1042.563746]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.563746]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.569376]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.569376]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.575020]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.575020]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.580643]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.580643]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.586192]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.591647] hcid          D 000000ed     0  2840      1
[ 1042.597115]        c2de3e94 00000046 d3b19b88 000000ed c2de2000 c02da620=
=20
00000000 0026b200=20
[ 1042.597444]        00000000 d3d84d88 000000ed 00000000 c2de3fb8 b7e93ff4=
=20
c2de3ea0 c014543b=20
[ 1042.603072]        08090da8 c2de3ed4 c0126c1c 00000005 00000001 00000008=
=20
00000019 c2de3fb8=20
[ 1042.608742] Call Trace:
[ 1042.619623]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.619623]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.625237]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.625237]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.630879]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.630879]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.636555]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.636555]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.642109]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.647584] sdpd          D 000000ed     0  2877      1
[ 1042.653126]        c2be3e94 00000046 d3c2913d 000000ed c2be2000 c02da620=
=20
00000000 00162da2=20
[ 1042.653456]        00000000 d3d8bedf 000000ed 00000000 c2be3fb8 b7f82ff4=
=20
c2be3ea0 c014543b=20
[ 1042.659113]        08055618 c2be3ed4 c0126c1c 00000002 00000000 c19212e0=
=20
c19212d0 c2be3fb8=20
[ 1042.664802] Call Trace:
[ 1042.675703]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.675703]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.681339]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.681339]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.686999]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.686999]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.692643]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.692643]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.698196]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.703658] hald          D 000000ed     0  2896      1
[ 1042.709141]        c2a65e94 00000046 d3bf7729 000000ed c2a64000 c02da620=
=20
00000000 000a62b0=20
[ 1042.709469]        00000000 d3c9d9d9 000000ed 00000000 c2a65fb8 b7e0aff4=
=20
c2a65ea0 c014543b=20
[ 1042.715111]        081ef8f0 c2a65ed4 c0126c1c 0000000c 00000003 00000010=
=20
00000001 c2a65fb8=20
[ 1042.720799] Call Trace:
[ 1042.731714]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.731714]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.737339]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.737339]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.742998]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.742998]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.748642]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.748642]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.754201]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.759666] hald-runner   D 000000ed     0  2899   2896
[ 1042.765164]        c2e71e94 00000046 d3b206b2 000000ed c2e70000 c02da620=
=20
00000000 00286780=20
[ 1042.765494]        00000000 d3da6e32 000000ed 00000000 c2e71fb8 b7e69ff4=
=20
c2e71ea0 c014543b=20
[ 1042.771198]        0804d968 c2e71ed4 c0126c1c 00000000 c2c16d60 c02d1847=
=20
00000005 c2e71fb8=20
[ 1042.776885] Call Trace:
[ 1042.787782]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.787782]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.793413]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.793413]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.799067]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.799067]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.804713]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.804713]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.810275]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.815753] crond         D 000000ed     0  2905      1
[ 1042.821283]        c2d59e94 00000046 d3b22798 000000ed c2d58000 c02da620=
=20
00000000 00289574=20
[ 1042.821610]        00000000 d3dabd0c 000000ed 00000000 c2d59fb8 00000000=
=20
c2d59ea0 c014543b=20
[ 1042.827293]        bfd53d24 c2d59ed4 c0126c1c 00000000 c2a82000 c02d1847=
=20
00000001 c2d59fb8=20
[ 1042.833017] Call Trace:
[ 1042.843986]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.843986]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.849654]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.849654]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.855342]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.855342]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.861017]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.861017]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.866610]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.872113] console-kit-d D 000000ed     0  2925      1
[ 1042.877635]        c2b8de94 00000046 d3b246c5 000000ed c2b8c000 c02da620=
=20
00000001 0028f9ad=20
[ 1042.877963]        00000000 d3db4072 000000ed 00000000 c2b8dfb8 b7da2ff4=
=20
c2b8dea0 c014543b=20
[ 1042.883652]        080693e8 c2b8ded4 c0126c1c 00000009 00000001 c02ebda0=
=20
c2b8ded0 c2b8dfb8=20
[ 1042.889390] Call Trace:
[ 1042.900346]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.900346]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.906015]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.906015]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.911706]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.911706]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.917389]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.917389]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.922991]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.928515] console-kit-d D 000000ed     0  2936      1
[ 1042.934052]        c2d87e94 00000046 d3b265a3 000000ed c2d86000 c02da620=
=20
00000001 00294022=20
[ 1042.934424]        00000000 d3dba5c5 000000ed 00000000 c2d87fb8 00000002=
=20
c2d87ea0 c014543b=20
[ 1042.940121]        0000000b c2d87ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d87efc c2d87fb8=20
[ 1042.945864] Call Trace:
[ 1042.956831]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1042.956831]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1042.962503]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1042.962503]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1042.968198]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1042.968198]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1042.973876]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1042.973876]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1042.979483]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1042.984987] console-kit-d D 000000ed     0  2937      1
[ 1042.990513]        c2dc3e94 00000046 d3b285ad 000000ed c2dc2000 c02da620=
=20
00000001 00296fde=20
[ 1042.990882]        00000000 d3dbf58b 000000ed 00000000 c2dc3fb8 00000003=
=20
c2dc3ea0 c014543b=20
[ 1042.996576]        0000000b c2dc3ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2dc3efc c2dc3fb8=20
[ 1043.002305] Call Trace:
[ 1043.013247]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.013247]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.018909]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.018909]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.024602]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.024602]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.030275]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.030275]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.035860]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.041361] console-kit-d D 000000ed     0  2938      1
[ 1043.046887]        c2c87e94 00000046 d3b2a399 000000ed c2c86000 c02da620=
=20
00000001 00299dee=20
[ 1043.047213]        00000000 d3dc4187 000000ed 00000000 c2c87fb8 00000004=
=20
c2c87ea0 c014543b=20
[ 1043.052898]        0000000b c2c87ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c87efc c2c87fb8=20
[ 1043.058632] Call Trace:
[ 1043.069576]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.069576]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.075225]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.075225]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.080902]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.080902]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.086562]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.086562]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.092150]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.097648] console-kit-d D 000000ed     0  2939      1
[ 1043.103173]        c2a7be94 00000046 d3c2b150 000000ed c2a7a000 c02da620=
=20
00000000 0019dd9f=20
[ 1043.103500]        00000000 d3dc8eef 000000ed 00000000 c2a7bfb8 00000005=
=20
c2a7bea0 c014543b=20
[ 1043.109188]        0000000b c2a7bed4 c0126c1c c216c038 00000000 00000000=
=20
c2a7becc c2a7bfb8=20
[ 1043.114912] Call Trace:
[ 1043.125837]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.125837]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.131479]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.131479]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.137151]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.137151]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.142809]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.142809]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.148378]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.153855] console-kit-d D 000000ed     0  2940      1
[ 1043.159362]        c2be9e94 00000046 d3b2e349 000000ed c2be8000 c02da620=
=20
00000001 002a5a20=20
[ 1043.159690]        00000000 d3dd3d69 000000ed 00000000 c2be9fb8 00000006=
=20
c2be9ea0 c014543b=20
[ 1043.165358]        0000000b c2be9ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2be9efc c2be9fb8=20
[ 1043.171075] Call Trace:
[ 1043.181967]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.181967]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.187594]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.187594]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.193246]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.193246]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.198882]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.198882]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.204443]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.209909] console-kit-d D 000000ed     0  2943      1
[ 1043.215412]        c2dcde94 00000046 d3c2d16e 000000ed c2dcc000 c02da620=
=20
00000000 001abe7b=20
[ 1043.215742]        00000000 d3dd8fe9 000000ed 00000000 c2dcdfb8 00000008=
=20
c2dcdea0 c014543b=20
[ 1043.221407]        0000000b c2dcded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2dcdefc c2dcdfb8=20
[ 1043.227101] Call Trace:
[ 1043.237984]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.237984]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.243600]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.243600]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.249243]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.249243]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.254870]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.254870]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.260415]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.265867] console-kit-d D 000000ed     0  2944      1
[ 1043.271360]        c2e1fe94 00000046 d3b3247f 000000ed c2e1e000 c02da620=
=20
00000001 002b0b5d=20
[ 1043.271690]        00000000 d3de2fdc 000000ed 00000000 c2e1ffb8 00000009=
=20
c2e1fea0 c014543b=20
[ 1043.277333]        0000000b c2e1fed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e1fefc c2e1ffb8=20
[ 1043.283019] Call Trace:
[ 1043.293865]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.293865]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.299465]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.299465]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.305088]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.305088]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.310700]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.310700]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.316271]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.321707] console-kit-d D 000000ed     0  2945      1
[ 1043.327180]        c2b51e94 00000046 d3c2f178 000000ed c2b50000 c02da620=
=20
00000000 001b87e9=20
[ 1043.327552]        00000000 d3de7961 000000ed 00000000 c2b51fb8 0000000a=
=20
c2b51ea0 c014543b=20
[ 1043.333191]        0000000b c2b51ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b51efc c2b51fb8=20
[ 1043.338871] Call Trace:
[ 1043.349694]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.349694]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.355284]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.355284]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.360892]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.360892]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.366492]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.366492]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.372004]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.377420] console-kit-d D 000000ed     0  2946      1
[ 1043.382880]        c2c5be94 00000046 d3b364bb 000000ed c2c5a000 c02da620=
=20
00000001 002bae10=20
[ 1043.383208]        00000000 d3df12cb 000000ed 00000000 c2c5bfb8 0000000b=
=20
c2c5bea0 c014543b=20
[ 1043.388822]        0000000b c2c5bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c5befc c2c5bfb8=20
[ 1043.394490] Call Trace:
[ 1043.405306]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.405306]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.410893]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.410893]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.416508]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.416508]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.422111]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.422111]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.427632]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.433058] console-kit-d D 000000ed     0  2947      1
[ 1043.438517]        c2dbbe94 00000046 d3c313dc 000000ed c2dba000 c02da620=
=20
00000000 001c4e10=20
[ 1043.438847]        00000000 d3df61ec 000000ed 00000000 c2dbbfb8 0000000c=
=20
c2dbbea0 c014543b=20
[ 1043.444473]        0000000b c2dbbed4 c0126c1c c2b6e038 00000000 00000000=
=20
c2dbbecc c2dbbfb8=20
[ 1043.450132] Call Trace:
[ 1043.460936]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.460936]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.466518]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.466518]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.472121]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.472121]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.477719]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.477719]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.483226]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.488660] console-kit-d D 000000ed     0  2948      1
[ 1043.494129]        c2c39e94 00000046 d3b3a53e 000000ed c2c38000 c02da620=
=20
00000001 002c5363=20
[ 1043.494459]        00000000 d3dff8a1 000000ed 00000000 c2c39fb8 0000000d=
=20
c2c39ea0 c014543b=20
[ 1043.500081]        0000000b c2c39ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c39efc c2c39fb8=20
[ 1043.505743] Call Trace:
[ 1043.516561]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.516561]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.522149]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.522149]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.527759]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.527759]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.533353]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.533353]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.538865]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.544295] console-kit-d D 000000ed     0  2949      1
[ 1043.549747]        c2d03e94 00000046 d3c33849 000000ed c2d02000 c02da620=
=20
00000000 001d0a7f=20
[ 1043.550076]        00000000 d3e042c8 000000ed 00000000 c2d03fb8 0000000e=
=20
c2d03ea0 c014543b=20
[ 1043.555695]        0000000b c2d03ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d03efc c2d03fb8=20
[ 1043.561357] Call Trace:
[ 1043.572162]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.572162]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.577746]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.577746]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.583352]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.583352]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.588951]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.588951]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.594461]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.599879] console-kit-d D 000000ed     0  2950      1
[ 1043.605341]        c2dbfe94 00000046 d3b3e55b 000000ed c2dbe000 c02da620=
=20
00000001 002d4053=20
[ 1043.605670]        00000000 d3e125ae 000000ed 00000000 c2dbffb8 0000000f=
=20
c2dbfea0 c014543b=20
[ 1043.611299]        0000000b c2dbfed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2dbfefc c2dbffb8=20
[ 1043.616971] Call Trace:
[ 1043.627807]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.627807]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.633406]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.639034]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.639034]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.644648]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.644648]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.650189]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.655631] console-kit-d D 000000ed     0  2951      1
[ 1043.661106]        c2e87e94 00000046 d3b40424 000000ed c2e86000 c02da620=
=20
00000001 002d760d=20
[ 1043.661433]        00000000 d3e17a31 000000ed 00000000 c2e87fb8 00000010=
=20
c2e87ea0 c014543b=20
[ 1043.667071]        0000000b c2e87ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e87efc c2e87fb8=20
[ 1043.672747] Call Trace:
[ 1043.683576]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.683576]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.689175]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.689175]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.694800]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.694800]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.700413]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.700413]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.705945]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.711394] console-kit-d D 000000ed     0  2952      1
[ 1043.716882]        c2e6de94 00000046 d3b42597 000000ed c2e6c000 c02da620=
=20
00000001 002d9db0=20
[ 1043.717209]        00000000 d3e1c347 000000ed 00000000 c2e6dfb8 00000011=
=20
c2e6dea0 c014543b=20
[ 1043.722856]        0000000b c2e6ded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e6defc c2e6dfb8=20
[ 1043.728564] Call Trace:
[ 1043.739445]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.739445]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.745067]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.745067]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.750718]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.750718]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.756353]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.756353]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.761902]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.767364] console-kit-d D 000000ed     0  2953      1
[ 1043.772854]        c2c3de94 00000046 d3c35c70 000000ed c2c3c000 c02da620=
=20
00000000 001eb1a9=20
[ 1043.773182]        00000000 d3e20e19 000000ed 00000000 c2c3dfb8 00000012=
=20
c2c3dea0 c014543b=20
[ 1043.778835]        0000000b c2c3ded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c3defc c2c3dfb8=20
[ 1043.784533] Call Trace:
[ 1043.795430]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.795430]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.801059]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.801059]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.806716]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.806716]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.812363]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.812363]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.817926]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.823400] console-kit-d D 000000ed     0  2954      1
[ 1043.828902]        c2a9be94 00000046 d3b463ac 000000ed c2a9a000 c02da620=
=20
00000001 002ea7a6=20
[ 1043.829231]        00000000 d3e30b52 000000ed 00000000 c2a9bfb8 00000013=
=20
c2a9bea0 c014543b=20
[ 1043.834899]        0000000b c2a9bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2a9befc c2a9bfb8=20
[ 1043.840664] Call Trace:
[ 1043.851602]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.851602]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.857245]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.857245]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.862966]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.862966]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.868631]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.868631]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.874209]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.879691] console-kit-d D 000000ed     0  2955      1
[ 1043.885216]        c2bb1e94 00000046 d3b48347 000000ed c2bb0000 c02da620=
=20
00000001 002ed958=20
[ 1043.885545]        00000000 d3e35c9f 000000ed 00000000 c2bb1fb8 00000014=
=20
c2bb1ea0 c014543b=20
[ 1043.891229]        0000000b c2bb1ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bb1efc c2bb1fb8=20
[ 1043.896959] Call Trace:
[ 1043.907897]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.907897]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.913541]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.913541]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.919214]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.919214]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1043.924875]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.924875]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.930455]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.935942] console-kit-d D 000000ed     0  2956      1
[ 1043.941464]        c2bbde94 00000046 d3b4a384 000000ed c2bbc000 c02da620=
=20
00000001 002f0335=20
[ 1043.941792]        00000000 d3e3a6b9 000000ed 00000000 c2bbdfb8 00000015=
=20
c2bbdea0 c014543b=20
[ 1043.947514]        0000000b c2bbded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bbdefc c2bbdfb8=20
[ 1043.953241] Call Trace:
[ 1043.964172]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1043.964172]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1043.969814]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1043.969814]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1043.975484]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1043.981148]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1043.981148]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1043.986716]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1043.992189] console-kit-d D 000000ed     0  2957      1
[ 1043.997697]        c2d11e94 00000046 d3c37e65 000000ed c2d10000 c02da620=
=20
00000000 002075f6=20
[ 1043.998025]        00000000 d3e3f45b 000000ed 00000000 c2d11fb8 00000016=
=20
c2d11ea0 c014543b=20
[ 1044.003690]        0000000b c2d11ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d11efc c2d11fb8=20
[ 1044.009404] Call Trace:
[ 1044.020343]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.020343]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.025994]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.025994]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.031670]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.031670]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.037332]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.037332]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.042917]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.048410] console-kit-d D 000000ed     0  2958      1
[ 1044.053932]        c2d81e94 00000046 d3b4e351 000000ed c2d80000 c02da620=
=20
00000001 002ff596=20
[ 1044.054260]        00000000 d3e4d8e7 000000ed 00000000 c2d81fb8 00000017=
=20
c2d81ea0 c014543b=20
[ 1044.059949]        0000000b c2d81ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d81efc c2d81fb8=20
[ 1044.065681] Call Trace:
[ 1044.076628]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.076628]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.082279]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.082279]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.087949]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.087949]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.093611]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.093611]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.099187]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.104662] console-kit-d D 000000ed     0  2959      1
[ 1044.110173]        c2d1be94 00000046 d3b502cf 000000ed c2d1a000 c02da620=
=20
00000001 00302f5a=20
[ 1044.110541]        00000000 d3e53229 000000ed 00000000 c2d1bfb8 00000018=
=20
c2d1bea0 c014543b=20
[ 1044.116218]        0000000b c2d1bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d1befc c2d1bfb8=20
[ 1044.121939] Call Trace:
[ 1044.132865]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.132865]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.138500]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.138500]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.144167]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.144167]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.149820]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.149820]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.155388]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.160861] console-kit-d D 000000ed     0  2960      1
[ 1044.166372]        c2d41e94 00000046 d3b52315 000000ed c2d40000 c02da620=
=20
00000001 00305883=20
[ 1044.166699]        00000000 d3e57b98 000000ed 00000000 c2d41fb8 00000019=
=20
c2d41ea0 c014543b=20
[ 1044.172379]        0000000b c2d41ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2d41efc c2d41fb8=20
[ 1044.178099] Call Trace:
[ 1044.189009]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.189009]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.194640]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.194640]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.200298]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.200298]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.205949]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.205949]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.211523]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.217006] console-kit-d D 000000ed     0  2961      1
[ 1044.222512]        c2bc9e94 00000046 d3c3a105 000000ed c2bc8000 c02da620=
=20
00000000 002226ea=20
[ 1044.222841]        00000000 d3e5c7ef 000000ed 00000000 c2bc9fb8 0000001a=
=20
c2bc9ea0 c014543b=20
[ 1044.228537]        0000000b c2bc9ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bc9efc c2bc9fb8=20
[ 1044.234256] Call Trace:
[ 1044.245184]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.245184]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.250830]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.250830]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.256497]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.256497]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.262158]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.262158]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.267727]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.273207] console-kit-d D 000000ed     0  2962      1
[ 1044.278705]        c2cdde94 00000046 d3b5617a 000000ed c2cdc000 c02da620=
=20
00000001 00315731=20
[ 1044.279031]        00000000 d3e6b8ab 000000ed 00000000 c2cddfb8 0000001b=
=20
c2cddea0 c014543b=20
[ 1044.284691]        0000000b c2cdded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2cddefc c2cddfb8=20
[ 1044.290395] Call Trace:
[ 1044.301304]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.301304]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.306942]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.306942]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.312604]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.312604]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.318251]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.318251]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.323822]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.329289] console-kit-d D 000000ed     0  2963      1
[ 1044.334787]        c2c0be94 00000046 d3b58120 000000ed c2c0a000 c02da620=
=20
00000001 00318cf4=20
[ 1044.335115]        00000000 d3e70e14 000000ed 00000000 c2c0bfb8 0000001c=
=20
c2c0bea0 c014543b=20
[ 1044.340781]        0000000b c2c0bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c0befc c2c0bfb8=20
[ 1044.346491] Call Trace:
[ 1044.357398]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.357398]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.363032]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.363032]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.368694]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.368694]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.374335]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.374335]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.379897]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.385365] console-kit-d D 000000ed     0  2964      1
[ 1044.390864]        c2b39e94 00000046 d3b5a238 000000ed c2b38000 c02da620=
=20
00000001 0031b757=20
[ 1044.391193]        00000000 d3e7598f 000000ed 00000000 c2b39fb8 0000001d=
=20
c2b39ea0 c014543b=20
[ 1044.396858]        0000000b c2b39ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b39efc c2b39fb8=20
[ 1044.402571] Call Trace:
[ 1044.413488]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.413488]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.419132]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.419132]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.424797]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.424797]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.430455]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.430455]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.436026]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.441505] console-kit-d D 000000ed     0  2965      1
[ 1044.447017]        c2b69e94 00000046 d3c3c590 000000ed c2b68000 c02da620=
=20
00000000 0023de30=20
[ 1044.447387]        00000000 d3e7a3c0 000000ed 00000000 c2b69fb8 0000001e=
=20
c2b69ea0 c014543b=20
[ 1044.453071]        0000000b c2b69ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b69efc c2b69fb8=20
[ 1044.458794] Call Trace:
[ 1044.469725]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.469725]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.475371]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.475371]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.481053]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.481053]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.486713]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.486713]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.492281]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.497762] console-kit-d D 000000ed     0  2966      1
[ 1044.503276]        c2ba1e94 00000046 d3b5e2ec 000000ed c2ba0000 c02da620=
=20
00000001 0032695d=20
[ 1044.503604]        00000000 d3e84c49 000000ed 00000000 c2ba1fb8 0000001f=
=20
c2ba1ea0 c014543b=20
[ 1044.509277]        0000000b c2ba1ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2ba1efc c2ba1fb8=20
[ 1044.515006] Call Trace:
[ 1044.525946]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.525946]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.531587]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.531587]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.537260]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.537260]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.542922]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.542922]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.548499]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.553974] console-kit-d D 000000ed     0  2967      1
[ 1044.559488]        c2aa7e94 00000046 d3c3eab2 000000ed c2aa6000 c02da620=
=20
00000000 0024ae81=20
[ 1044.559816]        00000000 d3e89933 000000ed 00000000 c2aa7fb8 00000020=
=20
c2aa7ea0 c014543b=20
[ 1044.565495]        0000000b c2aa7ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2aa7efc c2aa7fb8=20
[ 1044.571211] Call Trace:
[ 1044.582117]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.582117]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.587745]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.587745]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.593404]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.593404]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.599053]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.599053]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.604617]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.610083] console-kit-d D 000000ed     0  2968      1
[ 1044.615584]        c2bdbe94 00000046 d3b621ab 000000ed c2bda000 c02da620=
=20
00000001 003353cf=20
[ 1044.615913]        00000000 d3e9757a 000000ed 00000000 c2bdbfb8 00000021=
=20
c2bdbea0 c014543b=20
[ 1044.621579]        0000000b c2bdbed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bdbefc c2bdbfb8=20
[ 1044.627302] Call Trace:
[ 1044.638227]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.638227]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.643867]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.643867]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.649529]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.649529]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.655188]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.655188]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.660748]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.666214] console-kit-d D 000000ed     0  2969      1
[ 1044.671713]        c2e77e94 00000046 d3b64134 000000ed c2e76000 c02da620=
=20
00000001 00338605=20
[ 1044.672042]        00000000 d3e9c739 000000ed 00000000 c2e77fb8 00000022=
=20
c2e77ea0 c014543b=20
[ 1044.677698]        0000000b c2e77ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e77efc c2e77fb8=20
[ 1044.683406] Call Trace:
[ 1044.694343]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.694343]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.699982]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.699982]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.705647]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.705647]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.711303]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.711303]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.716868]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.722351] console-kit-d D 000000ed     0  2970      1
[ 1044.727869]        c2e97e94 00000046 d3c40c4d 000000ed c2e96000 c02da620=
=20
00000000 00260bcd=20
[ 1044.728198]        00000000 d3ea181a 000000ed 00000000 c2e97fb8 00000023=
=20
c2e97ea0 c014543b=20
[ 1044.733917]        0000000b c2e97ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e97efc c2e97fb8=20
[ 1044.739636] Call Trace:
[ 1044.750585]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.750585]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.756240]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.756240]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.761925]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.761925]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.767599]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.767599]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.773179]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.778658] console-kit-d D 000000ed     0  2971      1
[ 1044.784174]        c2bafe94 00000046 d3b68397 000000ed c2bae000 c02da620=
=20
00000001 00344e3e=20
[ 1044.784501]        00000000 d3ead1d5 000000ed 00000000 c2baffb8 00000024=
=20
c2bafea0 c014543b=20
[ 1044.790176]        0000000b c2bafed4 c0126c1c c2a9c038 00000000 00000000=
=20
c2bafecc c2baffb8=20
[ 1044.795921] Call Trace:
[ 1044.806873]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.806873]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.812574]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.812574]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.818259]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.818259]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.823938]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.823938]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.829530]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.835030] console-kit-d D 000000ed     0  2972      1
[ 1044.840564]        c2c7fe94 00000046 d3b6a51e 000000ed c2c7e000 c02da620=
=20
00000001 00347968=20
[ 1044.840894]        00000000 d3eb1e86 000000ed 00000000 c2c7ffb8 00000025=
=20
c2c7fea0 c014543b=20
[ 1044.846591]        0000000b c2c7fed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c7fefc c2c7ffb8=20
[ 1044.852321] Call Trace:
[ 1044.863280]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.863280]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.868935]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.868935]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.874615]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.874615]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.880287]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.880287]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.885859]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.891339] console-kit-d D 000000ed     0  2973      1
[ 1044.896853]        c2b9be94 00000046 d3c430c3 000000ed c2b9a000 c02da620=
=20
00000000 00274941=20
[ 1044.897224]        00000000 d3eb7a04 000000ed 00000000 c2b9bfb8 00000026=
=20
c2b9bea0 c014543b=20
[ 1044.902893]        0000000b c2b9bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b9befc c2b9bfb8=20
[ 1044.908625] Call Trace:
[ 1044.919565]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.919565]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.925210]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.925210]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.930893]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.930893]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.936560]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.936560]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.942143]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1044.947623] console-kit-d D 000000ed     0  2974      1
[ 1044.953129]        c2b63e94 00000046 d3b6ea99 000000ed c2b62000 c02da620=
=20
00000001 0035956c=20
[ 1044.953457]        00000000 d3ec8005 000000ed 00000000 c2b63fb8 00000027=
=20
c2b63ea0 c014543b=20
[ 1044.959128]        0000000b c2b63ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b63efc c2b63fb8=20
[ 1044.964841] Call Trace:
[ 1044.975764]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1044.975764]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1044.981409]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1044.981409]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1044.987070]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1044.987070]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1044.992722]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1044.992722]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1044.998292]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.003751] console-kit-d D 000000ed     0  2977      1
[ 1045.009251]        c2cd5e94 00000046 d3b70b4e 000000ed c2cd4000 c02da620=
=20
00000001 0035d079=20
[ 1045.009578]        00000000 d3ecdbc7 000000ed 00000000 c2cd5fb8 00000028=
=20
c2cd5ea0 c014543b=20
[ 1045.015235]        0000000b c2cd5ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2cd5efc c2cd5fb8=20
[ 1045.020936] Call Trace:
[ 1045.031833]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.031833]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.037466]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.037466]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.043125]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.043125]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.048774]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.048774]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.054340]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.059809] console-kit-d D 000000ed     0  2979      1
[ 1045.065312]        c2c4fe94 00000046 d3b72d93 000000ed c2c4e000 c02da620=
=20
00000001 0035fb35=20
[ 1045.065638]        00000000 d3ed28c8 000000ed 00000000 c2c4ffb8 00000029=
=20
c2c4fea0 c014543b=20
[ 1045.071298]        0000000b c2c4fed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c4fefc c2c4ffb8=20
[ 1045.077041] Call Trace:
[ 1045.087927]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.087927]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.093547]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.093547]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.099190]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.099190]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.104822]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.104822]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.110380]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.115844] console-kit-d D 000000ed     0  2980      1
[ 1045.121342]        c2bf3e94 00000046 d3b74f06 000000ed c2bf2000 c02da620=
=20
00000001 003628a4=20
[ 1045.121671]        00000000 d3ed77aa 000000ed 00000000 c2bf3fb8 0000002a=
=20
c2bf3ea0 c014543b=20
[ 1045.127731]        0000000b c2bf3ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bf3efc c2bf3fb8=20
[ 1045.133447] Call Trace:
[ 1045.144352]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.144352]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.149984]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.149984]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.155649]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.155649]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.161304]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.161304]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.166870]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.172338] console-kit-d D 000000ed     0  2981      1
[ 1045.177834]        c2cbbe94 00000046 d3c45219 000000ed c2cba000 c02da620=
=20
00000000 00297060=20
[ 1045.178163]        00000000 d3edc279 000000ed 00000000 c2cbbfb8 0000002b=
=20
c2cbbea0 c014543b=20
[ 1045.183824]        0000000b c2cbbed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2cbbefc c2cbbfb8=20
[ 1045.189540] Call Trace:
[ 1045.200465]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.200465]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.206110]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.206110]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.211784]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.211784]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.217449]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.217449]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.223027]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.228523] console-kit-d D 000000ed     0  2982      1
[ 1045.234046]        c2c05e94 00000046 d3b79083 000000ed c2c04000 c02da620=
=20
00000001 00376570=20
[ 1045.234374]        00000000 d3eef5f3 000000ed 00000000 c2c05fb8 0000002c=
=20
c2c05ea0 c014543b=20
[ 1045.240055]        0000000b c2c05ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c05efc c2c05fb8=20
[ 1045.245782] Call Trace:
[ 1045.256731]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.256731]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.262425]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.262425]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.268116]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.268116]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.273779]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.273779]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.279358]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.284857] console-kit-d D 000000ed     0  2983      1
[ 1045.290378]        c2b7fe94 00000046 d3b7b110 000000ed c2b7e000 c02da620=
=20
00000001 003791a5=20
[ 1045.290706]        00000000 d3ef42b5 000000ed 00000000 c2b7ffb8 0000002d=
=20
c2b7fea0 c014543b=20
[ 1045.296386]        0000000b c2b7fed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2b7fefc c2b7ffb8=20
[ 1045.302112] Call Trace:
[ 1045.313053]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.313053]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.318705]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.318705]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.324384]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.324384]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.330048]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.330048]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.335671]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.341155] console-kit-d D 000000ed     0  2984      1
[ 1045.346682]        c2bf9e94 00000046 d3b7d0d3 000000ed c2bf8000 c02da620=
=20
00000001 0037c1ab=20
[ 1045.347053]        00000000 d3ef927e 000000ed 00000000 c2bf9fb8 0000002e=
=20
c2bf9ea0 c014543b=20
[ 1045.352737]        0000000b c2bf9ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bf9efc c2bf9fb8=20
[ 1045.358464] Call Trace:
[ 1045.369415]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.369415]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.375066]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.375066]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.380741]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.380741]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.386404]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.386404]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.393324]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.400933] console-kit-d D 000000ed     0  2985      1
[ 1045.406456]        c2ec5e94 00000046 d3b7f119 000000ed c2ec4000 c02da620=
=20
00000001 0037ee97=20
[ 1045.406825]        00000000 d3efdfb0 000000ed 00000000 c2ec5fb8 0000002f=
=20
c2ec5ea0 c014543b=20
[ 1045.412515]        0000000b c2ec5ed4 c0126c1c c2ee0038 00000000 00000000=
=20
c2ec5ecc c2ec5fb8=20
[ 1045.418247] Call Trace:
[ 1045.429186]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.429186]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.434836]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.434836]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.440504]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.440504]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.446166]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.446166]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.451740]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.457216] console-kit-d D 000000ed     0  2986      1
[ 1045.462726]        c2bc5e94 00000046 d3c0ac08 000000ed c2bc4000 c02da620=
=20
00000000 002f864d=20
[ 1045.463054]        00000000 d3f03255 000000ed 00000000 c2bc5fb8 00000030=
=20
c2bc5ea0 c014543b=20
[ 1045.468717]        0000000b c2bc5ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bc5efc c2bc5fb8=20
[ 1045.474418] Call Trace:
[ 1045.485317]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.485317]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.490944]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.490944]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.496596]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.496596]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.502234]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.502234]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.507797]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.513267] console-kit-d D 000000ed     0  2987      1
[ 1045.518766]        c2c8be94 00000046 d3b834aa 000000ed c2c8a000 c02da620=
=20
00000001 0038b98c=20
[ 1045.519094]        00000000 d3f0ee36 000000ed 00000000 c2c8bfb8 00000031=
=20
c2c8bea0 c014543b=20
[ 1045.524755]        0000000b c2c8bed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c8befc c2c8bfb8=20
[ 1045.530458] Call Trace:
[ 1045.541347]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.541347]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.546972]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.546972]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.552620]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.552620]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.558257]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.558257]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.563811]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.569276] console-kit-d D 000000ed     0  2988      1
[ 1045.574783]        c2cdbe94 00000046 d3bf2b4a 000000ed c2cda000 c02da620=
=20
00000000 00321879=20
[ 1045.575110]        00000000 d3f143c3 000000ed 00000000 c2cdbfb8 00000032=
=20
c2cdbea0 c014543b=20
[ 1045.580766]        0000000b c2cdbed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2cdbefc c2cdbfb8=20
[ 1045.586474] Call Trace:
[ 1045.597366]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.597366]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.602998]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.602998]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.608652]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.608652]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.614305]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.614305]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.619865]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.625327] console-kit-d D 000000ed     0  2989      1
[ 1045.630832]        c2c23e94 00000046 d3b87677 000000ed c2c22000 c02da620=
=20
00000001 0039a383=20
[ 1045.631159]        00000000 d3f219fa 000000ed 00000000 c2c23fb8 00000033=
=20
c2c23ea0 c014543b=20
[ 1045.636862]        0000000b c2c23ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c23efc c2c23fb8=20
[ 1045.642569] Call Trace:
[ 1045.653482]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.653482]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.659114]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.659114]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.664776]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.664776]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.670425]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.670425]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.675989]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.681462] console-kit-d D 000000ed     0  2990      1
[ 1045.686964]        c2c99e94 00000046 d3b897e0 000000ed c2c98000 c02da620=
=20
00000001 0039d548=20
[ 1045.687292]        00000000 d3f26d28 000000ed 00000000 c2c99fb8 00000034=
=20
c2c99ea0 c014543b=20
[ 1045.692960]        0000000b c2c99ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c99efc c2c99fb8=20
[ 1045.698679] Call Trace:
[ 1045.709624]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.709624]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.715281]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.715281]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.720965]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.720965]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.726634]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.726634]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.732276]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.737778] console-kit-d D 000000ed     0  2991      1
[ 1045.743316]        c2e65e94 00000046 d3c0f07f 000000ed c2e64000 c02da620=
=20
00000000 0031ca7d=20
[ 1045.743689]        00000000 d3f2bafc 000000ed 00000000 c2e65fb8 00000035=
=20
c2e65ea0 c014543b=20
[ 1045.749383]        0000000b c2e65ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e65efc c2e65fb8=20
[ 1045.755122] Call Trace:
[ 1045.766093]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.766093]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.771756]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.771756]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.777437]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.777437]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.783117]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.783117]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.788705]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.794197] console-kit-d D 000000ed     0  2992      1
[ 1045.799726]        c2e37e94 00000046 d3b8d9ad 000000ed c2e36000 c02da620=
=20
00000001 003ae546=20
[ 1045.800099]        00000000 d3f3bef3 000000ed 00000000 c2e37fb8 00000036=
=20
c2e37ea0 c014543b=20
[ 1045.805790]        0000000b c2e37ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2e37efc c2e37fb8=20
[ 1045.811535] Call Trace:
[ 1045.822522]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.822522]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.828195]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.828195]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.833891]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.833891]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.839581]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.839581]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.845181]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.850680] console-kit-d D 000000ed     0  2993      1
[ 1045.856214]        c2c57e94 00000046 d3b8fab2 000000ed c2c56000 c02da620=
=20
00000001 003b10b2=20
[ 1045.856545]        00000000 d3f40b64 000000ed 00000000 c2c57fb8 00000037=
=20
c2c57ea0 c014543b=20
[ 1045.862241]        0000000b c2c57ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c57efc c2c57fb8=20
[ 1045.867983] Call Trace:
[ 1045.878941]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.878941]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.884610]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.884610]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.890302]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.890302]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.895979]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.895979]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.901575]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.907080] console-kit-d D 000000ed     0  2994      1
[ 1045.912618]        c2dfde94 00000046 d3b91a75 000000ed c2dfc000 c02da620=
=20
00000001 003b4c51=20
[ 1045.912946]        00000000 d3f466c6 000000ed 00000000 c2dfdfb8 00000038=
=20
c2dfdea0 c014543b=20
[ 1045.918650]        0000000b c2dfded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2dfdefc c2dfdfb8=20
[ 1045.924387] Call Trace:
[ 1045.935348]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.935348]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.941015]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.941015]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1045.946701]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1045.946701]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1045.952376]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1045.952376]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1045.957960]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1045.963451] console-kit-d D 000000ed     0  2995      1
[ 1045.968977]        c2bd3e94 00000046 d3b93b98 000000ed c2bd2000 c02da620=
=20
00000001 003b764d=20
[ 1045.969306]        00000000 d3f4b1e5 000000ed 00000000 c2bd3fb8 00000039=
=20
c2bd3ea0 c014543b=20
[ 1045.974993]        0000000b c2bd3ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2bd3efc c2bd3fb8=20
[ 1045.980734] Call Trace:
[ 1045.991672]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1045.991672]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1045.997328]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1045.997328]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.003006]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.003006]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.008679]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.008679]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.014267]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.019756] console-kit-d D 000000ed     0  2996      1
[ 1046.025278]        c2ec9e94 00000046 d3c1153c 000000ed c2ec8000 c02da620=
=20
00000000 0033f40a=20
[ 1046.025605]        00000000 d3f50946 000000ed 00000000 c2ec9fb8 0000003a=
=20
c2ec9ea0 c014543b=20
[ 1046.031289]        0000000b c2ec9ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2ec9efc c2ec9fb8=20
[ 1046.037017] Call Trace:
[ 1046.047959]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.047959]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.053616]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
46.053616]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.059296]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.059296]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.064962]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.064962]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.070549]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.076027] console-kit-d D 000000ed     0  2997      1
[ 1046.081540]        c2c0de94 00000046 d3b97b84 000000ed c2c0c000 c02da620=
=20
00000001 003cca7a=20
[ 1046.081866]        00000000 d3f645fe 000000ed 00000000 c2c0dfb8 0000003b=
=20
c2c0dea0 c014543b=20
[ 1046.087532]        0000000b c2c0ded4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c0defc c2c0dfb8=20
[ 1046.093287] Call Trace:
[ 1046.104197]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.104197]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.109836]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.109836]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.115549]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.115549]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.121210]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.121210]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.126776]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.132252] console-kit-d D 000000ed     0  2998      1
[ 1046.137770]        c2c0fe94 00000046 d3b99e56 000000ed c2c0e000 c02da620=
=20
00000001 003cfdef=20
[ 1046.138098]        00000000 d3f69c45 000000ed 00000000 c2c0ffb8 0000003c=
=20
c2c0fea0 c014543b=20
[ 1046.143769]        0000000b c2c0fed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2c0fefc c2c0ffb8=20
[ 1046.149489] Call Trace:
[ 1046.160426]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.160426]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.166072]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.166072]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.171735]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.171735]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.177381]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.177381]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.182950]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.188430] console-kit-d D 000000ed     0  2999      1
[ 1046.193937]        c2cabe94 00000046 d3b9bf6e 000000ed c2caa000 c02da620=
=20
00000001 003d2add=20
[ 1046.194264]        00000000 d3f6ea4b 000000ed 00000000 c2cabfb8 0000003d=
=20
c2cabea0 c014543b=20
[ 1046.199975]        0000000b c2cabed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2cabefc c2cabfb8=20
[ 1046.205693] Call Trace:
[ 1046.216629]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.216629]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.222280]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.222280]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.227966]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.227966]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.233642]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.233642]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.239220]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.244704] console-kit-d D 000000ed     0  3000      1
[ 1046.250223]        c2ce9e94 00000046 d3b9e1fa 000000ed c2ce8000 c02da620=
=20
00000001 003d5c22=20
[ 1046.250552]        00000000 d3f73e1c 000000ed 00000000 c2ce9fb8 0000003e=
=20
c2ce9ea0 c014543b=20
[ 1046.256224]        0000000b c2ce9ed4 c0126c1c c0479b28 c03973bc 00000000=
=20
c2ce9efc c2ce9fb8=20
[ 1046.261950] Call Trace:
[ 1046.272886]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.272886]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.278528]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.278528]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.284196]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.284196]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.289853]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.289853]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.295421]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.300901] console-kit-d D 000000ed     0  3732      1
[ 1046.306415]        c2a79e94 00000046 d3c0879b 000000ed c2a78000 c02da620=
=20
00000000 00370781=20
[ 1046.306787]        00000000 d3f78f1c 000000ed 00000000 c2a79fb8 00000001=
=20
c2a79ea0 c014543b=20
[ 1046.312464]        0000000b c2a79ed4 c0126c1c c1bc6034 00000000 00000000=
=20
c1bc6000 c2a79fb8=20
[ 1046.318179] Call Trace:
[ 1046.329118]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.329118]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.334776]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.334776]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.340452]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.340452]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.346117]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.346117]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.351700]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.357190] krfcommd      S 00000000     0  3002      2
[ 1046.362707]        c2e6bee8 00000046 00000000 00000000 c2e6a000 c02da620=
=20
000080d0 00000000=20
[ 1046.363036]        00000000 777b5379 000000ce c2b90c00 00000000 dfe59fd0=
=20
c2e6bfcc dfe5a0d7=20
[ 1046.368716]        61765f70 76655f72 00000002 00000000 c03eb010 c22de000=
=20
c22de658 00000000=20
[ 1046.374446] Call Trace:
[ 1046.385395]  [<dfe5a0d7>] rfcomm_run+0x107/0x1450 [rfcomm]
[ 1046.391140]  [kthread+66/112] kthread+0x42/0x70
[ 1046.391140]  [<c012e372>] kthread+0x42/0x70
[ 1046.396814]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1046.402500]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.408062] smartd        D 000000ed     0  3031      1
[ 1046.413648]        c2b99e94 00000046 d3ba3082 000000ed c2b98000 c02da620=
=20
00000000 003ea142=20
[ 1046.413976]        00000000 d3f8d1c4 000000ed 00000000 c2b99fb8 00000000=
=20
c2b99ea0 c014543b=20
[ 1046.419762]        bfe53d24 c2b99ed4 c0126c1c 00000000 c2c20000 c02d1847=
=20
00000001 c2b99fb8=20
[ 1046.425513] Call Trace:
[ 1046.436510]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.436510]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.442172]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.442172]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.447867]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.447867]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.453557]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.453557]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.459227]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.464775] hald-addon-in D 000000ed     0  3189   2899
[ 1046.470342]        c2c45e94 00000046 d3ba9bfc 000000ed c2c44000 c02da620=
=20
00000000 003ed63a=20
[ 1046.470669]        00000000 d3f97236 000000ed 00000000 c2c45fb8 b7e59ff4=
=20
c2c45ea0 c014543b=20
[ 1046.476495]        08052290 c2c45ed4 c0126c1c 00000003 00000001 00000007=
=20
00000001 c2c45fb8=20
[ 1046.482226] Call Trace:
[ 1046.493198]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.493198]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.498848]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.498848]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.504534]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.504534]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.510214]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.510214]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.515866]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.521414] hald-addon-ac D 000000ed     0  3202   2899
[ 1046.526980]        c2e5be94 00000046 d3bae29a 000000ed c2e5a000 c02da620=
=20
00000000 000b82c0=20
[ 1046.527307]        00000000 d3c6655a 000000ed 00000000 c2e5bfb8 00000000=
=20
c2e5bea0 c014543b=20
[ 1046.533077]        bf9972a4 c2e5bed4 c0126c1c 00000000 c2a70000 c02d1847=
=20
00000001 c2e5bfb8=20
[ 1046.538807] Call Trace:
[ 1046.549762]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.549762]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.555399]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.555399]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.561083]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.561083]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.566748]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.566748]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.572399]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.577930] hald-addon-ac D 00000000     0  3204   2899
[ 1046.583491]        c2eb7e94 00000046 00000000 00000000 c2eb6000 c196d524=
=20
00000000 00000000=20
[ 1046.583818]        00000000 d40dd11f 000000ed 00000000 c2eb7fb8 b7e4eff4=
=20
c2eb7ea0 c014543b=20
[ 1046.589575]        00000000 c2eb7ed4 c0126c1c c013b14b 00000000 c2c16000=
=20
c0174095 c2eb7fb8=20
[ 1046.595272] Call Trace:
[ 1046.606196]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.606196]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.611826]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.611826]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.617492]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.617492]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.623152]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.623152]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.628782]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.634300] hald-addon-st D 000000ed     0  3216   2899
[ 1046.639836]        c2e2be94 00000046 d3babfaa 000000ed c2e2a000 c02da620=
=20
00000000 003f194e=20
[ 1046.640164]        00000000 d3f9d8f8 000000ed 00000000 c2e2bfb8 b7d91ff4=
=20
c2e2bea0 c014543b=20
[ 1046.645899]        080519f8 c2e2bed4 c0126c1c c2a44d60 c2a453b8 00000000=
=20
00000001 c2e2bfb8=20
[ 1046.651607] Call Trace:
[ 1046.662518]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.662518]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.668148]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.668148]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.673788]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.673788]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.679407]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.679407]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.684940]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.690397] xinetd        D 000000ed     0  3636      1
[ 1046.695878]        c2aa5e94 00000046 d3c067ce 000000ed c2aa4000 c02da620=
=20
00000000 003a052c=20
[ 1046.696206]        00000000 d3fa6cfa 000000ed 00000000 c2aa5fb8 00000000=
=20
c2aa5ea0 c014543b=20
[ 1046.701845]        00000009 c2aa5ed4 c0126c1c 00000002 00000000 00000000=
=20
c2c9b070 c2aa5fb8=20
[ 1046.707540] Call Trace:
[ 1046.718396]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.718396]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.724001]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.724001]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.729650]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.729650]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.735322]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.735322]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.740867]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.746318] avahi-daemon  D 000000ed     0  3641      1
[ 1046.751841]        c2b81e94 00000046 d3bb3c7e 000000ed c2b80000 c02da620=
=20
00000000 000c166e=20
[ 1046.752168]        00000000 d3c752ec 000000ed 00000000 c2b81fb8 b7ee9ff4=
=20
c2b81ea0 c014543b=20
[ 1046.757806]        0806b178 c2b81ed4 c0126c1c 0000000e 00000001 0000000d=
=20
00000001 c2b81fb8=20
[ 1046.763491] Call Trace:
[ 1046.774381]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.774381]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.780006]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.780006]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.785652]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.785652]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.791283]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.791283]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.796835]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.802292] kdm           D 000000ed     0  3649      1
[ 1046.807789]        c2b4be94 00000046 d3bb694d 000000ed c2b4a000 c02da620=
=20
00000000 0040ac97=20
[ 1046.808119]        00000000 d3fc15e4 000000ed 00000000 c2b4bfb8 00000000=
=20
c2b4bea0 c014543b=20
[ 1046.813771]        00000012 c2b4bed4 c0126c1c c2b46d60 c2b473b8 00000000=
=20
00000001 c2b4bfb8=20
[ 1046.819466] Call Trace:
[ 1046.830306]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.830306]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.835903]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.835903]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.841529]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.841529]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.847134]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.847134]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.852655]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.858109] rpcbind       D 000000ed     0  3656      1
[ 1046.863585]        c2a8fe94 00000046 d3bebb64 000000ed c2a8e000 c02da620=
=20
00000000 00093e62=20
[ 1046.863913]        00000000 d3c7f9c6 000000ed 00000000 c2a8ffb8 b7f13ff4=
=20
c2a8fea0 c014543b=20
[ 1046.869550]        bf950c68 c2a8fed4 c0126c1c 00000008 000000c3 00000009=
=20
000000c3 c2a8ffb8=20
[ 1046.875220] Call Trace:
[ 1046.886084]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.886084]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1046.891692]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1046.891692]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1046.897327]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1046.897327]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1046.902953]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1046.902953]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1046.908544]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.913991] automount     S 00000000     0  3687      1
[ 1046.919459]        c2b83ebc 00000046 00000000 00000000 c2b82000 c0104253=
=20
00000000 00000000=20
[ 1046.919831]        00000000 7b89fbe2 000000f2 7fffffff c2b83f9c 00000000=
=20
c2b83f04 c02cf895=20
[ 1046.925462]        c0138a5c c2ef0000 c2f30fd4 00000000 c2ef0000 c02d1672=
=20
00000000 c2b83f00=20
[ 1046.931146] Call Trace:
[ 1046.942046]  [schedule_timeout+117/192] schedule_timeout+0x75/0xc0
[ 1046.942046]  [<c02cf895>] schedule_timeout+0x75/0xc0
[ 1046.947714]  [schedule_timeout_interruptible+20/32]=20
schedule_timeout_interruptible+0x14/0x20
[ 1046.947714]  [<c02cf914>] schedule_timeout_interruptible+0x14/0x20
[ 1046.953376]  [sys_rt_sigtimedwait+282/592] sys_rt_sigtimedwait+0x11a/0x2=
50
[ 1046.953376]  [<c012742a>] sys_rt_sigtimedwait+0x11a/0x250
[ 1046.959034]  [sysenter_past_esp+95/165] sysenter_past_esp+0x5f/0xa5
[ 1046.959034]  [<c010416a>] sysenter_past_esp+0x5f/0xa5
[ 1046.964603]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1046.970081] automount     D 000000ed     0  3688      1
[ 1046.975600]        c2ef7e94 00000046 d3c1594f 000000ed c2ef6000 c02da620=
=20
00000000 003b8e87=20
[ 1046.975927]        00000000 d3fce7d6 000000ed 00000000 c2ef7fb8 00000001=
=20
c2ef7ea0 c014543b=20
[ 1046.981618]        80036824 c2ef7ed4 c0126c1c c2b3cd60 c0114720 c2ef7e34=
=20
c2ef7e34 c2ef7fb8=20
[ 1046.987343] Call Trace:
[ 1046.998303]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1046.998303]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.003962]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.003962]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.009648]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.009648]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.015323]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.015323]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.020921]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.026430] automount     D 000000ed     0  3689      1
[ 1047.031950]        c2b49e94 00000046 d3bbcda6 000000ed c2b48000 c02da620=
=20
00000000 00425038=20
[ 1047.032278]        00000000 d3fe1dde 000000ed 00000000 c2b49fb8 000002e7=
=20
c2b49ea0 c014543b=20
[ 1047.037962]        80036784 c2b49ed4 c0126c1c c191e000 c0114720 c2b49e34=
=20
c2b49e34 c2b49fb8=20
[ 1047.043698] Call Trace:
[ 1047.054683]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.054683]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.060354]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.060354]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.066054]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.066054]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.071736]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.071736]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.077338]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.082852] nsrexecd      D 000000ed     0  3691      1
[ 1047.088465]        c2cf7e94 00000046 d3bbf09f 000000ed c2cf6000 c02da620=
=20
00000001 0042a16a=20
[ 1047.088795]        00000000 d3fe9209 000000ed 00000000 c2cf7fb8 b7bfeff4=
=20
c2cf7ea0 c014543b=20
[ 1047.094528]        bf866e00 c2cf7ed4 c0126c1c 00000000 c2cca000 c2cf7ed0=
=20
c01146a4 c2cf7fb8=20
[ 1047.100308] Call Trace:
[ 1047.111345]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.111345]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.117047]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.117047]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.122774]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.122774]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.128493]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.128493]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.134132]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.139678] nsrexecd      D 000000ed     0  3722      1
[ 1047.145242]        c2f01e94 00000046 d3bc1231 000000ed c2f00000 c02da620=
=20
00000001 0042fa9a=20
[ 1047.145572]        00000000 d3ff0ccb 000000ed 00000000 c2f01fb8 b7bfeff4=
=20
c2f01ea0 c014543b=20
[ 1047.151304]        b7a10e10 c2f01ed4 c0126c1c c20d8d60 c20d93b8 00000000=
=20
00000001 c2f01fb8=20
[ 1047.157080] Call Trace:
[ 1047.168157]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.168157]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.173869]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.173869]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.179610]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.179610]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.185341]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.185341]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.190978]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.196523] nsrexecd      D 000000ed     0  3723      1
[ 1047.202077]        c2ef3e94 00000046 d3bc33e9 000000ed c2ef2000 c02da620=
=20
00000001 0043351d=20
[ 1047.202405]        00000000 d3ff6906 000000ed 00000000 c2ef3fb8 b7bfeff4=
=20
c2ef3ea0 c014543b=20
[ 1047.208127]        b720fca0 c2ef3ed4 c0126c1c c013bdca c2ef3f3c c013bdca=
=20
00000005 c2ef3fb8=20
[ 1047.213886] Call Trace:
[ 1047.224956]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.224956]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.230665]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.230665]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.236386]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.236386]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.242096]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.242096]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.247716]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.253246] nsrexecd      D 000000ed     0  3724      1
[ 1047.258787]        c2a75e94 00000046 d3bffe16 000000ed c2a74000 c02da620=
=20
00000000 003fe4f2=20
[ 1047.259114]        00000000 d3ffe308 000000ed 00000000 c2a75fb8 b7bfeff4=
=20
c2a75ea0 c014543b=20
[ 1047.264820]        b6a0ee00 c2a75ed4 c0126c1c c2a75ebc c0138a5c c2a8c000=
=20
c2dab2e0 c2a75fb8=20
[ 1047.270577] Call Trace:
[ 1047.281605]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.281605]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.287299]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.287299]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.293017]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.293017]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.298722]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.298722]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.304355]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.309888] sshd          D 000000ed     0  3699      1
[ 1047.315444]        c2eb9e94 00200046 d3bc7ee1 000000ed c2eb8000 c02da620=
=20
00000000 00446b90=20
[ 1047.315772]        00000000 d400ea71 000000ed 00000000 c2eb9fb8 00000000=
=20
c2eb9ea0 c014543b=20
[ 1047.321482]        00000004 c2eb9ed4 c0126c1c 00000002 00000000 c2c9bc60=
=20
c2c9bc50 c2eb9fb8=20
[ 1047.327233] Call Trace:
[ 1047.338219]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.338219]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.343889]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.343889]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.349581]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.349581]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.355269]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.355269]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.360873]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.366383] X             D 000000ed     0  3705   3649
[ 1047.371923]        c2c2be94 00200046 d3c0434c 000000ed c2c2a000 c02da620=
=20
00000000 0043c7c5=20
[ 1047.372250]        00000000 d4040b11 000000ed 00000000 c2c2bfb8 bfcd7a60=
=20
c2c2bea0 c014543b=20
[ 1047.377938]        00000100 c2c2bed4 c0126c1c 00000000 00000000 00000000=
=20
00000000 c2c2bfb8=20
[ 1047.383672] Call Trace:
[ 1047.394611]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.394611]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.400263]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.400263]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.405942]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.405942]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.411619]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.411619]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.417202]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.422703] kauditd       S 00000000     0  3715      2
[ 1047.428260]        c2ccdfa0 00000046 00000000 00000000 c2ccc000 c02da620=
=20
00000000 00000000=20
[ 1047.428587]        00000000 3451dfda 000000d1 00000000 c2ccdfb0 c014afd0=
=20
c2ccdfcc c014b0f7=20
[ 1047.434264]        00000000 00000000 00000000 c2a70d60 c0114720 c0396420=
=20
c0396420 fffffffc=20
[ 1047.439953] Call Trace:
[ 1047.450821]  [kauditd_thread+295/352] kauditd_thread+0x127/0x160
[ 1047.450821]  [<c014b0f7>] kauditd_thread+0x127/0x160
[ 1047.456461]  [kthread+66/112] kthread+0x42/0x70
[ 1047.456461]  [<c012e372>] kthread+0x42/0x70
[ 1047.462060]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
[ 1047.462060]  [<c01044e3>] kernel_thread_helper+0x7/0x14
[ 1047.467673]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.473162] kdm           D 000000ed     0  3729   3649
[ 1047.478697]        c2aa3e94 00000046 d3bccdeb 000000ed c2aa2000 c02da620=
=20
00000000 004918c6=20
[ 1047.479025]        00000000 d405e6b1 000000ed 00000000 c2aa3fb8 00000f54=
=20
c2aa3ea0 c014543b=20
[ 1047.484722]        00000f54 c2aa3ed4 c0126c1c 00000000 c2e62000 c02d1847=
=20
00000004 c2aa3fb8=20
[ 1047.490390] Call Trace:
[ 1047.501239]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.501239]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.506828]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.506828]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.512455]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.512455]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.518077]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.518077]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.523693]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.529184] cupsd         D 000000ed     0  3735      1
[ 1047.534697]        c2f1be94 00200046 d3bcf08a 000000ed c2f1a000 c02da620=
=20
00000000 00495345=20
[ 1047.535025]        00000000 d40643cf 000000ed 00000000 c2f1bfb8 080a27b0=
=20
c2f1bea0 c014543b=20
[ 1047.540726]        00000000 c2f1bed4 c0126c1c c03eb000 c2f1bed0 c01178ea=
=20
00000000 c2f1bfb8=20
[ 1047.546388] Call Trace:
[ 1047.557220]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.557220]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.562797]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.562797]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.568412]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.568412]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.574014]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.574014]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.579597]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.585063] nsrd          D 000000ed     0  3740      1
[ 1047.590552]        c2e29e94 00000046 d3bd1426 000000ed c2e28000 c02da620=
=20
00000000 0049e803=20
[ 1047.590881]        00000000 d406fc29 000000ed 00000000 c2e29fb8 b7c40ff4=
=20
c2e29ea0 c014543b=20
[ 1047.596582]        bfc7d9f0 c2e29ed4 c0126c1c 00000008 00000040 0000000b=
=20
00000040 c2e29fb8=20
[ 1047.602248] Call Trace:
[ 1047.613113]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.613113]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.618711]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.618711]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.624355]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.624355]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.629984]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.629984]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.635602]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.641113] nsrmmdbd      D 000000ed     0  3795   3740
[ 1047.646650]        c2df5e94 00000046 d3bd35ca 000000ed c2df4000 c02da620=
=20
00000000 004a3dd6=20
[ 1047.646978]        00000000 d40773a0 000000ed 00000000 c2df5fb8 b7c3eff4=
=20
c2df5ea0 c014543b=20
[ 1047.652716]        bfe39b90 c2df5ed4 c0126c1c c2a76000 c2a76658 00000000=
=20
00000001 c2df5fb8=20
[ 1047.658423] Call Trace:
[ 1047.669356]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.669356]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.675024]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.675024]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.680692]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.680692]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.686346]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.686346]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.691988]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.697508] nsrindexd     D 000000ed     0  3801   3740
[ 1047.703075]        c2f2de94 00000046 d3bd5838 000000ed c2f2c000 c02da620=
=20
00000000 004a7cf8=20
[ 1047.703402]        00000000 d407d530 000000ed 00000000 c2f2dfb8 b7bebff4=
=20
c2f2dea0 c014543b=20
[ 1047.709183]        bf890320 c2f2ded4 c0126c1c 00000000 c2b86000 c02d1847=
=20
00000005 c2f2dfb8=20
[ 1047.714930] Call Trace:
[ 1047.725939]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.725939]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.731635]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.731635]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.737333]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.737333]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.743032]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.743032]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.748649]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.754167] nsrjobd       D 000000ed     0  3815   3740
[ 1047.759722]        c2b61e94 00000046 d3bd7a55 000000ed c2b60000 c02da620=
=20
00000001 004ad1bd=20
[ 1047.760049]        00000000 d4084c12 000000ed 00000000 c2b61fb8 b7c28ff4=
=20
c2b61ea0 c014543b=20
[ 1047.765768]        bfebc6a0 c2b61ed4 c0126c1c c2e56d60 c2e573b8 00000000=
=20
00000001 c2b61fb8=20
[ 1047.771525] Call Trace:
[ 1047.782568]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.782568]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.788270]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.788270]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.794009]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.794009]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.799726]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.799726]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.805358]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.810896] nsrjobd       D 000000ed     0  3855   3740
[ 1047.816469]        c2effe94 00000046 d3bd9eb9 000000ed c2efe000 c02da620=
=20
00000001 004b10de=20
[ 1047.816796]        00000000 d408af97 000000ed 00000000 c2efffb8 00000049=
=20
c2effea0 c014543b=20
[ 1047.822535]        081350fc c2effed4 c0126c1c c18acd60 c0114720 c2effe34=
=20
c2effe34 c2efffb8=20
[ 1047.828314] Call Trace:
[ 1047.839393]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.839393]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.845115]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.845115]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.850861]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.850861]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.856596]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.856596]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.862251]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.867809] nsrjobd       D 000000ed     0  3856   3740
[ 1047.873389]        c2c29e94 00000046 d3bdc021 000000ed c2c28000 c02da620=
=20
00000001 004b3c43=20
[ 1047.873716]        00000000 d408fc64 000000ed 00000000 c2c29fb8 00000095=
=20
c2c29ea0 c014543b=20
[ 1047.879487]        080a810c c2c29ed4 c0126c1c c2b86d60 c0114720 c2c29e34=
=20
c2c29e34 c2c29fb8=20
[ 1047.885261] Call Trace:
[ 1047.896317]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.896317]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.902030]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.902030]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.907772]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.907772]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.913505]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.913505]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.919146]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.924695] nsrjobd       D 000000ed     0  3866   3740
[ 1047.930270]        c2f79e94 00000046 d3bde3d0 000000ed c2f78000 c02da620=
=20
00000000 004b8b21=20
[ 1047.930598]        00000000 d4096ef1 000000ed 00000000 c2f79fb8 b7c28ff4=
=20
c2f79ea0 c014543b=20
[ 1047.936332]        b6a37e40 c2f79ed4 c0126c1c c0479b28 c03973bc 00000002=
=20
c2f79efc c2f79fb8=20
[ 1047.942113] Call Trace:
[ 1047.953195]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1047.953195]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1047.958916]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1047.958916]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1047.964665]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1047.964665]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1047.970406]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1047.970406]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1047.976073]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1047.981632] mingetty      D 000000ed     0  3817      1
[ 1047.987217]        c2a8be94 00000046 d3be063d 000000ed c2a8a000 c02da620=
=20
00000000 004be9ae=20
[ 1047.987546]        00000000 d409efeb 000000ed 00000000 c2a8bfb8 bf8cafa8=
=20
c2a8bea0 c014543b=20
[ 1047.993291]        00000000 c2a8bed4 c0126c1c c2a8bef0 00000046 00000001=
=20
000006aa c2a8bfb8=20
[ 1047.999089] Call Trace:
[ 1048.010177]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.010177]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.015913]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.015913]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.021719]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.021719]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.027466]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.027466]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.033131]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.038700] mingetty      D 000000ed     0  3818      1
[ 1048.044284]        c2b5be94 00000046 d3be2b05 000000ed c2b5a000 c02da620=
=20
00000000 004c322d=20
[ 1048.044611]        00000000 d40a5d32 000000ed 00000000 c2b5bfb8 bface988=
=20
c2b5bea0 c014543b=20
[ 1048.050360]        00000000 c2b5bed4 c0126c1c c2b5bef0 00000046 00000001=
=20
000002ad c2b5bfb8=20
[ 1048.056197] Call Trace:
[ 1048.067287]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.067287]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.073008]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.073008]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.078746]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.078746]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.084472]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.084472]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.090114]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.095657] mingetty      D 000000ed     0  3819      1
[ 1048.101226]        c2f0fe94 00000046 d3be4ef9 000000ed c2f0e000 c02da620=
=20
00000000 004c7290=20
[ 1048.101554]        00000000 d40ac189 000000ed 00000000 c2f0ffb8 bfcf53e8=
=20
c2f0fea0 c014543b=20
[ 1048.107282]        00000000 c2f0fed4 c0126c1c c2f0fef0 00000046 00000001=
=20
000002a5 c2f0ffb8=20
[ 1048.113061] Call Trace:
[ 1048.124131]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.124131]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.129837]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
8.129837]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.135573]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.135573]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.141292]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.141292]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.146934]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.152479] mingetty      D 000000ed     0  3820      1
[ 1048.158098]        c2f07e94 00000046 d3be70bd 000000ed c2f06000 c02da620=
=20
00000000 004cb8c0=20
[ 1048.158426]        00000000 d40b297d 000000ed 00000000 c2f07fb8 bffd96c8=
=20
c2f07ea0 c014543b=20
[ 1048.164154]        00000000 c2f07ed4 c0126c1c c2f07ef0 00000046 00000001=
=20
000002a6 c2f07fb8=20
[ 1048.169932] Call Trace:
[ 1048.181000]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.181000]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.186714]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.186714]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.192456]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.192456]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.198181]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.198181]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.203824]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.209376] mingetty      D 000000ed     0  3821      1
[ 1048.214942]        c2a6be94 00000046 d3be95b6 000000ed c2a6a000 c02da620=
=20
00000000 004cfaa3=20
[ 1048.215269]        00000000 d40b9059 000000ed 00000000 c2a6bfb8 bf8455e8=
=20
c2a6bea0 c014543b=20
[ 1048.220996]        00000000 c2a6bed4 c0126c1c c2a6bef0 00000046 00000001=
=20
000002ad c2a6bfb8=20
[ 1048.226792] Call Trace:
[ 1048.237857]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.237857]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.243567]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.243567]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.249296]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.249296]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.255015]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.255015]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.260652]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.266192] mingetty      D 000000ed     0  3822      1
[ 1048.271754]        c2b5de94 00000046 d3bee632 000000ed c2b5c000 c02da620=
=20
00000000 004d1869=20
[ 1048.272083]        00000000 d40bfe9b 000000ed 00000000 c2b5dfb8 bfb97298=
=20
c2b5dea0 c014543b=20
[ 1048.277805]        00000000 c2b5ded4 c0126c1c c2b5def0 00000046 00000001=
=20
000002a6 c2b5dfb8=20
[ 1048.283569] Call Trace:
[ 1048.294600]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.294600]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.300292]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.300292]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.306013]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.306013]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.311720]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.311720]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.317348]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.322881] startkde      D 000000ed     0  3924   3729
[ 1048.328443]        c2f49e94 00000046 d3bf0b0e 000000ed c2f48000 c02da620=
=20
00000000 00095413=20
[ 1048.328771]        00000000 d3c85f21 000000ed 00000000 c2f49fb8 00000000=
=20
c2f49ea0 c014543b=20
[ 1048.334491]        ffffffff c2f49ed4 c0126c1c 00000000 c2f76d60 c02d1847=
=20
00000004 c2f49fb8=20
[ 1048.340261] Call Trace:
[ 1048.351292]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.351292]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.356995]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.356995]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.362711]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.362711]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.368419]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.368419]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.374040]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.379570] nsrmmd        D 000000ed     0  3946   3740
[ 1048.385121]        c2f95e94 00000046 d3bf4f8f 000000ed c2f94000 c02da620=
=20
00000000 004d0913=20
[ 1048.385447]        00000000 d40c58a2 000000ed 00000000 c2f95fb8 b7be9ff4=
=20
c2f95ea0 c014543b=20
[ 1048.391154]        bfc11c50 c2f95ed4 c0126c1c c03988c0 c2f95eec bfc21b10=
=20
c2f95ec4 c2f95fb8=20
[ 1048.396913] Call Trace:
[ 1048.407916]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.407916]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.413602]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.413602]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.419308]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.419308]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.425008]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.425008]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.430618]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.436125] ssh-agent     D 000000ed     0  3987      1
[ 1048.441655]        c2f93e94 00200046 d3b1bcb4 000000ed c2f92000 c02da620=
=20
00000000 00170874=20
[ 1048.441983]        00000000 d3c8c528 000000ed 00000000 c2f93fb8 00000000=
=20
c2f93ea0 c014543b=20
[ 1048.447681]        00000004 c2f93ed4 c0126c1c c2b58000 c2b58658 00000000=
=20
00000001 c2f93fb8=20
[ 1048.453406] Call Trace:
[ 1048.464331]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.464331]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.469974]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.469974]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.475631]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.481293]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.481293]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.486859]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.492331] gpg-agent     D 000000ed     0  4013      1
[ 1048.497822]        c2f91e94 00000046 d3b854dc 000000ed c2f90000 c02da620=
=20
00000000 00397330=20
[ 1048.498149]        00000000 d3f1c80c 000000ed 00000000 c2f91fb8 08099038=
=20
c2f91ea0 c014543b=20
[ 1048.503799]        00000007 c2f91ed4 c0126c1c 00000000 c0473bc4 c2f91f40=
=20
c013bdca c2f91fb8=20
[ 1048.509501] Call Trace:
[ 1048.520401]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.520401]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.526027]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.526027]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.531680]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.531680]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.537328]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.537328]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.542886]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.548348] nsrmmd        D 000000ed     0  4039   3740
[ 1048.553838]        c2fafe94 00000046 d3c4742c 000000ed c2fae000 c02da620=
=20
00000000 00483fd7=20
[ 1048.554169]        00000000 d40cb403 000000ed 00000000 c2faffb8 b7b5fff4=
=20
c2fafea0 c014543b=20
[ 1048.559817]        bfde8280 c2fafed4 c0126c1c c0479b28 c03973bc 00000002=
=20
c2fafefc c2faffb8=20
[ 1048.565510] Call Trace:
[ 1048.576419]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.576419]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.582052]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.582052]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.587717]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.587717]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.593370]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.593370]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.598931]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.604403] dbus-launch   D 000000ed     0  4129      1
[ 1048.609912]        c2fc5e94 00000046 d3bf973c 000000ed c2fc4000 c02da620=
=20
00000000 000a9362=20
[ 1048.610242]        00000000 d3ca2a9e 000000ed 00000000 c2fc5fb8 00000000=
=20
c2fc5ea0 c014543b=20
[ 1048.615962]        00000006 c2fc5ed4 c0126c1c 00000001 00000000 c2fa3a00=
=20
c047c468 c2fc5fb8=20
[ 1048.621676] Call Trace:
[ 1048.632580]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.632580]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.638209]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.638209]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.643861]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.643861]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.649511]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.649511]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.655067]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.660535] dbus-daemon   D 000000ed     0  4130      1
[ 1048.666027]        c2fbde94 00000046 d3bfba2c 000000ed c2fbc000 c02da620=
=20
00000000 000ad05d=20
[ 1048.666354]        00000000 d3ca8a89 000000ed 00000000 c2fbdfb8 b7f7bff4=
=20
c2fbdea0 c014543b=20
[ 1048.672012]        bfe58900 c2fbded4 c0126c1c 00000002 00000000 c2c9b2e0=
=20
c2c9b2d0 c2fbdfb8=20
[ 1048.677706] Call Trace:
[ 1048.688595]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.688595]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.694221]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.694221]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.699879]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.699879]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.705522]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.705522]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.711095]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.716579] s2u           D 000000ed     0  4165      1
[ 1048.722113]        c2ff5e94 00000046 d3bfdcea 000000ed c2ff4000 c02da620=
=20
00000000 000b0c17=20
[ 1048.722484]        00000000 d3cae901 000000ed 00000000 c2ff5fb8 b7c92ff4=
=20
c2ff5ea0 c014543b=20
[ 1048.728172]        08064b20 c2ff5ed4 c0126c1c 00000001 c0138a5c c2ff2000=
=20
c047c468 c2ff5fb8=20
[ 1048.733899] Call Trace:
[ 1048.744872]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.744872]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.750547]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.750547]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.756247]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.756247]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.761931]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.761931]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.767530]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.773027] start_kdeinit D 000000ed     0  4183      1
[ 1048.778555]        c2ff9e94 00200046 d3c022a2 000000ed c2ff8000 c02da620=
=20
00000000 000b2dfd=20
[ 1048.778883]        00000000 d3cb509f 000000ed 00000000 c2ff9fb8 00000003=
=20
c2ff9ea0 c014543b=20
[ 1048.784577]        00000003 c2ff9ed4 c0126c1c c2ff9ebc c0138a4a c02dc320=
=20
c2ff9ed0 c2ff9fb8=20
[ 1048.790322] Call Trace:
[ 1048.801319]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.801319]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.807006]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.807006]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.812716]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.812716]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.818412]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.818412]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.824031]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.829548] kdeinit       D 000000ed     0  4184      1
[ 1048.835080]        c3419e94 00200046 d3bc5875 000000ed c3418000 c02da620=
=20
00000000 00442a54=20
[ 1048.835408]        00000000 d40082c9 000000ed 00000000 c3419fb8 00000000=
=20
c3419ea0 c014543b=20
[ 1048.841106]        0000000c c3419ed4 c0126c1c 00000000 c2fc6d60 c02d1847=
=20
00000005 c3419fb8=20
[ 1048.846842] Call Trace:
[ 1048.857802]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.857802]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.863465]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.863465]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.869148]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.869148]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.874815]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.874815]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.880400]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.885899] dcopserver    D 000000ed     0  4187      1
[ 1048.891435]        c3441e94 00200046 d3c0cec5 000000ed c3440000 c02da620=
=20
00000000 000c9ef5=20
[ 1048.891762]        00000000 d3cd6dba 000000ed 00000000 c3441fb8 00000000=
=20
c3441ea0 c014543b=20
[ 1048.897462]        00000029 c3441ed4 c0126c1c 00000040 c343e000 c02ebda0=
=20
c3441ed0 c3441fb8=20
[ 1048.903201] Call Trace:
[ 1048.914141]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.914141]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.919794]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.919794]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.925470]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.925470]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.931142]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.931142]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.936725]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.942217] klauncher     D 000000ed     0  4189   4184
[ 1048.947738]        c2fd9e94 00200046 d3c22c08 000000ed c2fd8000 c02da620=
=20
00000000 00429d70=20
[ 1048.948066]        00000000 d404c978 000000ed 00000000 c2fd9fb8 b756bbe4=
=20
c2fd9ea0 c014543b=20
[ 1048.953760]        0000002b c2fd9ed4 c0126c1c 00000000 c343ed60 c02ebda0=
=20
c2fd9ed0 c2fd9fb8=20
[ 1048.959498] Call Trace:
[ 1048.970441]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1048.970441]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1048.976100]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1048.976100]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1048.981777]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1048.981777]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1048.987435]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1048.987435]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1048.993020]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1048.998512] kded          D 000000ed     0  4191      1
[ 1049.004022]        c344de94 00200046 d3bb10fa 000000ed c344c000 c02da620=
=20
00000000 00404618=20
[ 1049.004351]        00000000 d3fb5712 000000ed 00000000 c344dfb8 b756bbe4=
=20
c344dea0 c014543b=20
[ 1049.010032]        00000010 c344ded4 c0126c1c 00000001 c2ef0d60 c02ebda0=
=20
c047c468 c344dfb8=20
[ 1049.015797] Call Trace:
[ 1049.026746]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.026746]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.032400]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.032400]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.038081]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.038081]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.043752]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.043752]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.049334]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.054821] gam_server    D 000000ed     0  4193      1
[ 1049.060333]        c3485e94 00200046 d3ba0d4c 000000ed c3484000 c02da620=
=20
00000000 003e5792=20
[ 1049.060663]        00000000 d3f864de 000000ed 00000000 c3485fb8 b7ec5ff4=
=20
c3485ea0 c014543b=20
[ 1049.066337]        08073668 c3485ed4 c0126c1c 00000008 00000001 00000009=
=20
00000001 c3485fb8=20
[ 1049.072048] Call Trace:
[ 1049.082997]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.082997]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.088655]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.088655]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.094335]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.094335]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.099999]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.099999]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.105572]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.111062] kwrapper      D 000000ed     0  4199   3924
[ 1049.116584]        c34bde94 00200046 d3b811f6 000000ed c34bc000 c02da620=
=20
00000000 00388a1b=20
[ 1049.116912]        00000000 d3f09c11 000000ed 00000000 c34bdfb8 00000000=
=20
c34bdea0 c014543b=20
[ 1049.122598]        bfb1f8c4 c34bded4 c0126c1c 00000000 c3458000 c02d1847=
=20
00000001 c34bdfb8=20
[ 1049.128326] Call Trace:
[ 1049.139278]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.139278]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.144927]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.144927]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.150604]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.150604]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.156270]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.156270]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.161853]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.167347] ksmserver     D 000000ed     0  4201      1
[ 1049.172889]        c3461e94 00200046 d3c135f0 000000ed c3460000 c02da620=
=20
00000000 000dbb1d=20
[ 1049.173219]        00000000 d3cef10d 000000ed 00000000 c3461fb8 00000000=
=20
c3461ea0 c014543b=20
[ 1049.178921]        0000001e c3461ed4 c0126c1c 00000001 c2ff2d60 c02ebda0=
=20
c047c468 c3461fb8=20
[ 1049.184661] Call Trace:
[ 1049.195635]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.195635]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.201300]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.201300]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.206995]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.206995]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.212679]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.212679]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.218273]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.223775] kwin          D 000000ed     0  4202   4184
[ 1049.229339]        c2fe1e94 00200046 d3b8b89e 000000ed c2fe0000 c02da620=
=20
00000000 003ab4de=20
[ 1049.229668]        00000000 d3f36d7c 000000ed 00000000 c2fe1fb8 b756bbe4=
=20
c2fe1ea0 c014543b=20
[ 1049.235376]        0000000c c2fe1ed4 c0126c1c 00000001 c3458d60 c02ebda0=
=20
c047c468 c2fe1fb8=20
[ 1049.241125] Call Trace:
[ 1049.252130]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.252130]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.257809]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.257809]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.263515]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.263515]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.269209]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.269209]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.274814]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.280335] kdesktop      D 000000ed     0  4204      1
[ 1049.285880]        c34dde94 00000046 d3b95b98 000000ed c34dc000 c02da620=
=20
00000000 003c9a9e=20
[ 1049.286207]        00000000 d3f5f636 000000ed 00000000 c34ddfb8 b756bbe4=
=20
c34ddea0 c014543b=20
[ 1049.291910]        00000013 c34dded4 c0126c1c 00000001 c34da000 c02ebda0=
=20
c047c468 c34ddfb8=20
[ 1049.297653] Call Trace:
[ 1049.308617]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.308617]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.314288]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.314288]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.319976]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.319976]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.325660]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.325660]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.331250]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.336753] kio_file      D 000000ed     0  4206   4184
[ 1049.342276]        c3423e94 00200046 d3c179b3 000000ed c3422000 c02da620=
=20
00000000 000f21ad=20
[ 1049.342603]        00000000 d3d09b60 000000ed 00000000 c3423fb8 00000000=
=20
c3423ea0 c014543b=20
[ 1049.348283]        00000004 c3423ed4 c0126c1c 00000000 c3406000 c02ebda0=
=20
c3423ed0 c3423fb8=20
[ 1049.353998] Call Trace:
[ 1049.364893]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.364893]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.370520]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.370520]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.376165]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.376165]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.381805]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.381805]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.387351]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.392816] kicker        D 000000ed     0  4207      1
[ 1049.398313]        c34e3e94 00200046 d3bbac83 000000ed c34e2000 c02da620=
=20
00000000 00421bd3=20
[ 1049.398641]        00000000 d3fdc856 000000ed 00000000 c34e3fb8 b756bbe4=
=20
c34e3ea0 c014543b=20
[ 1049.404298]        0000000f c34e3ed4 c0126c1c 00000001 c34e0000 c02ebda0=
=20
c047c468 c34e3fb8=20
[ 1049.409999] Call Trace:
[ 1049.420894]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.420894]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.426522]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.426522]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.432177]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.432177]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.437860]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.437860]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.443419]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.448889] kio_file      D 000000ed     0  4208   4184
[ 1049.454388]        c351be94 00200046 d3c19d8a 000000ed c351a000 c02da620=
=20
00000000 000f531f=20
[ 1049.454717]        00000000 d3d0f0a9 000000ed 00000000 c351bfb8 00000000=
=20
c351bea0 c014543b=20
[ 1049.460382]        00000004 c351bed4 c0126c1c 00000000 c34e0d60 c02ebda0=
=20
c351bed0 c351bfb8=20
[ 1049.466092] Call Trace:
[ 1049.476966]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.476966]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.482577]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.482577]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.488206]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.488206]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.493827]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.493827]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.499360]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.504798] kweatherservi D 000000ed     0  4210      1
[ 1049.510275]        c3543e94 00200046 d3c1bfed 000000ed c3542000 c02da620=
=20
00000000 000fb53a=20
[ 1049.510601]        00000000 d3d17527 000000ed 00000000 c3543fb8 00000000=
=20
c3543ea0 c014543b=20
[ 1049.516235]        0000000a c3543ed4 c0126c1c 00000001 c3540000 c02ebda0=
=20
c047c468 c3543fb8=20
[ 1049.521905] Call Trace:
[ 1049.532721]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.532721]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.538304]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.538304]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.543914]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.543914]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.549507]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.549507]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.555020]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.560445] kxkb          D 000000ed     0  4234      1
[ 1049.565910]        c356be94 00200046 d3c1e2a1 000000ed c356a000 c02da620=
=20
00000000 001017f6=20
[ 1049.566241]        00000000 d3d1fa97 000000ed 00000000 c356bfb8 00000000=
=20
c356bea0 c014543b=20
[ 1049.571861]        0000000a c356bed4 c0126c1c 00000001 c3568000 c02ebda0=
=20
c047c468 c356bfb8=20
[ 1049.577516] Call Trace:
[ 1049.588283]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.588283]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.593852]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.593852]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.599445]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.599445]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.605033]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.605033]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.610527]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.615936] kaccess       D 000000ed     0  4236      1
[ 1049.621399]        c35dfe94 00200046 d3c2083b 000000ed c35de000 c02da620=
=20
00000000 00107052=20
[ 1049.621730]        00000000 d3d2788d 000000ed 00000000 c35dffb8 00000000=
=20
c35dfea0 c014543b=20
[ 1049.627362]        0000000a c35dfed4 c0126c1c 00000001 c35dc000 c02ebda0=
=20
c047c468 c35dffb8=20
[ 1049.633028] Call Trace:
[ 1049.643824]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.643824]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.649410]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.649410]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.655022]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.655022]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.660624]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.660624]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.666136]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.671559] konsole       D 000000ed     0  4237   4184
[ 1049.677012]        c35ade94 00200046 d3af7422 000000ed c35ac000 c02da620=
=20
00000000 0023ee37=20
[ 1049.677339]        00000000 d3d36259 000000ed 00000000 c35adfb8 00000000=
=20
c35adea0 c014543b=20
[ 1049.682965]        0000000d c35aded4 c0126c1c 00000001 c35dcd60 c02ebda0=
=20
c047c468 c35adfb8=20
[ 1049.688622] Call Trace:
[ 1049.699428]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.699428]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.705010]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.705010]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.710621]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.710621]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.716231]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.716231]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.721746]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.727174] kwifimanager  D 000000ed     0  4238   4184
[ 1049.732645]        c35dbe94 00200046 d3bcabc3 000000ed c35da000 c02da620=
=20
00000000 0048c0cc=20
[ 1049.732972]        00000000 d4056c8f 000000ed 00000000 c35dbfb8 b749ebe4=
=20
c35dbea0 c014543b=20
[ 1049.738614]        0000000b c35dbed4 c0126c1c 00000001 c0280282 c35dbf28=
=20
c047c468 c35dbfb8=20
[ 1049.744295] Call Trace:
[ 1049.755159]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.755159]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.760770]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.760770]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.766406]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.766406]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.772035]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.772035]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.777612]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.783074] konsole       D 000000ed     0  4239   4184
[ 1049.788561]        c3625e94 00200046 d3b024ee 000000ed c3624000 c02da620=
=20
00000000 002575db=20
[ 1049.788933]        00000000 d3d59ac9 000000ed 00000000 c3625fb8 b756bbe4=
=20
c3625ea0 c014543b=20
[ 1049.794591]        0000000d c3625ed4 c0126c1c 00000001 c3622000 c02ebda0=
=20
c047c468 c3625fb8=20
[ 1049.800289] Call Trace:
[ 1049.811171]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.811171]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.816800]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.816800]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.822451]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.822451]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.828092]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.828092]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.833646]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.839120] ksensors      D 000000ed     0  4243      1
[ 1049.844639]        c35b3e94 00200046 d3b14425 000000ed c35b2000 c02da620=
=20
00000000 002632e9=20
[ 1049.844969]        00000000 d3d7770e 000000ed 00000000 c35b3fb8 b78a3be4=
=20
c35b3ea0 c014543b=20
[ 1049.850645]        0000000a c35b3ed4 c0126c1c 00000001 c3602d60 c02dc320=
=20
c047c468 c35b3fb8=20
[ 1049.856361] Call Trace:
[ 1049.867287]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.867287]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.872921]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.872921]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.878588]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.878588]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.884239]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.884239]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.889801]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.895285] kontact       D 000000ed     0  4248      1
[ 1049.900848]        c36bbe94 00200046 d3b1e720 000000ed c36ba000 c02da620=
=20
00000000 0028202e=20
[ 1049.901175]        00000000 d3da074e 000000ed 00000000 c36bbfb8 b6a4cbe4=
=20
c36bbea0 c014543b=20
[ 1049.906863]        0000001c c36bbed4 c0126c1c 00000001 c36b8000 00000000=
=20
c047c468 c36bbfb8=20
[ 1049.912602] Call Trace:
[ 1049.923553]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.923553]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.929213]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.929213]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.934888]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.934888]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.940555]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.940555]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1049.946126]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1049.951611] kontact       D 000000ed     0  4402      1
[ 1049.957135]        c36b1e94 00200046 d3b2c2e4 000000ed c36b0000 c02da620=
=20
00000000 002a2e89=20
[ 1049.957463]        00000000 d3dcf16d 000000ed 00000000 c36b1fb8 00000001=
=20
c36b1ea0 c014543b=20
[ 1049.963151]        0846f3f4 c36b1ed4 c0126c1c c376a000 c0114720 c36b1e34=
=20
c36b1e34 c36b1fb8=20
[ 1049.968928] Call Trace:
[ 1049.979899]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1049.979899]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1049.985566]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1049.985566]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1049.991254]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1049.991254]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1049.996930]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1049.996930]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.002522]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.008030] kontact       D 000000ed     0  4403      1
[ 1050.013567]        c36b5e94 00200046 d3b3033f 000000ed c36b4000 c02da620=
=20
00000000 002ae50c=20
[ 1050.013895]        00000000 d3dde84b 000000ed 00000000 c36b5fb8 00000002=
=20
c36b5ea0 c014543b=20
[ 1050.019591]        0846f3f4 c36b5ed4 c0126c1c c376ad60 c0114720 c36b5e34=
=20
c36b5e34 c36b5fb8=20
[ 1050.025383] Call Trace:
[ 1050.036396]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.036396]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.042084]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.042084]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.047797]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.047797]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.053494]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.053494]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.059106]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.064627] kontact       D 000000ed     0  4404      1
[ 1050.070190]        c36abe94 00200046 d3b344b1 000000ed c36aa000 c02da620=
=20
00000000 002b8025=20
[ 1050.070518]        00000000 d3dec4d6 000000ed 00000000 c36abfb8 00000003=
=20
c36abea0 c014543b=20
[ 1050.076239]        0846f3f4 c36abed4 c0126c1c c365a000 c0114720 c36abe34=
=20
c36abe34 c36abfb8=20
[ 1050.082038] Call Trace:
[ 1050.093079]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.093079]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.098776]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.098776]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.104499]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.104499]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.110217]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.110217]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.115852]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.121391] kontact       D 000000ed     0  4405      1
[ 1050.126972]        c37b9e94 00200046 d3b38461 000000ed c37b8000 c02da620=
=20
00000000 002c2804=20
[ 1050.127300]        00000000 d3dfac65 000000ed 00000000 c37b9fb8 00000004=
=20
c37b9ea0 c014543b=20
[ 1050.133042]        0846f3f4 c37b9ed4 c0126c1c c3602000 c0114720 c37b9e34=
=20
c37b9e34 c37b9fb8=20
[ 1050.138874] Call Trace:
[ 1050.149964]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.149964]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.155682]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.155682]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.161429]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.161429]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.167162]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.167162]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.172801]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.178334] kalarmd       D 000000ed     0  4252      1
[ 1050.183912]        c3499e94 00200046 d3b3c5dd 000000ed c3498000 c02da620=
=20
00000000 002d15a9=20
[ 1050.184241]        00000000 d3e0db86 000000ed 00000000 c3499fb8 b72e7be4=
=20
c3499ea0 c014543b=20
[ 1050.189982]        00000009 c3499ed4 c0126c1c c03988c0 00200246 c3499ebc=
=20
c02d110d c3499fb8=20
[ 1050.195782] Call Trace:
[ 1050.206894]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.206894]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.212632]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.212632]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.218393]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.218393]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.224146]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.224146]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.229812]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.235380] kpowersave    D 000000ed     0  4253      1
[ 1050.240968]        c3713e94 00200046 d3b44474 000000ed c3712000 c02da620=
=20
00000000 002e7570=20
[ 1050.241297]        00000000 d3e2b9e4 000000ed 00000000 c3713fb8 b756bbe4=
=20
c3713ea0 c014543b=20
[ 1050.247045]        0000000c c3713ed4 c0126c1c 00000001 c3713ed0 c02ebda0=
=20
c047c468 c3713fb8=20
[ 1050.252848] Call Trace:
[ 1050.263929]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.263929]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.269654]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.269654]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.275394]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.275394]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.281117]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.281117]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.286752]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.292295] knotify       D 000000ed     0  4255      1
[ 1050.297848]        c3739e94 00200046 d3b4c225 000000ed c3738000 c02da620=
=20
00000000 002fc9c3=20
[ 1050.298175]        00000000 d3e48be8 000000ed 00000000 c3739fb8 00000000=
=20
c3739ea0 c014543b=20
[ 1050.303901]        0000000a c3739ed4 c0126c1c 00000001 c36e2d60 c02ebda0=
=20
c047c468 c3739fb8=20
[ 1050.309673] Call Trace:
[ 1050.320702]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.320702]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.326396]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.326396]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.332118]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.332118]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.337822]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.337822]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.343439]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.348968] kalarm        D 000000ed     0  4256      1
[ 1050.354521]        c375de94 00200046 d3b54352 000000ed c375c000 c02da620=
=20
00000000 0031295c=20
[ 1050.354848]        00000000 d3e66cae 000000ed 00000000 c375dfb8 b6de1be4=
=20
c375dea0 c014543b=20
[ 1050.360562]        0000000a c375ded4 c0126c1c 00000001 c375a000 c02ebda0=
=20
c047c468 c375dfb8=20
[ 1050.366320] Call Trace:
[ 1050.377311]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.377311]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.382983]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.382983]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.388684]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.388684]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.394375]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.394375]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.399982]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.405486] xsettings-kde D 000000ed     0  4257   4184
[ 1050.411026]        c3737e94 00200046 d3b5c24d 000000ed c3736000 c02da620=
=20
00000000 00323c8b=20
[ 1050.411356]        00000000 d3e7fed8 000000ed 00000000 c3737fb8 b7debff4=
=20
c3737ea0 c014543b=20
[ 1050.417055]        0804d640 c3737ed4 c0126c1c 00000040 c3737ed0 c02ebda0=
=20
c3737ed0 c3737fb8=20
[ 1050.422795] Call Trace:
[ 1050.433757]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.433757]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.439412]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.439412]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.445094]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.445094]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.450767]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.450767]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.456345]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.461833] zsh           D 000000ed     0  4262   4237
[ 1050.467381]        c3773e94 00200046 d3b602ed 000000ed c3772000 c02da620=
=20
00000000 00332202=20
[ 1050.467710]        00000000 d3e924ef 000000ed 00000000 c3773fb8 00000000=
=20
c3773ea0 c014543b=20
[ 1050.473373]        0000000a c3773ed4 c0126c1c c3773ef0 00200046 00000001=
=20
000003d4 c3773fb8=20
[ 1050.479082] Call Trace:
[ 1050.489974]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.489974]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.495607]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.495607]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.501257]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.501257]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.506895]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.506895]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.512451]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.517911] zsh           D 000000ed     0  4269   4239
[ 1050.523401]        c3633e94 00200046 d3b662bb 000000ed c3632000 c02da620=
=20
00000000 00341cb7=20
[ 1050.523729]        00000000 d3ea7f72 000000ed 00000000 c3633fb8 00000000=
=20
c3633ea0 c014543b=20
[ 1050.529366]        0000000a c3633ed4 c0126c1c c3633ef0 00200046 00000001=
=20
000002b1 c3633fb8=20
[ 1050.535049] Call Trace:
[ 1050.545902]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.551514]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.551514]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.557148]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.557148]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.562775]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.562775]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.568312]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.573759] kbluetooth    D 000000ed     0  4281      1
[ 1050.579240]        c36fde94 00200046 d3b6c778 000000ed c36fc000 c02da620=
=20
00000000 003566c7=20
[ 1050.579567]        00000000 d3ec2e3f 000000ed 00000000 c36fdfb8 00000000=
=20
c36fdea0 c014543b=20
[ 1050.585246]        0000000c c36fded4 c0126c1c 00000001 00000002 00000000=
=20
c047c468 c36fdfb8=20
[ 1050.590927] Call Trace:
[ 1050.601744]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.601744]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.607381]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.607381]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.613003]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.613003]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.618609]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.618609]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.624126]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.629554] korgac        D 000000ed     0  4407      1
[ 1050.635021]        c3627e94 00200046 d3b76fe3 000000ed c3626000 c02da620=
=20
00000000 00372b98=20
[ 1050.635393]        00000000 d3ee9b7b 000000ed 00000000 c3627fb8 b7287be4=
=20
c3627ea0 c014543b=20
[ 1050.641024]        0000000e c3627ed4 c0126c1c 00000001 c2df2d60 c02ebda0=
=20
c047c468 c3627fb8=20
[ 1050.646699] Call Trace:
[ 1050.657550]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.657550]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.663152]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.663152]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.668782]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.668782]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.674393]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.674393]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.679913]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.685347] hal-system-po D 000000ed     0  4523   2899
[ 1050.690824]        c3653e94 00000046 d3b0dbd7 000000ed c3652000 c02da620=
=20
00000000 005c2cca=20
[ 1050.691152]        00000000 d40d08a1 000000ed 00000000 c3653fb8 00000000=
=20
c3653ea0 c014543b=20
[ 1050.696785]        ffffffff c3653ed4 c0126c1c 00000000 c35b6000 c02d1847=
=20
00000004 c3653fb8=20
[ 1050.702466] Call Trace:
[ 1050.713339]  [refrigerator+155/208] refrigerator+0x9b/0xd0
[ 1050.713339]  [<c014543b>] refrigerator+0x9b/0xd0
[ 1050.718951]  [get_signal_to_deliver+1020/1152]=20
get_signal_to_deliver+0x3fc/0x480
[ 1050.718951]  [<c0126c1c>] get_signal_to_deliver+0x3fc/0x480
[ 1050.724589]  [do_notify_resume+123/1888] do_notify_resume+0x7b/0x760
[ 1050.724589]  [<c01036bb>] do_notify_resume+0x7b/0x760
[ 1050.730228]  [work_notifysig+19/27] work_notifysig+0x13/0x1b
[ 1050.730228]  [<c01042e0>] work_notifysig+0x13/0x1b
[ 1050.735776]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1050.741238] pm-suspend    R running      0  4525   4523
[ 1050.746741] Sched Debug Version: v0.06-v22, 2.6.24-rc1-1avb #1
[ 1050.752185] now at 478521.589239 msecs
[ 1050.757601]   .sysctl_sched_latency                    : 20.000000
[ 1050.763079]   .sysctl_sched_nr_latency                 : 0.000020
[ 1050.768518]   .sysctl_sched_wakeup_granularity         : 10.000000
[ 1050.773955]   .sysctl_sched_batch_wakeup_granularity   : 10.000000
[ 1050.779372]   .sysctl_sched_child_runs_first           : 0.000001
[ 1050.784781]   .sysctl_sched_features                   : 51
[ 1050.790092]=20
[ 1050.790095] cpu#0, 747.687 MHz
[ 1050.800331]   .nr_running                    : 4
[ 1050.805396]   .load                          : 8290
[ 1050.810414]   .nr_switches                   : 517368
[ 1050.815397]   .nr_load_updates               : 71618
[ 1050.820338]   .nr_uninterruptible            : 149
[ 1050.825260]   .jiffies                       : 53580
[ 1050.830163]   .next_balance                  : 0.000000
[ 1050.835037]   .curr->pid                     : 4525
[ 1050.839789]   .clock                         : 238727.792095
[ 1050.844500]   .idle_clock                    : 0.000000
[ 1050.849146]   .prev_clock_raw                : 1050849.120472
[ 1050.853694]   .clock_warps                   : 0
[ 1050.858193]   .clock_overflows               : 49373
[ 1050.862656]   .clock_deep_idle_events        : 0
[ 1050.867075]   .clock_max_delta               : 3.333114
[ 1050.871487]   .cpu_load[0]                   : 8290
[ 1050.875864]   .cpu_load[1]                   : 8290
[ 1050.880174]   .cpu_load[2]                   : 8290
[ 1050.884347]   .cpu_load[3]                   : 8290
[ 1050.888402]   .cpu_load[4]                   : 8290
[ 1050.892356]=20
[ 1050.892359] cfs_rq
[ 1050.899772]   .exec_clock                    : 187542.109698
[ 1050.903574]   .MIN_vruntime                  : 0.000001
[ 1050.907325]   .min_vruntime                  : 118914.089839
[ 1050.911069]   .max_vruntime                  : 0.000001
[ 1050.914760]   .spread                        : 0.000000
[ 1050.918423]   .spread0                       : 0.000000
[ 1050.921939]   .nr_running                    : 1
[ 1050.925355]   .load                          : 2048
[ 1050.928687]   .bkl_count                     : 0
[ 1050.931884]   .nr_spread_over                : 0
[ 1050.934996]=20
[ 1050.934999] cfs_rq
[ 1050.940978]   .exec_clock                    : 67473.966878
[ 1050.944047]   .MIN_vruntime                  : 0.000001
[ 1050.947076]   .min_vruntime                  : 118932.421985
[ 1050.950092]   .max_vruntime                  : 0.000001
[ 1050.953027]   .spread                        : 0.000000
[ 1050.955891]   .spread0                       : 0.000000
[ 1050.958685]   .nr_running                    : 0
[ 1050.961414]   .load                          : 0
[ 1050.964142]   .bkl_count                     : 0
[ 1050.966840]   .nr_spread_over                : 0
[ 1050.969504]=20
[ 1050.969507] cfs_rq
[ 1050.974585]   .exec_clock                    : 48.462480
[ 1050.977242]   .MIN_vruntime                  : 0.000001
[ 1050.979872]   .min_vruntime                  : 118949.087567
[ 1050.982521]   .max_vruntime                  : 0.000001
[ 1050.985162]   .spread                        : 0.000000
[ 1050.987744]   .spread0                       : 0.000000
[ 1050.990328]   .nr_running                    : 0
[ 1050.992892]   .load                          : 0
[ 1050.995438]   .bkl_count                     : 0
[ 1050.997924]   .nr_spread_over                : 0
[ 1051.000428]=20
[ 1051.000430] cfs_rq
[ 1051.005247]   .exec_clock                    : 103.504661
[ 1051.007709]   .MIN_vruntime                  : 0.000001
[ 1051.010218]   .min_vruntime                  : 118962.420034
[ 1051.012735]   .max_vruntime                  : 0.000001
[ 1051.015228]   .spread                        : 0.000000
[ 1051.017661]   .spread0                       : 0.000000
[ 1051.020137]   .nr_running                    : 0
[ 1051.022631]   .load                          : 0
[ 1051.025143]   .bkl_count                     : 0
[ 1051.027626]   .nr_spread_over                : 0
[ 1051.030138]=20
[ 1051.030140] cfs_rq
[ 1051.034999]   .exec_clock                    : 1580.710217
[ 1051.037524]   .MIN_vruntime                  : 0.000001
[ 1051.040055]   .min_vruntime                  : 118977.419060
[ 1051.042587]   .max_vruntime                  : 0.000001
[ 1051.045123]   .spread                        : 0.000000
[ 1051.047634]   .spread0                       : 0.000000
[ 1051.050160]   .nr_running                    : 0
[ 1051.052682]   .load                          : 0
[ 1051.055196]   .bkl_count                     : 0
[ 1051.057660]   .nr_spread_over                : 2
[ 1051.060152]=20
[ 1051.060155] cfs_rq
[ 1051.064971]   .exec_clock                    : 609.310369
[ 1051.067479]   .MIN_vruntime                  : 0.000001
[ 1051.069983]   .min_vruntime                  : 118992.418085
[ 1051.072497]   .max_vruntime                  : 0.000001
[ 1051.074967]   .spread                        : 0.000000
[ 1051.077491]   .spread0                       : 0.000000
[ 1051.079988]   .nr_running                    : 0
[ 1051.082491]   .load                          : 0
[ 1051.084949]   .bkl_count                     : 0
[ 1051.087434]   .nr_spread_over                : 0
[ 1051.089905]=20
[ 1051.089908] cfs_rq
[ 1051.094695]   .exec_clock                    : 117819.556594
[ 1051.097202]   .MIN_vruntime                  : 85608.319912
[ 1051.099724]   .min_vruntime                  : 119007.417110
[ 1051.102252]   .max_vruntime                  : 85608.319912
[ 1051.104749]   .spread                        : 0.000000
[ 1051.107319]   .spread0                       : 0.000000
[ 1051.109855]   .nr_running                    : 4
[ 1051.112390]   .load                          : 8290
[ 1051.114891]   .bkl_count                     : 0
[ 1051.117435]   .nr_spread_over                : 18
[ 1051.119960]=20
[ 1051.119963] runnable tasks:
[ 1051.119966]             task   PID         tree-key  switches  prio    =
=20
exec-runtime         sum-exec        sum-sleep
[=20
1051.119972] --------------------------------------------------------------=
=2D-------------------------------------------
[ 1051.130455]         events/0     5     85608.319912      1657   115    =
=20
85608.319912       272.128589    232329.413049
[ 1051.133550]           kacpid    37     85608.319912        72   115    =
=20
85608.319912       143.011026    235269.004090
[ 1051.136691]          pdflush   139     85608.319912      4432   120    =
=20
85608.319912       427.757260    229751.279099
[ 1051.139983] R     pm-suspend  4525     91091.261544    182735   120    =
=20
91091.261544     23752.744102      9883.612506
[ 1051.143372]=20
[ 1051.146869]  automount
[ 1051.150313]=20
[ 1051.153570] Restarting tasks ... done.

--Boundary-01=_qaNIHV31Ak5siLp
Content-Type: text/plain;
  charset="us-ascii";
  name="config-2.6.24-rc1-1avb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config-2.6.24-rc1-1avb"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc1
# Wed Oct 24 21:04:55 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_UP_POSSIBLE=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_CUSTOM_DSDT_INITRD=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# Old SIR device drivers
#
# CONFIG_IRPORT_SIR is not set

#
# Old Serial dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="\"\""
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=m
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_WDC_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_PLATFORM is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_SHAPER=m
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_KPROBES=y
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
CONFIG_DEBUG_RODATA=y
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

--Boundary-01=_qaNIHV31Ak5siLp--

--nextPart1851810.lKSTslhpdd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHINaqR6LMutpd94wRApOTAJoCvaH0pGjf4Eh80QqTVRKNT1UcOACfTXfR
dlbWLgM1B02VwtHlHY3fSdM=
=xxDD
-----END PGP SIGNATURE-----

--nextPart1851810.lKSTslhpdd--
