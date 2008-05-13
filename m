Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYEMWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYEMWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYEMWDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:03:54 -0400
Received: from moog.chdir.org ([88.191.42.160]:55239 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbYEMWDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:03:51 -0400
X-Greylist: delayed 1067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 18:03:51 EDT
From: arno@natisbad.org (Arnaud Ebalard)
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 20/37] {nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets
References: <20080513200453.064446337@mini.kroah.org>
	<20080513201218.GU31167@suse.de>
X-GnuPG-Key: 0x047A5026
X-Hashcash: 1:20:080513:alan@lxorguk.ukuu.org.uk::HTh+DK7YosqX792l:000000000000000000000000000000000000000uK
X-Hashcash: 1:20:080513:rdunlap@xenotime.net::w3O2fnZayqEC6QmT:000000000000000000000000000000000000000000T5l
X-Hashcash: 1:20:080513:torvalds@linux-foundation.org::DrJyVP5e1r+ezmtI:000000000000000000000000000000000dZH
X-Hashcash: 1:20:080513:linux-kernel@vger.kernel.org::Q17ppTuoYIi+aXkC:00000000000000000000000000000000013PK
X-Hashcash: 1:20:080513:gregkh@suse.de::ckz+yMVnYehIr7GB:0001PKI
X-Hashcash: 1:20:080513:davej@redhat.com::O8JQ3NILuWL4mvpW:01UdX
X-Hashcash: 1:20:080513:kaber@trash.net::1Mk7zjJaKcAoI01c:001KJD
X-Hashcash: 1:20:080513:zwane@arm.linux.org.uk::KKL9Fa2uV21hVKiH:0000000000000000000000000000000000000001WLE
X-Hashcash: 1:20:080513:davem@davemloft.net::60I9yFFMmn+HsNg8:0000000000000000000000000000000000000000001HQR
X-Hashcash: 1:20:080513:stable@kernel.org::MCDPTPWvv9G70pPr:000000000000000000000000000000000000000000002bkk
X-Hashcash: 1:20:080513:cavokz@gmail.com::CYgg3X+jgs10eLTm:02ZK7
X-Hashcash: 1:20:080513:chuckw@quantumlinux.com::+7ffXtPdEEPMSGJo:000000000000000000000000000000000000002YX2
X-Hashcash: 1:20:080513:cebbert@redhat.com::a4CoBDN/YJ7Xcpm9:00000000000000000000000000000000000000000002j+1
X-Hashcash: 1:20:080513:tytso@mit.edu::q5gOte/Erji2ntut:00004E5a
X-Hashcash: 1:20:080513:akpm@linux-foundation.org::q4we4Ag4J0J5wYe0:0000000000000000000000000000000000003bP4
X-Hashcash: 1:20:080513:netfilter-devel@vger.kernel.org::seVFXp9DiEcODasD:0000000000000000000000000000006405
X-Hashcash: 1:20:080513:jmforbes@linuxtx.org::Kk/nw416YK4YLCm0:000000000000000000000000000000000000000006fFw
X-Hashcash: 1:20:080513:mkrufky@linuxtv.org::OiRikciR5vkq2Opb:00000000000000000000000000000000000000000073/7
X-Hashcash: 1:20:080513:reviews@ml.cw.f00f.org::2miOqPA5CBvb4z6z:0000000000000000000000000000000000000009SLe
Date: Wed, 14 May 2008 01:45:15 +0200
In-Reply-To: <20080513201218.GU31167@suse.de> (Greg KH's message of "Tue, 13
	May 2008 13:12:18 -0700")
Message-ID: <877idxdb04.fsf@natisbad.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

Greg KH <gregkh@suse.de> writes:

> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

Sorry for the noise, but for those who missed one of the latest post on
the topic on netdev, I should add that the bug is also in 2.6.24.4 (even
if it's probably too late for that poor guy :-( ).=20=20

> ------------------
> From: Arnaud Ebalard <arno@natisbad.org>
>
> [NETFILTER]: {nfnetlink,ip,ip6}_queue: fix skb_over_panic when enlarging =
packets
>
> From: Arnaud Ebalard <arno@natisbad.org>
>
> Upstream commit 9a732ed6d:
>
> While reinjecting *bigger* modified versions of IPv6 packets using
> libnetfilter_queue, things work fine on a 2.6.24 kernel (2.6.22 too)
                                            ^^^^^^
                                  i.e. read 2.6.24.x with x<4

Cheers,

a+


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKigUAlWVfAR6UCYRAlmLAKCfw31nXa8WIHc6eNsWfvxgtd7dkACfQLA7
3ezUP5GEVtysDNo3mIa0cXw=
=xMpa
-----END PGP SIGNATURE-----
--=-=-=--
