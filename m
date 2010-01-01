Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839Ab0AABXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0AABXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468Ab0AABXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:23:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53983 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0AABXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:23:09 -0500
Date: Fri, 1 Jan 2010 12:22:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: linux-next: origin tree build warnings
Message-Id: <20100101122259.394d5b19.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0912311649070.3630@localhost.localdomain>
References: <20100101114238.83108321.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0912311649070.3630@localhost.localdomain>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jan_2010_12_22_59_+1100_qP59=V.CBD63rkrk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jan_2010_12_22_59_+1100_qP59=V.CBD63rkrk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 31 Dec 2009 16:50:39 -0800 (PST) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> Ok, I tested and committed the other warning you pointed out, but this on=
e=20
> I can't test since I no longer do powerpc builds. I assume the trivial fi=
x=20
> below fixes it, but without testing I won't be committing it.

I have built drivers/mfd/twl4030-irq.o the same way as before but after
applying your patch and the warnings are fixed.  I do not have the
hardware and so cannot do a runtime test.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jan_2010_12_22_59_+1100_qP59=V.CBD63rkrk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks9TnMACgkQjjKRsyhoI8zCGACgulGI+TAzdv7X7w4km/XQc2Xc
/g8An1p/seFBRIVp5TYu9S/x7wkW5TXR
=qQpD
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jan_2010_12_22_59_+1100_qP59=V.CBD63rkrk--
