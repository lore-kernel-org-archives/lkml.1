Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZIKQOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZIKQOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZIKQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:14:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:16941 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbZIKQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=d8c6+OQO5la/gK4q1VwqWqapnJ3PKec3fwIpX6bg1jfooT8BEHgjb8/VQ553eAFvWK
         lshWS2Vw8hjuz1qv2Oy82hUaGBfPBzfNo3bNV/gVsugREoZMn5tT2q9a9xd4acTpS0b4
         OnQ72TI8e/J/IlUFbfAf2AoYcf1sgCR2bvxLk=
Message-ID: <4AAA774F.2050209@gmail.com>
Date: Fri, 11 Sep 2009 12:14:07 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu> <4AAA7415.5080204@gmail.com>
In-Reply-To: <4AAA7415.5080204@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig82C43E5F2EF2CEB5FEA90C83"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig82C43E5F2EF2CEB5FEA90C83
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:

[snip]

>=20
> FWIW: VBUS handles this situation via the "memctx" abstraction.  IOW,
> the memory is not assumed to be a userspace address.  Rather, it is a
> memctx-specific address, which can be userspace, or any other type
> (including hardware, dma-engine, etc).  As long as the memctx knows how=

> to translate it, it will work.
>=20

citations:

Here is a packet import (from the perspective of the host side "venet"
device model, similar to Michaels "vhost")

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dblob;f=3Dkernel/vbus/devices/venet-tap.c;h=3Dee091c47f06e9bb84=
87a45e72d493273fe08329f;hb=3Dded8ce2005a85c174ba93ee26f8d67049ef11025#l53=
5

Here is the KVM specific memctx:

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dblob;f=3Dkernel/vbus/kvm.c;h=3D56e2c5682a7ca8432c159377b0f7389=
cf34cbc1b;hb=3Dded8ce2005a85c174ba93ee26f8d67049ef11025#l188

and

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dblob;f=3Dvirt/kvm/xinterface.c;h=3D0cccb6095ca2a51bad01f7ba213=
7fdd9111b63d3;hb=3Dded8ce2005a85c174ba93ee26f8d67049ef11025#l289

You could alternatively define a memctx for your environment which knows
how to deal with your PPC boards PCI based memory, and the devices would
all "just work".

Kind Regards,
-Greg



--------------enig82C43E5F2EF2CEB5FEA90C83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqqd08ACgkQP5K2CMvXmqEaqQCfXWSJFQS12SmLB3k+J4WDiEJq
68cAoIjRCya0FvGnWGkZBETyFAe17+a/
=8hCs
-----END PGP SIGNATURE-----

--------------enig82C43E5F2EF2CEB5FEA90C83--
