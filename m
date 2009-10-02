Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZJBWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZJBWhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZJBWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:37:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:32889 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbZJBWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:37:03 -0400
X-Sasl-enc: k/d6FDa8b32rW+Ya0SmeGxTjmEFaTGpAkvEV7TyDnvIO 1254523026
Message-ID: <4AC68086.8020100@imap.cc>
Date: Sat, 03 Oct 2009 00:36:54 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/48] 2.6.27.32-stable review
References: <200909112223.n8BMMSHG002530@hera.kernel.org> <20090916210956.GB24567@kroah.com> <4AB387E3.6030709@imap.cc> <20091001153017.GA6058@kroah.com>
In-Reply-To: <20091001153017.GA6058@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9BD851D89528D7EFD54D88FF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9BD851D89528D7EFD54D88FF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.10.2009 17:30 schrieb Greg KH:
> On Fri, Sep 18, 2009 at 03:15:15PM +0200, Tilman Schmidt wrote:
>>
>> So commit 221418f9a25cd96aff99d6aba41c177f6eb00853 should be reverted =
and
>> my original patch below applied instead. The patch by Stefan Bader is
>> equivalent to that but additionally backports two pr_err() calls from
>> mainline.
>=20
> I took Stefan's patch as it was simpler.  Let me know if the problem is=

> still present.

Stefan's patch is fine. I just did a quick test of
fix-incorrect-stable-backport-to-bas_gigaset.patch
on top of 2.6.27.35 and the problem is gone.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig9BD851D89528D7EFD54D88FF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKxoCPQ3+did9BuFsRAnTqAJ9EhtSELx/Bs0Yx3aacIGWxmrcghACfU0ow
SLv1GSLmHKe+vcBHGIQ3t+Y=
=M2rA
-----END PGP SIGNATURE-----

--------------enig9BD851D89528D7EFD54D88FF--
