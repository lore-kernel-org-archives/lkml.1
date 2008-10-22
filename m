Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYJVAmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYJVAmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 20:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYJVAl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 20:41:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45389 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYJVAl5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 20:41:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alex Howells <alex@bytemark.co.uk>
Cc: Greg KH <greg@kroah.com>, Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: Your message of "Tue, 21 Oct 2008 20:52:02 BST."
             <48FE32E2.5000601@bytemark.co.uk>
From: Valdis.Kletnieks@vt.edu
References: <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk> <20081020202147.GA20788@kroah.com>
            <48FE32E2.5000601@bytemark.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1224636084_22260P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 20:41:24 -0400
Message-ID: <33098.1224636084@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1224636084_22260P
Content-Type: text/plain; charset=us-ascii

On Tue, 21 Oct 2008 20:52:02 BST, Alex Howells said:
> Requirements for me to put a kernel on a given server would be:

>     *  supports the hardware
The problem is that "supports" is often a fuzzy jello-like substance you
try to nail to a tree.  You mention the R8169 and e1000 drivers - if they
bring the device up, but have issues under corner cases, is that "supports"
or not?

>     *  no security holes [in options I enable]
Similarly for "no security holes".  At *BEST*, you'll get "no *known* *major*
security holes", unless you feel like auditing the entire source tree.  There's
a whole slew of bugs that we can't even agree if they *are* security bugs or
just plain bugs - see Linus's rant on the subject a few months back.

>     *  works reliably, under load/stress.
And you win the trifecta - I don't think we've *ever* shipped a Linux kernel
that worked reliably under the proper "beat on the scheduler/VM corner case"
load/stress testing.  Again, the best you can hope for is "doesn't fall over
under non-pathological non-corner-case loads when sufficient resources are
available so the kernel has a fighting chance".  Doing 'make -j100' on a
single Core2 Duo is gonna be painful, no matter what.


--==_Exmh_1224636084_22260P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI/na0cC3lWbTT17ARAl/NAKDqt+/Z3WbNk8obIJGE7S+qDQVVqQCfabIk
VroOeOk36IVlE9RW6xxlpwo=
=wAI5
-----END PGP SIGNATURE-----

--==_Exmh_1224636084_22260P--
