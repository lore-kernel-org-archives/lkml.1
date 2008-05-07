Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbYEGTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbYEGTUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbYEGTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:20:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34446 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442AbYEGTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:20:27 -0400
X-Greylist: delayed 1065 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 15:20:26 EDT
X-Sasl-enc: 3v2us7hjJ35QD11xU0zwAD6APpISUmJS5YMBorpl8MzB 1210186959
Message-ID: <4821FCC1.8070907@imap.cc>
Date: Wed, 07 May 2008 21:02:25 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] isdn: use the common ascii hex helpers
References: <1209754916.26173.37.camel@brick>
In-Reply-To: <1209754916.26173.37.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC12D05A2D40DCD72F46B6990"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC12D05A2D40DCD72F46B6990
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 02.05.2008 21:01, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks,
Tilman

> ---
>  drivers/isdn/gigaset/isocdata.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/isocdata.c b/drivers/isdn/gigaset/iso=
cdata.c
> index e30a777..fbce522 100644
> --- a/drivers/isdn/gigaset/isocdata.c
> +++ b/drivers/isdn/gigaset/isocdata.c
> @@ -247,7 +247,6 @@ static inline void dump_bytes(enum debuglevel level=
, const char *tag,
>  #ifdef CONFIG_GIGASET_DEBUG
>  	unsigned char c;
>  	static char dbgline[3 * 32 + 1];
> -	static const char hexdigit[] =3D "0123456789abcdef";
>  	int i =3D 0;
>  	while (count-- > 0) {
>  		if (i > sizeof(dbgline) - 4) {
> @@ -258,8 +257,8 @@ static inline void dump_bytes(enum debuglevel level=
, const char *tag,
>  		c =3D *bytes++;
>  		dbgline[i] =3D (i && !(i % 12)) ? '-' : ' ';
>  		i++;
> -		dbgline[i++] =3D hexdigit[(c >> 4) & 0x0f];
> -		dbgline[i++] =3D hexdigit[c & 0x0f];
> +		dbgline[i++] =3D hex_asc_hi(c);
> +		dbgline[i++] =3D hex_asc_lo(c);
>  	}
>  	dbgline[i] =3D '\0';
>  	gig_dbg(level, "%s:%s", tag, dbgline);


--------------enigC12D05A2D40DCD72F46B6990
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIIfzNQ3+did9BuFsRAqNyAJ4s5QeQyvBmywreF1qpGPMqpgBKnwCgiNuV
jR/leG6LkxP8O/BxQr4JMFw=
=bzMH
-----END PGP SIGNATURE-----

--------------enigC12D05A2D40DCD72F46B6990--
