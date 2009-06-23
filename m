Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZFWMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZFWMCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZFWMCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:02:07 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54456 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZFWMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:02:05 -0400
Message-ID: <4A40C434.9090306@novell.com>
Date: Tue, 23 Jun 2009 08:01:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com> <20090623114438.GD17635@redhat.com> <4A40C2E7.9000705@redhat.com>
In-Reply-To: <4A40C2E7.9000705@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD160633A48ED89F30919328F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD160633A48ED89F30919328F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/23/2009 02:44 PM, Michael S. Tsirkin wrote:
>> On Tue, Jun 23, 2009 at 12:04:06AM -0400, Gregory Haskins wrote:
>>  =20
>>>>>   It will also need to support
>>>>> multiple matches.
>>>>>
>>>>>         =20
>>>> What, signal many fds on the same address/value pair?
>>>> I see this as a bug. Why is this a good thing to support?
>>>> Just increases the chance of leaking this fd.
>>>>
>>>>       =20
>>> I believe Avi asked for this feature specifically, so I will defer
>>> to him.
>>>     =20
>>
>> Hmm. That's hard to implement in my model. Avi, can we give up
>> this feature? I don't think anyone needs this specifically ...
>>   =20
>
> I think we can make do with passing that single eventfd to multiple
> consumers.  It means their event count reads may return zero, but I
> guess we can live with that.
>
> I do want to retain flexibility in how we route events.
>

Ok, so for now I will just crank up the io_bus array, and we can address
scale another day.  Can I just drop patch 2/3 and let the io_bus govern
the limit?

-Greg


--------------enigD160633A48ED89F30919328F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAxDUACgkQlOSOBdgZUxnGKQCdGo9Dy+Uci9DWlSv7BEfV+3No
ZikAn3zEeJ4Wkp5YrX/aG4s+lTDjSbiW
=KpFI
-----END PGP SIGNATURE-----

--------------enigD160633A48ED89F30919328F--
