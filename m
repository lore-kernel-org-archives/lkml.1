Return-Path: <linux-kernel-owner+w=401wt.eu-S971082AbXHMSdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971082AbXHMSdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032780AbXHMSLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:11:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45648 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032769AbXHMSLo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:11:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
In-Reply-To: Your message of "Mon, 13 Aug 2007 10:09:08 PDT."
             <2c0942db0708131009y6f1c4cc4n59d8b36943643955@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1186984174.10249.7.camel@localhost>
            <2c0942db0708131009y6f1c4cc4n59d8b36943643955@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187028697_3175P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 14:11:37 -0400
Message-ID: <17264.1187028697@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187028697_3175P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Aug 2007 10:09:08 PDT, Ray Lee said:
> On 8/12/07, Joe Perches <joe@perches.com> wrote:
> > I grew weary of looking up the appropriate
> > maintainer email address(es) to CC: for a patch.
> >
> > I added flags to the MAINTAINERS file
> >
> > F:      file pattern
> >
> > for each maintained block and a script to parse
> > the modified blocks for maintainer and list
> > email addresses.
> 
> Why not parse git annotate or blame instead (other than it's freakin'
> slow)? Using the repository history has the added benefit of telling
> you a lot more fine-grained detail about who may want to know about
> your patch.

1) Not everybody wants to install git and pull down the whole kernel tree
just so they can do 'git blame' and point the report at the right cc:'s.
(Heck, *I* don't even have a 'git pull' of the kernel handy, and I probably
whinge about a lot more stuff than the average person reporting a bug)

2) A quick 'grep git' through Documentation/ doesn't find any actual mention
of how to find a web page that will do a 'git blame' for you.

I posit that if you want users to point bug reports at the correct cc:'s,
all the information needed has to be in the distributed linux-2.6.foo.tar file
(I'd allow that a functional "Go to this URL" suffices for this).


--==_Exmh_1187028697_3175P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwJ7ZcC3lWbTT17ARAh4bAKDS+J2+n9Wm+Qz4leo//+IjYMPspACePP3D
ChwtqXSOu8rP/J92b2TulG4=
=MdWa
-----END PGP SIGNATURE-----

--==_Exmh_1187028697_3175P--
