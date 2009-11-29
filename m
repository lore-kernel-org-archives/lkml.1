Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZK2LGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZK2LGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZK2LGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:06:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39657 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZK2LGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:06:21 -0500
Date: Sun, 29 Nov 2009 22:06:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, mingo@elte.hu, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3 16/27] PPC: use helpers for rlimits
Message-Id: <20091129220603.e96d1613.sfr@canb.auug.org.au>
In-Reply-To: <1259442963.2076.17.camel@pasglop>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
	<1259363167-9347-16-git-send-email-jslaby@suse.cz>
	<1259367557.2076.11.camel@pasglop>
	<4B10E385.1030900@gmail.com>
	<1259442963.2076.17.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__29_Nov_2009_22_06_03_+1100_/Zvb4eLUFcV_h4j4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__29_Nov_2009_22_06_03_+1100_/Zvb4eLUFcV_h4j4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Sun, 29 Nov 2009 08:16:03 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> On Sat, 2009-11-28 at 09:47 +0100, Jiri Slaby wrote:
> > Are you sure? The previous version with ACCESS_ONCE was generally
> > NACKed. This one uses a newly added helper which is much more cleaner
> > way to do it.
>=20
> I haven't seen a nack, but then I haven't pushed out yet so I can easily
> back it off and replace it with this one.

You need to hold off adding this to your tree until after patch 14/27
("resource: add helpers for fetching rlimits") of this series (or a
modified version of it) reaches Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__29_Nov_2009_22_06_03_+1100_/Zvb4eLUFcV_h4j4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksSVZsACgkQjjKRsyhoI8z7xgCfUKMP9lW83BqkRUhzJLvV4ETK
v/kAn3WGivyaF2xMoZR7AsD8r5mODJjG
=Cnxu
-----END PGP SIGNATURE-----

--Signature=_Sun__29_Nov_2009_22_06_03_+1100_/Zvb4eLUFcV_h4j4--
