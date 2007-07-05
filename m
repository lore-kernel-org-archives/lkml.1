Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXGEGo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXGEGo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXGEGot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:44:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36149 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbXGEGos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:44:48 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: x86_64 memory hotplug simulation support?
Date: Thu, 5 Jul 2007 16:44:54 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707051430.00800.nigel@nigel.suspend2.net> <20070705145527.2798.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20070705145527.2798.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8004533.CuxqoNjGfF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707051644.55191.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8004533.CuxqoNjGfF
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 16:20:18 Yasunori Goto wrote:
> Hello. Nigel-san.
>=20
> > I'm wondering whether anyone has patches lying around that might be use=
ful=20
for=20
> > simulating memory hotplug on x86_64. Goggling has revealed some old x86=
=20
> > patches, but that's all.
>=20
> I'm not sure what "simulation" means.
> Could you tell me how/what do you expect memory hotplug
> simulation exactly?
>=20
> Memory hot-add code is included in kernel. And, remove(unplug) code
> has developed (and hopefully, it will be merged to -mm after
> some cleanups, I think.)
>=20
> I would like to make sure what is necessary.

Thanks for your reply. Please, just call me Nigel :). I saw a patch that Da=
ve=20
Hansen had posted, back around the time of 2.6.11 iirc. It was for x86, and=
=20
(so far as I understand) allowed a person who doesn't really have=20
hotpluggable memory to make their computer pretend that it does.

Just in case I'm not being clear enough, let me get more concrete. I have h=
ad=20
some code for a while that uses bitmaps to simulate page flags, without=20
needing to take up those precious bits in page->flags. I've begun to add=20
support for memory hotplugging, in the hope that I can make it general enou=
gh=20
that it will be useful for more than just suspend2. To do that, I'd like to=
=20
be able to test the memory hotplugging paths, without needing to actually=20
have hotpluggable memory. I do have an x86 desktop I could work on, but wou=
ld=20
prefer to do it on my x86_64 laptop if I can.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart8004533.CuxqoNjGfF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjJNnN0y+n1M3mo0RAvo8AJ0d7pNmI4Z1pqrPvK3diIRH+NDCOACgonP5
F85QLqAyniOi4EU6Conlgvk=
=keJA
-----END PGP SIGNATURE-----

--nextPart8004533.CuxqoNjGfF--
