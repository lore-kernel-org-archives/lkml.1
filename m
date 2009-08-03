Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZHCT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZHCT6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZHCT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:58:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58207 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZHCT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:05 -0400
Message-ID: <4A774147.8090207@novell.com>
Date: Mon, 03 Aug 2009 15:57:59 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] venet: add scatter-gather/GSO support
References: <20090803171030.17268.26962.stgit@dev.haskins.net>	<20090803171807.17268.49836.stgit@dev.haskins.net> <20090803113355.734e69b6@nehalam>
In-Reply-To: <20090803113355.734e69b6@nehalam>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig729E2AC306E0E4CAC25F29DB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig729E2AC306E0E4CAC25F29DB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Stephen Hemminger wrote:
> On Mon, 03 Aug 2009 13:18:07 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
>=20
>> +	struct {
>> +		int                sg:1;
>> +		int                tso:1;
>> +		int                ufo:1;
>> +		int                tso6:1;
>> +		int                ecn:1;
>> +	} flags;
>=20
> Why do you have to shadow flags that are already available in net_devic=
e?
> It is bad design to replicate state in a device driver. The problem
> with replicated state is that it has to be updated in both places.
>=20

Ya, you are right.  I think the rationale was that the flags were "hw"
state, whereas dev->features was software state.  But thinking about it
after you comments, I don't think it makes much difference either way.

I will just have the negcap() function set the features directly in v2.

Kind Regards,
-Greg


--------------enig729E2AC306E0E4CAC25F29DB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp3QUcACgkQP5K2CMvXmqFApwCfWvniqvhjljwRK06ZywYww8TL
HeIAn12tmTF1vrt/U2eqFygxMuqhhTE/
=TQZc
-----END PGP SIGNATURE-----

--------------enig729E2AC306E0E4CAC25F29DB--
