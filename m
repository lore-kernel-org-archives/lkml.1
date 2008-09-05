Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYIEMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYIEMK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYIEMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:10:15 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:4732 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYIEMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:10:14 -0400
X-Greylist: delayed 1913 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 08:10:13 EDT
Message-ID: <48C119FB.4030809@imap.cc>
Date: Fri, 05 Sep 2008 13:37:31 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
References: <20080903191023.GF2772@parisc-linux.org> <Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org> <20080904214802.GO2772@parisc-linux.org>
In-Reply-To: <20080904214802.GO2772@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5C687B4DAC3FE291AD0F3880"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5C687B4DAC3FE291AD0F3880
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Sep 2008 15:48:02 -0600, Matthew Wilcox wrote:
> On Wed, Sep 03, 2008 at 04:15:39PM -0400, Alan Stern wrote:
[...]
>> It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13; =
=20
>> the request is actually sent to the device's upstream hub.
>=20
> Mmm.  In this case, we don't have an upstream hub.  The vhci-hcd driver=

> is on the host and sends URBs across the network where they're received=

> by the stub driver.  The stub then sends them to the exported device.

The way I've always understood it, there is, by definition,
always an upstream hub. It's the entity controlling the port
to which the device is connected. In the case discussed here,
I guess the stub would have to play that part.

Am I wrong?

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig5C687B4DAC3FE291AD0F3880
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIwRoCQ3+did9BuFsRAjmeAJ0Tqu92peXJTLVTVp4d5ZzT4i0c0gCfdZ5I
6NrT+wuzsAkZFf0PcPzs1qc=
=jAcS
-----END PGP SIGNATURE-----

--------------enig5C687B4DAC3FE291AD0F3880--
