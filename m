Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZEGVOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZEGVOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZEGVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:13:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:24148 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZEGVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=pljPFpA+bQqZIzzZJZ5XASx/0a/QwNkaFnoa3a1U56wg2d5EloDwQuk9nYLlm/hVb8
         HqLwy/z8IqhoerMIqP7rsiWligr6hOt4bwbktrS/h3DHLsMRJzGr2lfIoNbRHJ5+xwH1
         cKXCZIo5B+s+sCYdc7T0sLlrGoMzPhUQpbDXs=
Message-ID: <4A034F0E.6010603@gmail.com>
Date: Thu, 07 May 2009 17:13:50 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chris Wright <chrisw@sous-sol.org>, Gregory Haskins <ghaskins@novell.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A031471.7000406@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A033685.7070802@gmail.com> <200905072254.06982.arnd@arndb.de>
In-Reply-To: <200905072254.06982.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE30FAEF574E3A77BEB9C0F3C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE30FAEF574E3A77BEB9C0F3C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Thursday 07 May 2009, Gregory Haskins wrote:
>  =20
>> What I am not clear on is how you would know to flag the address to
>> begin with.
>>    =20
>
> pci_iomap could look at the bus device that the PCI function sits on.
> If it detects a PCI bridge that has a certain property (config space
> setting, vendor/device ID, ...), it assumes that the device itself
> will be emulated and it should set the address flag for IO_COND.
>
> This implies that all pass-through devices need to be on a different
> PCI bridge from the emulated devices, which should be fairly
> straightforward to enforce.
>  =20

Thats actually a pretty good idea.

Chris, is that issue with the non ioread/iowrite access of a mangled
pointer still an issue here?  I would think so, but I am a bit fuzzy on
whether there is still an issue of non-wrapped MMIO ever occuring.

-Greg



--------------enigE30FAEF574E3A77BEB9C0F3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDTw4ACgkQP5K2CMvXmqGGvwCeMOTARdc6vnODRVcFuijQcXck
ph4AmwalQhdc5qiLZUbT5dL5IlrV/vN2
=iTIN
-----END PGP SIGNATURE-----

--------------enigE30FAEF574E3A77BEB9C0F3C--
