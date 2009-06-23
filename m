Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZFWLku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZFWLku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZFWLkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:40:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45424 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZFWLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:40:41 -0400
Message-ID: <4A40BF30.9000707@novell.com>
Date: Tue, 23 Jun 2009 07:40:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090623085633.GA16294@redhat.com> <4A40BD73.8050902@novell.com> <20090623113634.GC17635@redhat.com>
In-Reply-To: <20090623113634.GC17635@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3430ADB1817DC0835808E89A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3430ADB1817DC0835808E89A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 07:33:07AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> +static int
>>>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, i=
nt len,
>>>> +			  int is_write)
>>>> +{
>>>> +	struct _iosignalfd_group *p =3D to_group(this);
>>>> +
>>>> +	return ((addr >=3D p->addr && (addr < p->addr + p->length)));
>>>> +}
>>>>    =20
>>>>        =20
>>> I think I see a problem here. For virtio, we do not necessarily want =
all
>>> virtqueues for a device to live in kernel: there might be control
>>> virtqueues that we want to leave in userspace. Since this claims all
>>> writes to a specific address, the signal never makes it to userspace.=

>>>
>>>  =20
>>>      =20
>> You can use a wildcard.  Would that work?
>>
>>    =20
>
> Nope, you need to know the value written.
>
>  =20
Note: You can also terminate an eventfd in userspace...it doesn't have
to terminate in-kernel.  Not sure if that helps.


--------------enig3430ADB1817DC0835808E89A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAvzEACgkQlOSOBdgZUxkyxwCeMoRc9C4FICoeF1VVIKTQkv23
eQ0Anj2TLvIOb6rnHOqZSyYYpnFDxce1
=wL0C
-----END PGP SIGNATURE-----

--------------enig3430ADB1817DC0835808E89A--
