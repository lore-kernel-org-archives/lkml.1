Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbZFIKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbZFIKki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762908AbZFIKgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:36:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762891AbZFIKgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:36:42 -0400
Date: Tue, 9 Jun 2009 20:36:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfgang Grandegger <wg@grandegger.com>
Subject: linux-next: net tree build warning
Message-Id: <20090609203639.96e503fe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_20_36_39_+1000_UW_IUqx3b1jgqg5P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_20_36_39_+1000_UW_IUqx3b1jgqg5P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (powerpc allyesconfig) produced these warnings:

drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_pro=
be':
drivers/net/can/sja1000/sja1000_of_platform.c:111: warning: format '%#x' ex=
pects type 'unsigned int', but argument 4 has type 'resource_size_t'
drivers/net/can/sja1000/sja1000_of_platform.c:111: warning: format '%#x' ex=
pects type 'unsigned int', but argument 5 has type 'resource_size_t'
drivers/net/can/sja1000/sja1000_of_platform.c:118: warning: format '%#x' ex=
pects type 'unsigned int', but argument 4 has type 'resource_size_t'
drivers/net/can/sja1000/sja1000_of_platform.c:118: warning: format '%#x' ex=
pects type 'unsigned int', but argument 5 has type 'resource_size_t'

Introduced by commit d1a277c584d0862dbf51991baea947ea5f2ce6bf ("can:
sja1000: generic OF platform bus driver").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_20_36_39_+1000_UW_IUqx3b1jgqg5P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouOzcACgkQjjKRsyhoI8yWBwCeOpubycsan27trtgJ80GmbSWM
u64An3++6hYHH8dRB8LAhFC/+gtpfiAX
=TIh6
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_20_36_39_+1000_UW_IUqx3b1jgqg5P--
