Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYBTG6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYBTG6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYBTG6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:58:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55930 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYBTG6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:58:10 -0500
Date: Wed, 20 Feb 2008 17:57:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 20
Message-Id: <20080220175756.ab1ada1d.sfr@canb.auug.org.au>
In-Reply-To: <20080220055055.GC31832@kroah.com>
References: <20080220163457.79b9189f.sfr@canb.auug.org.au>
	<20080220055055.GC31832@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Feb_2008_17_57_56_+1100_Obz/34IqPXl9OJVY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2008_17_57_56_+1100_Obz/34IqPXl9OJVY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Feb 2008 21:50:55 -0800 Greg KH <greg@kroah.com> wrote:
>
> What's the best way to constantly follow this tree?  I had cloned it a
> while ago, but now if I 'git pull' it wants to merge things, which isn't
> right.
>=20
> I'm guessing that this is constantly being rebased?  Against what,
> Linus's tree?  So we should be able to clone Linus's tree, and then pull
> in -next?

That would work.  Chris has the right idea, though.  Just set up
linux-next as a remote on any existing clone of Linus' tree and the
"fetch" will forcibly update the linux-next/master branch (remember to
not have that branch checked out when you fetch).

If you keep a continuing git tree for this, you will have the history of
all the next trees because I tag each one.

> Or am I totally missing something here?

I said in the original announcement that the "master" branch would be
rebasing every day (well, I actually said that I would recreate the tree
every day).

Each day, I start with the latest version of Linus' tree (my "stable"
branch) and then merge all the subsystem trees on that.

> I like seeing these, to know that things are at least still working.  I
> imagine you could script them, or just send them to the linux-next list
> if there are no problems, but lkml should probably be notified of any
> issues, right?

Sounds like a plan.  So new "normal" announcements will happen on the
linux-next mailing list and "abnormal" ones to LKML as well (at least).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Feb_2008_17_57_56_+1100_Obz/34IqPXl9OJVY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHu894TgG2atn1QN8RApNqAJwPTyJXgm4ytu25ZenpdICIZglLRQCeKrQJ
QHai54XgLD2F3faxC3h1xK0=
=5XUE
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2008_17_57_56_+1100_Obz/34IqPXl9OJVY--
