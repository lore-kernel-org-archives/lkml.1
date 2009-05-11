Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZEKOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZEKOmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZEKOmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:42:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35971 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZEKOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:42:01 -0400
Message-ID: <4A083932.50605@novell.com>
Date: Mon, 11 May 2009 10:41:54 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, alext@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       avi@redhat.com, bhutchings@solarflare.com, andi@firstfloor.org,
       gregkh@suse.de, chrisw@sous-sol.org, shemminger@vyatta.com,
       alex.williamson@hp.com, nikola.ciprich@linuxbox.cz
Subject: Re: [RFC PATCH v3 00/17] virtual-bus
References: <20090421183341.12548.33393.stgit@dev.haskins.net> <20090511113731.GA6205@nik-comp.linuxbox.cz>
In-Reply-To: <20090511113731.GA6205@nik-comp.linuxbox.cz>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD2EBDE3F49001BFCDC924DD4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD2EBDE3F49001BFCDC924DD4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Nikola Ciprich wrote:
> Hi Gregory,
>
> I'd like to try Your vbus patches, but compiling 2.6.30-rc2 (or 2.6.30-=
rc5) fails
> with following error:
> drivers/vbus/proxy/kvm-guest-vbus: struct pci_device_id is 32 bytes.  T=
he last of 1 is:
> 0xda 0x11 0x00 0x00 0x00 0x20 0x00 0x00 0xff 0xff 0xff 0xff 0xff 0xff 0=
xff 0xff 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00=
 0x00 0x00 0x00
> FATAL: drivers/vbus/proxy/kvm-guest-vbus: struct pci_device_id is not t=
erminated with a NULL entry!
>
> Do You have any idea on what might be wrong?
> thanks a lot in advance...
>  =20
Hi Nik,
  I haven't seen that error with vbus itself, but oddly enough I just
encountered something similar when I was working on a different series
(nullio).   The fix there was trivial, and I suspect it will be here as
well.  What I am more confused on is why this suddenly started
happening....  I will get back to you with a fix.

Regards,
-Greg



--------------enigD2EBDE3F49001BFCDC924DD4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoIOTIACgkQlOSOBdgZUxnhxACgjL/ON3Z9VbdZbI2IRwH+QNrV
zm4AmQHazMQ86K/fIMWS1rUKo7jwNuRq
=7vrT
-----END PGP SIGNATURE-----

--------------enigD2EBDE3F49001BFCDC924DD4--
