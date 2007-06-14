Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXFNPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXFNPrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXFNPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:47:06 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:43439 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbXFNPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:47:05 -0400
Date: Thu, 14 Jun 2007 17:44:48 +0200
From: markus reichelt <ml@mareichelt.de>
Subject: Re: /dev/loop* devices not appearing in /dev (at least since
 2.6.22-rc3*)
In-reply-to: <20070614172234.7f636307@localhost>
To: linux-kernel@vger.kernel.org
Mail-followup-to: linux-kernel@vger.kernel.org
Message-id: <20070614154448.GC4155@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=WhfpMioaduB5tiZL
Content-disposition: inline
X-IronPort-AV: E=Sophos;i="4.16,421,1175472000";   d="scan'208";a="2216884"
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
 <20070614145206.58fdec91@localhost>
 <e85b9d30706140710x5671fa12n5845172d4ce32a10@mail.gmail.com>
 <20070614172234.7f636307@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Paolo Ornati <ornati@fastwebnet.it> wrote:

> So with this patch "max_loop=3D32" will create 32 loop devices... but
> then it doesn't allow more of them.

Well, that's what a max_ parameter implies ;p

A manually set limit of loop devices is ok with me. (32 was just an
example -- After all, I could have chosen 256 just to annoy some
people :-)

And with the recent hype of creating things when needed, or even
recycling already used ones (sdx), I worry that this impacts
stability or even usability as a whole. (yes, it's a -rc release ...)

I'll be staying with 2.6.20.x for a year or so. Get the newly
introduced bugs squashed before they have a chance to bug me, heh ;P


PS: Just wondering: Who came up with this "on-demand" hype?
--=20
left blank, right bald

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGcWJwLMyTO8Kj/uQRAogiAKCCDBL6+hYIHOI06BGu+zRStB76lgCdEbNG
HRb5VicLNiB6H4PFsSffT2E=
=WCRL
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
