Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXDVMYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXDVMYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030512AbXDVMYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:24:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43415 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030502AbXDVMYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:24:50 -0400
X-Sasl-enc: Sw2jHOahZNhgggJYHKDNFTTuzP1krPpvfou7cxOx5NGz 1177244689
Message-ID: <462B54A0.9000203@imap.cc>
Date: Sun, 22 Apr 2007 14:27:12 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
CC: linux-kernel@vger.kernel.org, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de, akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
References: <20070115172912.GA3323@pingi.kke.suse.de>	<462A0CA7.2090908@imap.cc>	<20070421215844.542d3aab@the-village.bc.nu> <20070421.151052.78709111.davem@davemloft.net>
In-Reply-To: <20070421.151052.78709111.davem@davemloft.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EF6D7F6097185D6E7912C04"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EF6D7F6097185D6E7912C04
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.04.2007 00:10 schrieb David Miller:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Sat, 21 Apr 2007 21:58:44 +0100
>=20
>> On Sat, 21 Apr 2007 15:07:51 +0200
>> Tilman Schmidt <tilman@imap.cc> wrote:
>>
>>> From: Tilman Schmidt <tilman@imap.cc>
>>>
>>> The "obsolete" label on the ISDN_I4L Kconfig option is not, and
>>> has never been, accurate. It has already prompted repeated attempts
>>> to remove actively used functionality from the kernel without a
>>> working replacement. This patch removes the incorrect label and
>>> corrects the accompanying help text.
>>>
>>> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
>> Nak-by: Alan Cox <alan@redhat.com>
>>
>> If it isn't obsolete then fix the code to use the newer APIs

Why should that be a precondition for removing the incorrect
"obsolete" label?

The code works, and adapting it to newer APIs is the job of those
who introduced those newer APIs in the first place, according to
the oft-touted stable_api_nonsense.txt policy document. In fact I
suspect the incorrect "obsolete" label is a major reason why they
haven't done that job so far.

Anyway, I'm not the right person for that job. I know neither the
code in question nor those newer APIs well enough to do it. I am
just trying to help by correcting an error I found. That doesn't
make me responsible for every other problem that code may have.

>> as its about
>> to end up && BROKEN let alone Obsolete.

That can't happen. Any change that breaks isdn4linux before its
replacement is ready would constitute a regression.
We've been there once, remember?

> There is zero work being done on that subsystem to freshen it up
> and make it current in any way.

Not true. What is true, however, is that the main effort of ISDN
development is currently going into the future replacement for
isdn4linux, the CAPI subsystem. But that's no reason to mark the
current one as obsolete before the time.

> Lack of a working replacement is not an argument for anything.

I beg to differ. Existence of a working replacement is exactly
the criterion we arrived at when discussing the meaning of the
term "obsolete". So lack of a working replacement *is* an
argument for concluding that something is not obsolete.

To sum it up:

- The "obsolete" label on the isdn4linux subsystem is, and has
  always been, incorrect.

- The authors of certain in-kernel API changes seem to have
  neglected the isdn4linux subsystem in their work.

- These are two independent problems. Blocking the correction of
  one of them because the other one still exists doesn't help,
  but only risks deadlock.

I therefore kindly ask you to accept this patch even though I
cannot offer a remedy for the other gripes you have with the
isdn4linux subsystem, and even though you might personally not
have any use for that subsystem.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enig2EF6D7F6097185D6E7912C04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGK1SpMdB4Whm86/kRAoAFAJ9JHp9htyb54IGNOWKTQj7xW4VA9wCfSdSg
tg66TmIOv+FbS2SblAk3A2w=
=SDPA
-----END PGP SIGNATURE-----

--------------enig2EF6D7F6097185D6E7912C04--
