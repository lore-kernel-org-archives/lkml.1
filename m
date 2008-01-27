Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYA0VPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYA0VPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYA0VOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:14:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:58087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752402AbYA0VOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:14:52 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+FEOQ3MTiF1GKX6EtVFCvuo4sQxvhmjgwCPIcxka
	N08dJfsdgpBG+K
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sun, 27 Jan 2008 22:14:47 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <479B69D2.5050603@wpkg.org> <200801271339.14668.toralf.foerster@gmx.de> <1201460328.5092.95.camel@homer.simson.net>
In-Reply-To: <1201460328.5092.95.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26706347.LjJtZSgDHu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801272214.49928.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26706347.LjJtZSgDHu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Sunday 27 January 2008 Mike Galbraith wrote :
>=20
> On Sun, 2008-01-27 at 13:39 +0100, Toralf F=C3=B6rster wrote:
> > Ough, does this mean that for a multi-user scenario of 2 non-root users=
 "A" and
> > "B" each running exactly 1 process with nice level 0 and 19 rerspective=
ly
> > that both share ~50% of the CPU *and furthermore* that that user "B" do=
es never
> > ever have a  chance to be nice to user "A" although his process should =
really
> > use only those CPU cycles not eated by any other user ?
>=20
> Yes.  If you want one task group to receive less cpu cycles, you have to
> 'nice' that task group by reducing it's share.

> I think it's better to just disable fair group scheduling if it doesn't
> suit your needs.  It's not going to be everyone's cup of tea.

Yes, disabling this kernel option is much better for me as a notebook user.

BTW t I've one more question related to this topic:

Is it correct that within the scenario described above user "A" never gets =
more
than 50% of the CPU as soon as user "B" is logged into the system (because =
of
the login process itself) ?

> 	-Mike
>=20



=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart26706347.LjJtZSgDHu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnPRJhyrlCH22naMRAkOuAKDBmHxJLNcsTvS0hDqlGqFWx4wV6ACfXwqR
HD7rwTqd4jkN4e6IDPIilms=
=joNu
-----END PGP SIGNATURE-----

--nextPart26706347.LjJtZSgDHu--
