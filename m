Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbZEMKxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbZEMKxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZEMKxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:53:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59930 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbZEMKxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:53:42 -0400
Message-ID: <4A0AA6AE.5080709@novell.com>
Date: Wed, 13 May 2009 06:53:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws> <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws> <4A0824C2.4000109@gmail.com> <4A0860D7.6010708@codemonkey.ws>
In-Reply-To: <4A0860D7.6010708@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigED07AB3D9D40DBD89633B77B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigED07AB3D9D40DBD89633B77B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>>
>> So, yes, the delta from PIO to HC is 350ns.  Yes, this is a ~1.4%
>> improvement.  So what?  Its still an improvement.  If that improvement=

>> were for free, would you object?  And we all know that this change isn=
't
>> "free" because we have to change some code (+128/-0, to be exact).  Bu=
t
>> what is it specifically you are objecting to in the first place?  Addi=
ng
>> hypercall support as an pv_ops primitive isn't exactly hard or complex=
,
>> or even very much code.
>>  =20
>
> Where does 25us come from?  The number you post below are 33us and 66us=
=2E

<snip>

The 25us is approximately the max from an in-kernel harness strapped
directly to the driver gathered informally during testing.  The 33us is
from formally averaging multiple runs of a userspace socket app in
preparation for publishing.  I consider the 25us the "target goal" since
there is obviously overhead that a socket application deals with that
theoretically a guest bypasses with the tap-device.  Note that the
socket application itself often sees < 30us itself...this was just a
particularly "slow" set of runs that day.

Note that this is why I express the impact as "approximately" (e.g.
"~4%").  Sorry for the confusion.

-Greg


--------------enigED07AB3D9D40DBD89633B77B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoKpq4ACgkQlOSOBdgZUxnFqQCdFZy7CVK5gdTf/QzTh9t+XRBC
HFkAn1GkRKNfvoeC3WKnPeXtRb5bkOkR
=80kT
-----END PGP SIGNATURE-----

--------------enigED07AB3D9D40DBD89633B77B--
