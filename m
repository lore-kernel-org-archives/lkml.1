Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYJNTui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYJNTui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYJNTua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:50:30 -0400
Received: from mail.ipom.com ([69.73.131.218]:58746 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYJNTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:50:28 -0400
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 15:50:28 EDT
Message-ID: <48F4F337.8080104@ipom.com>
Date: Tue, 14 Oct 2008 21:29:59 +0200
From: Phil Dibowitz <phil@ipom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: Avoid I/O errors when issuing SCSI ioctls to JMicron USB/ATA
 bridge
References: <Pine.LNX.4.44L0.0810141111080.2662-300000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810141111080.2662-300000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBB8D029AB346657DDACB9C38"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBB8D029AB346657DDACB9C38
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alexandre Oliva wrote:
> Here's the patch that implements the fix you suggested to avoid the
> I/O errors that I was running into with my new USB enclosure with a
> JMicron USB/ATA bridge, while issuing scsi-io USN or other such
> queries used by Fedora's mkinitrd.
> http://bugzilla.kernel.org/show_bug.cgi?id=3D9638#c85

Alexandre,

The patch looks generally good, but you've included every possible revisi=
on
of the hardware. Can you please change your patch to include just the
revision in question (0x0100) rather than the whole range (0x0000 - 0x999=
9)?

Thanks.
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigBB8D029AB346657DDACB9C38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkj08zcACgkQN5XoxaHnMrtwkgCdH/as5auZbjmsSYbFYdDCznFV
PxEAoJUKuJfmd3b7XNMV3MWpNS0IWySl
=TR3C
-----END PGP SIGNATURE-----

--------------enigBB8D029AB346657DDACB9C38--
