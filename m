Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbZLRV4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbZLRV4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZLRV4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:56:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40657 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZLRV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:56:51 -0500
Date: Sat, 19 Dec 2009 08:56:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and
 beg for  mercy
Message-Id: <20091219085640.c3414f51.sfr@canb.auug.org.au>
In-Reply-To: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Dec_2009_08_56_40_+1100_9Li+QtiSlJlAcYMO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Dec_2009_08_56_40_+1100_9Li+QtiSlJlAcYMO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Fri, 18 Dec 2009 09:26:29 -0800 "Luis R. Rodriguez" <mcgrof@gmail.com> w=
rote:
>
> I tend to always be on a 2.6.32 kernel + John's queued up patches for
> wireless for the next kernel release (I use wireless-testing). My
> system is a Thinkpad T61, userspace is Ubuntu 9.10 based (ships with
> git 1.6.3.3) and I kept an ext3 filesystem to be able to go back in
> time to 2.6.27 at will without issues.  I git clone'd linux-next a few
> weeks ago. After a few days I then tried to git pull and my system
> became completely unusable, It took *ages* to open up a terminal and

The start of the daily linux-next boilerplate says:

> If you are tracking the linux-next tree using git, you should not use
> "git pull" to do so as that will try to merge the new linux-next release
> with the old one.  You should use "git fetch" as mentioned in the FAQ on
> the wiki (see below).

(Unfortunately, the wiki seems to be unavailable at the moment)

I am guessing that the merge that git is attempting is killing your
laptop (though besides the number of common commits I am not sure why).
Please try using "get fetch" instead.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__19_Dec_2009_08_56_40_+1100_9Li+QtiSlJlAcYMO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksr+pgACgkQjjKRsyhoI8wH3gCfejvqDRVQt1+FYNTp1VPG0lHO
5X0AnjtcBHhBPkw9CcznM4XEcRuOqroH
=AYM1
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Dec_2009_08_56_40_+1100_9Li+QtiSlJlAcYMO--
