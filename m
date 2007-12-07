Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXLGXJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXLGXJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXLGXJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:09:48 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34571 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754502AbXLGXJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:09:47 -0500
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
In-Reply-To: <20071207150251.a0dbae23.akpm@linux-foundation.org>
References: <1197059904.15428.15.camel@localhost>
	 <20071207150251.a0dbae23.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HBosa0bxTsG2YYzOwf61"
Date: Fri, 07 Dec 2007 23:09:43 +0000
Message-Id: <1197068983.15428.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0mKH-0001X2-3B-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HBosa0bxTsG2YYzOwf61
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-07 at 15:02 -0800, Andrew Morton wrote:
> On Fri, 07 Dec 2007 20:38:24 +0000
> Zan Lynx <zlynx@acm.org> wrote:
>=20
> > While I'm reporting problems I'll get this one out there.
> >=20
> > I normally use a USB-2 memory card reader but I also have a PCMCIA
> > CompactFlash adapter that I use occasionally.  During the MM series
> > kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  I
> > don't know about vanilla since I don't run that.
> >=20
> > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
> > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
> > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > reader.
> >

> Are we talking about this?
[cut]
> > It might be that it auto-configures for PIO-0.  I have no idea why it
> > does that.
> >=20
> > Another interesting thing is that doing a dd to or from the card brings
> > the rest of the system to a nearly complete halt.  Interrupt problem?
>=20
> Where are you seeing the evidence that it autoconfigures for PIO-0?

No, this:
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x50000000-0x57ffffff: excluding 0x50000000-0x57ffffff
cs: memory probe 0xe0100000-0xe17fffff: excluding 0xe0100000-0xe026ffff 0xe=
03e0000-0xe082ffff 0xe0b10000-0xe10cffff
pcmcia: registering new device pcmcia0.0
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0x3100 ctl 0x310e irq 19
ata3.00: CFA: LEXAR ATA FLASH, V2.00, max PIO6
ata3.00: 8018640 sectors, multi 0: LBA=20
ata3.00: configured for PIO0
ata3.00: configured for PIO0
ata3: EH complete
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      LEXAR ATA FLASH  V2.0 PQ: 0 ANSI: =
5
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk

Specifically:
ata3.00: configured for PIO0
ata3.00: configured for PIO0
--=20
Zan Lynx <zlynx@acm.org>

--=-HBosa0bxTsG2YYzOwf61
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWdK3G8fHaOLTWwgRAhKZAJ94o0dERpHvJHo01ADGDgdZG9tMoQCgpke0
TIkaXwM/3zxnYO+RgEpy5DM=
=Tf9i
-----END PGP SIGNATURE-----

--=-HBosa0bxTsG2YYzOwf61--

