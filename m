Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZEFQDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZEFQDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZEFQDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:03:38 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46417 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZEFQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:03:37 -0400
Message-ID: <4A01B4CF.3080706@novell.com>
Date: Wed, 06 May 2009 12:03:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws>
In-Reply-To: <4A019717.7070806@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF52EDB868B01494D75DDAB32"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF52EDB868B01494D75DDAB32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>>
>> Today, there is no equivelent of a platform agnostic "iowrite32()" for=

>> hypercalls so the driver would look like the pseudocode above except
>> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The proposa=
l
>> is to allow the hypervisor to assign a dynamic vector to resources in
>> the backend and convey this vector to the guest (such as in PCI
>> config-space as mentioned in my example use-case).  The provides the
>> "address negotiation" function that would normally be done for somethi=
ng
>> like a pio port-address.   The hypervisor agnostic driver can then use=

>> this globally recognized address-token coupled with other device-priva=
te
>> ABI parameters to communicate with the device.  This can all occur
>> without the core hypervisor needing to understand the details beyond t=
he
>> addressing.
>>  =20
>
> PCI already provide a hypervisor agnostic interface (via IO regions).=20
> You have a mechanism for devices to discover which regions they have
> allocated and to request remappings.  It's supported by Linux and
> Windows.  It works on the vast majority of architectures out there toda=
y.
>
> Why reinvent the wheel?

I suspect the current wheel is square.  And the air is out.  Plus its
pulling to the left when I accelerate, but to be fair that may be my
alignment....

:) But I digress.  See: http://patchwork.kernel.org/patch/21865/

To give PCI proper respect, I think its greatest value add here is the
inherent IRQ routing (which is a huge/difficult component, as I
experienced with dynirq in vbus v1).  Beyond that, however, I think we
can do better.

HTH
-Greg



--------------enigF52EDB868B01494D75DDAB32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoBtM8ACgkQlOSOBdgZUxmBQgCfauKW7ZdTD0wPtxIl+/FCeruV
fV0AnRQo3lV+fyiZW90M08rsI8tdp9NI
=h0oB
-----END PGP SIGNATURE-----

--------------enigF52EDB868B01494D75DDAB32--
