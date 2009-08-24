Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZHXN4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZHXN4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZHXN4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:56:14 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44138 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZHXN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=RWPMtQaSQsqEHLPlr3w4mW8rFzUWlCI1m66gm3YhRg266mwp4bc+BQCDFJzcaYMPid
         +qNb8BMJAIqfODQG8oke6CGUtamgzQ6ca87RAnKnlAjrvhwkXr9l9jAB55WFAXuADSG4
         vpTpER5C7icS7Q1PI+rAtiOA3Sa30CYSDDO9g=
Message-ID: <4A929BF5.2050105@gmail.com>
Date: Mon, 24 Aug 2009 15:56:05 +0200
From: Stefan Huber <shuber2@gmail.com>
Reply-To: shuber2@gmail.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>,
       James Morris <jmorris@namei.org>, William Irwin <wli@movementarian.org>,
       Mel Gorman <mel@csn.ul.ie>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call (fwd)
References: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org> <Pine.LNX.4.64.0908241258070.27704@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908241258070.27704@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigE64C7769F176B869D162D009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE64C7769F176B869D162D009
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> However, though I can well believe that your patch works well for you,
> I don't think it's general enough: there is no guarantee that the tests=

> in can_do_hugetlb_shm() will give the same answer to the user who ends
> up calling shm_destroy() as it did once upon a time to the user who
> called hugetlb_file_setup().
>=20
> So, please could you try this alternative patch below, to see if it
> passes your testing too, and let us know the result?  I'm sure we'd
> like to get a fix into 2.6.31, and into 2.6.30-stable.


Yes, your observation is right and your modified patch works good for
me.

So long
Stefan




--------------enigE64C7769F176B869D162D009
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkqSm/oACgkQluL3b44/h0ofQwCeJ6vUjbAZZc13APFOUMZNOTbI
eqYAoKhtPiHynuffJAKHZFYjEDRgEpTQ
=mRoT
-----END PGP SIGNATURE-----

--------------enigE64C7769F176B869D162D009--
