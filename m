Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYE1UTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYE1UTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYE1UTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:19:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYE1UTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:19:11 -0400
Subject: Re: Linux 2.6.26-rc4
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, John Linville <linville@tuxdriver.com>
In-Reply-To: <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org> (sfid-20080528_221047_669541_BE57D5DF)
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <20080527124315.131b1343@Varda>
	 <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org>
	 (sfid-20080528_221047_669541_BE57D5DF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9XnJ+yhkO3WoZphoPs9o"
Date: Wed, 28 May 2008 22:17:57 +0200
Message-Id: <1212005877.21624.47.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9XnJ+yhkO3WoZphoPs9o
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> >  4) if i try to run some sudo command it gets stuck (Crtl +C doesnt' he=
lp)
> >     "ip route" gets stuck too. User programs i tried wrok fine (only ls=
 and
> >     htop). Network realted problem?
>=20
> I assume it's related to the oops above - the oops probably happened whil=
e=20
> holding some mutex or other lock, which is why network-related stuff then=
=20
> blocks on that lock (which will never be released, since the oops killed=20
> the process that held it).

rtnl, in fact, I suspect.
=EF=BB=BF
> I suspect the oops is also why the bootup breaks, so it's likely all the=20
> same issue. Please save the dmesg into a file, reboot into a working=20
> setup, and send that. Along with hw information (it's likely related to=20
> your network device driver, since I've not seen an uproar of these kinds=20
> of problems from everybody else..).

Actually, please apply the patch "=EF=BB=BFrt2x00: Use atomic interface
iteration in irq context" before trying anything more, that'll fix it.
I'm not sure where Linville is hiding ;)

(http://article.gmane.org/gmane.linux.kernel.wireless.general/15268)

johannes

--=-9XnJ+yhkO3WoZphoPs9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD299KVg1VMiehFYAQIiEg/8C+iLVxvWEFSi+C784nrvRe/3ZBxkVut2
gtczpascZyZii9Xr6pNWoRvl4U70gOx37KMMXCL49vxhqsKFICu6IKl9lZbCLY/H
8P/kl1vB/pFe7MoR+P3IsUIKFajHFKHeKApDSNpizRCZVXxHBg7vwF+ldni74ILQ
kz8IXgi2TmUJ+GSQcEPzH0f0xwObILlCh1LrXOwRBC+hXE8qPY+S6ovJKHdkT4Zu
e3fxGr2kGejzKvgOpnuL3NGThfqNpLwBnv0FQy09IjHBFAPvAhQHDeufmmCa9xIw
ppi5BkY3uuAdKY5J+CbIPdu8eWTtWAOCKFDgYwmxPGd/WnODbVGaQ4T4E8y24YA0
A0DRrtmvh6lJ83olfu/xSMyi2Wx1oDvoHO84KYvFwgXLT8lUMVstOx4tYUrb+Dnd
t3OSc4GU2iBh8bjqD0dv5ZIMXEyReknwbocRTi7N9VQ446zmnf0GEEseU/N8Q5JZ
4leTPFtSsDQr7MtAA2a610wcTH+v17NPFZ9UpeJ6Plujoe1TbW0DFNl1+Mko8az2
yVWny7EyfF1UUBYnBuTok5B8UC3YmfTNRgFTYbF98DF+Hl+ydOFs4kB/sbYMLRLe
8H+2ZCxif+n/YL4AWx3qVnuJQsyPpqwaIj2OPepOAZjFAyf1fmXOXiEo9y36fJlU
RT2MvVW69Kg=
=w69Z
-----END PGP SIGNATURE-----

--=-9XnJ+yhkO3WoZphoPs9o--

