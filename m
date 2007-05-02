Return-Path: <linux-kernel-owner+w=401wt.eu-S1767134AbXEBWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767134AbXEBWn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767147AbXEBWn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:43:58 -0400
Received: from lugor.de ([212.112.242.222]:36251 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767134AbXEBWn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:43:57 -0400
From: Christian Hesse <mail@earthworm.de>
To: linux-kernel@vger.kernel.org
Subject: build system: no module target ending with slash?
Date: Thu, 3 May 2007 00:43:43 +0200
User-Agent: KMail/1.9.6
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
Cc: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1319683.WfmWIRjNGC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705030043.49208.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Thu, 03 May 2007 00:43:51 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1319683.WfmWIRjNGC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi James, hi everybody,

playing with iwlwifi I try to patch it into the kernel and to build it from=
=20
there. But I have a problem with the build system.

The file drivers/net/wireless/mac80211/Makefile contains one single line:

obj-$(CONFIG_IWLWIFI)   +=3D iwlwifi/

When CONFIG_IWLWIFI=3Dm in scripts/Makefile.lib line 29 the target is filte=
red=20
as it ends with a slash. That results in=20
drivers/net/wireless/mac80211/built-in.o not being built and the build=20
process breaks with an error. What is the correct way to handle this? Why a=
re=20
targets ending with a slash filtered?
=2D-=20
Regards,
Chris

--nextPart1319683.WfmWIRjNGC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGORQllZfG2c8gdSURAthNAJ9cDisJxUf8U19+u9lDLB8MhGkmgQCcDkoi
OIh9L3boEFN/P/X++mCOXRI=
=Krh7
-----END PGP SIGNATURE-----

--nextPart1319683.WfmWIRjNGC--
