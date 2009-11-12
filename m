Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZKLKrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZKLKrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZKLKrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:47:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33148 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZKLKrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:47:07 -0500
Date: Thu, 12 Nov 2009 21:47:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sysctl tree build failure
Message-Id: <20091112214706.7c7b3168.sfr@canb.auug.org.au>
In-Reply-To: <m1fx8kp0op.fsf@fess.ebiederm.org>
References: <20091112184805.1c0720cb.sfr@canb.auug.org.au>
	<m1ljicp3l0.fsf@fess.ebiederm.org>
	<20091112191451.d21250f2.sfr@canb.auug.org.au>
	<m1fx8kp0op.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_21_47_06_+1100_HNc_Ss47S1333=vu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_21_47_06_+1100_HNc_Ss47S1333=vu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 12 Nov 2009 01:11:34 -0800 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Any clue how all_noconfig happened to have CONFIG_SYSCTL_SYSCALL set?

CONFIG_SYSCTL_SYSCALL defaults to y and only depends on
CONFIG_PROC_SYSCTL which also defaults to y and depends on CONFIG_PROC_FS
which also defaults to y.  All three are only selectable if
CONFIG_EMBEDDED is y (which it obviously isn't).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_21_47_06_+1100_HNc_Ss47S1333=vu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr756oACgkQjjKRsyhoI8zZ+gCfWM8lTzl8jUp3F0ITfY7f8kR2
wkwAoLWtpvdJiIq+4Z3E27+36lp1NyPT
=mbEw
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_21_47_06_+1100_HNc_Ss47S1333=vu--
