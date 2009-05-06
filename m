Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbZEFQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbZEFQqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEFQqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:46:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:41853 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750868AbZEFQqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:46:30 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/Dw/4zE4/DdwRFGsgRht67n2ch99hnvp1VsFnTOz
	lRKiGR314L/TAc
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: patch mm-fix-committed_as-underflow-on-large-nr_cpus-environment.patch added to 2.6.29-stable tree
Date: Wed, 6 May 2009 18:46:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-2.slh.6-sidux-amd64; KDE/4.2.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie,
       stable@kernel.org
References: <20090504220454.3F71148FB8@coco.kroah.org> <20090505225932.GA4982@suse.de> <2f11576a0905051612p140e077fva214e954273a39df@mail.gmail.com>
In-Reply-To: <2f11576a0905051612p140e077fva214e954273a39df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1420212.tFuVaQ5p5F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905061846.21126.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1420212.tFuVaQ5p5F
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Mittwoch, 6. Mai 2009, KOSAKI Motohiro wrote:
> > On Wed, May 06, 2009 at 07:26:51AM +0900, KOSAKI Motohiro wrote:
> >> Could you please post oops log?
> >> current mmotm (include this patch) works fine on my x86_64 box. Then,
> >> I have no hint now ;-)
> >
> > Attached is a picture of the oops.
> >
> > Hope this helps,
>=20
> OK, the reason is 99% mis-applied patch. I've made rebased patch.
>=20
> in my environment
>=20
> 2.6.29.2 + original patch:  panic
> 2.6.29.2 + rebased patch:  works well
>=20
> Could you please try it?

This patch seems to fix the problems, it's working without any issues on=20
all systems I could test so far.

Thank you
	Stefan Lippers-Hollmann

--nextPart1420212.tFuVaQ5p5F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoBvt0ACgkQORbEMfgJlPYUtgCcCfoyOgF2TIsBslRTBG6GhYgE
dg0AmgJnpoOX2XoEfXmaTiANk+Ikck0V
=L5Vs
-----END PGP SIGNATURE-----

--nextPart1420212.tFuVaQ5p5F--
