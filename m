Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZIXSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZIXSEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZIXSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:04:37 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62210 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZIXSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=lE4XB2ViOGfJSM+bFhUTdVjhCN/zVhk3XKGRkLKQ66d7RxzRw982v+2sLomeqwCFsr
         o70J4LHOx60/Y6DZA4j25xA3ng87tdXf+srgAEKIXy1oH419gDo1PDkHkq5SV55Fay5M
         3G8LBsX9ujy0cDxw3Hl0Wa7By1Yne/8SaIR9c=
Message-ID: <4ABBB4B2.7050404@gmail.com>
Date: Thu, 24 Sep 2009 14:04:34 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <4AB0A070.1050400@redhat.com> <4AB0CFA5.6040104@gmail.com> <4AB0E2A2.3080409@redhat.com> <4AB0F1EF.5050102@gmail.com> <4AB10B67.2050108@redhat.com> <4AB13B09.5040308@gmail.com> <4AB151D7.10402@redhat.com> <4AB1A8FD.2010805@gmail.com> <20090921214312.GJ7182@ovro.caltech.edu> <4AB89C48.4020903@redhat.com> <4ABA3005.60905@gmail.com> <4ABA32AF.50602@redhat.com> <4ABA3A73.5090508@gmail.com> <4ABA61D1.80703@gmail.com> <4ABA78DC.7070604@redhat.com> <4ABB27B9.4050904@redhat.com>
In-Reply-To: <4ABB27B9.4050904@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDE5D73E043EEC9B7281C9F0D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDE5D73E043EEC9B7281C9F0D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 09/23/2009 10:37 PM, Avi Kivity wrote:
>>
>> Example: feature negotiation.  If it happens in userspace, it's easy
>> to limit what features we expose to the guest.  If it happens in the
>> kernel, we need to add an interface to let the kernel know which
>> features it should expose to the guest.  We also need to add an
>> interface to let userspace know which features were negotiated, if we
>> want to implement live migration.  Something fairly trivial bloats
>> rapidly.
>=20
> btw, we have this issue with kvm reporting cpuid bits to the guest.=20
> Instead of letting kvm talk directly to the hardware and the guest, kvm=

> gets the cpuid bits from the hardware, strips away features it doesn't
> support, exposes that to userspace, and expects userspace to program th=
e
> cpuid bits it wants to expose to the guest (which may be different than=

> what kvm exposed to userspace, and different from guest to guest).
>=20

This issue doesn't exist in the model I am referring to, as these are
all virtual-devices anyway.  See my last reply

-Greg


--------------enigDE5D73E043EEC9B7281C9F0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkq7tLIACgkQP5K2CMvXmqFsrACfdMqWfjhbcD0aRdM1iWka41vU
lDkAmwWgvAoZNTrMhDRgJ/UlEl0f4Mpo
=5LFr
-----END PGP SIGNATURE-----

--------------enigDE5D73E043EEC9B7281C9F0D--
