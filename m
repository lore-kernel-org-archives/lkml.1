Return-Path: <linux-kernel-owner+w=401wt.eu-S2992713AbXDRVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992713AbXDRVKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992714AbXDRVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:10:38 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52204 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992713AbXDRVKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:10:37 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Date: Thu, 19 Apr 2007 00:08:10 +0300
User-Agent: KMail/1.9.6
Cc: Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu>
In-Reply-To: <20070418154811.GA16842@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1227214.ad1YppaAM1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704190008.19262.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1227214.ad1YppaAM1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

18 Nis 2007 =C3=87ar tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> * S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr> wrote:
> > -       schedule();
> > +       msleep(1);
> >
> > which Ingo sends me to try also has the same effect on me. I cannot
> > reproduce hangs anymore with that patch applied top of CFS while one
> > console checks out SVN repos and other one compiles a small test
> > software.
>
> great! Could you please unapply the hack above and try the proper fix
> below, does this one solve the hangs too?

Instead of that one, i tried CFSv3 and i cannot reproduce the hang anymore,=
=20
Thanks!...

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1227214.ad1YppaAM1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGJojCy7E6i0LKo6YRAh8SAKCTFACM2sFKiOi4izmA+i2//9n3VACfWJcx
gL1dfj2llfgS+fGMnxSVe8U=
=U3/l
-----END PGP SIGNATURE-----

--nextPart1227214.ad1YppaAM1--
