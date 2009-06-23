Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZFWLd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZFWLd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZFWLdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:33:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33894 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZFWLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:33:19 -0400
Message-ID: <4A40BD73.8050902@novell.com>
Date: Tue, 23 Jun 2009 07:33:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090623085633.GA16294@redhat.com>
In-Reply-To: <20090623085633.GA16294@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3B31A81BB5CE4856BB7BF978"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3B31A81BB5CE4856BB7BF978
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
>  =20
>> +static int
>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int=
 len,
>> +			  int is_write)
>> +{
>> +	struct _iosignalfd_group *p =3D to_group(this);
>> +
>> +	return ((addr >=3D p->addr && (addr < p->addr + p->length)));
>> +}
>>    =20
>
> I think I see a problem here. For virtio, we do not necessarily want al=
l
> virtqueues for a device to live in kernel: there might be control
> virtqueues that we want to leave in userspace. Since this claims all
> writes to a specific address, the signal never makes it to userspace.
>
>  =20
You can use a wildcard.  Would that work?


--------------enig3B31A81BB5CE4856BB7BF978
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAvXMACgkQlOSOBdgZUxkCegCcCwx6ZrwhlhktUjqHwdniWlq/
3MsAn0sg5TvJ5/yMZqzwtiGJAGqnDzTm
=aGJe
-----END PGP SIGNATURE-----

--------------enig3B31A81BB5CE4856BB7BF978--
