Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773Ab0COAUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:20:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35781 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934529Ab0COAUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:20:22 -0400
Date: Mon, 15 Mar 2010 01:20:17 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       dmitry.torokhov@gmail.com
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
	commit a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <20100315002016.GA28894@pengutronix.de>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org> <m1fx43zhbd.fsf@fess.ebiederm.org> <loom.20100314T113306-436@post.gmane.org> <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 14, 2010 at 11:04:25AM -0700, Linus Torvalds wrote:

> Hey, goodie.  Can we merge the trivial one-liners into a single patch tha=
t=20
> fixes the issue?

Sure, will send it in a minute.

> Also, that "firmware_attr_data" thing should probably be marked 'const',=
=20
> no? That should make it more obvious that it's ok to share across multipl=
e=20
> different firmware file, I think.

I will leave that to Dmitry (adding to CC).

> You removed everybody from the Cc: line, so I doubt Eric even sees your=
=20
> email. I added the cc's back in.

Oops, thanks. I was using gmane to reply to that mail and did probably
something wrong. I'm sorry.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkudfUAACgkQD27XaX1/VRtJngCgj0mva0DZgiyRw/yvPS6GHDnn
+N4AoLBeU79Y48XZgrceP1ElY/0rw3wu
=47r4
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
