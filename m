Return-Path: <linux-kernel-owner+w=401wt.eu-S937756AbXFGWbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937756AbXFGWbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937462AbXFGWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:31:13 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:50148 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937401AbXFGWbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:31:11 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v14
Date: Fri, 8 Jun 2007 01:29:25 +0300
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
References: <20070523120616.GA23407@elte.hu> <200706011635.02774.caglar@pardus.org.tr> <alpine.LFD.0.98.0706010829041.3957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706010829041.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1328215.Pd3fz7NFma";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706080129.28487.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1328215.Pd3fz7NFma
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

01 Haz 2007 Cum tarihinde, Linus Torvalds =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> Has it been hot where you are lately? Is your fan working?

=46irst of all sorry for late reply.

=46or a while =C4=B0stanbul is not really hot [~26 C] :) and yes fans are/s=
eems=20
working without a problem.

> Hardware that acts up under load is quite often thermal-related,
> especially if it starts happening during summer and didn't happen before
> that... ESPECIALLY the kinds of behaviours you see: the "sudden power-off"
> is the normal behaviour for a CPU that trips a critial overheating point,
> and the slowdown is also one normal response to overheating (CPU
> throttling).

According to ACPI output;

[caglar@zangetsu][~]> cat /proc/acpi/thermal_zone/THRM/*
<setting not supported>
cooling mode:   passive
<polling disabled>
state:                   ok
temperature:             56 C
critical (S5):           105 C
passive:                 95 C: tc1=3D1 tc2=3D5 tsp=3D10 devices=3D0xc20deec8

105 C is critical for that CPU, for a while (this is why i reply late) i'm=
=20
constantly monitoring the temprature under low and high load.=20

Its in 50-70 C interval in normal usage/idle and 80-100 C interval under hi=
gh=20
load (compiling some applications, using cpuburn to test etc.), so seems it=
=20
can handle overheating issues

But digging the kern.log shows some strange values also;

May 24 10:39:23 localhost kernel: [    0.000000] Detected 897.748 MHz=20
processor. <--- 2.6.21.2-CFS-v14
=2E..
May 30 00:59:11 localhost kernel: [    0.000000] Detected 898.726 MHz=20
processor. <--- 2.6.21.2-CFS-v15
=2E..
Jun  1 02:09:44 localhost kernel: [    0.000000] Detected 897.591 MHz=20
processor. <--- 2.6.21.3-CFS-v15
=2E..

And according to same log these slowdowns occured after i compiled/installe=
d=20
these kernel versions into system(cause these are the first appearence of=20
this versions in kern.log). So as you said it seems definetly a overheating=
=20
issue. I'll continue to test/monitor and report back if i can find anything=
=2E=20
Thanks!

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1328215.Pd3fz7NFma
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGaIbIy7E6i0LKo6YRAkSgAKCmr0DoEy3E+5S8lS+uEtWyq3TCRgCfVTTS
v3EzGeywu6XhLs3xMFRui9o=
=M8rK
-----END PGP SIGNATURE-----

--nextPart1328215.Pd3fz7NFma--
