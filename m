Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096Ab0ADFRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab0ADFRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964Ab0ADFR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:17:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0ADFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:17:28 -0500
Date: Mon, 4 Jan 2010 16:17:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for
 POSIX_FADV_RANDOM
Message-Id: <20100104161719.a0bb35ad.sfr@canb.auug.org.au>
In-Reply-To: <20100104045020.GA21021@localhost>
References: <20091225000717.GA26949@yahoo-inc.com>
	<87aax18xms.fsf@basil.nowhere.org>
	<20091230051540.GA16308@localhost>
	<20091230052402.GB26364@localhost>
	<873a2s8hmp.fsf@basil.nowhere.org>
	<20100104045020.GA21021@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jan_2010_16_17_19_+1100_oQXHM_dh_ML2_Wjk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jan_2010_16_17_19_+1100_oQXHM_dh_ML2_Wjk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wu,

On Mon, 4 Jan 2010 12:50:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>
> --- linux.orig/include/asm-generic/fcntl.h	2010-01-04 12:39:29.000000000 =
+0800
> +++ linux/include/asm-generic/fcntl.h	2010-01-04 12:40:11.000000000 +0800
> @@ -80,6 +80,10 @@
>  #define O_NDELAY	O_NONBLOCK
>  #endif
> =20
> +#ifndef O_RANDOM
> +#define O_RANDOM	010000000	/* random access pattern hint */
> +#endif

This value conflicts with O_CLOEXEC on alpha and parisc and O_NOATIME on
sparc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jan_2010_16_17_19_+1100_oQXHM_dh_ML2_Wjk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktBed8ACgkQjjKRsyhoI8wIEQCeNMjDV1v8tte7KqFHMMs7jBRA
efEAn2xEHcGVeoCws3CkP/C9cLxVpZsi
=qvHN
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jan_2010_16_17_19_+1100_oQXHM_dh_ML2_Wjk--
