Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZFYSlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZFYSlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZFYSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:41:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50833 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZFYSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:41:14 -0400
Message-ID: <4A43C4C5.4040404@novell.com>
Date: Thu, 25 Jun 2009 14:41:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix	notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <200906241255.54709.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com> <200906252112.24730.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906250922530.9517@makko.or.mcafeemobile.com> <4A43B4A6.8050001@novell.com> <20090625182636.GA3239@redhat.com>
In-Reply-To: <20090625182636.GA3239@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig552ED7461EAD0818B5046D67"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig552ED7461EAD0818B5046D67
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 01:32:22PM -0400, Gregory Haskins wrote:
>  =20
>> Please take a close look at it and consider for merging, if you would.=

>>    =20
>
> With all the incremental patching, I kind of lost track of what the
> complete file would look like.  Is there a git tree I could pull?
>
>  =20

Ask and ye shall receive :)

git pull
ssh://master.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks=
=2Egit
kvm/irqfd

If you dont have a kernel.org account, it should rsync to the
gitweb/git: server soon, in which case
s|ssh://master|git://git should get you the proper path.

Note that there is one additional race that I found that is not included
in that tree in the slow-work infrastructure.  You can find my latest
submission to David Howells to resolve that issue here:

http://patchwork.kernel.org/patch/32287/

Thanks Michael!
-Greg


--------------enig552ED7461EAD0818B5046D67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDxMUACgkQlOSOBdgZUxmVsQCeP+rG8cro/3zmDhnD2RROvJxW
8BwAoIQwDJXQy9c6JeAFlrEzUqqFEU4P
=BdvX
-----END PGP SIGNATURE-----

--------------enig552ED7461EAD0818B5046D67--
