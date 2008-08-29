Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbYH2Qc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbYH2Qc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYH2QcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:32:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51150 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYH2QcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:32:18 -0400
Message-ID: <48B823F6.1010509@novell.com>
Date: Fri, 29 Aug 2008 12:29:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>, mingo@elte.hu,
       rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org>
In-Reply-To: <20080829162216.GW26610@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBECBE93C59AE269ACCF9414C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBECBE93C59AE269ACCF9414C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
>> Im running it on a x86_64 box as we speak.  How can I tell if there is=
 a
>> certain mode that is permitting this?
>>    =20
>
> If the boot up says you're running with PMtimer then it uses the fallba=
ck
> (usually happens on pre Fam10h AMD boxes). A typical Intel box
> would use the faster ring 3 only TSC path and then explode with your
> change I bet.=20
>  =20

Thinking about this some more, perhaps the issue is I am not hitting the
contended path in vsyscall?

-Greg



--------------enigBECBE93C59AE269ACCF9414C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki4I/YACgkQlOSOBdgZUxmOWwCfV+N6HBTlTeyzEy3A0TH1iMF/
K+kAn0GFKYL6LTtr93N3qT8XCSX7U6IR
=QH1h
-----END PGP SIGNATURE-----

--------------enigBECBE93C59AE269ACCF9414C--
