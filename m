Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYBRSOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYBRSOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYBRSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:13:58 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34047 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYBRSN5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:13:57 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Adrian Bunk <bunk@kernel.org>, Roel Kluin <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
In-Reply-To: Your message of "Mon, 18 Feb 2008 14:27:10 GMT."
             <12131.1203344830@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be> <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org> <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org> <47B72BFE.9060302@am.sony.com> <20080216103927.2a02352b@laptopd505.fenrus.org> <1203249003.6718.24.camel@concordia> <20080218135609.GD21080@cs181133002.pp.htv.fi>
            <12131.1203344830@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203358266_2991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 13:11:06 -0500
Message-ID: <26571.1203358266@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203358266_2991P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Feb 2008 14:27:10 GMT, David Howells said:

> __builtin_expect() is useful on FRV where you _have_ to give each branch and
> conditional branch instruction a measure of probability whether the branch
> will be taken.

What does gcc do the 99.998% of the time we don't have likely/unlikely coded?

--==_Exmh_1203358266_2991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHuco6cC3lWbTT17ARAh+cAKD5ET97Gyef5yariQO4KkTKYSAucQCgomsw
NiqkKVG+zUxU2wMpR2NuZbk=
=ycYU
-----END PGP SIGNATURE-----

--==_Exmh_1203358266_2991P--
