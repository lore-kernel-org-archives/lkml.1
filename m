Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYAOAiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYAOAiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYAOAhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:37:52 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:41927 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbYAOAhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:37:51 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt2
Date: Tue, 15 Jan 2008 02:37:37 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain>
In-Reply-To: <1200336080.318.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26097333.iopcmaTSH5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801150237.44029.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26097333.iopcmaTSH5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

14 Oca 2008 Pts tarihinde, Steven Rostedt =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
> downloaded from the location:
[...]
> The broken out patches are also available.

2.6.24-rc7-rt2 (-rt2 patchset on top of Linus's current git commit=20
031f2dcd7075e218e74dd7f942ad015cf82dffab) starts to complain like following=
=20
(full dmesg can be found @ [1]) when try to login from console (the other=20
acpi related errors also existed in 2.6.24-rc5-rt1) and FYI, plain 2.6.24-r=
c7=20
(again commit 031f2dcd7075e218e74dd7f942ad015cf82dffab) has no issues.

[...]
sysfs: duplicate filename 'vcs1' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1298, comm: mingetty Not tainted 2.6.24-rc7-rt2-99 #1
[...]

And because of mcount-add-basic-support-for-gcc-profiler-instrum.patch, clo=
sed=20
source nvidia-new module cannot be used with this release (mcount is export=
ed=20
GPL only), i know this is not supported but i used it with that [2] patch u=
p=20
until now without a single problem.=20

Please don't misunderstand this, i really do not want to start a discussion=
=20
for this, i just want to ask the possibility of converting this into=20
EXPORT_SYMBOL cause i thought some of the possible -rt users may need this=
=20
closed source module explicitly because of its 3D performance.=20

If anything else needed for sysfs warnings please just say it...

[1] http://cekirdek.pardus.org.tr/~caglar/dmesg.rt
[2]=20
http://svn.pardus.org.tr/pardus/devel/kernel/drivers/nvidia-new/files/rt.pa=
tch

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart26097333.iopcmaTSH5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBHjABYy7E6i0LKo6YRArhhAJ0Yr+puJJU+kLPq4BNTLgAwJ9K5MQCgjiha
u9emouMsbDnS/hPLx8sGfiQ=
=9g3Y
-----END PGP SIGNATURE-----

--nextPart26097333.iopcmaTSH5--
