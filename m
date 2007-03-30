Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXC3RYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXC3RYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXC3RYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:24:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35230 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXC3RYn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:24:43 -0400
Message-Id: <200703301723.l2UHNO59025665@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3
In-Reply-To: Your message of "Fri, 30 Mar 2007 01:05:59 PDT."
             <20070330010559.2a232d9a.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175275404_10233P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Mar 2007 13:23:24 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175275404_10233P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2007 01:05:59 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc=
5/2.6.21-rc5-mm3/

Building with CONFIG_MAC80211_DEBUGFS=3Dy but CONFIG_MAC80211_DEBUG_COUNT=
ERS=3Dn
blows chunks on my box:

  CC =5BM=5D  net/mac80211/debugfs.o
net/mac80211/debugfs.c: In function =E2=80=98stats_wme_rx_queue_read=E2=
=80=99:
net/mac80211/debugfs.c:266: error: =E2=80=98struct ieee80211_local=E2=80=
=99 has no member named =E2=80=98wme_rx_queue=E2=80=99
net/mac80211/debugfs.c: In function =E2=80=98stats_wme_tx_queue_read=E2=
=80=99:
net/mac80211/debugfs.c:286: error: =E2=80=98struct ieee80211_local=E2=80=
=99 has no member named =E2=80=98wme_tx_queue=E2=80=99
make=5B2=5D: *** =5Bnet/mac80211/debugfs.o=5D Error 1


--==_Exmh_1175275404_10233P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGDUeMcC3lWbTT17ARAgkqAKDC0Z7HmrrqwlI6pkyepGhWedxNlgCgpP5+
T/QZBP1FfBEw7zYDCkxVmoQ=
=0+dY
-----END PGP SIGNATURE-----

--==_Exmh_1175275404_10233P--
