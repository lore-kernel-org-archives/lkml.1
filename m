Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZIYLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZIYLso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIYLsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:48:43 -0400
Received: from mail.klingt.org ([86.59.21.178]:52343 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZIYLsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:48:42 -0400
Message-ID: <4ABCADE2.1020300@klingt.org>
Date: Fri, 25 Sep 2009 13:47:46 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Lightning/1.0pre Shredder/3.0pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org> <4AB09562.3010501@klingt.org> <4AB0D34A.2010502@kernel.org> <4ABC44FE.5050904@kernel.org> <4ABC7543.90407@klingt.org> <4ABC7714.2030709@kernel.org>
In-Reply-To: <4ABC7714.2030709@kernel.org>
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7BDF7968254A89A4220DB068"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2b1 (klingt.org [127.0.0.1]); Fri, 25 Sep 2009 13:47:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7BDF7968254A89A4220DB068
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>>>>>> Can you please try the attached patch and report the result?  The =
bug
>>>>>> shouldn't happen now and for cases where it would have happened,
>>>>>> libata will report "link online but device misclassified" and retr=
y.
>>>>> this patch cannot be applied onto stable-2.6.31/master ... e.g. the=

>>>>> first chunk is already in there ....
>>>> Eh... the first chunk was for the current devel branch.  Here's a
>>>> version without that one.
>>> Ping.
>>
>> i haven't run into any further issues with this patch ... so i somehow=

>> guess, it solved the problem ...
>=20
> In your boot logs, do you ever see messages like "link online but
> device misclassified, retrying"?

i didn't really pay attention to it ... at my currently running system,
it doesn't show up ... but i will keep my eyes open ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

After one look at this planet any visitor from outer space would say
"I want to see the manager."
  William S. Burroughs


--------------enig7BDF7968254A89A4220DB068
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq8reQACgkQdL+4qsZfVssk+wCfTI6TsFIV76ChXt6Cnmvxmkox
3gMAn02yqCu8YHjfIGNJ88lxJCe1tDHK
=BwNs
-----END PGP SIGNATURE-----

--------------enig7BDF7968254A89A4220DB068--
