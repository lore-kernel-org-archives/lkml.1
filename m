Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZGGNS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZGGNS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZGGNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:18:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47580 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbZGGNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:18:14 -0400
Message-ID: <4A534B01.4020007@novell.com>
Date: Tue, 07 Jul 2009 09:17:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com>
In-Reply-To: <4A53372E.6090509@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE4BA011FB69B4CAF01779DD4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE4BA011FB69B4CAF01779DD4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> (adding Davide, there's a small comment for you in the middle, search
> for eventfd)
>
> On 07/07/2009 02:20 PM, Michael S. Tsirkin wrote:
>>
>>> @@ -307,6 +307,19 @@ struct kvm_guest_debug {
>>>       struct kvm_guest_debug_arch arch;
>>>   };
>>>
>>> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1<<  0) /* trigger is valid *=
/
>>>     =20
>>
>> can we rename trigger ->  value?
>>   =20
>
> Or maybe data_match?

Yeah, at the least I should be consistent with trigger/match
>
> Speaking of renames, how about IOSIGNALFD -> IOEVENTFD?  I have some
> vague uneasiness seeing signals all the time.

Sure, that works for me.

-Greg



--------------enigE4BA011FB69B4CAF01779DD4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTSwEACgkQlOSOBdgZUxlp3ACePpRde9UldP8O8UAbINhqPS8K
87gAnRQFzOWitX/5BJusAAlcMRFUFE6+
=Egme
-----END PGP SIGNATURE-----

--------------enigE4BA011FB69B4CAF01779DD4--
