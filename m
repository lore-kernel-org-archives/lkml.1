Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbZEOQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbZEOQff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762621AbZEOQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:35:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48926 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZEOQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:35:22 -0400
Message-ID: <4A0D99C4.5010102@novell.com>
Date: Fri, 15 May 2009 12:35:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: avi@redhat.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 0/4] iosignalfd
References: <20090515162047.26209.93545.stgit@dev.haskins.net>
In-Reply-To: <20090515162047.26209.93545.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFFA4E0D20C4093C2022CC6AA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFFA4E0D20C4093C2022CC6AA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> [
>
>     Applies to kvm.git:833367b57c plus the irqfd patch, v8, as posted h=
ere:
>
>             http://lkml.org/lkml/2009/5/14/258
>  =20

I should also mention: NOT FOR INCLUSION

I am still testing this code, so this is an rfc for now.
> ]
>
> This is v2 of the series.  For more details, please see the header to
> patch 4/4.
>
> [
>    Changelog:
>
>       v2:
>            *) added optional data-matching capability (via cookie field=
)
>            *) changed name from iofd to iosignalfd
>            *) added io_bus unregister function
>            *) implemented deassign feature
>
>       v1:
>            *) original release (integrated into irqfd v7 series as "iof=
d")
> ]
>
> ---
>
> Gregory Haskins (4):
>       kvm: add iosignalfd support
>       kvm: add io_bus unregister function
>       kvm: add return value to kvm_io_bus_register_dev
>       eventfd: export eventfd interfaces for module use
>
>
>  arch/x86/kvm/i8254.c      |    7 +-
>  arch/x86/kvm/i8259.c      |    5 +
>  fs/eventfd.c              |    3 +
>  include/linux/kvm.h       |   15 ++++
>  include/linux/kvm_host.h  |   10 ++-
>  virt/kvm/coalesced_mmio.c |    4 +
>  virt/kvm/eventfd.c        |  154 +++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/ioapic.c         |    4 +
>  virt/kvm/kvm_main.c       |   62 ++++++++++++++++--
>  9 files changed, 249 insertions(+), 15 deletions(-)
>
>  =20



--------------enigFFA4E0D20C4093C2022CC6AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoNmcQACgkQlOSOBdgZUxnZQgCfYI/gR5jfKbqczeZwJQ6/osq1
1XMAniQOak5/kiB5wgQMLOrSQXJmbpso
=pHND
-----END PGP SIGNATURE-----

--------------enigFFA4E0D20C4093C2022CC6AA--
