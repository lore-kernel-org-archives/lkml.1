Return-Path: <linux-kernel-owner+w=401wt.eu-S934602AbZLPHVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbZLPHVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbZLPHVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:21:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36698 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933588AbZLPHVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:21:41 -0500
Date: Wed, 16 Dec 2009 18:21:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Balaji T K <balajitk@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next:  tree build failure
Message-Id: <20091216182132.357359a6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_18_21_32_+1100_ZjX8dFBUCmKR_koS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_18_21_32_+1100_ZjX8dFBUCmKR_koS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/regulator/twl-regulator.c: In function 'twlreg_disable':
drivers/regulator/twl-regulator.c:158: error: 'P1_GRP' undeclared (first us=
e in this function)
drivers/regulator/twl-regulator.c:158: error: 'P2_GRP' undeclared (first us=
e in this function)
drivers/regulator/twl-regulator.c:158: error: 'P3_GRP' undeclared (first us=
e in this function)
drivers/regulator/twl-regulator.c: At top level:
drivers/regulator/twl-regulator.c:358: error: 'twlldo_list_voltage' undecla=
red here (not in a function)
drivers/regulator/twl-regulator.c:450:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:450: error: 'TWL_ADJUSTABLE_LDO' undeclar=
ed here (not in a function)
drivers/regulator/twl-regulator.c:451:40: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:452:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:453:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:454:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:455:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:456:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:457:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:458:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:459:34: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:460:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:461:40: error: macro "TWL_FIXED_LDO" requ=
ires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:461: error: 'TWL_FIXED_LDO' undeclared he=
re (not in a function)
drivers/regulator/twl-regulator.c:462:39: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:463:39: error: macro "TWL_FIXED_LDO" requ=
ires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:464:34: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:465:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:466:35: error: macro "TWL_ADJUSTABLE_LDO"=
 requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:467:39: error: macro "TWL_FIXED_LDO" requ=
ires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:468:39: error: macro "TWL_FIXED_LDO" requ=
ires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:469:39: error: macro "TWL_FIXED_LDO" requ=
ires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:474: error: 'VAUX1_6030_VSEL_table' undec=
lared here (not in a function)
drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:474: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:474: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:474: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:475: error: 'VAUX2_6030_VSEL_table' undec=
lared here (not in a function)
drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:475: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:475: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:475: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:476: error: 'VAUX3_6030_VSEL_table' undec=
lared here (not in a function)
drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:476: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:476: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:476: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:477: error: 'VMMC_VSEL_table' undeclared =
here (not in a function)
drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:477: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:477: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:477: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:478: error: 'VPP_VSEL_table' undeclared h=
ere (not in a function)
drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:478: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:478: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:478: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:479: error: 'VUSIM_VSEL_table' undeclared=
 here (not in a function)
drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:479: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:479: warning: type defaults to 'int' in d=
eclaration of 'type name'
drivers/regulator/twl-regulator.c:479: error: negative width in bit-field '=
<anonymous>'
drivers/regulator/twl-regulator.c: In function 'twlreg_probe':
drivers/regulator/twl-regulator.c:544: error: implicit declaration of funct=
ion 'twl4030reg_write'

I guess we knew this was coming :-(

Caused by a bad rebase of the voltage tree onto Linus' tree (in order to
do fixups for commit fc7b92fca4e546184557f1c53f84ad57c66b7695 "mfd:
Rename all twl4030_i2c*" and others).

I have reverted all the commits in the voltage tree that touched
drivers/regulator/twl-regulator.c for today:

6051d7a2786c57d0c5c4227dd9ddfc348a86ce91 "twl4030-regulator: Fixes VAUX1-3 =
exclusion introduced"
2677c78184a52edcc228c20a1c05c14925118293 "Reset REMAP configuration in regu=
lator probe"
de449258306274739ed3a747f49b9ac8f91f9e4a "Define critical regulators as alw=
ays_on"
66d65d352f6fd61dd5695925906b140f1e0ac9c3 "twl4030-regulator: Add all TWL re=
gulators to twreg_info"
f33a0d47bd44dbf44a45c33b32e1e3bbbf8d06e6 "twl4030-regulator: Remove regulat=
or from all groups when disabling"

Please fix up this tree properly.  You may have been better off merging
Linus' tree into yours and fixing up the merge commit than trying to do
the rebase.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_18_21_32_+1100_ZjX8dFBUCmKR_koS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoinwACgkQjjKRsyhoI8zdPgCdHxSpm1JOaJ63bjTe4UAJB+6z
RogAnj1ifbVxKqCM8txTNPpt4zgiKWSr
=Gdbx
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_18_21_32_+1100_ZjX8dFBUCmKR_koS--
