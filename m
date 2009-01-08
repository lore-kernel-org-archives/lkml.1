Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbZAHW5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbZAHW5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZAHW5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:57:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:17087 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZAHW5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=k18OoHVaPpk5AN8fLxkMRpeu8lVRk60MNWfzI3AlB7V0xV4IGphpukqSyFzOAsSXwk
         2oo73oJu5/M13KcltKeb39bhP2u6GZE8C8kvrZOapvA/kuZinEyDP2FkS046++cYIiDw
         iaQkiZjT97ii5XlBXgnaa6N2JQeT+RrIveX/k=
From: Florian Fainelli <florian@openwrt.org>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: FPGA programming driver architecture
Date: Thu, 8 Jan 2009 23:57:21 +0100
User-Agent: KMail/1.9.9
Cc: "Thiago Galesi" <thiagogalesi@gmail.com>,
       "Hugo Villeneuve" <hugo@hugovil.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <20081212150314.6ea24996.hugo@hugovil.com> <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com> <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com>
In-Reply-To: <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1407056.eZfqosaT1b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901082357.24432.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1407056.eZfqosaT1b
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

Le Thursday 08 January 2009 23:47:58 Leon Woestenberg, vous avez =E9crit=A0:
> Indeed.
>
> The programming back end should be generic enough so that it can use
> other subsystems.
>
> The FPGA configuration interface could be on the memory bus (and in
> many cases the DMA helpers can be used) or behind a PCI bus, or can
> even have SPI etc front-ends.
>
> In general the programming API should accept a blob of data,
> preferably in one chunk (pointer plus length) or at least 4kB chunks
> or so, so that configuration is not severy overheaded by a callback
> per byte (or even bit).

That's the idea behind using request_firmware, which provides you with both=
 a=20
pointer to the data and the size of the blob.
=2D-=20
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
=2D------------------------------

--nextPart1407056.eZfqosaT1b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklmhNIACgkQlyvkmBGtjyZVwgCfRdq0d7DUxbQLSm1+jqHTBbNg
x4wAoLRizBd5SyVIt+Ch3utQBXAOYSCr
=JyIa
-----END PGP SIGNATURE-----

--nextPart1407056.eZfqosaT1b--
