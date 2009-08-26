Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbZHZBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbZHZBB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbZHZBB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:01:26 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:60413 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbZHZBBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=HKI0WrUcDPROpaqRK9sOItsMWZiHnf3CznYcRPsjEY4q7kAs5wzB6Wdd8rAW5Hq83Q
         hbsinY5tyhzBKMzZe6hMETZIdYgiBvDH/YJc+ImxGYyUVM9jgEsFLVgUxV6FfK6rEadX
         YLJQ5A2mRkHwcRBbpu1oXww3uszpHf5EaOQ4Q=
Message-ID: <4A948962.7090909@gmail.com>
Date: Tue, 25 Aug 2009 21:01:22 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: alacrityvm-devel@lists.sourceforge.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: AlacrityVM benchmark numbers updated
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBAF2F37F4D27E7A7E6AA6204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBAF2F37F4D27E7A7E6AA6204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We are pleased to announce the availability of the latest networking
benchmark numbers for AlacrityVM.  We've made several tweaks to the
original v0.1 release to improve performance.  The most notable is a
switch from get_user_pages to switch_mm+copy_[to/from]_user thanks to a
review suggestion from Michael Tsirkin (as well as his patch to
implement it).

This change alone accounted for freeing up an additional 1.2Gbps, which
is over 25% improvement from v0.1.  The previous numbers were 4560Gbps
before the change, and 5708Gbps after (for 1500mtu over 10GE).  This
moves us ever closer to the goal of native performance under virtualizati=
on.

These changes will be incorporated into the upcoming v0.2 release.  For
more details, please visit our project wiki:

http://developer.novell.com/wiki/index.php/AlacrityVM

Kind Regards,
-Greg


--------------enigBAF2F37F4D27E7A7E6AA6204
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqUiWIACgkQP5K2CMvXmqF9BwCdFTp8kstaf1ZPUuYdn3KnC1dH
XOYAnihscqZ86aDpLrA7yZ7gMYo3jjfP
=apF0
-----END PGP SIGNATURE-----

--------------enigBAF2F37F4D27E7A7E6AA6204--
