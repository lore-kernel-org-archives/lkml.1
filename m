Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZJURHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZJURHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJURHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:07:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47044 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbZJURHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:07:15 -0400
X-Sasl-enc: SnAq0D7qgHPM/A8x0Rn7J3lANMfvIzHJqA6lNgC4p2au 1256144839
Message-ID: <4ADF3FBB.1060009@imap.cc>
Date: Wed, 21 Oct 2009 19:07:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl false positive? "ERROR: do not use assignment in
 if condition"
References: <4ADDDC55.8020809@imap.cc> <20091020085820.e312a38b.rdunlap@xenotime.net> <20091020162400.GF13064@penfold>
In-Reply-To: <20091020162400.GF13064@penfold>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig17E6A4A32FCDA92C73E205C1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig17E6A4A32FCDA92C73E205C1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andy Whitcroft schrieb:
> On Tue, Oct 20, 2009 at 08:58:20AM -0700, Randy Dunlap wrote:
>> On Tue, 20 Oct 2009 17:50:45 +0200 Tilman Schmidt wrote:
>>
>>> The command
>>> ./scripts/checkpatch.pl -f drivers/isdn/gigaset/bas-gigaset.c=20
>>> produces a lot of "ERROR" messages like these:
>>>
>>> ERROR: do not use assignment in if condition
>>> #608: FILE: isdn/gigaset/bas-gigaset.c:608:
>>> +       if ((ret =3D usb_submit_urb(ucs->urb_cmd_in, GFP_ATOMIC)) !=3D=
 0) {
>>>
>>> ERROR: do not use assignment in if condition
>>> #745: FILE: isdn/gigaset/bas-gigaset.c:745:
>>> +               if ((ucs->rcvbuf =3D kmalloc(l, GFP_ATOMIC)) =3D=3D N=
ULL) {
>>>
>>> ERROR: do not use assignment in if condition
>>> #753: FILE: isdn/gigaset/bas-gigaset.c:753:
>>> +               if ((rc =3D atread_submit(cs, BAS_TIMEOUT)) < 0) {
>>>
>>> As far as I can see there's nothing wrong with these lines. In partic=
ular,
>>> I cannot find anything in Documentation/CodingStyle that would prohib=
it an
>>> assignment inside an 'if' condition.
>> Yes, we don't try to list Every Possible Problem in CodingStyle,

Well, that's not very nice towards small time developers like me.
I try to follow CodingStyle as best I can, only to get smacked with
a checkpatch ERROR for something that isn't even hinted at there.
If a way of coding is such an abomination that it merits an ERROR
from checkpatch (meaning " change this or see your submission
rejected"), then it also merits being mentioned in CodingStyle.

>> but emails on lkml over the past several years try to discourage such
>> assignments inside if's because they can be confusing, difficult to re=
ad,
>> and generally are not helping to produce any better code output than
>> using:
>> 	ret =3D usb_submit_urb(args);
>> 	if (ret) {
>> 		foo;
>> 		bar;
>> 		blah();
>> 	}

I don't agree, but judging from your wording you don't want to hear any
arguments, so I'll leave it at that. I just want to know *beforehand*
what I have to do in order to get my code merged.

> What he said :).  We try and codify the preferred style where there is
> a preference.  That preference was made by reviewers as it is much
> harder to accidentally do the following when you meant the assignment o=
r
> visa versa:

But does a mere preference by some reviewers warrant an ERROR message,
when even a line that exceeds the 80 character limit, which is
elaborately justified in CodingStyle, produces only a warning?

Again, I don't want to start a discussion about that preference. I know
now that it exists, and I am in no position to question it. But how many
of those preferences may yet turn up to bite me? If people are feeling
so strongly about a preference that those who do not honor it must be
slapped with a checkpatch ERROR then they should also find the energy
to add an appropriate warning about that to CodingStyle so that coders
have a chance to avoid it. That's only fair.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig17E6A4A32FCDA92C73E205C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK3z/FQ3+did9BuFsRAkqUAJ9E9kZUyoGNPjkYezK0Ec2jiDpBhQCeP916
czBliXXwA/ex/sQCo0Dzx28=
=VdfI
-----END PGP SIGNATURE-----

--------------enig17E6A4A32FCDA92C73E205C1--
