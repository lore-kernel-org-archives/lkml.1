Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZK0EWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZK0EWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZK0EWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:22:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39758 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZK0EWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:22:12 -0500
Date: Fri, 27 Nov 2009 15:22:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       =?UTF-8?B?IkFuw61iYWwgTW9uc2FsdmUg?= =?UTF-8?B?U2FsYXphciI=?= 
	<anibal@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-kbuild.git
Message-Id: <20091127152211.55043dbb.sfr@canb.auug.org.au>
In-Reply-To: <20091126193750.GA15453@merkur.ravnborg.org>
References: <4B0E73E1.50900@suse.cz>
	<20091126193750.GA15453@merkur.ravnborg.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_15_22_11_+1100_gxWKPyByXDZsZToy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_15_22_11_+1100_gxWKPyByXDZsZToy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Thu, 26 Nov 2009 20:37:50 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Thu, Nov 26, 2009 at 01:26:09PM +0100, Michal Marek wrote:
> >=20
> > I went through the patches posted to linux-kbuild and picked those that
> > were easy enough to review, looked safe and worked for me. I also took
> > Sam's series from kbuild-next.git, but I didn't really review it yet, so
> > there is no signoff from me (TBD). The repo is at
> >=20
> >   git://repo.or.cz/linux-kbuild.git for-next
>=20
> Looks good.
> Good to see you picked up some of the patches that were pending.
>=20
> Stephen - please replace my kbuild trees with this.

I have replaced this from today.  Do you intend to run the equivalent of
the kbuild-current tree (bug fixes for the current release while they are
waiting to go to Linus)?  I have removed the kbuild-current tree for now
since the only commit in it is in the new kbuild tree.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__27_Nov_2009_15_22_11_+1100_gxWKPyByXDZsZToy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksPU/MACgkQjjKRsyhoI8yQYQCgiDBjkauTqRCkX+vKVgJId4lo
/kkAn0Zl8Anz+qfkn456wk+BICxMlhUD
=8WMO
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_15_22_11_+1100_gxWKPyByXDZsZToy--
