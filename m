Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZGOUvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZGOUvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbZGOUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:51:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbZGOUvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:51:46 -0400
Date: Wed, 15 Jul 2009 22:52:20 +0200
From: Kurt Garloff <garloff@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090715205220.GL31657@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com> <4A4DE3C1.5080307@vlnb.net> <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com> <4A51DC0A.10302@vlnb.net> <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com> <4A5238EC.1070505@vlnb.net> <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com> <4A5395FD.2040507@vlnb.net> <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com> <4A5493A8.2000806@vlnb.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4XBiSqiiHCIj6zoM"
Content-Disposition: inline
In-Reply-To: <4A5493A8.2000806@vlnb.net>
X-Operating-System: Linux 2.6.27.23-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4XBiSqiiHCIj6zoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 08, 2009 at 04:40:08PM +0400, Vladislav Bolkhovitin wrote:
> I've also long ago noticed that reading data from block devices is slower=
=20
> than from files from mounted on those block devices file systems. Can=20
> anybody explain it?

Brainstorming:
- block size (reads on the block dev might be done with smaller size)
- readahead (do we use the same RA algo for block devs)
- page cache might be better optimized than buffer cache?

Just guesses from someone that has not looked into that area of the
kernel for a while, so take it with a grain of salt.

Cheers,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--4XBiSqiiHCIj6zoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKXkGExmLh6hyYd04RAmIdAKDO25MtI+jgPE09QrhDPWmUFkLPhwCfbrZO
7h8ZtYqALUktKQZEkthjf10=
=7dKY
-----END PGP SIGNATURE-----

--4XBiSqiiHCIj6zoM--
