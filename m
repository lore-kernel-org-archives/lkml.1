Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZFJLTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZFJLTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZFJLS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:18:59 -0400
Received: from mail.technotrend.de ([212.185.20.147]:59743 "EHLO
	mail.technotrend.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZFJLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:18:58 -0400
Date: Wed, 10 Jun 2009 13:18:59 +0200
From: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
To: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: FDTI-SIO: kernel-oops after resume
Message-ID: <20090610111859.GA5462@novabasedigitaltv.de>
Reply-To: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
References: <20090609063948.GA17564@novabasedigitaltv.de> <20090610005018.2c84d229.akpm@linux-foundation.org> <20090610082417.GA32313@novabasedigitaltv.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20090610082417.GA32313@novabasedigitaltv.de>
X-Operating-System: Linux dieter 2.6.29.3-Xeno 
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2009 at 09:24:17AM +0100, <Martin Zwickel> bubbled:
> On Wed, Jun 10, 2009 at 08:50:18AM +0100, <Andrew Morton> bubbled:
> > On Tue, 9 Jun 2009 08:39:48 +0200 Martin Zwickel <martin.zwickel@novaba=
sedigitaltv.de> wrote:
> >
> > > My kernel runs with SMP and HIGHMEM if it matters:
> > > Linux tt-business 2.6.29.4 #3 SMP PREEMPT Fri Jun 5 00:03:39 WEST 200=
9 i686 Intel(R) Core(TM)2 Duo CPU T7300 @ 2.00GHz GenuineIntel GNU/Linux
> > >
> >
> > The oops is very very similar to the one which Daniel Mack reported,
> > and which was fixed by
> >
> > commit c16199fcd341f10147eb2e29a60aed41ceca55b4
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Thu Apr 30 10:06:19 2009 -0400
> >
> >     usb-serial: ftdi_sio: fix reference counting of ftdi_private
> >
> > but your 2.6.29.4 contained that fix, so it seems that we still have a
> > problem here?
>=20
> Could be, or I'm doing something wrong.
>=20
> I will clean the kernel, rebuild 2.6.29.4, reboot, try to crash it and
> let you know.
> If I should try some patches, please let me know.

I have seen that 2.6.30 is out. I'm now running with 2.6.30 and
tried to crash the ftdi_sio driver, I had no luck till now.

So it seems to be fixed at least in 2.6.30, and I believe it was this
patch:

commit 80193195f87ebca6d7417516d6edeb3969631c15
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Mon May 18 13:07:35 2009 +0100

    Fix oops on close of hot-unplugged FTDI serial converter


Best regards,
     Martin



--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkovlqMACgkQ/XnDWy8tQ2e3wACfZ4xgSTPqTaomXEIGBXttYTOf
dH0AmgJ03/jisWYBWWrHDid9POMNJQiG
=1rJ4
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
