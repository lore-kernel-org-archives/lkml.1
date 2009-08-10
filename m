Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZHJJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZHJJNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZHJJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:13:38 -0400
Received: from smtp-out114.alice.it ([85.37.17.114]:4815 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZHJJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:13:37 -0400
Date: Mon, 10 Aug 2009 11:13:00 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       openezx-devel@lists.openezx.org, Ilya Petrov <ilya.muromec@gmail.com>
Subject: Re: [PATCH v3] input: PCAP2 misc input driver
Message-Id: <20090810111300.6c9abe57.ospite@studenti.unina.it>
In-Reply-To: <20090810072431.D2068526EC9@mailhub.coreip.homeip.net>
References: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
	<20090810072431.D2068526EC9@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.16.5; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_11_13_00_+0200_lb7ek4ZoAc+CSKaJ"
X-OriginalArrivalTime: 10 Aug 2009 09:13:08.0821 (UTC) FILETIME=[C7063050:01CA199A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_11_13_00_+0200_lb7ek4ZoAc+CSKaJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Aug 2009 23:54:07 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Aug 07, 2009 at 10:54:16PM +0200, Daniel Ribeiro wrote:
> > diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> > index 0d979fd..679bae3 100644
> > --- a/drivers/input/misc/Makefile
> > +++ b/drivers/input/misc/Makefile
> > @@ -26,3 +26,4 @@ obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+=3D twl4030-pw=
rbutton.o
> >  obj-$(CONFIG_INPUT_UINPUT)		+=3D uinput.o
> >  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+=3D wistron_btns.o
> >  obj-$(CONFIG_INPUT_YEALINK)		+=3D yealink.o
> > +obj-$(CONFIG_INPUT_PCAP)		+=3D pcap_keys.o
>=20
> Btw, could we please keep Makefile sorted alphabetically? This should
> help with merge conflicts a bit (I know Kconfig is still not sorted).
>

Ok, do I need to send another version?

And, is Samuel taking this one and the pcap_ts one?
They depends on changes already in his for-next branch.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Mon__10_Aug_2009_11_13_00_+0200_lb7ek4ZoAc+CSKaJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/5JwACgkQ5xr2akVTsAEndQCeJ1oeMWeihERU5zEfpIkNfIWq
ZoYAn1gqNfj9HT37HCIF+qJ8nu31gm0Z
=3J0A
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_11_13_00_+0200_lb7ek4ZoAc+CSKaJ--
