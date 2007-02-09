Return-Path: <linux-kernel-owner+w=401wt.eu-S1946051AbXBILhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946051AbXBILhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946370AbXBILhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:37:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946051AbXBILha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:37:30 -0500
From: Emmeran Seehuber <rototor@rototor.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
Date: Fri, 9 Feb 2007 12:37:24 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702071817.17006.rototor@rototor.de> <45CC3C9C.3050101@gmail.com>
In-Reply-To: <45CC3C9C.3050101@gmail.com>
X-Face: r$Dk&6(PFBkz"O(d4nE<ZXvpygmFFB%`/+1FHeQCFD|K1tY#:C3t"=?utf-8?q?wW2zb=27QD=3FYWE=26liV=5E=0A=09h!=26-=7C=5DT=2E=5BRlcZ=7DN=7E4A0z?=
 =?utf-8?q?4syfMw=5E=26gH=24M?=,fWc+P@GWh1Ja)'J5]In}-=d<
 =?utf-8?q?tj=3A+oV-=23*D=27Bi=0A=094DR=5DF=7CEZH=5EjC/O?=)(Oe<Fc+`f}2^M14u<gK_mw4_wF$xn"~bF!BKsdTiaMs)"
 =?utf-8?q?=3D=5DxT8aC=5FS=3D=0A=09RA=3ATsO?="hfoHvOa%8'u0/6RLTL=-}>=S;uWHI5DiU)YUUnED+B784<x\2*,VR^E>
 =?utf-8?q?3=5Bz=7CIJ=7B=0A=09ftYrhFwU1=26?=<.=`'*vh@
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0zFzFtSV8Np6cTH"
Message-Id: <200702091237.24576.rototor@rototor.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:d84d732d8ddd2281dac05c143a411240
X-Provags-ID2: V01U2FsdGVkX1/S6JVYSTBEYJBOW9qZ/kJhJPOLgKB7lKdCBsURVjwEt4JDDm9QX7w180M2ohvOVqoz08ELBIv5szXq71z0k8RUiOyh+zlsHIoBoBjh5tSrdQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0zFzFtSV8Np6cTH
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Friday 09 February 2007 schrieb Tejun Heo:
> Hi,

>
> This is just the recovery part.  Need more log.  If possible, please
> give a shot at 2.6.20.  It might have fixed your problem or at least
> allow better diagnosis.
>

I=B4ll look into getting 2.6.20 on the machine. But it might take some time=
 till=20
we can do this.

> > Does somebody have a glue whats going on here? Could it be a hardware
> > failure?
>
> It might be.  Quite some SATA bug reports turn out to be hardware
> problem, most commonly PSU issues.

The power supply unit (you meant this with PSU, didn`t you?) has 800 Watt, =
so=20
it should be powerfull enough for one harddisk and no graphics board.

> > Do you need additional information?
>
> Yeah, please post the content of /var/log/boot.msg if available and the
> result of dmesg and lspci -nn.

We don`t have a /var/log/boot.msg, but it seems the boot messages were save=
d=20
in /var/log/dmesg, so I attached it.

Thanks for your effort.

cu,
  Emmy

--Boundary-00=_0zFzFtSV8Np6cTH
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci-nn.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci-nn.txt"

00:01.0 PCI bridge [0604]: Broadcom HT1000 PCI/PCI-X bridge [1166:0036]
00:02.0 Host bridge [0600]: Broadcom HT1000 Legacy South Bridge [1166:0205]
00:02.1 IDE interface [0101]: Broadcom HT1000 Legacy IDE controller [1166:0214]
00:02.2 ISA bridge [0601]: Broadcom HT1000 LPC Bridge [1166:0234]
00:03.0 USB Controller [0c03]: Broadcom HT1000 USB Controller [1166:0223] (rev 01)
00:03.1 USB Controller [0c03]: Broadcom HT1000 USB Controller [1166:0223] (rev 01)
00:03.2 USB Controller [0c03]: Broadcom HT1000 USB Controller [1166:0223] (rev 01)
00:04.0 Ethernet controller [0200]: Intel Corporation 82541GI/PI Gigabit Ethernet Controller [8086:1076] (rev 05)
00:05.0 Ethernet controller [0200]: Intel Corporation 82541GI/PI Gigabit Ethernet Controller [8086:1076] (rev 05)
00:06.0 VGA compatible controller [0300]: XGI - Xabre Graphics Inc Volari Z7 [18ca:0020]
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
00:19.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:19.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
00:19.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
00:19.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
01:0d.0 PCI bridge [0604]: Broadcom HT1000 PCI/PCI-X bridge [1166:0104] (rev c0)
01:0e.0 RAID bus controller [0104]: Broadcom BCM5785 (HT1000) SATA Native SATA Mode [1166:024a]

--Boundary-00=_0zFzFtSV8Np6cTH
Content-Type: application/x-gzip;
  name="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg.txt.gz"

H4sICKdXzEUAA2RtZXNnLnR4dADt3E9v2zYYx/F7X8XTmwukCinJfyKgh9RJtxzSBbWHYadBkehE
iC16lJyke/WjZWcxsB62tsNM5+tDokT8UdJj8gMqMmLdIp9L0+btqhH1eKbE1rK0rvU/fPCvcay6
V6r0+NXp9DST/Lq2Lz2Ut7mOlMrk90LaamHsqpVesSh9W1O8ed49y6u5KaW1cnF2/nF68eFX6V0c
/yTGOeuO1t9+W+TN3Tv1mO6knLnP51WZt5U/hW0XPd+2tu/e9jftdrt2prD3xkljF0ZKc18Vpjny
v23d56q+kaqWvjSmaLbB29yVfm9j2na9e32J2z0TXwuZV/WdrJaio778cL1spDeZbIqidSKTsa1b
Z+eSKLVzxoWtZ9XNyvkTmlknP59dnh7rJNn2e/6jb7BYzk1rXk3Gk4vtSUpT5pnEJ4lKB8PBSPo6
fnv9uTVyWz649Rm31vnD6/666HL5/s2rLvCLq3ybK2db30KqRuxsttlzaUsjE1M3JhOlJMnXX5X6
+zFLV90bKfLi1rd86Pq7zou75+sxj4VZduU/X78//m1VvjpFu9k4d85vpJvxoCQvupbqMZaZs3+Y
+rmf3vtLX4puVPn9A71Tsja/ESWbMZP0/zpO+tTYX7LpjqOktx1iT299Nyr9hTdz+7AZAM3S1uWR
+BLnjb8WI0s/eEzd7gZ2B0zXXnqJ6gbGU7+NnbVfHhn/1RH/9Yjbcxf2PARbsPUd2Spy2IIt2IIt
2IKtQDCBLdj6Jram46tMps7PRF/4VV3MbX5nytdyZXx5R2mkh6NIax3Fqc6SYZwcj/wsvHW+Yo08
VHXp5/TAn24cqyTJuq1+OlKRfDLLvPLFiYARGA86BIwHCSNswdYhh2ALtmALtgILwRZswRZsBRaC
LdiCLdgKLARbsAVbsBVYCLYOkq1/8qzyREVaDTPdH8VfeFSZDFJ/NaNhOsi6zeHoRPOwEhlfTAgZ
D1JG2IKtQw7BFmzBFmwFFoIt2IIt2AosBFuwBVuwFVgItmALtmArsBBswRZswVZgIdiCLdjaI7bi
r5niLy4EW7AFW3vE1p4sZ/Y8BFuwBVuwFVgItmCL/ywNW4GFYAu2YAu2AgvBFmxxkwhbgYVgC7Zg
C7YCC8EWbMEWbAUWgi3Ygi3YCiwEW7D1HdmK+ZM8bMEWbIXFFqst2IIt2AqMLT4AAVuwBVuBscVq
C7ZgC7ZgC7aCwQS2YCtItrhJhC3Ygq3A2GK1BVuwBVuwBVvBYAJbsAVbsBUYJrAFW7AFW4FhAluw
BVuwFRgmsAVbsAVbgWECW7AFW7AVGCawBVuwBVuBYQJbsBUkW3zcFLZgC7YCY4vVFmzBFmwFxhar
LdiCLdgKjC1WW7AFW7AVGFustmALtmALtmArGExgC7aCZIubRNiCLdiCLdgKBhPYgq1vYms6vspk
6vxM9IVf1cXc5nemfC1Xxpd3lEa6P4jiVEdaDzKt0vh45GfhrfMVa+Shqks/p+M06Q+S/lBl3VY6
0Ekkn8wyr3xxImAExoMOAeNBwvi/sTWCLdiCLdgKiy1WW7AFW7D1dWz9CdCEstXy7wAA

--Boundary-00=_0zFzFtSV8Np6cTH
Content-Type: application/x-gzip;
  name="boot.dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="boot.dmesg.txt.gz"

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
uG4AAA==

--Boundary-00=_0zFzFtSV8Np6cTH--
