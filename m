Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXFPLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXFPLp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXFPLpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:45:19 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49086 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236AbXFPLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:45:17 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Dave Jones <davej@redhat.com>
Subject: Re: [BUG] Interesting race between cpufreq_ondemand and snd_atiixp
Date: Sat, 16 Jun 2007 14:44:08 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk, tiwai@suse.de
References: <200706160233.47659.caglar@pardus.org.tr> <20070616005428.GG23417@redhat.com>
In-Reply-To: <20070616005428.GG23417@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2377874.3WZIVusdfQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706161444.08999.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2377874.3WZIVusdfQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

16 Haz 2007 Cts tarihinde, Dave Jones =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> On Sat, Jun 16, 2007 at 02:33:41AM +0300, S.=C3=87a=C4=9Flar Onur wrote:
>  > One of our colleagues found following problem with his old laptop while
>  > testing Linus's latest git with external alsa-driver (v1.0.14). And we
>  > can also reproduce same problem with 2.6.18.8 so it seems not a new
>  > regression (if it is a regression).
>  >
>  > As a summary "sound stops to work if cpufreq_ondemand governor is used"
>  > on that laptop. Problem occurs only if cpufreq_* modules are loaded and
>  > %100 reproducable if system configured for ondemand governor.
>
> I'm puzzled.  The cpuinfo shows that this cpu doesn't have speedstep, so
> why acpi-cpufreq successfully loads is a mystery.
>
> What's in/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequenci=
es
>  ?

mavi ~ #=20
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
2793000 1596000

> Maybe the acpi implementation is faking multiple speeds using throttling
> a la p4-clockmod, which would be a bit loopy, but possible I guess.

modprobe p4-clockmod with 2.6.18.8 ends up with "Device or resource busy"

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2377874.3WZIVusdfQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGc80Iy7E6i0LKo6YRAjBLAJ9+FyoUyPNV2jPcYACp/A06x1xqxgCggVgt
+cyf3deKroYdgxr5zsLS7nA=
=8ER2
-----END PGP SIGNATURE-----

--nextPart2377874.3WZIVusdfQ--
