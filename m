Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbXBTHXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbXBTHXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964854AbXBTHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:23:45 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:44742 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964848AbXBTHXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:23:45 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Tue, 20 Feb 2007 08:24:01 +0100
User-Agent: KMail/1.9.6
References: <200702161437.34063.eike-kernel@sf-tec.de> <200702191539.38902.eike-kernel@sf-tec.de> <20070219115952.a06be52c.akpm@linux-foundation.org>
In-Reply-To: <20070219115952.a06be52c.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2104166.tgITizfczl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702200824.06728.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2104166.tgITizfczl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 19. Februar 2007 schrieben Sie:
> On Mon, 19 Feb 2007 15:39:38 +0100 Rolf Eike Beer <eike-kernel@sf-tec.de>=
=20
wrote:
> > > It's totally weird. It prints the "skipped" message for every (!)
> > > number, not just for the blacklisted ones. And I've triple checked th=
at
> > > I don't have missed the '{'.
> > >
> > > Compiler is SuSEs 4.1.0 from their 10.1. I remember some rumors that
> > > this thing is just broken?
> >
> > Ok, I'm using the compiler from SuSE 10.2 now and it works. Time that we
> > refuse to build if it's a 4.1.0.
>
> argh, I was down to suspecting gcc.
>
> I suppose we can just stir the code around to make it go away.  Like this?

Too late, sorry. I've upgraded to 4.1.3 and it works fine now. Maybe I'll f=
ind=20
time to check again but this will take some days.

Eike

--nextPart2104166.tgITizfczl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2qIWXKSJPmm5/E4RAkcDAKCCt4WNOZu+iq2epwGXwnVXiWtzagCfSChJ
/VR11Lp21D0vlhxQZL5gp40=
=tjKB
-----END PGP SIGNATURE-----

--nextPart2104166.tgITizfczl--
