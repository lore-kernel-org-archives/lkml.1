Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZLVTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZLVTla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZLVTl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:41:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41910 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbZLVTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=LMDhp7Ekg45CHqLnjhnOktfpG/tU4gXHiiQo7zHaf3TM8ffvU5vN6Ms0+Jqz5lRAz3
         m68nJd6ssAakJnSbD49EWd4Ssu1vNEFjg4dcDJXel46EgQdKazNv43ebfYoMMIV3qYEq
         USDXu/Wt9geV01GG+ChCvoexXL/LeplHvPK5s=
Message-ID: <4B3120E2.7070307@gmail.com>
Date: Tue, 22 Dec 2009 14:41:22 -0500
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
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <4B311D20.7020400@redhat.com> <4B311ECB.6040205@gmail.com> <4B312042.7010804@redhat.com>
In-Reply-To: <4B312042.7010804@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig50247FF784F95F3FF76E2066"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig50247FF784F95F3FF76E2066
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/22/09 2:38 PM, Avi Kivity wrote:
> On 12/22/2009 09:32 PM, Gregory Haskins wrote:
>> xinterface, as it turns out, is a great KVM interface for me and easy =
to
>> extend, all without conflicting with the changes in upstream.  The old=

>> way was via the kvm ioctl interface, but that sucked as the ABI was
>> always moving.  Where is the problem?  ioeventfd still works fine as
>> it is.
>>   =20
>=20
> It means that kvm locking suddenly affects more of the kernel.
>=20

Thats ok.  This would only be w.r.t. devices that are bound to the KVM
instance anyway, so they better know what they are doing (and they do).

-Greg


--------------enig50247FF784F95F3FF76E2066
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksxIOIACgkQP5K2CMvXmqGQegCeJFYZWuAUJyCQ8FQwFIUMc7at
p7UAn2M2HWKIw9trJq0ZxH65DCFPX6xM
=bw6e
-----END PGP SIGNATURE-----

--------------enig50247FF784F95F3FF76E2066--
