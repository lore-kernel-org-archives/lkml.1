Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYGYJlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYGYJlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYGYJlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:41:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:45933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbYGYJlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:41:09 -0400
From: Andreas Jaeger <aj@novell.com>
To: "Michael Kerrisk" <mtk.manpages@gmail.com>
Cc: "Fabian Kreutz" <kreutz@dbs.uni-hannover.de>,
       "Andries Brouwer" <Andries.Brouwer@cwi.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: math_error.7 draft 3, for review
References: <cfd18e0f0807160647o776d8523yb2f1ed4f0d946911@mail.gmail.com>
	<cfd18e0f0807210314s6556f15bue41b1af46e28f77d@mail.gmail.com>
	<517f3f820807210326x30ce95dayf18d72ba0ce03588@mail.gmail.com>
OpenPGP: id=C272A126; url=http://www.suse.de/~aj/keys.txt
Mail-Followup-To: "Michael Kerrisk" <mtk.manpages@gmail.com>,
	"Fabian Kreutz" <kreutz@dbs.uni-hannover.de>,
	"Andries Brouwer" <Andries.Brouwer@cwi.nl>,
	lkml <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jul 2008 11:41:00 +0200
In-Reply-To: <517f3f820807210326x30ce95dayf18d72ba0ce03588@mail.gmail.com>
	(Michael Kerrisk's message of "Mon, 21 Jul 2008 12:26:49 +0200")
Message-ID: <m3r69ib8sz.fsf@gromit.moeb>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

"Michael Kerrisk" <mtk.manpages@gmail.com> writes:

> [ooops -- sorry for the noise.  Wrong list CCed]
>
> On 7/21/08, Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>> Andreas,
>>
>>  The latest version of the page is below.
>>
>>  =3D=3D=3D
>>
>>  Hi Andreas,
>>
>>  (Andries suggested that you probably have the background knowledge to
>>  help here.)
>>
>>  The math man pages in man-pages are in a somewhat sorry state, with
>>  respect to the following:
>>
>>  * Few of the pages properly describe the special cases for Inf, -Inf,
>>  NaN arguments (e.g., compare "man 3 log" with the POSIX.1 page "man 3p
>>  log").
>>
>>  * There isn't a clear discussion of error cases, and how to determine
>>  if an error occurrred using errno and/or fetestexcept(3).
>>
>>  I'm planning to fix each of the math man pages to address these
>>  issues, and use a new page, math_error.7, as an anchor page referenced
>>  by all of the math pages for discussion of how to handle errors.
>>
>>  Would you be willing to review this new page (below) to see whether it
>>  correctly describes the glibc details?  Might you also be willing to
>>  look at a sampling of the changed math page pages that I'll make later
>>  this week/early next week in order to let me know I'm on the right
>>  track in terms of the changes I'm making?

In general glibc should follow the ISO C99 and Posix Standards and if
there is any discrepancy between those and the glibc implementation,
it's a bug.  That should help you to verify the details as well.

I'll try to answer questions and should be able to look at them but I
cannot double check each and every case myself.


>>  .I math_errhandling
>>  identifier,
>>  which is supposed to indicate which of these two mechanisms is in use;
>>  the standards require that at least one be in use,
>>  but permit both to be available.
>>  Although glibc does not support this identifier,
>>  in practice it supports both mechanisms.

I just noticed something that's also in draft 4, so let me cite from the
CONFORMANCE file of glibc:

   Implementing MATH_ERRNO, MATH_ERREXCEPT and math_errhandling in
   <math.h> needs compiler support: see
=20=20=20
   http://sources.redhat.com/ml/libc-hacker/2000-06/msg00008.html
   http://sources.redhat.com/ml/libc-hacker/2000-06/msg00014.html
   http://sources.redhat.com/ml/libc-hacker/2000-06/msg00015.html

I check gcc and glibc and this is still missing,

Andreas
=2D-=20
 Andreas Jaeger, Director Platform/openSUSE, aj@suse.de
  SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
   Maxfeldstr. 5, 90409 N=FCrnberg, Germany
    GPG fingerprint =3D 93A3 365E CE47 B889 DF7F  FED1 389A 563C C272 A126

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFIiZ+tOJpWPMJyoSYRAhFGAKCDKOdOfF5MT0MHDQ1lD6jv4fnamgCePvic
kB7vf4rJBPWb2qph4GnArlU=
=u0HO
-----END PGP SIGNATURE-----
--=-=-=--
