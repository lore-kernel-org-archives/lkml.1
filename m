Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZFWWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZFWWRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZFWWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:17:40 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:58037 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZFWWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:17:39 -0400
From: Michael Pyne <mpyne@kde.org>
Organization: KDE
To: Michel =?iso-8859-1?q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH] drm: fix edid interlaced bit position
Date: Tue, 23 Jun 2009 18:16:21 -0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-07735-ga7768a0; KDE/4.2.92; x86_64; svn-985087; 2009-06-20)
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>, airlied@gmail.com
References: <1245700718-2015-1-git-send-email-jglisse@redhat.com> <1245753392.8882.27.camel@thor.local>
In-Reply-To: <1245753392.8882.27.camel@thor.local>
X-Face: TtB_W6e,=~z{cZh,kn{oZG?&\(G7$q^w)(K52a>]Iq|Er,v)U^CKD+Q's>hPVM9(
 =?iso-8859-1?q?keKTOP=0A=09Tq?=(
 =?iso-8859-1?q?C=3B=3Fa0fQ=5EUngsDPQJuH=23l9hoqUixM=7CH7R=3FF4VKjW=3A=3Do?=
 =?iso-8859-1?q?muv64s5F=5BZ/=5Ewwd=5CMqu8ZL=5BUT=0A=09br/=7D!OI=5Fo1t=60BO?=
 =?iso-8859-1?q?U/Ks=2EKBLY?=
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1564822.Yx14URlE37";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906231816.29831.mpyne@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1564822.Yx14URlE37
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 23 June 2009 06:36:32 Michel D=C3=A4nzer wrote:
> On Mon, 2009-06-22 at 21:58 +0200, Jerome Glisse wrote:
> > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> > ---
> >  include/drm/drm_edid.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
>
> That's just the tip of the iceberg... Looks like I managed to mess up
> most shifts when converting from bitfields. :(
>
> The patch below works on my Thinkpad T500 (as well as on my PowerBook,
> where the previous change worked as well, maybe out of luck...). I'd
> appreciate more testing and eyes looking over it though.
>
> Michael, does this fix your problem?

Your patch works just fine here, thanks.

Regards,
 - Michael Pyne

--nextPart1564822.Yx14URlE37
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABCAAGBQJKQVQ9AAoJEAuvDJx7aunyJ8cQAJ410zKXgTNI+OXRfiZWUFFJ
+kc3JTlL9qI4gXP7mgne/rrx04oSJZDXewuXmc6FHFPfevqOg1vt3zMzRfwlhByh
x9sP7IKT+NwG954U2K11uYOSZ4Cb/wiYH//tcmBjESbu16b/93ylObC0z2B+W0/h
OkgiQRw9R5fuhaPN1EnG0cZS6YjOmauKnTnV++wAlHAE9iWvemGvrByy+QL1Vbqu
6w2/GMr8AjjJXPZGMtt38Jy3Mg3Og8UrmNuZahhnwhy2RMz7X1fEiTZ7xZqifLdr
qC9ymscW6UIQ2lTatWCUfk4H6Nh91LHew0VK3irvf4wWQl5goCSd2IpawPUfLwRO
zuKirQvlGA4ffDREdFhDdFSs/t6GnFjoeb6bnkxCQdSVCvGPAoYG4svOA7Z+h9Um
EuG5HsQhmNCxcKWdKJhG7dG8AFbYQW6gE8GKPJy/em0rTJSBiPTxpaCbwYEm42Zb
MrnXwOQYeOA4Y01fvFoICmbNmgFR2EoWX7n7ZoBJ2HhvGWZUQOApl1ikII7w+m9c
1nUW4mekOgmk7RttIaAw1jtwL+c7NprNRQFC5RQn4vQGfohcZSfKAxQNR6oyG1e2
R+BK/Z8mns9L8bb9IuWJRprxDWsRKrTUF/c/k475HLtt5JzJK2INyI2l9xClcKS0
MSyJvKXSstbPioPKXdZ8
=bxTm
-----END PGP SIGNATURE-----

--nextPart1564822.Yx14URlE37--
