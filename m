Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZEENka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZEENka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZEENkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:40:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60242 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZEENkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:40:16 -0400
Message-ID: <4A0041BA.6060106@novell.com>
Date: Tue, 05 May 2009 09:40:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com>
In-Reply-To: <4A0040C0.1080102@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB352C0A3FDD21142A4F5A85B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB352C0A3FDD21142A4F5A85B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> (Applies to Linus' tree, b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a)
>>
>> Please see patch 1/3 for a description.  This has been tested with a K=
VM
>> guest on x86_64 and appears to work properly.  Comments, please.
>>  =20
>
> What about the hypercalls in include/asm/kvm_para.h?
>
> In general, hypercalls cannot be generic since each hypervisor
> implements its own ABI.
Please see the prologue to 1/3.  Its all described there, including a
use case which I think answers your questions.  If there is still
ambiguity, let me know.

>   The abstraction needs to be at a higher level (pv_ops is such a level=
).
Yep, agreed.  Thats exactly what this series is doing, actually.


-Greg




--------------enigB352C0A3FDD21142A4F5A85B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoAQboACgkQlOSOBdgZUxkfngCdE1DZWI8uYALcfl6BZk03dGhH
zwIAnjYXyhTgJ4f1YRSYqUKe0oNtshRX
=QgEL
-----END PGP SIGNATURE-----

--------------enigB352C0A3FDD21142A4F5A85B--
