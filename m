Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXCPHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXCPHUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXCPHUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:20:21 -0400
Received: from betty.cbit.net.au ([202.55.154.10]:42825 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752962AbXCPHUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:20:19 -0400
Date: Fri, 16 Mar 2007 18:20:10 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       David Woodhouse <dwmw2@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, torvalds@linux-foundation.org
Subject: Re: Make sure we populate the initroot filesystem late enough
Message-ID: <20070316072010.GB30892@keitarou>
References: <1172448057.3971.9.camel@shinybook.infradead.org> <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou> <1172558897.11949.43.camel@localhost.localdomain> <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org> <1172644987.11949.90.camel@localhost.localdomain> <1172657584.3452.51.camel@pmac.infradead.org> <1172709056.5852.6.camel@concordia.ozlabs.ibm.com> <20070312230137.GA8304@keitarou> <1173769429.24454.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <1173769429.24454.61.camel@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 13, 2007 at 08:03:49AM +0100, Benjamin Herrenschmidt wrote:

>> Hmm. The crash came back after I booted into Mac OS X and back. It was h=
owever
>> a different crash, I believe it was coming from the USB modules (as it w=
ould
>> keep going when it happened, and get another crash, which tended to scro=
ll away
>> too fast for me to capture) but I believe it was still getting down into=
 the
>> slab code and actually dying there.

> Have you tried, instead, to apply
> 38f3323037de22bb0089d08be27be01196e7148b ? (That is revert
> 39d61db0edb34d60b83c5e0d62d0e906578cc707).

That's working fine at the moment, and has even survived a trip to Mac
OS X and back.

Thankyou.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+kUqexDuohKLFuARAkOhAJ96GHCCINsGMm2uNjnHnYevyj9sOQCfaX0A
4v0y+0rBJ4ipO5PqzR3LOqI=
=Wn4+
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
