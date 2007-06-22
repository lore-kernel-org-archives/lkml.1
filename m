Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbXFVIHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbXFVIHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXFVIHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:07:33 -0400
Received: from mail.suse.de ([195.135.220.2]:41967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXFVIH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:07:29 -0400
Date: Fri, 22 Jun 2007 01:06:40 -0700
From: John Johansen <jjohansen@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Lars Marowsky-Bree <lmb@suse.de>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622080640.GB14593@suse.de>
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2007 at 04:59:54PM -0400, Stephen Smalley wrote:
> On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
> > On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:
> >=20
>=20
> > And now, yes, I know AA doesn't mediate IPC or networking (yet), but
> > that's a missing feature, not broken by design.
>=20
> The incomplete mediation flows from the design, since the pathname-based
> mediation doesn't generalize to cover all objects unlike label- or
> attribute-based mediation.  And the "use the natural abstraction for
> each object type" approach likewise doesn't yield any general model or
> anything that you can analyze systematically for data flow.
>=20
No the "incomplete" mediation does not flow from the design.  We have
deliberately focused on doing the necessary modifications for pathname
based mediation.  The IPC and network mediation are a wip.

We have never claimed to be using pathname-based mediation IPC or networkin=
g.
The "natural abstraction" approach does generize well enough and will
be analyzable.

> The emphasis on never modifying applications for security in AA likewise
> has an adverse impact here, as you will ultimately have to deal with
> application mediation of access to their own objects and operations not
> directly visible to the kernel (as we have already done in SELinux for
> D-BUS and others and are doing for X).  Otherwise, your "protection" of
> desktop applications is easily subverted.
>=20
yes of course, we realize that dbus and X must be trusted applications,
this to will happen.  But it will happen piece meal, something about
releasing early and often comes to mind.

> > > You might define this as a non-technical issue, but the fact that App=
Armor=20
> > > simply does not and can not work is a fairly significant consideratio=
n, I=20
> > > would imagine.
> >=20
> > If I restrict my Mozilla to not access my on-disk mail folder, it can't
> > get there. (Barring bugs in programs which Mozilla is allowed to run
> > unconfined, sure.)
>=20
> Um, no.  It might not be able to directly open files via that path, but
> showing that it can never read or write your mail is a rather different
> matter.
>=20
Actually it can be analyzed and shown.  It is ugly to do and we
currently don't have a tool capable of doing it, but it is possible.

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGe4MQi/GH5xuqKCcRAiz9AKCNyRGp/H/Io8E2dODf7zEaQDXkRgCfX1Tk
oWHzDDECBGlIEtI99Y9q6bw=
=cJaD
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
