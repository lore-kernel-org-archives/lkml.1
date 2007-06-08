Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXFHNMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXFHNMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXFHNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:12:00 -0400
Received: from iucha.net ([209.98.146.184]:48184 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969091AbXFHNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:11:59 -0400
Date: Fri, 8 Jun 2007 08:11:57 -0500
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: spurious completions during NCQ?
Message-ID: <20070608131157.GH30661@iucha.net>
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <4666C477.1070603@shaw.ca> <20070607120430.GB30661@iucha.net> <466951DE.9070004@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64LDleNqNegJ4g97"
Content-Disposition: inline
In-Reply-To: <466951DE.9070004@gmail.com>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--64LDleNqNegJ4g97
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 08, 2007 at 09:55:58PM +0900, Tejun Heo wrote:
> Florin Iucha wrote:
> >> It means the drive reported command tags were completed that were not=
=20
> >> outstanding. What kind of drive is this?
> >=20
> > [   29.033142] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_se=
ctors =3D 156
> > 301488
> > [   29.033146] ata1.00: ATA-7: HITACHI HTS541680J9SA00, SB2IC7EP, max U=
DMA/100
> > [   29.033149] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 3=
1/32)
> > [   29.034230] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_se=
ctors =3D 156
> > 301488
>=20
> Please report the result of 'hdparm -I /dev/sda'.  We'll probably have
> to blacklist it for NCQ.

Here it is: I only jumbled the serial number a bit.

/dev/sda:

ATA device, with non-removable media
	Model Number:       HITACHI HTS541680J9SA00                =20
	Serial Number:      SB******I57L4A
	Firmware Revision:  SB2IC7EP
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 1=20
	Supported: 7 6 5 4=20
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  156301488
	LBA48  user addressable sectors:  156301488
	device size with M =3D 1024*1024:       76319 MBytes
	device size with M =3D 1000*1000:       80026 MBytes (80 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Vendor, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 16
	Advanced power management level: 128 (0x80)
	Recommended acoustic management value: 128, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5=20
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4=20
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	SET_MAX security extension
	    	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	   *	IDLE_IMMEDIATE with UNLOAD
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	    	Non-Zero buffer offsets in DMA Setup FIS
	    	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	    	In-order data delivery
	   *	Software settings preservation
Security:=20
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
	not	supported: enhanced erase
	42min for SECURITY ERASE UNIT.=20
Checksum: correct

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--64LDleNqNegJ4g97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGaVWdND0rFCN2b1sRAoLyAJ90dz6x4vxS3ZjoBWXNavD2LtJS4QCeIV7L
eHpiN+Ll/8b5sGRVZs2r/pA=
=4bnF
-----END PGP SIGNATURE-----

--64LDleNqNegJ4g97--
