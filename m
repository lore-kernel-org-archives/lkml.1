Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZBON2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZBON2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZBON16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:27:58 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:59631 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZBON14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=bT2DIopEcQgaTncAw4kPRZJRa4CYSrrhqH9CJ4LydYr77zDdsoeMNhNwGc0/Wroa7W
         CfQZIAarawSFd+KhmbNIUw4H3adcHcaJX7gNvACdzDbrSBJVaMcGggCI/FZTxFMjvMby
         QbS7E4iDG0twtVprCzVUmGgq1n0wJVWPKni7Y=
From: Florian Fainelli <florian@openwrt.org>
To: openwrt-devel@lists.openwrt.org
Subject: Re: [OpenWrt-Devel] [PATCH] bcm47xx: Fix GPIO API return codes
Date: Sun, 15 Feb 2009 14:27:36 +0100
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200902142127.19521.mb@bu3sch.de>
In-Reply-To: <200902142127.19521.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1869951.d106Co95NN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902151427.39196.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1869951.d106Co95NN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Michael,

Le Saturday 14 February 2009 21:27:19 Michael Buesch, vous avez =E9crit=A0:
> The GPIO API is supposed to return 0 or a negative error code,
> but the SSB GPIO functions return the bitmask of the GPIO register.
> Fix this by ignoring the bitmask and always returning 0. The SSB GPIO
> functions can't fail.

At some point we might want to convert the existing board code to use gpiol=
ib.=20
I will try to come up with a patch for this later this afternoon.

Otherwise, your patch looks good.
=2D-=20
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
=2D------------------------------

--nextPart1869951.d106Co95NN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmYGEkACgkQlyvkmBGtjybnOQCgkJeiSsHE70xAb8zJHfDFW5IM
yJEAoLkOwurY6Su/heKCC63538XPgCSr
=f+qY
-----END PGP SIGNATURE-----

--nextPart1869951.d106Co95NN--
