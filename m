Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411Ab0AEC2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0AEC2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018Ab0AEC2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:28:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43311 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0AEC2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:28:31 -0500
Date: Tue, 5 Jan 2010 13:28:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC][PATCH v4] readahead: introduce O_RANDOM for
 POSIX_FADV_RANDOM
Message-Id: <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
In-Reply-To: <20100105022650.GB29428@localhost>
References: <20091225000717.GA26949@yahoo-inc.com>
	<87aax18xms.fsf@basil.nowhere.org>
	<20091230051540.GA16308@localhost>
	<20091230052402.GB26364@localhost>
	<873a2s8hmp.fsf@basil.nowhere.org>
	<20100104045020.GA21021@localhost>
	<20100104161719.a0bb35ad.sfr@canb.auug.org.au>
	<20100104073328.GA3422@infradead.org>
	<20100104125620.GB12266@localhost>
	<20100105130322.006c03ee.sfr@canb.auug.org.au>
	<20100105022650.GB29428@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jan_2010_13_28_24_+1100_fVcy5Jo_WYOru8Rm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jan_2010_13_28_24_+1100_fVcy5Jo_WYOru8Rm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

On Tue, 5 Jan 2010 10:26:50 +0800 Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>
> Where is it? I cannot grep find one in arch/.
> There is one defined in include/asm-generic/fcntl.h:
>=20
> #ifndef O_SYNC
> #define __O_SYNC        04000000
> #define O_SYNC          (__O_SYNC|O_DSYNC)
> #endif
>=20
> However it has one less '0' :)

Search for 0x800000 ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jan_2010_13_28_24_+1100_fVcy5Jo_WYOru8Rm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktCo8gACgkQjjKRsyhoI8zuUwCeJbrJPfcwKe4it3Z/c8Cx/q8u
HgUAoJgF2J5iP/57GwXBYdDCG+Q1cTGq
=68mU
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jan_2010_13_28_24_+1100_fVcy5Jo_WYOru8Rm--
