Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXB1TEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXB1TEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXB1TEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:04:15 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:36949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbXB1TEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:04:14 -0500
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070228185117.GE6134@bougret.hpl.hp.com>
References: <20070228012741.GA3988@bougret.hpl.hp.com>
	 <1172654165.3681.31.camel@johannes.berg>
	 <20070228185117.GE6134@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NR8qX51MDIqWktgcvFRY"
Date: Wed, 28 Feb 2007 20:03:39 +0100
Message-Id: <1172689419.5015.76.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NR8qX51MDIqWktgcvFRY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 10:51 -0800, Jean Tourrilhes wrote:

> 	That's why I always specify the kernel version. I'll look into
> that, I'm sure it's not the end of the world ;-)

Sure, just wanted to point it out.

> 	In which sense ? Wireless interface are regular netdevices.

Yeah but in mac80211 we have the wiphy concept since multiple virtual
interfaces can be associated to one hardware, and that is where QoS is
done, not the netdevs. Of course, those interested can just listen to
nl80211 events to figure out if someone renamed a 802.11 phy, but things
like hal would probably not want to and still know about the name
change.

> 	I'm just trying to follow the established pattern. Both
> class_device_add() and class_device_del() are generating the
> event. Also, I'm not sure if other subsystem would benefit from it, I
> don't want to generate too many useless events.

I don't think many other subsystems (can) rename things ;)

johannes

--=-NR8qX51MDIqWktgcvFRY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5dIL/ETPhpq3jKURAvQRAKC1WTGB2L+O6LtJKyiEXlXjEMER9gCeKqVg
wjnFfafZHPDjwA5DsQlnems=
=kyiu
-----END PGP SIGNATURE-----

--=-NR8qX51MDIqWktgcvFRY--

