Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZARWk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZARWk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZARWkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:40:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43543 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZARWkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:40:10 -0500
Date: Mon, 19 Jan 2009 09:39:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-Id: <20090119093959.ef7f2495.sfr@canb.auug.org.au>
In-Reply-To: <1232273454.23100.9.camel@localhost.localdomain>
References: <1232273454.23100.9.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_09_39_59_+1100_NJCCE1A1TSa7gXrD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_09_39_59_+1100_NJCCE1A1TSa7gXrD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5571dbe..81fa255 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1480,7 +1480,7 @@ struct v4l2_chip_ident_old {
> =20
>  #if 1
>  /* Experimental, meant for debugging, testing and internal use.
> -   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
> +   Only implemented if VIDEO_ADV_DEBUG is defined.
>     You must be root to use these ioctls. Never use these in applications=
! */

Is there some reason we cannot fix the tool that does the checking for
this case?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_09_39_59_+1100_NJCCE1A1TSa7gXrD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklzr78ACgkQjjKRsyhoI8wc/gCfbhIwBaJIk4EY6+AjkF5GuqER
V68AnAlcQ7MyfbfTkN1P3/VtJhwnRiF9
=cWVF
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_09_39_59_+1100_NJCCE1A1TSa7gXrD--
