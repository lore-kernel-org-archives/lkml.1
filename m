Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXFOIvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXFOIvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFOIvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:51:17 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:32900 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750786AbXFOIvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:51:16 -0400
From: "=?iso-8859-3?q?S=2E=C7a=BBlar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2.6.22-rc4] kexec failed: invalid argument
Date: Fri, 15 Jun 2007 11:50:19 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au
References: <200706142109.46027.caglar@pardus.org.tr> <m1hcpanlkw.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcpanlkw.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1418425.uV0NnNsvms";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151150.19605.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1418425.uV0NnNsvms
Content-Type: text/plain;
  charset="iso-8859-3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

15 Haz 2007 Cum tarihinde, Eric W. Biederman =BAunlar=B9 yazm=B9=BAt=B9:=20
> Sight unseen I'm guessing that you have a kexec aware distro that is doing
> something in the runlevel change scripts and thus unloading the kernel.
> What do: /sys/kernel/kexec_loaded and /sys/kernel/kexec_crash_loaded say?

Not sure, here is the pseudo output what our init system does;

=2D Stop running services
=2D Save random seed, sync clock
=2D Unmount mounted fs's (this includes proc/sysfs etc.)
=2D Call kexec -e
=2D Call reboot
=20
> kexec -e at any point should start a loaded kernel without problems, but =
it
> is a lot like pressing the reset button.  Nothing is guaranteed to be
> shutdown cleanly.  Now that journalling filesystems are the norm it is
> quite possible nothing bad will happen to you.

zangetsu ~ #=20
kexec -l /boot/kernel-2.6.22-rc4-CFS-v16 --append=3D"root=3D/dev/sda3" --in=
itrd=3D/boot/initramfs-2.6.22-rc4-CFS-v16
setup_linux_vesafb: 1024x768x16 @ c0000000 +300000
zangetsu ~ # cat /sys/kernel/kexec_loaded
1
zangetsu ~ # cat /sys/kernel/kexec_crash_loaded
0

Cheers
=2D-=20
S.=C7a=BBlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1418425.uV0NnNsvms
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGclLLy7E6i0LKo6YRAmrFAKCjpl6XqzLSkt7Mlywx6rTxid6JbACgs5r6
9qTHdU2cfe6tbQEYRPTs0Og=
=uoF3
-----END PGP SIGNATURE-----

--nextPart1418425.uV0NnNsvms--
