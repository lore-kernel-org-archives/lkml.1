Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZASAAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZASAAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZASAAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:00:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44599 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbZASAAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:00:07 -0500
Date: Mon, 19 Jan 2009 10:59:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-Id: <20090119105956.573d434f.sfr@canb.auug.org.au>
In-Reply-To: <1232273454.23100.9.camel@localhost.localdomain>
References: <1232273454.23100.9.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_10_59_56_+1100_yW1SjCS.8Ur0/7TB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_10_59_56_+1100_yW1SjCS.8Ur0/7TB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
>=20
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:3=
06: leaks CONFIG_NET to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:3=
07: leaks CONFIG_NET to userspace where it is not valid

> diff --git a/include/linux/pkt_cls.h b/include/linux/pkt_cls.h
> index 3c842ed..7a45e09 100644
> --- a/include/linux/pkt_cls.h
> +++ b/include/linux/pkt_cls.h
> @@ -304,8 +304,8 @@ enum
>  	TCA_FW_UNSPEC,
>  	TCA_FW_CLASSID,
>  	TCA_FW_POLICE,
> -	TCA_FW_INDEV, /*  used by CONFIG_NET_CLS_IND */
> -	TCA_FW_ACT, /* used by CONFIG_NET_CLS_ACT */
> +	TCA_FW_INDEV,	/* used by NET_CLS_IND */
> +	TCA_FW_ACT,	/* used by NET_CLS_ACT */
>  	TCA_FW_MASK,

Again, surely we can improve the tool to not warn about these.  If nothing
else, the actual warning is not correct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_10_59_56_+1100_yW1SjCS.8Ur0/7TB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklzwnwACgkQjjKRsyhoI8z8EgCfT3FPenjEJksupLYaYyUDIzhi
Rt8AoK+U630Xyfiau/jzUFW9XGrooUbk
=+Tn1
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_10_59_56_+1100_yW1SjCS.8Ur0/7TB--
