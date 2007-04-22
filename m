Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXDVO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXDVO0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030910AbXDVO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:26:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49719 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030901AbXDVO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:26:34 -0400
X-Sasl-enc: ra/4kPpfPpgxdrxQxSgwsTB98hA3I0NrUR3SoOLIu5mC 1177251993
Message-ID: <462B712D.7070504@imap.cc>
Date: Sun, 22 Apr 2007 16:29:01 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kkeil@suse.de, i4ldeveloper@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
References: <20070115172912.GA3323@pingi.kke.suse.de>	<462A0CA7.2090908@imap.cc>	<20070421215844.542d3aab@the-village.bc.nu>	<20070421.151052.78709111.davem@davemloft.net>	<462B54A0.9000203@imap.cc> <20070422135835.037e323c@the-village.bc.nu>
In-Reply-To: <20070422135835.037e323c@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig639A5C55623FCC2BAB464F11"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig639A5C55623FCC2BAB464F11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.04.2007 14:58 schrieb Alan Cox:
>>>> If it isn't obsolete then fix the code to use the newer APIs
>> Why should that be a precondition for removing the incorrect
>> "obsolete" label?
>=20
> Because if we remove the obsolete label the users are going to be
> suprised when it goes away entirely with && BROKEN or && !HOTPLUG or
> similar.

I trust that && BROKEN won't happen before it will actually *be*
obsolete and correctly re-labelled as such. As for the && !HOTPLUG
menace you keep touting, that might perhaps be applied to some of
the individual hardware device drivers but certainly not to the
I4L core itself. What you mean by "or similar" I cannot guess.
AFAIK we don't have an && EYESORE option yet. :-)

>> Any change that breaks isdn4linux before its
>> replacement is ready would constitute a regression.
>> We've been there once, remember?
>=20
> Want to be on that. There is nobody maintaining it. That isn't a
> sustainable situation so it will break.

Not sure I'm following you. There is an official maintainer, and
although he's currently rather silent on this topic, there's no
reason to believe he won't step up if there's actually some urgent
maintaining to be done.

>> [L]ack of a working replacement *is* an
>> argument for concluding that something is not obsolete.
>=20
> Ok then it should be marked "BROKEN" instead.

Is that a serious suggestion? Replace one wrong label with another,
even wronger one? I don't see how that might help.

>> - These are two independent problems. Blocking the correction of
>>   one of them because the other one still exists doesn't help,
>>   but only risks deadlock.
>=20
> No risk of deadlock. It'll progress to && BROKEN which will either caus=
e
> sufficient pain for someone to get off their arse and fix it, for enoug=
h
> of a vendors users to get the vendor to do the work or for someone who
> cares to pay a third party to do the work.

Do I sense some hidden agenda there?

The isdn4linux subsystem will not "progress" to BROKEN unless
somebody pushes it there. It is currently working sufficiently
well for its users to fill the gap until its successor CAPI is
ready. Once that happens, it can be obsoleted, but not before.
I know people are less than happy this hasn't happened yet, but
the way to promote the move to CAPI is not to kill off I4L before
the time and leave users standing in the rain.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enig639A5C55623FCC2BAB464F11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGK3EtMdB4Whm86/kRAhgTAJ0Xy98hk6y0yrTYNcll4S9UFvpKRQCfXso8
kBctNlGq4HT74NiAuOC2DK0=
=ed3Y
-----END PGP SIGNATURE-----

--------------enig639A5C55623FCC2BAB464F11--
