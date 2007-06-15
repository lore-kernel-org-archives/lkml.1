Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbXFONMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbXFONMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbXFONMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:12:03 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:40984 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754241AbXFONMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:12:01 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2.6.22-rc4] kexec failed: invalid argument
Date: Fri, 15 Jun 2007 16:10:58 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au
References: <200706142109.46027.caglar@pardus.org.tr> <m1hcpanlkw.fsf@ebiederm.dsl.xmission.com> <200706151150.19605.caglar@pardus.org.tr>
In-Reply-To: <200706151150.19605.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8044712.EHKf5oBSap";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151611.01166.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8044712.EHKf5oBSap
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

15 Haz 2007 Cum tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> 15 Haz 2007 Cum tarihinde, Eric W. Biederman =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:
> > Sight unseen I'm guessing that you have a kexec aware distro that is
> > doing something in the runlevel change scripts and thus unloading the
> > kernel. What do: /sys/kernel/kexec_loaded and
> > /sys/kernel/kexec_crash_loaded say?
>
> Not sure, here is the pseudo output what our init system does;
>
> - Stop running services
> - Save random seed, sync clock
> - Unmount mounted fs's (this includes proc/sysfs etc.)
> - Call kexec -e
> - Call reboot

Heh, i found a problem in our init system and after solving that issue kexe=
c=20
starts to works fine :), thanks for the tip!

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart8044712.EHKf5oBSap
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGco/ly7E6i0LKo6YRAmC8AJ9kAueUVEJpBAQj/FvEOH4SWNilpgCgneR7
ufgLtfrG2r9rRPUKIT4Jtcc=
=ELvN
-----END PGP SIGNATURE-----

--nextPart8044712.EHKf5oBSap--
