Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZDXB6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZDXB6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZDXB54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:57:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49310 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZDXB5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:57:55 -0400
Date: Fri, 24 Apr 2009 11:57:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       =?UTF-8?B?IkZy?= =?UTF-8?B?w6lkw6lyaWMgV2Vpc2JlY2tlciI=?= 
	<fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5 -tip] umount_begin BKL pushdown
Message-Id: <20090424115744.bd2d8444.sfr@canb.auug.org.au>
In-Reply-To: <20090423213249.GA4814@elte.hu>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
	<20090423191817.GW8633@ZenIV.linux.org.uk>
	<20090423213249.GA4814@elte.hu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Apr_2009_11_57_44_+1000__KSg4cMX1rrhp_Yt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Apr_2009_11_57_44_+1000__KSg4cMX1rrhp_Yt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 23 Apr 2009 23:32:49 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> >=20
> > Another thing: -tip is no place for that.  I can put that into VFS=20
> > tree, provided that comments above are dealt with.
>=20
> When that happens, could you please put it into a separate,=20
> append-only branch i could pull (after some initial test-time) into=20
> tip:kill-the-BKL?

And just wondering how all this relates to Jonathan's (currently empty)
bkl-removal tree (that is merged into linux-next)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Apr_2009_11_57_44_+1000__KSg4cMX1rrhp_Yt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknxHJgACgkQjjKRsyhoI8xjjwCgm0AFsf5vkDSwamUlpTlA70ab
C0YAoLK2ACqim33PNAs5Oylv+UapGWV1
=OiAz
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Apr_2009_11_57_44_+1000__KSg4cMX1rrhp_Yt--
