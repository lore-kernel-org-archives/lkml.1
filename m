Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXFBHkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXFBHkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXFBHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:40:32 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:57054 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbXFBHkc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:40:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Sat, 02 Jun 2007 04:30:30 -0000."
             <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
From: Valdis.Kletnieks@vt.edu
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu>
            <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180770021_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 02 Jun 2007 03:40:21 -0400
Message-ID: <14604.1180770021@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180770021_4213P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 04:30:30 -0000, David Wagner said:
> I don't find the Windows stuff too relevant here.

I'm surprised.  The only Windows-specific thing in the whole paragraph is that
the attack described is currently wildly successful. And there *have* been
known exploitable bugs in the Linux version of Firefox. In other words, all the
pieces are in place for exactly the same thing to work on Linux.

The type of hardening that AppArmor can provide network-facing daemons is only
protecting the system against attacks that aren't even a large part of the
threat model.   Exploiting a broken PHP script? Happens all the time, and
AppArmor can't do much for it.  SQL injection? Happens all the time, and it
can't help much there either.  Systems getting pwned because the sysadmin's
laptop got hacked? Pretty common, and another thing that AppArmor won't slow
down. But yes, I *will* grant that the next time there's a buffer overflow in
Apache, AppArmor will be able to help *that*....

>                                                    As I understand it,
> AppArmor isn't aimed at defending Windows desktop users; it is aimed at
> defending Linux servers.  A pretty different environment, I'd say.

The only reason you're not seeing the same exact threat model against Linux
servers is because it's still a minority.  It's *always* been true that one of
the most productive attacks on a server has been to find a desktop that you can
attack, and then abuse a trust relationship from the desktop to the server (and
has been, ever since the server was a IBM mainframe and the desktop was an RJE
station.  Amazing how trusting OS/360 was of a card deck tossed into a remote
card reader... :)

> Ultimately, there are some things AppArmor may be good at, and there
> are also sure to be some things it is bloody useless for.  My hammer
> isn't very good for screwing in screws, but I still find it useful.

The question is whether it's a hammer, a screwdriver, or that coping saw that
you never seem to find a use for...

> I confess I don't understand the kvetching about AppArmor's goals.
> What are you expecting, some kind of silver bullet?

Exactly the opposite - I'm worried that it will be treated as a silver bullet.

And historically, we've had an amazing amount of pushback againt things that
are intrusive and only provide a partial solution.



--==_Exmh_1180770021_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYR7kcC3lWbTT17ARAo3RAJ9VGHOCzhLQ8pDFi1Zh2QCGysRFPwCggm5x
7BQAN/LjX7YvcMth46D+WrQ=
=J/V6
-----END PGP SIGNATURE-----

--==_Exmh_1180770021_4213P--
