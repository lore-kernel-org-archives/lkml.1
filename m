Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZK2Lox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZK2Lox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZK2Lox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:44:53 -0500
Received: from mail.klingt.org ([86.59.21.178]:39023 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZK2Low (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:44:52 -0500
Message-ID: <4B125E8A.7020306@klingt.org>
Date: Sun, 29 Nov 2009 12:44:10 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091127 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, 64-bit: Set data segments to null after switching
 to 64-bit mode
References: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com> <1259165856-3512-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1259165856-3512-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig05165578737EB17F8C7F3761"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Sun, 29 Nov 2009 12:44:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig05165578737EB17F8C7F3761
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/25/2009 05:17 PM, Brian Gerst wrote:
> This prevents kernel threads from inheriting non-null segment selectors=
,
> and causing optimizations in __switch_to() to be ineffective.
>=20
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

with this patch, the branch hint is actually correct, giving 100%
correct predictions. so please revert my earlier patch (commit
a3a1de0c34de6f5f8332cd6151c46af7813c0fcb)

thnx, tim

--=20
tim@klingt.org
http://tim.klingt.org

Desperation is the raw material of drastic change. Only those who can
leave behind everything they have ever believed in can hope to escape.
  William S. Burroughs


--------------enig05165578737EB17F8C7F3761
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSXooACgkQdL+4qsZfVsvT8gCfbN9ZFxhtUC0AvbqwdvlJinQH
nosAn1UsNXW/Xt3FpKe9CgzNM0L8WtPw
=YPxA
-----END PGP SIGNATURE-----

--------------enig05165578737EB17F8C7F3761--
