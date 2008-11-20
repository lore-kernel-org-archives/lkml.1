Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKTADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKTADT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYKTADL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:03:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYKTADK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:03:10 -0500
Date: Thu, 20 Nov 2008 11:02:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 19 (v4l2 warnings)
Message-Id: <20081120110253.c0f2e80b.sfr@canb.auug.org.au>
In-Reply-To: <20081119105100.26de5ff0.randy.dunlap@oracle.com>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
	<20081119105100.26de5ff0.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Nov_2008_11_02_53_+1100_BlqoAmEZ/EXf0.oU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Nov_2008_11_02_53_+1100_BlqoAmEZ/EXf0.oU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Wed, 19 Nov 2008 10:51:00 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On Wed, 19 Nov 2008 17:59:17 +1100 Stephen Rothwell wrote:

(Randy, I didn't really ...)

> drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type =
'int', but argument 3 has type 'struct v4l2_fract'
> drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type =
'int', but argument 4 has type 'struct v4l2_fract'
> drivers/media/video/v4l2-ioctl.c:1819: warning: format '%d' expects type =
'int', but argument 5 has type 'struct v4l2_fract'

Introduced in commit b35e0c6035369de9f3273b6a3fbb1c67f830cf49 "4L/DVB
(9578): v4l core: add support for enumerating frame sizes and intervals"
and been there for some time now.

Mauro, please fix this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Nov_2008_11_02_53_+1100_BlqoAmEZ/EXf0.oU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkkqS0ACgkQjjKRsyhoI8z3PwCgjbRalkdjjqLsULyZGncp78FD
6F8An1SktKaIgWvWeM+yKLL0v8BsMdkI
=wSC7
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Nov_2008_11_02_53_+1100_BlqoAmEZ/EXf0.oU--
