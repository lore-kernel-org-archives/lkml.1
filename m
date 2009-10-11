Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbZJKLlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbZJKLlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 07:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbZJKLll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 07:41:41 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633AbZJKLll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 07:41:41 -0400
Subject: Re: NOHZ: local_softirq_pending 08
From: Johannes Berg <johannes@sipsolutions.net>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4AD1BF06.3050103@phoenixsoftware.de>
References: <20091011095217.GA2200@darkstar>
	 <1255255735.4095.53.camel@johannes.local>
	 <4AD1BF06.3050103@phoenixsoftware.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-x1esR/MCyQ1Jo0nOU/DC"
Date: Sun, 11 Oct 2009 13:40:51 +0200
Message-Id: <1255261251.4095.143.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x1esR/MCyQ1Jo0nOU/DC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 13:18 +0200, Tilman Schmidt wrote:

> Can you explain a bit more what that message is about?
> I am encountering it in a completely different context
> (PPP over ISDN) and I would like to know where to start
> looking for the cause and developing a fix. The thread
> on linux.kernel.wireless.general only seems to address
> the specific situation in the wireless stack.

Basically, calling netif_rx() with softirqs enabled.

johannes

--=-x1esR/MCyQ1Jo0nOU/DC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0cRAAAoJEODzc/N7+QmaOEgQAKay17lYOfLkKKBXpej1nva4
i/XvNBAtRDwmOBVG/qG/2MLGMi6mJXdUMya1oJv8JbVAprzNkIMaeXgnDDNKVAsm
szqT3e9rd//NrUSMc2c11DugOzvIncuzC6TbwJX7r574IT/6rw/YRxAW6+4s881N
t3zP2soCwpez8BqNv9yqrNuPc8oU28lVzqhfNE0+76Bc277wE50g52pa0fyF+buw
dpVVGWWpxcwgRZHxLkHK9ivm6RBjieisxqnVAw6kASb2bVuCgucKNSEwnT4ze+4G
aVTVYNAaAYBsg4p9cg8knFei0+fEabiw8agOd8y8oKzGrVhFqapVgB5MP64M1VNa
O79lhv6kk66usqnYro+lrAxVT1hJ0O1mIPQRpDz5HrdkgSxU4gV+tlprA4DSYePo
/XJ1HBlO5bhG8kU8QQ/3YxWYvnfvMJgiSc8fIu8EwW2DBJ5Q8nvhxa/DrHry2zqK
xt53Ay5LNJat9yFHistRlEOMNDZi6FsvcrhD91/vRY9f1xYcDjlB+e/l5ro6MraX
HoqSTsRkVAtnGVIhmr5VDu3L/GivE4YQ6wzc0umh/USyAN0lHzOVBavpTCCqpmEv
RXvpSie2HaMoz9jtd1935DNg9zVlQbFYiz8VydsKu+2yvExEy/3/iNs059mWen8e
T9EARp4mnhCUqlxj5za/
=jhS/
-----END PGP SIGNATURE-----

--=-x1esR/MCyQ1Jo0nOU/DC--

