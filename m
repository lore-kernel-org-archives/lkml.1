Return-Path: <linux-kernel-owner+w=401wt.eu-S934488AbXGLOpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488AbXGLOpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXGLOps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:45:48 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:44277 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbXGLOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:45:47 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.22.1-rt1
Date: Thu, 12 Jul 2007 16:45:45 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070712121355.GA10949@elte.hu>
In-Reply-To: <20070712121355.GA10949@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6735047.zNW99nFvBq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707121645.46206.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1184251547;fd7ef82f;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6735047.zNW99nFvBq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[sorry Ingo for the dublicated post]

> to build a 2.6.22.1-rt1 tree, the following patches should be applied:
> =C2=A0
> =C2=A0 =C2=A0http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.b=
z2
> =C2=A0 =C2=A0http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt1

I get a compile error on my x86_64 dualcore sytem.

mgd@seneca:/usr/src/linux-2.6.22.1-rt1> make
=C2=A0 CHK =C2=A0 =C2=A0 include/linux/version.h
=C2=A0 CHK =C2=A0 =C2=A0 include/linux/utsrelease.h
=C2=A0 CALL =C2=A0 =C2=A0scripts/checksyscalls.sh
=C2=A0 CHK =C2=A0 =C2=A0 include/linux/compile.h
=C2=A0 CC [M] =C2=A0net/rfkill/rfkill-input.o
net/rfkill/rfkill-input.c: In function =E2=80=98rfkill_schedule_toggle=E2=
=80=99:
net/rfkill/rfkill-input.c:60: error: size of array =E2=80=98type name=E2=80=
=99 is negative
net/rfkill/rfkill-input.c:60: warning: comparison of distinct pointer types=
 lacks a cast
net/rfkill/rfkill-input.c:68: error: size of array =E2=80=98type name=E2=80=
=99 is negative
net/rfkill/rfkill-input.c:68: warning: comparison of distinct pointer types=
 lacks a cast
net/rfkill/rfkill-input.c: At top level:
net/rfkill/rfkill-input.c:82: warning: implicit declaration of function =E2=
=80=98__MUTEX_INITIALIZER=E2=80=99
net/rfkill/rfkill-input.c:82: warning: missing braces around initializer
net/rfkill/rfkill-input.c:82: warning: (near initialization for =E2=80=98rf=
kill_wlan.mutex=E2=80=99)
net/rfkill/rfkill-input.c:82: error: initializer element is not constant
net/rfkill/rfkill-input.c:82: error: (near initialization for =E2=80=98rfki=
ll_wlan.mutex.lock.wait_lock.raw_lock.slock=E2=80=99)
net/rfkill/rfkill-input.c:82: error: initializer element is not constant
net/rfkill/rfkill-input.c:82: error: (near initialization for =E2=80=98rfki=
ll_wlan.lock=E2=80=99)
net/rfkill/rfkill-input.c:83: warning: missing braces around initializer
net/rfkill/rfkill-input.c:83: warning: (near initialization for =E2=80=98rf=
kill_bt.mutex=E2=80=99)
net/rfkill/rfkill-input.c:83: error: initializer element is not constant
net/rfkill/rfkill-input.c:83: error: (near initialization for =E2=80=98rfki=
ll_bt.mutex.lock.wait_lock.raw_lock.slock=E2=80=99)
net/rfkill/rfkill-input.c:83: error: initializer element is not constant
net/rfkill/rfkill-input.c:83: error: (near initialization for =E2=80=98rfki=
ll_bt.lock=E2=80=99)
make[2]: *** [net/rfkill/rfkill-input.o] Fehler 1
make[1]: *** [net/rfkill] Fehler 2
make: *** [net] Fehler 2


I used a linux-2.6.22.tar.bz2 and applied patch-2.6.22.1.bz2 followed
by patch-2.6.22.1-rt1

I had copied my .config from my (working) 2.6.22-cfs-v19 directory and
issued a 'make oldconfig' using mostly defaults.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=C3=A4ftsf=C3=BChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart6735047.zNW99nFvBq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGlj6aUYYhyuxDQc4RAogTAJ97TC9xUFOCMuu1fr6W0QweBRWLSACfVmwg
hN/Qb5JmsTKhVZOdJv/g5rY=
=DJCn
-----END PGP SIGNATURE-----

--nextPart6735047.zNW99nFvBq--
