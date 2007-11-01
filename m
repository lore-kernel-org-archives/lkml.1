Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXKAOOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXKAOOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXKAOOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:14:15 -0400
Received: from iucha.net ([209.98.146.184]:53951 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXKAOOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:14:14 -0400
Date: Thu, 1 Nov 2007 09:14:14 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071101141414.GZ25561@iucha.net>
References: <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ul2mxMk0z4RYCW0d"
Content-Disposition: inline
In-Reply-To: <E1InZht-0004lr-NN@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Ul2mxMk0z4RYCW0d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 01, 2007 at 09:03:33PM +0800, Fengguang Wu wrote:
> Or will the system or fs size/age make any difference? If you happen
> to have a spare/swap partition, could you make a new reiserfs and
> mount it and copy several less-than-4KB files into it and wait for 30s
> and see what happen to pdflush?

I will try that with a USB disk - I hope that won't make a difference.

> btw, what's the exact kernel version you are running?

I noticed it with the kernel in the $SUBJECT, as reported by 'git
describe'.  I have pulled in new changesets since then.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--Ul2mxMk0z4RYCW0d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKd81ND0rFCN2b1sRAvvhAJ9C4t6K8ht6nl+p4UJM3Y0Pthbj3wCeJB8s
9XYgzgx2+88n+EV9g6GBcHs=
=gNaN
-----END PGP SIGNATURE-----

--Ul2mxMk0z4RYCW0d--
