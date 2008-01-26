Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYAZSrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYAZSrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 13:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYAZSrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 13:47:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:49079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752148AbYAZSrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 13:47:05 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+fGFcavaqfDEdivxBcmEMRbVhlP75IXppXhfZ9HI
	nh2PQH/jvcLW0T
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sat, 26 Jan 2008 19:46:51 +0100
User-Agent: KMail/1.9.7
References: <479B69D2.5050603@wpkg.org>
In-Reply-To: <479B69D2.5050603@wpkg.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1735797.AXiU5mRk46";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801261946.54518.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1735797.AXiU5mRk46
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


The problem is the same as described here : http://lkml.org/lkml/2007/10/21=
/85
If I run dnetc even with lowest prority than the CPU stays at 600 MHz regar=
dless
of any other load (eg. rsyncing, svn update, compiling, ...)

Stopping the dnetc process immediately speeds up the CPU up to 1.7 GHz.


Am Samstag, 26. Januar 2008 schrieben Sie:
> During the test, run top, and watch your CPU usage. Does it go above 80%=
=20
> (the default for=20
> /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).

No, instead I get :

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7294 dnetc     39  19   664  348  264 R 49.5  0.0   0:48.68 dnetc
 7310 tfoerste  20   0  1796  492  428 R 48.5  0.0   0:07.19 factor
 7050 root      20   0 96736 8872 3972 S  0.7  0.9   0:02.99 X


> What CPUFreq processor driver are you using?
I use the native kernel built-in ondemand governor. BTW, here are the setti=
ngs:

n22 /sys/devices/system/cpu/cpu0/cpufreq/ondemand # tail -v *
=3D=3D> ignore_nice_load <=3D=3D
1

=3D=3D> powersave_bias <=3D=3D
0

=3D=3D> sampling_rate <=3D=3D
500000

=3D=3D> sampling_rate_max <=3D=3D
250000000

=3D=3D> sampling_rate_min <=3D=3D
250000

=3D=3D> up_threshold <=3D=3D
80


=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1735797.AXiU5mRk46
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHm4AehyrlCH22naMRAuYYAJ9rA9DZoOpspDgUpbBmj2t8vyZjTACgj0BS
bJ75ACLdfA2cIZeCX9YSD7o=
=t2WS
-----END PGP SIGNATURE-----

--nextPart1735797.AXiU5mRk46--
