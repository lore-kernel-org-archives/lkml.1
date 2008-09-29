Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYI2NFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYI2NFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2NFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:05:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:42187 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYI2NFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version
         :x-mailer;
        b=FjzUDAFTrQFkEfGb+OFcM6AETQzBR9n44c/jBRKf7ayQy3M+pGE1NjpWcPKKRFmqYG
         13otO4OZ1DEWqTLGA0QSkFN00qnriKWATM0Ys4sfZFOGddYxK7QL/4xvKEhN5srZiBBE
         LLkftkjMM52Yt1bbTgWCN9+cNPruPkNeIcCCc=
Subject: [libata] Spurious error msg on ahci controller
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VSCTHG4Sfv7VF2UGEN49"
Date: Mon, 29 Sep 2008 15:05:32 +0200
Message-Id: <1222693532.9527.3.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VSCTHG4Sfv7VF2UGEN49
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Linux varda 2.6.27-rc7 #9 SMP PREEMPT Mon Sep 22 01:37:23 CEST 2008
x86_64 GNU/Linux


 I got this on dmesg although nothing is attached to that port.=20

[  415.871744] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0x=
e frozen
[  415.873390] ata1: irq_stat 0x00000040, connection status changed
[  415.874642] ata1: SError: { DevExch }
[  415.875472] ata1: hard resetting link
[  416.599282] ata1: SATA link down (SStatus 0 SControl 300)
[  416.600523] ata1: EH complete

lspci

00:00.0 Host bridge: ALi Corporation M1697 HTT Host Bridge
00:01.0 PCI bridge: ALi Corporation PCI Express Root Port
00:02.0 PCI bridge: ALi Corporation PCI Express Root Port
00:03.0 PCI bridge: ALi Corporation PCI Express Root Port
00:04.0 PCI bridge: ALi Corporation PCI Express Root Port
00:11.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge
00:12.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated ether=
net. (rev 60)
00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
00:14.0 Audio device: ALi Corporation High Definition Audio/AC'97 Host Cont=
roller (rev 01)
00:15.0 ISA bridge: ALi Corporation PCI to LPC Controller (rev 10)
00:15.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
00:16.0 IDE interface: ALi Corporation M5229 IDE (rev c7)
00:16.1 SATA controller: ALi Corporation ULi M5288 SATA
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7300 GT]=
 (rev a1)
05:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
05:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigab=
it Ethernet (rev 10)
05:0c.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
05:0c.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
05:0c.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
05:0c.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)


--=-VSCTHG4Sfv7VF2UGEN49
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkjg0pwACgkQ3GEkiSnUSOEFKACaAiao54D7wiFWuOJ6R2td2MHI
ZOkAn39eG/Qu432zQydDMICbL40VaTtK
=0JKq
-----END PGP SIGNATURE-----

--=-VSCTHG4Sfv7VF2UGEN49--

