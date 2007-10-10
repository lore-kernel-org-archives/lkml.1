Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXJJJyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXJJJyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXJJJyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:54:41 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:51899 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbXJJJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:54:40 -0400
Date: Wed, 10 Oct 2007 13:54:32 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071010095432.GC30345@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <4706AD19.4040605@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <4706AD19.4040605@pcburn.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 278, 10 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
> Hello all,
>
> I've just installed a multiport serial card released by an outfit called=
=20
> Syba.  This is an 8 port serial-only card with an Octopus style breakout=
=20
> cable.  The main chipset on it is an ITE IT8871F.

Are you sure ? IIRC IT887x are PCI-ISA bridges with additional periphery
and your lspci shows PLX chip. Can you send complete lspci -vv output ?
Output of dmesg could be useful too.

> I've got two questions on this: Is there a driver I should try force=20
> loading on it (and if so, what options to use)?  and is there any useful=
=20
> testing I can do to report back to the LKML on this card?
>
> Thanks for your time, diagnostic output follows.
> -- Chris
>
> The following comes up from an "lspci -vv"
>
> 01:06.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev=
=20
> 01) (prog-if 02 [16550])
>        Subsystem: Unknown device 544e:0008
>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr=
-=20
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
=20
> <TAbort- <MAbort- >SERR- <PERR-
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at a000 [size=3D64]
>        Region 1: I/O ports at a400 [size=3D16]
>        Region 2: I/O ports at a800 [size=3D16]
>        Region 3: Memory at f5000000 (32-bit, non-prefetchable) [size=3D4K]
>        Region 4: Memory at f5001000 (32-bit, non-prefetchable) [size=3D4K]
>        Region 5: Memory at f5002000 (32-bit, non-prefetchable) [size=3D4K]
>
> and "lshw" outputs:
>
>        *-communication UNCLAIMED
>             description: Serial controller
>             product: PLX Technology, Inc.
>             vendor: PLX Technology, Inc.
>             physical id: 6
>             bus info: pci@0000:01:06.0
>             version: 01
>             width: 32 bits
>             clock: 33MHz
>             capabilities: 16550
>             configuration: latency=3D0
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHDKFYIWZCBzwS8mkRAozWAJ4tSBTGk4r7rZTMglLR5qFpdLajVQCgx4hP
VGC68SgJXCvcbywB0+QN+d8=
=x+T0
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
