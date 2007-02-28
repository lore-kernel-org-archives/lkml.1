Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXB1JQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXB1JQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXB1JQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:16:35 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:38280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXB1JQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:16:33 -0500
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070228012741.GA3988@bougret.hpl.hp.com>
References: <20070228012741.GA3988@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fqSkluyBxkpWE3nHXRW0"
Date: Wed, 28 Feb 2007 10:16:05 +0100
Message-Id: <1172654165.3681.31.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fqSkluyBxkpWE3nHXRW0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> 	Patch for 2.6.20 is attached.

... and in the meantime netdevices aren't class_device any more :) IOW,
your patch isn't going to work any more. Also, I think wireless could
benefit from this as well.

>         The kobject framework is well designed, so adding these
> features is trivial change and won't run the risk of breaking anything
> (famous last words). Obviously, hotplug apps are free to ignore those
> additional features.

Why not just add this to base kobject_rename instead? That way,
userspace is notified for all renames in sysfs.
The patch then collapses down to the change in net's sysfs code to add
the ifindex to the environment, and another change in kobject to invoke
a new event when a name changes and show the old name.

johannes

--=-fqSkluyBxkpWE3nHXRW0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5UhV/ETPhpq3jKURApykAJ9ZUXi6bJwmnMglXvkrs/woCNvi/ACfduQ/
vK6NsgvxMQh5r4sZIJT1acU=
=U4iY
-----END PGP SIGNATURE-----

--=-fqSkluyBxkpWE3nHXRW0--

