Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbXCAA6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbXCAA6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXCAA6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:58:16 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:57138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbXCAA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:58:15 -0500
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Greg KH <gregkh@suse.de>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070301005123.GA7116@bougret.hpl.hp.com>
References: <20070228012741.GA3988@bougret.hpl.hp.com>
	 <20070228153617.GA5670@suse.de> <20070301002647.GA7045@bougret.hpl.hp.com>
	 <1172709466.11911.7.camel@johannes.berg>
	 <20070301005123.GA7116@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mv71/LIfAuvxjTadtyA/"
Date: Thu, 01 Mar 2007 01:57:40 +0100
Message-Id: <1172710660.11911.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mv71/LIfAuvxjTadtyA/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 16:51 -0800, Jean Tourrilhes wrote:

> 	I would prefer to fix the comment when this change actually
> happens. I prefer comments to refer to the current reality, rather
> than past/future situation.

Uh, no. device_rename is perfectly fine, even other people may use it in
the future.

>  When you introduce wireless renaming, you
> will need to verify the whole chain anyway, so you might as well fix
> the comment while merging wireless renaming.

No again, device_rename is perfectly fine API, I shouldn't have to look
at it's internals to see if it's broken in my use case. Even if it's
only a broken comment.

I'm not going to respin your patches though, if this doesn't make it in
I don't care.

johannes

--=-mv71/LIfAuvxjTadtyA/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5iUE/ETPhpq3jKURArtZAJ9Y6ygfR9OIr5HQ9BhX6Rf0R4kbPwCdFZMx
26nPZwwnXTyG3X8lRhVbzTM=
=/Gif
-----END PGP SIGNATURE-----

--=-mv71/LIfAuvxjTadtyA/--

