Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZLVS4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZLVS4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZLVS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:56:45 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:60194 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZLVS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=gWJWmWsMgz1wR73I32CFR2jEnzGWTKIaEMQZG0Jk9oPvQwqlUYftM34QHE9ftUPMY4
         MGtY4zdOl5JMS3hi0Z0kbIyQN73Uh/vv2dukTcgDcFaBoSyVLO/8JPMUoC6B/zNaJQA6
         aOy0EyUz6qHPT5lRZY/zXM0bkBKW0SF9x/0ho=
Message-ID: <4B311667.5080405@gmail.com>
Date: Tue, 22 Dec 2009 13:56:39 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com>
In-Reply-To: <4B3115C1.4070303@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6C7BEE90DCC1CF66CE90B145"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6C7BEE90DCC1CF66CE90B145
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/22/09 1:53 PM, Avi Kivity wrote:
> On 12/22/2009 07:36 PM, Gregory Haskins wrote:
>>
>>> Gregory, it would be nice if you worked _much_ harder with the KVM fo=
lks
>>> before giving up.
>>>     =20
>> I think the 5+ months that I politely tried to convince the KVM folks
>> that this was a good idea was pretty generous of my employer.  The KVM=

>> maintainers have ultimately made it clear they are not interested in
>> directly supporting this concept (which is their prerogative), but are=

>> perhaps willing to support the peripheral logic needed to allow it to
>> easily interface with KVM.  I can accept that, and thus AlacrityVM was=

>> born.
>>   =20
>=20
> Review pointed out locking issues with xinterface which I have not seen=

> addressed.  I asked why the irqfd/ioeventfd mechanisms are insufficient=
,
> and you did not reply.
>=20

Yes, I understand.  I've been too busy to rework the code for an
upstream push.  I will certainly address those questions when I make the
next attempt, but they weren't relevant to the guest side.


--------------enig6C7BEE90DCC1CF66CE90B145
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksxFmcACgkQP5K2CMvXmqG/FQCbBrkWYeSsy/McAXgIeunEVht6
wdUAn2yXf163nKyYkPWFt3orqnFbSwBr
=+fMG
-----END PGP SIGNATURE-----

--------------enig6C7BEE90DCC1CF66CE90B145--
