Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZG0Wq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZG0Wq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZG0Wqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:46:55 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45708 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZG0Wqz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:46:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+bpsk@trn.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Securing a system with limits.conf
In-Reply-To: Your message of "Sun, 26 Jul 2009 07:10:41 +0300."
             <4A6BD741.2070807@trn.iki.fi>
From: Valdis.Kletnieks@vt.edu
References: <4A6BD741.2070807@trn.iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248734813_3074P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 18:46:53 -0400
Message-ID: <67027.1248734813@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248734813_3074P
Content-Type: text/plain; charset=us-ascii

On Sun, 26 Jul 2009 07:10:41 +0300, =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= said:

> - How should things be configured to reliably prevent non-priveleged 
> users from DoS'ing a machine.

This depends on your threat model.  What are you trying to defend against:

1) Clued user doing something stupid on their laptop?
2) Unclued user doing the same?
3) Clued user who just got bitten by an exploit in Firefox?
4) Clued user doing something stupid on a large database/web server?
5) Malicious user on a multi-user timesharing system?

bash$ :(){ :|:&};:

Consider the above line of bash code, in each of the 5 scenarios. Same
attack, but the configuration settings you use to deal with it may be
vastly different.

Now repeat the analysis, but assume you have a determined attacker who has
acquired access to *3* different logins on the machine and can use them
simultaneously, in collusion.  Now try to come up with a solution that
doesn't annoy the 3 users in question when they're legitimately logged on.

Bottom line: At best, you can make it more difficult for a local user to DoS
the box.  You can't *prevent* it unless you're willing to impose a lot of
limits your users won't like.

And sometimes, the correct security tool is not a system tunable setting,
but a baseball bat.

--==_Exmh_1248734813_3074P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKbi5dcC3lWbTT17ARAo5ZAKCnLTsEBnKWUgeTlvmCvPj6JJJzCwCfUn9S
jMYdFRXhlBhRvgh4GUzbMuM=
=eALL
-----END PGP SIGNATURE-----

--==_Exmh_1248734813_3074P--
