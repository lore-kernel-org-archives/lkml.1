Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYBLFH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYBLFH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYBLFHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:07:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59058 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYBLFHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:07:15 -0500
Date: Tue, 12 Feb 2008 16:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080212160704.77354af9.sfr@canb.auug.org.au>
In-Reply-To: <20080212042133.GA4625@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Feb_2008_16_07_04_+1100_OBufez3.w283ghO7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2008_16_07_04_+1100_OBufez3.w283ghO7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Feb 2008 20:21:33 -0800 Greg KH <greg@kroah.com> wrote:
>
> Note that a lot of these are already in the MAINTAINERS file.
>=20
> But for the record, here's mine, in the order they need to be pulled
> from.
>   Driver core:
> 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/
>   PCI:
> 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci/
>   USB:
> 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/
>=20
> These are all quilt trees, with the series file in the directory for the
> order of the patches, and a README saying what kernel version they have
> been rebased against.

Thank you.  Over time we might think about some sort of standard for
these.

> Oh oh oh, I get merged first!  me me me!

What's it worth to you?  :-)

> This is going to get really interesting, especially when (not if) we do
> more global api changes.  Look at the last round of kobject changes.
> That touched a lot of different places, and other trees ended up not
> building because of it, because I changed apis and they had added new
> code based on the old apis.

This is one of the things that linux-next will hopefully let us discover
more easily/faster.

> I think the only way to fix this is not going to just "drop the tree"
> like you are suggesting, but to let both people know (the person who
> caused the change, and the person who's tree broke after the merge), and
> then either add a "fixup patch" for the build like Andrew has been
> doing, or disabling something from the build section.

Right. Except that "drop the tree" will probably only mean for a day or
so i.e. it will be taken out of the current round but will reappear
automatically when the conflict/dependency is sorted out.

> As I know I'm going to be changing more driver core apis[1] this week,
> I'm sure we will get a very good set of examples of this for you to see
> in action :)

Excellent!

However, I am hoping that these global api changes may be introduced in a
more orderly fashion (some of which is happening already) by creating new
api's and then switching to them (and them maybe changing the names back
if necessary).  And, yes, I realise that this is sometimes not possible
(or at least not worth the extra effort).

> Good luck,

Thanks, I will probably need it :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Feb_2008_16_07_04_+1100_OBufez3.w283ghO7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsSl9TgG2atn1QN8RAgy5AJ9PsdRUcJ5xUenwHarbowB56ALM7ACgl2eD
qW2aHOkH8VkNsVHXFr93Bm4=
=7IOM
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2008_16_07_04_+1100_OBufez3.w283ghO7--
