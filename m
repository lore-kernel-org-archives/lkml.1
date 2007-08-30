Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXH3J5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXH3J5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXH3J5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:57:01 -0400
Received: from smtp-0-2.linuxrulz.org ([66.197.170.246]:50353 "EHLO
	smtp-0-2.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838AbXH3J47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:56:59 -0400
X-Greylist: delayed 1934 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 05:56:59 EDT
Message-ID: <46D68CC2.3030206@lbsd.net>
Date: Thu, 30 Aug 2007 09:24:18 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070727)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <4671366B.7090702@lbsd.net> <46716B1D.1070902@garzik.org> <20070614182854.GC1223@redhat.com> <20070618200703.GB13344@redhat.com> <46776223.3050402@lbsd.net>
In-Reply-To: <46776223.3050402@lbsd.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=27702C4E;
	url=pgpkeys.mit.edu
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAA5719806CF6555309CD603D"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA5719806CF6555309CD603D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hrmmm,

>>  >=20
>>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on=
 port
>>  >  > > 0x0001c807
>>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on=
 port
>>  >  > > 0x0001c807
>>  >=20
>>  > Unrelated to the other error, but I've been meaning to ask for a wh=
ile..
>>  > If this is 'abnormal', why does every SATA box I've seen do it?
>>
>> *crickets*
>>
>> Should we check for this case explicitly, and not print this?
>>
>>  =20
>>    =20
> After I get the above errors, my entire SATA bus crashes and I need to
> hard reset the box ... not sure we can just ignore the errors?
>
>  =20

Appears even with the patch provided a few months ago I'm getting
freezes. Replaced the HDD & all cables, same errors ... especially
whilst doing heavy IO.

Can anyone shed some light?


ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/133
ata2: EH complete
ata2.00: limiting speed to UDMA/100:PIO4
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/100
sd 3:0:0:0: SCSI error: return code =3D 0x08000002
sda: Current [descriptor]: sense key=3D0xb
    ASC=3D0x0 ASCQ=3D0x0
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 00
end_request: I/O error, dev sda, sector 30132639
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: limiting speed to UDMA/33:PIO4
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: configured for UDMA/33
ata2: EH complete



--------------enigAA5719806CF6555309CD603D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG1ozCKoUGSidwLE4RAliCAJkBTDag2fxG9JsMIsHx2sZsb7ZcnACfam1I
Iln1kIVevBQZ5EW9vwZZ7HA=
=lVvu
-----END PGP SIGNATURE-----

--------------enigAA5719806CF6555309CD603D--
