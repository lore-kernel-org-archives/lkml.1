Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZETOcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZETOcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZETObx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:31:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZETObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:31:53 -0400
Date: Thu, 21 May 2009 00:31:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Wai Yew CHAY <wychay@ctl.creative.com>,
       Ryan RICHARDS <ryan_richards@creativelabs.com>
Subject: linux-next: sound tree build failure
Message-Id: <20090521003145.7c31808d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_May_2009_00_31_45_+1000_Za=GUY/E4HuhNQ57"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_May_2009_00_31_45_+1000_Za=GUY/E4HuhNQ57
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (sparc64 allmodconfig) failed like this:

sound/pci/ctxfi/cthw20k2.c:1217:3: error: #error "Don't support 8k-page!"

Caused by commit 8cc72361481f00253f1e468ade5795427386d593 ("ALSA: SB X-Fi
driver merge").  I assume that this driver needs better Kconfig
protection.  Maybe test for CONFIG_SPARC64_PAGE_SIZE_8KB or something.
Does this driver support other pages sizes (16k, 64k, 256k)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_May_2009_00_31_45_+1000_Za=GUY/E4HuhNQ57
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoUFFEACgkQjjKRsyhoI8wjuwCfXtauJ9wjqTy74x/A86stPmY/
L3IAnAz1OQVUrmquQa6MppxVOMqnkH0a
=GI05
-----END PGP SIGNATURE-----

--Signature=_Thu__21_May_2009_00_31_45_+1000_Za=GUY/E4HuhNQ57--
