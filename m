Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYC1Mxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYC1Mxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYC1Mvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:49 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2770 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYC1Mvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:48 -0400
Message-ID: <47ECE9BB.3050006@imap.cc>
Date: Fri, 28 Mar 2008 13:51:07 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net>
In-Reply-To: <200803280249.42193.david-b@pacbell.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1FC5869A06BAE1123E71E6C7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1FC5869A06BAE1123E71E6C7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Mar 2008 02:49:41 -0700, David Brownell wrote:
> It seems too many people are used to enabling a legacy RTC despite=20
> the Kconfig help/comments; the gentle approach hasn't worked.

Gentleness is not the point. The Kconfig help/comments where just
not clear at all.

FWIW, it's still confusing to have an option "Enhanced Real Time
Clock Support" under "Character Devices", then later an option
"Real Time Clock" one level higher, none of the two in any way
acknowledging the existence of the other one, and only after
naively selecting both, you are told that there is some sort of
conflict. Couldn't this be made more explicit, such as:
- mentioning in both options' help text that the other one
   shouldn't be selected at the same time (if that's true)
- noting explicitly which of the two RTC options is the "legacy"
   one (is it RTC_CLASS?)
- enhancing the conflict message, which reads, in git-current:
        *** Conflicting RTC option has been selected, check GEN_RTC
        *** RTC interfaces ***
   Perhaps it's only me, but I do not know what to make of this.

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig1FC5869A06BAE1123E71E6C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH7Om7Q3+did9BuFsRAgvBAJ44Qb2EJRPNmcjKspYwRYh0nwnLFACeIARi
5JRZaHYw5/7rbnPE/jmDOpk=
=eMpk
-----END PGP SIGNATURE-----

--------------enig1FC5869A06BAE1123E71E6C7--
