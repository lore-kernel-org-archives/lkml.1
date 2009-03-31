Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZCaUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZCaUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZCaUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:00:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33072 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZCaUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:00:31 -0400
Message-ID: <49D276E5.6000000@novell.com>
Date: Tue, 31 Mar 2009 16:02:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 14/17] kvm: add a reset capability
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184400.28333.50396.stgit@dev.haskins.net> <49D26D8B.7020201@redhat.com>
In-Reply-To: <49D26D8B.7020201@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig63259ACD3C414AAF73D2D3DF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig63259ACD3C414AAF73D2D3DF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> We need a way to detect if a VM is reset later in the series, so lets
>> add a capability for userspace to signal a VM reset down to the kernel=
=2E
>>  =20
>
> How do you handle the case of a guest calling kexec to load a new
> kernel?  Or is that not important for your use case?
>

Hmm..I had not considered this.  Any suggestions on ways to detect it?


--------------enig63259ACD3C414AAF73D2D3DF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknSduUACgkQlOSOBdgZUxlUHACgjfkZ9UdnAEAzxUlkMDM3wJLk
8xAAn1BPfw9RIjH48ZO73jqWUACuFuzh
=wDa2
-----END PGP SIGNATURE-----

--------------enig63259ACD3C414AAF73D2D3DF--
