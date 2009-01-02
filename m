Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZABUsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZABUsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbZABUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:47:36 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46301 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759424AbZABUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:47:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH v2] linux/types.h: always export 64bit aligned defines
Date: Fri, 2 Jan 2009 15:47:30 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1230885562-11456-1-git-send-email-vapier@gentoo.org> <je4p0hhjko.fsf@sykes.suse.de>
In-Reply-To: <je4p0hhjko.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12463973.rz1a83a6NO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901021547.32666.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12463973.rz1a83a6NO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 January 2009 09:24:39 Andreas Schwab wrote:
> Mike Frysinger <vapier@gentoo.org> writes:
> > These these defines dont actually conflict with normal userspace / C
> > library types, there's no reason to hide them behind the
> > __KERNEL_STRICT_NAMES define.
>
> aligned_u64 would pollute the name space, wouldn't it?

if by "pollute the name space" you mean "it'll be defined where it normally=
=20
wasnt before", then yes.  it's always been in the header, just behind=20
__KERNEL_STRICT_NAMES.  i also highlight the fact that existing headers tha=
t=20
are exported to userspace are already using this type, so they're broken mo=
st=20
of the time today.

unless you want a completely new patch that deletes aligned_*64 types and=20
replaces them with __aligned_*64 types ...
=2Dmike

--nextPart12463973.rz1a83a6NO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXn1kAAoJEEFjO5/oN/WBqIgQAKH/yivRNdHf1sQoVsfDsJLV
i9OLK5GTZEOo7MQiUx1wabzpxeIodhc0HneRMEyKDt5hDEoOBnET3PFWiIC+fjLZ
XNPkuMAbSNiAieMpdNlW/Ini3ANIyzE/ZVBLXbX9SSeTAx2Lk2yJ6mL0gEslrAvp
t7nKVdeU1UXsHEg9WFPFd8GQgTf2O896eqh+S3iZ80uKrClKYWJDm3A98rQpvvsE
3/iaFLfmg0Gy9bL6iER4ehGnY7nIjggkQYTsGlgozXv16ou5SYbxlUqqKEmtWwIP
v9PSEOZB24GIdQc5zAyhlnnMFcVjOHGDNYxGcjHbp0VKLRXez+rgf5SBahvZWvF2
7ofRorWTGFsIYYY367EndaWHmbLrEc0SkbsACOYdS2fKvDxf8SsLgDEEKvUfjD2Q
1viowjW3ULuovL2PQlWdJnlhxqoYyhKCcPbkmJrHYeHi4WHe0+bang6AFduzHOIr
vkV5jMiIqG5kNwGWubKKDaO5U6TTR1CKNFbBaLw0r8c7KsoEnvbg0YCnskf5prDY
P9Koat4ej/iCHFwMBvVr0A2w1XPjNBbPhjW+VaCzu8IXpKcTPkEb8J34ZsmFCvwG
jcqhohnf/m5w0rrHAuZ9ycqNHUmkmFsm9IWWvM6ipPuV8Q5B+TNQObl4HEc+0a2u
ofV56PCek1Rtv0kRBDuj
=4sC/
-----END PGP SIGNATURE-----

--nextPart12463973.rz1a83a6NO--
