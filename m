Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZC2Mrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZC2Mrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZC2Mrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:47:32 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:52248 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741AbZC2Mra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:47:30 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 6178FE3C80
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sun, 29 Mar 2009 14:50:07 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903291115.54351.prakash@punnoor.de> <86802c440903290232g293b72e5oa05c20121bbc16d9@mail.gmail.com>
In-Reply-To: <86802c440903290232g293b72e5oa05c20121bbc16d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21353275.yVK3egiLek";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903291450.14466.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21353275.yVK3egiLek
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sonntag 29 M=E4rz 2009 11:32:56 Yinghai Lu wrote:
> On Sun, Mar 29, 2009 at 2:15 AM, Prakash Punnoor <prakash@punnoor.de> wro=
te:
> > On Sonntag 29 M=E4rz 2009 03:33:03 Yinghai Lu wrote:
> >> please try follwing patch over pci/linux-next
> >>
> >> Thanks
> >>
> >> YH
> >>
> >> [PATCH] pci: don't enable too much HT MSI mapping -v6
> >
> > Works fine now, thanks!
> >
> > pci 0000:00:00.0: Found disabled HT MSI Mapping
> > pci 0000:00:00.0: Enabling HT MSI Mapping
> > pci 0000:00:00.0: Found enabled HT MSI Mapping
> > pci 0000:00:05.0: Boot video device
> > pci 0000:00:09.0: Found disabled HT MSI Mapping
> > pci 0000:00:0e.0: Enabling HT MSI Mapping
> > pci 0000:00:09.0: Found disabled HT MSI Mapping
> > pci 0000:00:0f.0: Enabling HT MSI Mapping
> > pci 0000:00:09.0: Found disabled HT MSI Mapping
> > pci 0000:00:10.0: Enabling HT MSI Mapping
> > pci 0000:00:09.0: Found disabled HT MSI Mapping
> > pci 0000:00:10.1: Enabling HT MSI Mapping
>
> can you put you pcie network card in the pcie slot belong to c51?
> we should find 00:03.0 the pcie bridge...
>


Above is when inserted in PCIe 1x slot, now in my PCIe 16x slot
(I don't have other options):

pci 0000:00:00.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:0f.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping



00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (pro=
g-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-=20
        Latency: 0, Cache Line Size: 32 bytes                              =
                                 =20
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0                                        =20
        I/O behind bridge: 0000a000-0000afff                               =
                                 =20
        Memory behind bridge: fdc00000-fdcfffff                            =
                                 =20
        Prefetchable memory behind bridge: 00000000fdd00000-00000000fddffff=
f                                =20
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort+ <SERR- <PERR-      =20
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-      =
                                 =20
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-        =
                                 =20
        Capabilities: [40] Subsystem: nVidia Corporation Device 0000       =
                                 =20
        Capabilities: [48] Power Management version 2                      =
                                 =20
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)                  =20
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-            =
                                     =20
        Capabilities: [50] MSI: Mask- 64bit+ Count=3D1/2 Enable+           =
                                   =20
                Address: 00000000fee0300c  Data: 4149                      =
                                 =20
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-      =
                                 =20
                Mapping Address Base: 00000000fee00000                     =
                                 =20
        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00          =
                                 =20
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512=
ns, L1 <4us                      =20
                        ExtTag- RBE- FLReset-                              =
                                 =20
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-                          =20
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+       =
                                 =20
                        MaxPayload 128 bytes, MaxReadReq 512 bytes         =
                                 =20
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tr=
ansPend-                         =20
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Lat=
ency L0 <512ns, L1 <4us          =20
                        ClockPM- Surprise- LLActRep+ BwNot-                =
                                 =20
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+                             =20
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-     =
                                 =20
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive+ BWMgmt- ABWMgmt-          =20
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Su=
rpise-                           =20
                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=
                                 =20
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPI=
rq- LinkChg-                     =20
                        Control: AttnInd Off, PwrInd On, Power- Interlock- =
                                 =20
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ I=
nterlock-                        =20
                        Changed: MRL- PresDet+ LinkState+                  =
                                 =20
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-                     =20
                RootCap: CRSVisible-                                       =
                                 =20
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-            =
                                 =20
        Capabilities: [100] Virtual Channel <?>                            =
                                 =20
        Kernel driver in use: pcieport-driver                              =
                                 =20
00: de 10 fb 02 07 04 10 00 a1 00 04 06 08 00 01 00                        =
                                 =20
10: 00 00 00 00 00 00 00 00 00 01 01 00 a1 a1 00 20                        =
                                 =20
20: c0 fd c0 fd d1 fd d1 fd 00 00 00 00 00 00 00 00                        =
                                 =20
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00                        =
                                 =20
40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00                        =
                                 =20
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00                        =
                                 =20
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00                        =
                                 =20
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
80: 10 00 41 01 c0 04 00 00 10 28 00 00 01 3d 11 00                        =
                                 =20
90: 40 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00                        =
                                 =20
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20



--nextPart21353275.yVK3egiLek
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknPboYACgkQxU2n/+9+t5jPBwCgrlVcckdnUQZL6Y0p3zQiACDp
zKoAoPeTpG+s+CU0u7GwVyZqDg0ZT7T9
=h++1
-----END PGP SIGNATURE-----

--nextPart21353275.yVK3egiLek--
