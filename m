Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZELS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZELS4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZELS4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:56:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51571 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZELS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:56:00 -0400
Message-ID: <4A09C638.7070706@novell.com>
Date: Tue, 12 May 2009 14:55:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v6] kvm: add support for irqfd
References: <20090512040242.5692.99424.stgit@dev.haskins.net> <4A09BB16.90306@redhat.com>
In-Reply-To: <4A09BB16.90306@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig136F685581F1E09F28C6D789"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig136F685581F1E09F28C6D789
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> (Applies to kvm.git:833367b57)
>>
>> KVM provides a complete virtual system environment for guests, includi=
ng
>> support for injecting interrupts modeled after the real
>> exception/interrupt
>> facilities present on the native platform (such as the IDT on x86).
>> Virtual interrupts can come from a variety of sources (emulated device=
s,
>> pass-through devices, etc) but all must be injected to the guest via
>> the KVM infrastructure.  This patch adds a new mechanism to inject a
>> specific
>> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal
>> signal
>> on the irqfd (using eventfd semantics from either userspace or
>> kernel) will
>> translate into an injected interrupt in the guest at the next availabl=
e
>> interrupt window.
>>
>> I am reasonably satisfied with this series, so Avi please consider for=

>> inclusion.
>>  =20
>
> Looks good.  Please add a way to disassociate an irqfd (for hotunplug)
> and I'll merge.
>
Done, and v7 sent out.  Since I completed the testing on the
"hypercall-fd" (I call them "iofd" for reasons described in the patch
headers) I included those as well for review.  Since the irqfd stuff is
heavily reviewed and the iofd patches haven't seen the light of day
until today, feel free to merge them independently.  I included them
together because I wanted to avoid forking the CAP bits, etc, for two
closely related subsystems.  But they technically don't need to go in
together if you prefer.

Thanks Avi,
-Greg


--------------enig136F685581F1E09F28C6D789
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoJxjkACgkQlOSOBdgZUxnDlwCghWfxrGCzT018WtGmfIb5jXQJ
olgAoIro/5esPyyc2S8sibakVERjbAjs
=J98F
-----END PGP SIGNATURE-----

--------------enig136F685581F1E09F28C6D789--
