Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXEMBUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXEMBUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 21:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXEMBUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 21:20:42 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:53385 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755877AbXEMBUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 21:20:41 -0400
Date: Sat, 12 May 2007 18:20:45 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org
Cc: Fred Moyer <fred@redhotpenguin.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
Message-ID: <20070513012045.GA15162@curie-int.orbis-terrarum.net>
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no> <46460C1B.6000609@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <46460C1B.6000609@shaw.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 12, 2007 at 12:48:59PM -0600, Robert Hancock wrote:
>  Fred Moyer wrote:
> > I just joined the list today so apologies if this email breaks any emai=
l=20
> > client post threading.
> > I have been seeing similar errors on two different systems.  I applied=
=20
> > Robert's sata_nv patch posted to the list on May 5th, and approved toda=
y by=20
> > Jeff Garzik.  I've taken several steps to insure that this isn't a faul=
ty=20
> > cable or drive issue.  This is running on a hp dl145g2.  Here is my lsp=
ci,=20
> > dmesg, and relevant kernel config sections:
>=20
>  (snip)
>=20
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123=
392=20
> > in
> >          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM=20
> > violation)
> > ata1: soft resetting port
> > ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
>=20
>  This appears to be a different problem. Something is issuing SMART-relat=
ed=20
>  commands (smartd or smartctl perhaps) which the drive seems to be reacti=
ng=20
>  strangely to. It apparently completed the command but never raised DRQ t=
o=20
>  request any data being transferred even though we expected it to. Maybe=
=20
>  SMART is disabled on the drive and that's causing it to just toss these=
=20
>  commands? CCing linux-ide in case anyone knows what would cause this.
I previously posted a near identical error to linux-ide.
http://article.gmane.org/gmane.linux.ide/18375

Specifically, I could trigger it by running 'smartctl -d ata -S on
/dev/sda' OR (s-S/o/).

Same sata_nv controller, two different drives, many different cables.
Reproducible over 7 systems [two different models of Tyan mobo] that I
have.

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Council Member
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iD8DBQFGRmftPpIsIjIzwiwRAhYhAKDaME5zgmMNbTzr8UgFBSlGzQBcEwCgkKPW
thUTBUAH7EsD0oTqGCmPR/g=
=LHJw
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
