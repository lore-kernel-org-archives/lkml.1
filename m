Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbXKONiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbXKONiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbXKONiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:38:03 -0500
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:40461 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbXKONh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:37:58 -0500
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 08:37:57 EST
From: Michael Gerdau <mgerdau@tiscali.de>
To: Philippe Elie <phil.el@wanadoo.fr>
Subject: Re: OT: Does Linux have any "Perfect Code"
Date: Thu, 15 Nov 2007 14:16:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Russell Leighton <russ@elegant-software.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com> <20071115082746.GA2885@zaniah>
In-Reply-To: <20071115082746.GA2885@zaniah>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2797104.O5VQu9QCGi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711151416.54570.mgerdau@tiscali.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2797104.O5VQu9QCGi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> This code is far to be perfect, some part is outdated, bcopy() use instead
> of memcpy() for example. More annoying are the comment, the file is 3306
> lines while there is only 1640 line of code, nothing bad per se but looki=
ng
> some comments:
>=20
>  		/*
>  		 * Before we begin this operation, disable kernel preemption.
>  		 */
>  		kpreempt_disable();
>=20
>=20
> uhh...
>=20
> or=20
>=20
>  	if (cyclic->cy_pend !=3D 0) {
> 		/*
>  		 * The pend is non-zero; ...
>=20
> I will never guessed that, w/o the comment :)

<disclaimer>
I'm not a kernel developer.
</disclaimer>

That having said:
I really do like such obvious (as in: for those knowing the stuff anyway)
comments when looking at code and probably concepts I'm not familiar with.

IMO there is no need to belittle this type of comment. IMO any casual
reader not familiar with the whole set of functions possibly involved
will be thankful for this type of comment - I certainly am.

>  		/*
>  		 * We have both a left and a right child.  We need to compare
>  		 * the expiration times of the children to determine which
>  		 * expires earlier.
>  		 */
>  		if (cyclics[right].cy_expire < cyclics[left].cy_expire) {
>=20
> writing array[index] in C is already a promise than index is in
> [0-array size)

Yes. And ?


=46WIW whenever I tried to look at kernel code I'm usually facing the
decision to
=2D either give up trying to understand what is intended or
=2D do a thorough search to learn everything required

I usually give up due to time constraints.

I mean, isn't the whole purpose of comments to help those not familiar
with the code to understand it's purpose and possibly the intention of
the author (just in case the author had coded a bug) ?

=46rom my PoV this establishes a steep learning curve for "outsiders" to
start working on the kernel.
[just in case: don't give me anything along the line "this is an inherent
test as to the fitness of the potential hacker" ;]

Just my thoughts,
Michael
=2D-=20
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgerdau@tiscali.de
 GPG-keys available on request or at public keyserver

--nextPart2797104.O5VQu9QCGi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHPEbGUYYhyuxDQc4RApjWAJ40RlYkXB/6KVa/OUZq9jf1kg1ORgCfVcIe
MmdIHwyVfeiU+R9TDNpYgWU=
=oQuB
-----END PGP SIGNATURE-----

--nextPart2797104.O5VQu9QCGi--
