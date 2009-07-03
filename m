Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZGCJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZGCJTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZGCJTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:19:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:35496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbZGCJTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:19:00 -0400
Date: Fri, 3 Jul 2009 11:19:35 +0200
From: Kurt Garloff <garloff@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Greg KH <gregkh@suse.de>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090703091935.GL20681@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Ingo Molnar <mingo@elte.hu>,
	"Maciej W. Rozycki" <macro@linux-mips.org>, Greg KH <gregkh@suse.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Yinghai Lu <yinghai@kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org> <20090701111003.GC15958@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/ZYM6PqDyfNytx60"
Content-Disposition: inline
In-Reply-To: <20090701111003.GC15958@elte.hu>
X-Operating-System: Linux 2.6.27.23-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/ZYM6PqDyfNytx60
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ingo,

On Wed, Jul 01, 2009 at 01:10:03PM +0200, Ingo Molnar wrote:
> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
>=20
> > On Tue, 30 Jun 2009, Greg KH wrote:
> >=20
> > > >  These days an IOCK NMI typically happens in response to a PCI=20
> > > > SERR -- it may be useful to traverse PCI buses to find the=20
> > > > offender and dump this information on this occasion too.  The=20
> > > > south bridge may have additional status too.
> > >=20
> > > Sure, that would be great to have.  Care to make a patch?  :)
> >=20
> >  ENOTIME, sorry.  Next year perhaps.  Or a homework project for=20
> > one of the newbies. ;)
>=20
> You know that this project would kill a newbie, right? :)
>=20
> We have no real southbridge drivers on x86 - but we should certainly=20
> add some. Also, walking the PCI device tree from NMI context is=20
> tricky as the lists there are not NMI safe - we could crash if we=20
> happen to get a #IOCK while loading/unloading drivers (which is rare=20
> but could happen).

Well -- in case we panic the system anyway this is not necessarily a
big issue (let's print the message before ...) -- if we crash trying
to gather additional info, we'll lose the info. Currently we never have
the info ...

> IMHO it's all very much desired functionality, but highly=20
> non-trivial.

Too bad.

Best,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--/ZYM6PqDyfNytx60
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKTc0nxmLh6hyYd04RAgnMAJ9g2drf/hVbOuK+ELKKGT7PW9vksACfW/yr
Yl4mxSsdrgg0auUCOzlTuVc=
=PUY0
-----END PGP SIGNATURE-----

--/ZYM6PqDyfNytx60--
