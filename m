Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYKDQw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYKDQw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbYKDQr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:47:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:40312 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbYKDQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=F41ndjSAdvOa+7Xd6IzaCrIqJ2Fa55dsd52HdXkQr/hTyzEKmzfjbYhc173E0Kp5Ym
         W0/jbdKB57CbjbhILHIXcwozUPCnu3cJSW4kCST14NTAk0VsFjbSZKlJ29F6hPSP+qkr
         58nrh0r5ySQs2Yo2x/8zI6yKLZd51gM4f4C4Y=
Message-ID: <49107D98.9080201@gmail.com>
Date: Tue, 04 Nov 2008 18:51:36 +0200
From: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, hugh <hugh@veritas.com>
Subject: Re: mmap: is default non-populating behavior stable?
References: <490F73CD.4010705@gmail.com>	<1225752083.7803.1644.camel@twins>	<490F8005.9020708@redhat.com>	<491070B5.2060209@nortel.com>	<1225814820.7803.1672.camel@twins> <20081104162820.644b1487@lxorguk.ukuu.org.uk>
In-Reply-To: <20081104162820.644b1487@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD117098E412C7926C3D55A1A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD117098E412C7926C3D55A1A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alan Cox wrote:
> On Tue, 04 Nov 2008 17:07:00 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>> [snip]
>> I'm not sure how POSIX speaks of this.
>>
>> I think Linux does the expected thing.
>=20
> I believe our behaviour is correct for mmap/mumap/truncate and it
> certainly used to be and was tested.
>=20
> At the point you do anything involving mremap (which is non posix) our
> behaviour becomes rather bizarre.

Thanks to all for answers. I have made the conclusion that doing "open() =
new
file, truncate(<big size>), mmap(<the same big size>), write/read some me=
mory
pages" should not populate other, untouched by write/read pages (until
MAP_POPULATE given), right?

--=20
Eugene V. Lyubimkin aka JackYF


--------------enigD117098E412C7926C3D55A1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkQfZ4ACgkQchorMMFUmYxbqgCfUXKdc7I7juZHEBsyPsVVtwiu
zYwAn3cPA8yySpv583SYEUxTmcPALVQm
=mfAu
-----END PGP SIGNATURE-----

--------------enigD117098E412C7926C3D55A1A--
