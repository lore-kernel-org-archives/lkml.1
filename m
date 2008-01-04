Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYADU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYADU2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYADU2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:28:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38312 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYADU2L (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:28:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Do people exaggerate in security advisories?
In-Reply-To: Your message of "Fri, 04 Jan 2008 13:21:32 +0100."
             <fll7u3$p02$1@ger.gmane.org>
From: Valdis.Kletnieks@vt.edu
References: <fll7u3$p02$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199478488_8220P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Jan 2008 15:28:08 -0500
Message-ID: <20820.1199478488@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199478488_8220P
Content-Type: text/plain; charset=us-ascii

On Fri, 04 Jan 2008 13:21:32 +0100, Manuel Reimer said:

> Is it really possible to get root privileges with this bug or are there 
> people who just write "may be used to escalate privileges" near any bug 
> which has something to do with "setuid" or "setgid"?

It looks like it really *is* possible to do some damage, if you can make
several things happen:

1) Cause set[ug]id() to fail, possibly using a crafted 'capabilities' list.
2) Get it to invoke a helper that's now running with different permissions than
it was designed to, and feed said helper some carefully crafted malicious or
bogus data.

Given that it is semantically almost identical to the Sendmail-capabilities
bug from a few years ago, which was *certainly* abusable to get root, it would
be foolish to think anything *except* "this sucker should be assumed to be
a root exploit until *proven* otherwise".  Anybody who thinks "I don't see
how to exploit it, so it can't be done" is in for a rude surprise....

--==_Exmh_1199478488_8220P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHfpbYcC3lWbTT17ARAs/RAKCvR9UtXwxGG0tXJM248dEZA7BkJgCfZ9Hl
b3xf0K2WY3BXpyKk17cLWHs=
=Hgbd
-----END PGP SIGNATURE-----

--==_Exmh_1199478488_8220P--
