Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYBTHV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYBTHV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYBTHVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:21:45 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:4928 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYBTHVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:21:44 -0500
Date: Wed, 20 Feb 2008 08:21:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-ID: <20080220082133.56f93d27@crazy>
In-Reply-To: <20080219152129.6e8b7956.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
	<20080219165502.2c202759@crazy>
	<20080219152129.6e8b7956.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/v9SkIC1I3rgH11jU9F1sxey";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v9SkIC1I3rgH11jU9F1sxey
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 19 Feb 2008 15:21:29 -0800,
Andrew Morton <akpm@linux-foundation.org> a =C3=A9crit :

> ug, sorry, if I'd realised it was like this I'd have said "don't
> bother". Apart from the obvious problem, this means that people will
> keep breaking CONFIG_DMI=3Dn all the time, because they will forget the
> ifdefs, and the number of people who test with CONFIG_DMI=3Dn will be
> small.

Yes, #ifdef CONFIG_DMI is not very comfortable. That why I proposed
things such as DECLARE_DMI_FIXUP_TABLE(), because it would force people
to use these macros, which would then be working correctly depending on
DMI=3Dy/n. However, there's still the issue of driver_data that I
mentionned in my earlier post.

What should I do ? Option 1 ? Option 2 ? Give up with the patch ?

Thanks for your comments,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/v9SkIC1I3rgH11jU9F1sxey
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFHu9UB9lPLMJjT96cRAmjHAJd6dSQi8ZRI2tqu2nNT9dmSBFMfAJ0YXzwX
IoCwUCmPv6ZeYPhAg/0PTQ==
=M1LJ
-----END PGP SIGNATURE-----

--Sig_/v9SkIC1I3rgH11jU9F1sxey--
