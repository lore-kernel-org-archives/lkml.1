Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZGNQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZGNQ0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZGNQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:26:30 -0400
Received: from mail.open.by ([193.232.92.17]:63165 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZGNQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:26:30 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9025 [Jul 14 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 14 Jul 2009 19:28:37 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090714162837.GC3145@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
 <20090711235530.GA3231@localdomain.by>
 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Alan,
I'm having another problem which I guess may be caused by pty/tty changes.
The problem is that ppp connection constantly hangups under load (downloadi=
ng)=20
(it works perfectly with 30 kernel).

syslog:
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Request received.
pptp[1942]: anon log[ctrlp_rep:pptp_ctrl.c:251]: Sent control packet type i=
s 6 'Echo-Reply'=20
pppd[1929]: No response to 4 echo-requests
pppd[1929]: Serial link appears to be disconnected.
pppd[1929]: Connect time 8.5 minutes.

In average it works ~10 minutes.=20
I did "strace -ff -F -tt -s 200 -o ... pon ..." which produced 11MiB and 46=
 files (it'll take some time to dig).
Do you have any ability to test ppp under load?

	Sergey

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpcsjUACgkQfKHnntdSXjSj4QQA2Q6oDX8LDV7C5kTI0RDFhqno
KuSDJXO7cjvAR86a3M4WFIq0b5gpZp353uWIzggYF/uZi7IBDaXqmmme2AQKwSEX
6EA79qkFXNUgF9j79O6KzOkQDTzRwrGBHY8I1BZsD8DIxdDMPFolKnCL+YoXlLiS
jUc0YA0xi2hkn53UlYE=
=hzV+
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
