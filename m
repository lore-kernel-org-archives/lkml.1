Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXKKDzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXKKDzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXKKDzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:55:05 -0500
Received: from ns.suse.de ([195.135.220.2]:52413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXKKDzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:55:03 -0500
Date: Sat, 10 Nov 2007 19:55:12 -0800
From: John Johansen <jjohansen@suse.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Crispin Cowan <crispin@crispincowan.com>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071111035512.GC19216@suse.de>
References: <47363381.4030103@crispincowan.com> <601618.10362.qm@web36602.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <601618.10362.qm@web36602.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2007 at 06:17:30PM -0800, Casey Schaufler wrote:
>=20
> --- Crispin Cowan <crispin@crispincowan.com> wrote:
>=20
> > Dr. David Alan Gilbert wrote:
> > ...
> >
> > Can you explain why you want a non-privileged user to be able to edit
> > policy? I would like to better understand the problem here.
> >=20
> > Note that John Johansen is also interested in allowing non-privileged
> > users to manipulate AppArmor policy, but his view was to only allow a
> > non-privileged user to further tighten the profile on a program. To me,
> > that adds complexity with not much value, but if lots of users want it,
> > then I'm wrong :)
>=20
> Now this is getting interesting. It looks to me as if you've implemented
> a mandatory access control scheme that some people would like to be able
> to use as a discretionary access control scheme. This is creepy after
> seeing the MCS implementation in SELinux, which is also a DAC scheme
> wacked out of a MAC scheme. Very interesting indeed.
>=20
hehe perhaps.  There are lots of issues involved with doing something
like this and there are more important issues to address first.
I also don't see it so much of a DAC scheme as a user defining a MAC
for their own processes they don't trust.  An application so confined
would not have the ability to change its confinement.

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHNn0gi/GH5xuqKCcRAgCEAJ4tYWm05CIIgkNTV2LyilKQhYth+gCdEE05
4Qk61S8Ki8lofEfq3jpbuZ8=
=9hwT
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
