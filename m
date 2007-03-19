Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXCTAHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXCTAHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXCTAHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:07:55 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:45910 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030780AbXCTAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:07:54 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 20:07:54 EDT
Date: Tue, 20 Mar 2007 00:52:41 +0100
From: Till Maas <opensource@till.name>
Subject: unify encoding of files in Documentation
To: linux-kernel@vger.kernel.org
Message-id: <200703200052.49607.opensource@till.name>
MIME-version: 1.0
Content-type: multipart/signed; boundary=nextPart5472264.ica1RRm8TC;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Content-transfer-encoding: 7bit
X-Spam-Report: * -2.8 ALL_TRUSTED Did not pass through any untrusted hosts
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5472264.ica1RRm8TC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hiyas,

at the moment, some file in Documentation are utf-8 encoded and some are=20
latin1 encoded. Therefore I propose to change the default encoding to utf-8=
,=20
because this is the encoding that may current linux distributions use.

I can send a patch, if required. If you want to change the encoding of a fi=
le=20
from latin1 to utf-8 you can use recode:

recode latin1..utf-8 file.txt

This changes the encoding in place.

Regards,
Till




--nextPart5472264.ica1RRm8TC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF/yJJ36qIRnusQIMRAlpLAJwMZSwfuzGevcMoGqkkWKAIKJYq0QCfUlCK
hPNTZiruqGWyrZ8CghRsUCU=
=19gz
-----END PGP SIGNATURE-----

--nextPart5472264.ica1RRm8TC--


