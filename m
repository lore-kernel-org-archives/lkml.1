Return-Path: <linux-kernel-owner+w=401wt.eu-S1422991AbXDRNHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422991AbXDRNHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422992AbXDRNHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:07:30 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:60890 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422991AbXDRNH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:07:29 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: Kaffeine problem with CFS
Date: Wed, 18 Apr 2007 16:05:01 +0300
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <19a3b7a80704180534w3688af87x78ee68cc1c330a5c@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com>
In-Reply-To: <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart73560550.57c1iMg2DA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704181605.04615.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart73560550.57c1iMg2DA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

18 Nis 2007 =C3=87ar tarihinde, Christoph Pfister =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:=20
> > Okay - so here are some results (it's strange that gdb goes nuts
> > inside the xine_play call). I have three bts (seems to be fairly easy
> > to reproduce that behaviour over here): Twice while playing an audio
> > cd and once while playing a normal file. The hang usually ends if you
> > wait long enough (something around 30 secs over here).

I can confirm this, freeze ends after some wait period (~20-30 secs) if=20
kaffine is the only active process. I didn't notice that cause most probabl=
y=20
CPU is busy with compiling kernel at that time...

Now i'm testing Ingo's msleep patch + xine-lib-1.1.6...

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart73560550.57c1iMg2DA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGJheAy7E6i0LKo6YRApBvAJ0RVJwVdxqpS4+rV52wT478JXosvgCgrAbY
MAVh8ABPTHIHesT9ozMJ/vo=
=kfxK
-----END PGP SIGNATURE-----

--nextPart73560550.57c1iMg2DA--
