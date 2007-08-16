Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXHPDnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXHPDnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765988AbXHPDmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:42:52 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55893 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbXHPDmv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:42:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marc Perkel <mperkel@yahoo.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: Your message of "Wed, 15 Aug 2007 15:48:15 PDT."
             <291255.29775.qm@web52505.mail.re2.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <291255.29775.qm@web52505.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187235765_11310P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Aug 2007 23:42:45 -0400
Message-ID: <15627.1187235765@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187235765_11310P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Aug 2007 15:48:15 PDT, Marc Perkel said:
> > Consider the rules:
> > 
> > peter '*a*' can create
> > peter '*b*' cannot create
> > 
> > Peter tries to create 'foo-ab-bar' - is he allowed
> > to or not?
> > 
> 
> First - I'm proposing a concept, not writing the
> implementation of the concept. You are asking what
> happens when someone write conflicting rules. That
> depends on how you implement it. Conflicting rules can
> cause unpredictable results.

Good. Go work out what the rules have to be in order for the system to
behave sanely.  "Hand-waving concept" doesn't get anywhere.  Fully fleshed-out
concepts sometimes do - once they sprout code to actually  implement them.

> The point is that one can choose any rule system they
> want and the rules applies to the names of the files
> and the permissions of the users.

No, you *can't* choose any rule system you want - some rule systems are
unworkable because they create security exposures (usually of the
"ln /etc/passwd /tmp/foo" variety, but sometimes race conditions as well).

> > For an exersize, either write a program or do by
> > hand:

> All you would have to do is create a set of rules that
> emulates the current rules and you would have the same
> results.

Good. Go create it. Let us know when you're done.  Remember - not only do
you need to have it generate the same results, you need to find a way to
implement it so that it's somewhere near the same speed as the current code.
If it's 10 times slower, it's not going to fly no matter *how* "cool" it is.

--==_Exmh_1187235765_11310P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGw8e1cC3lWbTT17ARAtrOAKDTfpTe433Ny7O3DQA4x6v0Bs6fZwCg+l23
aRfJlP3MKT+sqXp4KS8rDOQ=
=aF1w
-----END PGP SIGNATURE-----

--==_Exmh_1187235765_11310P--
