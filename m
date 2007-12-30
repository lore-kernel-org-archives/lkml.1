Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXL3Dob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXL3Dob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXL3DoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:44:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37720 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbXL3DoV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:44:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: dean gaudet <dean@arctic.org>
Cc: David Newall <david@davidnewall.com>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2) to work across --bind mounts ?
In-Reply-To: Your message of "Sat, 29 Dec 2007 12:40:47 PST."
             <alpine.DEB.0.999999.0712291239360.5207@twinlark.arctic.org>
From: Valdis.Kletnieks@vt.edu
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org> <47760578.2090305@davidnewall.com> <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org> <4776AF82.6010808@davidnewall.com>
            <alpine.DEB.0.999999.0712291239360.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198986232_3779P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Dec 2007 22:43:52 -0500
Message-ID: <25388.1198986232@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198986232_3779P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Dec 2007 12:40:47 PST, dean gaudet said:

> > See, this is where you show that you don't understand the system.  I'll
> > explain it, just once.  /var/home contains  home directories.  /var/log and
> > /var/home are on the same filesystem.  So /var/log/* can be linked to
> > /var/home/malicious, and that's just one of your basic misunderstandings.
> 
> yes you are on crack.
> 
> i told you i understand this exactly.  it's right there in the message 
> sent.

So... You understand that if /var/home and /var/log are on one file system,
you can hard-link, and you set your system up knowing that, and then you're
*surprised* that:

> the main worry i have is some user maliciously hardlinks everything
> under /var/log somewhere else and slowly fills up the file system with
> old rotated logs.

"Doctor, it hurts when I do this.." "Well, don't do that then".

I think the first time I saw the recommendation "Put /home on its own
filesystem and don't give users directly writable directories on /var (except
via set-uid helpers) so they can't play hardlink games" back in 1983 or so.
I know that when SunOS 3.1 came out, that was already well-understood basic
sysadmining.  Sometimes, there's actual good reasons behind 20-year-old
voodoo.. ;)

You sure you don't want to redesign your filesystem layout so you don't
have to worry about your malicious users hardlinking stuff? Might be a lot
easier than trying to get the kernel to do what you want in this case....


--==_Exmh_1198986232_3779P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdxP4cC3lWbTT17ARAnI+AKDy+I+wnx4dqqy+xHmBEa501qjWtQCgsWt4
vyEFBWgrsadb6aXHQ8JQY30=
=QkUe
-----END PGP SIGNATURE-----

--==_Exmh_1198986232_3779P--
