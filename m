Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZJGWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZJGWfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZJGWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:35:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZJGWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:35:19 -0400
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ACD0E5A.7060106@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	 <4ACD0E5A.7060106@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-e0CVf0NC0EeLBaOtXwMm"
Date: Thu, 08 Oct 2009 00:34:02 +0200
Message-Id: <1254954842.3713.7.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e0CVf0NC0EeLBaOtXwMm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 14:55 -0700, Randy Dunlap wrote:
> John W. Linville wrote:
> > Should prevent this build error reported by Randy...
> >=20
> > net/wireless/wext-priv.c:206: error: implicit declaration of function '=
call_commit_handler'
> > make[3]: *** [net/wireless/wext-priv.o] Error 1
> >=20
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>=20
> Sorry, it did not work for me.

> linux-next-20091007/net/wireless/wext-priv.c:206: error: implicit declara=
tion of function 'call_commit_handler'
> make[3]: *** [net/wireless/wext-priv.o] Error 1
>=20
> Drivers like hostap and orinoco (hermes) select WEXT_PRIV regardless
> of the setting of WEXT_CORE.  oh, and staging/ drivers do that also.

But they also select WIRELESS_EXT, which should cause WEXT_CORE to be
turned on. Is it possible that is failing?

johannes

--=-e0CVf0NC0EeLBaOtXwMm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzRdWAAoJEODzc/N7+QmavbMQALtPSgL2BphPT3Aw3V1x6YG0
s0GGZSz8QNt8xBU/ZIjnAWSH7B8NTox4Kl9gZZY5VG2d5MkYv1Vpz1rWiftj1ezc
vjfSUVWNQWa9uAZDXmlTTLbV3ag6XsY46eVwTi2jwSkuSyfTSPi9FQrXaxDk+Al8
+AkiY7Qdv5DChfkKMZGSI+1FZ3PFa/ol/YzMnXwBWq6zUH+RootUfYKG3nSlnLv2
Tbigs2CBI0wXCkQaOqWWXkl0pM7KO2EwIq9ZB563TifLuGRcWV71k0KeY9U/ylnZ
StfkT1w426ojxWJoljjjlstrq39T6VZgJ/zTZMNTMxRlwOogMDAiXwvbYierKcHR
dBCadyzIExbRrGmOzDQ4xUJtUS/yO1Q3Qr/GxFn9/ZrqUAXbZECMhvTfwG7FLCwc
RSTTnrYLjXpo8SUy3emROZSvhJAnoRyQYF8rZUAkwd6Zz9DiUbj+BYDCP0ozbI5z
wQdfVEyxcNQTuoBi6QRySIY0N/vwN7SLDudBUawK93oNObx7LQnfTCL69nik58tb
792auPqfTunxqBqgwqIn6CKiJ6XK6cYHUxZr2RPlguDVQUh6M7SBCejv9m4PKyy7
2O+eG1SqNBt98ATe/TMgKZjNqgFxPtRMDopX5nFhUklncDzsC8phmM3/xUyT0NQp
U+vyBOk//kjYIPGK4sf2
=JxHo
-----END PGP SIGNATURE-----

--=-e0CVf0NC0EeLBaOtXwMm--

