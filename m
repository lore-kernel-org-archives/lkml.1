Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203Ab0AECDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0AECDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640Ab0AECDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:03:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35740 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0AECDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:03:34 -0500
Date: Tue, 5 Jan 2010 13:03:22 +1100
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
Message-Id: <20100105130322.006c03ee.sfr@canb.auug.org.au>
In-Reply-To: <20100104125620.GB12266@localhost>
References: <20091225000717.GA26949@yahoo-inc.com>
	<87aax18xms.fsf@basil.nowhere.org>
	<20091230051540.GA16308@localhost>
	<20091230052402.GB26364@localhost>
	<873a2s8hmp.fsf@basil.nowhere.org>
	<20100104045020.GA21021@localhost>
	<20100104161719.a0bb35ad.sfr@canb.auug.org.au>
	<20100104073328.GA3422@infradead.org>
	<20100104125620.GB12266@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jan_2010_13_03_22_+1100_1IZ=G_RNQZAHQZFI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jan_2010_13_03_22_+1100_1IZ=G_RNQZAHQZFI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Jan 2010 20:56:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>
> For now I'll use bit 040000000, which happen to equal to
> FMODE_NONOTIFY and will be masked out by __dentry_open()
> in the very beginning.

But also clashes with __O_SYNC on sparc, sorry.  I am not sure how we are
meant to reasonably choose these values any more ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jan_2010_13_03_22_+1100_1IZ=G_RNQZAHQZFI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktCneoACgkQjjKRsyhoI8xVIQCeKIVdZGKo2winQKhHWr/E1W7w
HfoAn3B4YGCetSpmocW4juILbASNMhcv
=L1dl
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jan_2010_13_03_22_+1100_1IZ=G_RNQZAHQZFI--
