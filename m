Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXHQExW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXHQExW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXHQExM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:53:12 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45862 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbXHQExK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:53:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: Your message of "Thu, 16 Aug 2007 21:24:22 PDT."
             <826926.60792.qm@web52510.mail.re2.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <826926.60792.qm@web52510.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187326371_6461P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 00:52:51 -0400
Message-ID: <21543.1187326371@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187326371_6461P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Aug 2007 21:24:22 PDT, Marc Perkel said:

> And then everything that's stored as /1/2/3/4 is still
> the same but the sections resolve to different names.
At that point, you need to go re-think your full-pathname permission scheme,
because that severely broke it.

> I'm sure there are errors in my logic but I'm trying
> to show that if you are persistent in trying to come
> up with ideas on how to do something you will
> eventually make it work.

Not true - there are *large* fields where *no* amount of persistence will
make it work - squaring a circle or trisecting an angle by geometric means,
perpetual motion machines, and many broken-as-designed computer programs.

>                           But if you are looking for
> ways to make it not work then you probably won't solve
> it.

Right.  It's not *our* job to solve your problem. It's *our* job to find
ways to not make it work - those are called *bugs*.  We try very hard to keep
buggy code and ideas out of the kernel.  So we make it difficult for bugs.

> So the correct response to this message isn't to prove
> that my method won't work, but to come up with a

You're the one proposing something.  *You* get to come up with something
that works.  It's *our* job to review and comment and point out problems.
You want to get something to happen, you take the comments, and use them
to improve the result. We point out every possible issue we can find (and
maybe suggest ways to fix them). That's what code review is about.

And if you think people like me and Kyle are rough on you, I suggest you go
back in the archives and read what people like Al Viro and Chris Hellwig
had to say about ReiserFS4.  And *that* was not just a hand-wave like
you're doing, that was an actual *working* filesystem.

> method that will work. You have to look for a solution
> rather than attack other people's solutions.

No, *you* have to look for a solution that is good enough to withstand the
combined scrutiny of everybody on the linux-kernel list.  That's why Linux
works, and why we're able to have several *million* lines of changes between
2.6.2N and 2.6.2(N+1), and only have several dozen things on the "known
regressions" list.

> That's what thinking outside the box means.
> 
> Impossible = Challenge

Good. Let us know when you come up with something that actually works.



--==_Exmh_1187326371_6461P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxSmjcC3lWbTT17ARAmUUAKCBvKixm2Q9qZJZ+60HCO6GIYztzACgomj1
UPtVZ+Mb7uFIQiTIHOCwyOY=
=jctq
-----END PGP SIGNATURE-----

--==_Exmh_1187326371_6461P--
