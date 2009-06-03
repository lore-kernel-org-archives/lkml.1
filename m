Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZFCVku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZFCVku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZFCVko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:40:44 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZFCVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:40:43 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200906032305.07551.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906031116.05114.rjw@sisk.pl> <1244062874.22576.4.camel@johannes.local>
	 <200906032305.07551.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lpuU9u7L+CoCht5DDRWe"
Date: Wed, 03 Jun 2009 23:25:15 +0200
Message-Id: <1244064315.22576.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lpuU9u7L+CoCht5DDRWe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[can you please turn off html email?]


> Can you please send me /proc/interrupts from the affected box?

$ cat /proc/interrupts=20
            CPU0       CPU1      =20
   0:    1820687          0   IO-APIC-edge      timer
   7:          1          0   IO-APIC-edge   =20
   9:      38721          0   IO-APIC-fasteoi   acpi
  16:        940          0   IO-APIC-fasteoi   HDA Intel
  17:        517          0   IO-APIC-fasteoi   ohci_hcd:usb4
  18:     289829          0   IO-APIC-fasteoi   ohci_hcd:usb3
  19:    2035671          0   IO-APIC-fasteoi   ehci_hcd:usb2
  20:         32          0   IO-APIC-fasteoi   ehci_hcd:usb1
  25:     515569          0   PCI-MSI-edge      ahci
  26:          0          0   PCI-MSI-edge      eth0
 NMI:          0          0   Non-maskable interrupts
 LOC:     152936     638337   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 RES:     317238     581858   Rescheduling interrupts
 CAL:         43        128   Function call interrupts
 TLB:      60645      53553   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 ERR:          1
 MIS:          0

johannes

--=-lpuU9u7L+CoCht5DDRWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJuo4AAoJEODzc/N7+Qmatq0QAM8Cu2HS8Xg+YJdspCcejiVC
4xzY6zH+upZZr4eg9I03nhrbHODt0o5rAmKsBv3M4Iy1NlM9KoTQIdTia77a2t6S
r7/gtnPZ3e4SiTTiTfDou4WDjwXaMLM80MYAhGs5EFtQDjpiGicpWOn21eyIcmun
f8bypCpCix8FyhZ9yXMrvwse4dLSWig2kxyE8WgsDoNy5/MiMNdyk/oP6MEFJeTE
osCN0H89IHwTHmWCkTWMyICxBzA5zaU7QpKBabWCmAlpbo0d9FPiRyBfjXCthur+
m3EoRVyVlrb5xEhtj1k/4O+3oT2sOcXVV9TTry1NsmMcCxaLcMG/99VaDP7gLKoW
Bi52tgxYVyL0CPFB4lwdhLiyHDk6TKr2soUPBfBgaw5KzcTyK9T5pjFkkUls4007
vYU8J7H2PMZa6Vfyq6N0gfCO+JWJkKP7TEcscUoFvlf0hZsinZeC+OvxckcGXzfv
uuQDVQjEX+6qXbI1PmdaZsCp/b+Hw2lmWh4H4o82c+gZaXP+PfF0bDi4a0hSoGsw
qRcfMquOYD3ht4TQnlkLddBbwZwJ1BnJpBXAmrQhG0P7T7KVSx3I+TjSLe05+G5q
xwzEj+PJEpyXDokA+2buHlp4YZ7s2/OtWSBfb7rr0rl0w7NTpFPdogbcaKjMjn1+
ZdkTbecWEUuJ+MSbCa2p
=lINr
-----END PGP SIGNATURE-----

--=-lpuU9u7L+CoCht5DDRWe--

