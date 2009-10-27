Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbZJ0VhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbZJ0VhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbZJ0VhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:37:18 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:62698 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbZJ0VhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=RcPvfqI4usHB8JYMGaLo5yr64SeOk7/JApb5SpPPAtJIwGzQg8RBK1PTthPeLh93Hf
         3LiGp6XcgLrYgCDbgMObY1HLusUuc9UH/zqBDkZDpjW5+fs9jNguRnt+PamT25ki51y7
         bVB5zqcIdDkzCLE9XIO4DBXFG8KS95nejnocA=
Message-ID: <4AE7680C.30704@gmail.com>
Date: Tue, 27 Oct 2009 17:37:16 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [PATCH] vbus-enet: fix l4ro pool non-atomic
 allocations in softirq	context
References: <20091027021701.20826.67034.stgit@mimic.site>
In-Reply-To: <20091027021701.20826.67034.stgit@mimic.site>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAFE57E0F5CFF8370BCB124E5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAFE57E0F5CFF8370BCB124E5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Patrick Mullaney wrote:
> The current code exhibits odd behavior in the guest when receiving L4RO=

> packets. This was tracked down to the improper allocation of
> GFP_KERNEL memory from softirq context
>=20

Applied, thanks!

-Greg



--------------enigAFE57E0F5CFF8370BCB124E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnaAwACgkQP5K2CMvXmqGBJACfcf7nBMbUfD6dQg9fTct28b5S
000An18FTtcsGnjPx6CJ0jCFagaLv4Yo
=TDY0
-----END PGP SIGNATURE-----

--------------enigAFE57E0F5CFF8370BCB124E5--
