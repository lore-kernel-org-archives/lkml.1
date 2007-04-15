Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXDOWRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXDOWRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXDOWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:17:08 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57462 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754018AbXDOWRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:17:07 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: Kaffeine problem with CFS
Date: Mon, 16 Apr 2007 01:14:54 +0300
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>
References: <20070413202100.GA9957@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
In-Reply-To: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1180539.9zokvfEFcb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704160114.58317.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1180539.9zokvfEFcb
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

15 Nis 2007 Paz tarihinde, Christoph Pfister =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> Could you try xine-ui or gxine? Because I suspect rather xine-lib for
> freezing issues. In any way I think a gdb backtrace would be much
> nicer - but if you can't reproduce the freeze issue with other xine
> based players and want to run kaffeine in gdb, you need to execute
> "gdb --args kaffeine --nofork".

I just tested xine-ui and i can easily reproduce exact same problem with=20
xine-ui also so you are right, it seems a xine-lib problem trigger by CFS=20
changes.

> > > thanks. This does has the appearance of a userspace race condition of
> > > some sorts. Can you trigger this hang with the patch below applied to
> > > the vanilla tree as well? (with no CFS patch applied)
> >
> > oops, please use the patch below instead.

Tomorrow i'll test that patch and also try to get a backtrace.

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1180539.9zokvfEFcb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGIqPiy7E6i0LKo6YRAojdAJ9oCfbrN0BydEajTVtVwRrOKlLDjwCfTHYs
PabhglRSIYvEUmo2LXmqU6A=
=IJI+
-----END PGP SIGNATURE-----

--nextPart1180539.9zokvfEFcb--
