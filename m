Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYBLHdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYBLHdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbYBLHdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:33:46 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:2464 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbYBLHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:33:45 -0500
Date: Tue, 12 Feb 2008 08:33:23 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out DMI scanning code
Message-ID: <20080212083323.6d579dc3@crazy>
In-Reply-To: <1202756478.28085.35.camel@cinder.waste.org>
References: <20080211175844.3358a49b@crazy>
	<1202756478.28085.35.camel@cinder.waste.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+FEYuD.zD0iN1I0iw9eIz6l";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+FEYuD.zD0iN1I0iw9eIz6l
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Matt,

Thanks for your review.

Le Mon, 11 Feb 2008 13:01:18 -0600,
Matt Mackall <mpm@selenic.com> a =C3=A9crit :

> Looks ok. Please preserve original authorship (ie me) in some fashion
> in your description.

Andrew seems to already have picked up the patch in -mm (I received an
e-mail + x86-configurable-dmi-scanning-code.patch added to -mm tree).
If I resend a new one with proper credits, will Andrew pick it up and
replace the old version by the new version ?

> > On top of this patch, I've tested if removing the big dmi tables in
> > the code (for example in arch/x86/kernel/reboot.c) would allow to
> > make more space optimizations. However, it seems that simply
> > defining dmi_check_system() to an empty static inlined function
> > already allows gcc to optimize out the dmi tables, because there
> > are not present in the code. Is that possible, or is my
> > understanding incorrect ?
>=20
> That's possible with modern gccs, yes.

I was compiling with 4.2.3, which I suppose is a modern gcc.

Thanks,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/+FEYuD.zD0iN1I0iw9eIz6l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsUvD9lPLMJjT96cRAhXcAJsFDJ7PVFhMz23z0qu5rMI5fzKTHgCcC8gc
g80u6r8abm0KZNxUjXpkI38=
=pwbX
-----END PGP SIGNATURE-----

--Sig_/+FEYuD.zD0iN1I0iw9eIz6l--
