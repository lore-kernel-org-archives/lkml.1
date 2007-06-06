Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXFFLun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXFFLun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761887AbXFFLud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:50:33 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62271 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762297AbXFFLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:50:32 -0400
X-BigFish: VP
X-FB-SS: 0,0,0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: "Mircea Bardac" <dev.list@mircea.bardac.net>
Subject: Re: CPU off-on-off: lost CPU management?
Date: Wed, 6 Jun 2007 13:50:20 +0200
User-Agent: KMail/1.9.7
cc: stefan.prechtel@googlemail.com,
       "Linux List" <linux-kernel@vger.kernel.org>
References: <200706051003.29501.peter.oruba@amd.com>
 <200706051253.01551.dev.list@mircea.bardac.net>
 <200706051256.49179.dev.list@mircea.bardac.net>
In-Reply-To: <200706051256.49179.dev.list@mircea.bardac.net>
MIME-Version: 1.0
Message-ID: <200706061350.25553.peter.oruba@amd.com>
X-OriginalArrivalTime: 06 Jun 2007 11:50:13.0835 (UTC)
 FILETIME=[D7F431B0:01C7A830]
X-WSS-ID: 6A7840F21GC4227091-01-01
Content-Type: multipart/signed;
 boundary=nextPart1306315.A96JqI0v2z;
 protocol="application/pgp-signature";
 micalg=pgp-sha1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1306315.A96JqI0v2z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm sorry, I am not able to reproduce this issue (using 2.6.21.3). Everythi=
ng=20
works fine on my Turion laptop. It looks like there is also CPU hotplug=20
involved in that issue, since brining cpu1 back on doesn't update siblings=
=20
and cpu_cores in /proc/cpuinfo as well. Can you specify more details about=
=20
the system you are using? Have you tried enabling CONFIG_CPU_FREQ_DEBUG and=
=20
booting with "cpufreq.debug=3D7"?

Peter Oruba


Am Dienstag, 5. Juni 2007 11:56:44 schrieb Mircea Bardac:
> On Tuesday 05 June 2007 12:52:59 Mircea Bardac wrote:
> > Hi Peter,
> >
> > This time with Kernel 2.6.21.3.
> >
> > [...]
> >
> > # echo 1 > /sys/devices/system/cpu/cpu1/online
> >
> > # cat /proc/cpuinfo
> > processor       : 0
> > vendor_id       : AuthenticAMD
> > cpu family      : 15
> > model           : 72
> > model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> > stepping        : 2
> > cpu MHz         : 800.000
> > cache size      : 512 KB
> > physical id     : 0
> > siblings        : 1
> > core id         : 0
> > cpu cores       : 1
> > fdiv_bug        : no
> > hlt_bug         : no
> > f00f_bug        : no
> > coma_bug        : no
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 1
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> > fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extap=
ic
> > cr8legacy ts fid vid ttp tm stc
> > bogomips        : 1597.67
> > clflush size    : 64
> >
> > processor       : 1
> > vendor_id       : AuthenticAMD
> > cpu family      : 15
> > model           : 72
> > model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> > stepping        : 2
> > cpu MHz         : 798.015
> > fdiv_bug        : no
> > hlt_bug         : no
> > f00f_bug        : no
> > coma_bug        : no
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 1
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> > fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extap=
ic
> > cr8legacy ts fid vid ttp tm stc
> > bogomips        : 1596.26
> > clflush size    : 64
>
> As a follow-up:
>
> As Stefan noticed initially, the CPU frequency of the 2nd CPU is different
> after the CPU is brought back online.
>
> Mircea


=2D-=20
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--nextPart1306315.A96JqI0v2z
Content-Type: application/pgp-signature;
 name=signature.asc
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGZp+B38rmLONd5dwRAiyjAKC0+AY4hHZKggAV9H5auJvuDMpxawCg2AuA
Eezzp38Dbs+139eV83XTaCA=
=ttG8
-----END PGP SIGNATURE-----

--nextPart1306315.A96JqI0v2z--


