Return-Path: <linux-kernel-owner+w=401wt.eu-S936647AbZDIWce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936647AbZDIWce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbZDIWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:32:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43980 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZDIWcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:32:23 -0400
Date: Fri, 10 Apr 2009 08:32:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] sparc64: extend TI_RESTART_BLOCK space by 8
 bytes
Message-Id: <20090410083209.03dbd756.sfr@canb.auug.org.au>
In-Reply-To: <49DE12DD.1040802@us.ibm.com>
References: <20090409151722.c8eabb56.sfr@canb.auug.org.au>
	<tip-d2de688891909b148efe83a6fc9520a9cd6015f0@git.kernel.org>
	<49DE12DD.1040802@us.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Apr_2009_08_32_09_+1000_ws2BUGWRQOzAJuyO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Apr_2009_08_32_09_+1000_ws2BUGWRQOzAJuyO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Darren,

On Thu, 09 Apr 2009 08:23:09 -0700 Darren Hart <dvhltc@us.ibm.com> wrote:
>
> Also, I noticed the following embedded in the definition of the=20
> structure, does enabling this option also break sparc64 builds?
>=20
> #ifdef CONFIG_COMPAT
> 			struct compat_timespec __user *compat_rmtp;
> #endif

Sparc64 would always have CONFIG_COMPAT enabled.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Apr_2009_08_32_09_+1000_ws2BUGWRQOzAJuyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkned2kACgkQjjKRsyhoI8y0rgCgnqsU9hGsM74rbFsp6j2GtCfV
ruIAoIxlEWs8ZpScD8pi+M36G3qr2sqh
=n/Y2
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Apr_2009_08_32_09_+1000_ws2BUGWRQOzAJuyO--
