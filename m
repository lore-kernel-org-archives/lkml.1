Return-Path: <linux-kernel-owner+w=401wt.eu-S1763177AbXHABdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763177AbXHABdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXHABd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:33:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52836 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbXHABdZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:33:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: trelane@digitasaru.net
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
In-Reply-To: Your message of "Mon, 30 Jul 2007 22:56:27 CDT."
             <20070731035626.GG6812@digitasaru.net>
From: Valdis.Kletnieks@vt.edu
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk> <20070731034059.GF6812@digitasaru.net> <20070731035023.GI21089@ftp.linux.org.uk>
            <20070731035626.GG6812@digitasaru.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185931991_12501P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 21:33:11 -0400
Message-ID: <13954.1185931991@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185931991_12501P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 Jul 2007 22:56:27 CDT, Joseph Pingenot said:
> From Al Viro on Tuesday, 31 July, 2007:
> >On Mon, Jul 30, 2007 at 10:40:59PM -0500, Joseph Pingenot wrote:
> >> I'm trying to implement pwait.  It blocks until a specified PID exits,
> >>   and then it exits.
> >er... ptrace(2)?
> 
> Should work for most common usage scenarios, although will suspect that it
>   won't for for processes owned by another user (at least, I hope
>   it wouldn't).
> 
> What is dangerous about inotify on a proc file?

And if it's dangerous, should the inotify system call fail when trying to
set the watch?  Bailout with a -EBADIDEA or something?


--==_Exmh_1185931991_12501P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGr+LXcC3lWbTT17ARAtqbAJ94kSIa8Xy8ZizU1edU13gDI3UOiwCcDLy6
m7T3X2f0pOrQbIhZ6qKaKQY=
=VMHn
-----END PGP SIGNATURE-----

--==_Exmh_1185931991_12501P--
