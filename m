Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXBUXsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXBUXsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXBUXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:48:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbXBUXsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:48:17 -0500
Message-ID: <45DCD9E5.2010106@redhat.com>
Date: Wed, 21 Feb 2007 15:46:45 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Michael K. Edwards" <medwards.linux@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu>
In-Reply-To: <20070221233111.GB5895@elte.hu>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAEC868673037F8140F28423F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEC868673037F8140F28423F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> in terms of AIO, the best queueing model is i think what the kernel use=
s=20
> internally: freely ordered, with barrier support.

Speaking of AIO, how do you imagine lio_listio is implemented?  If there
is no asynchronous syscall it would mean creating a threadlet for each
request but this means either waiting or creating several/many threads.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigAEC868673037F8140F28423F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF3Nnm2ijCOnn/RHQRAmzpAKCRNkvgljdPStMA+j/57bXOulw7tgCfeK73
2s92RYE5stWX7nVZSi3rqFw=
=bKDB
-----END PGP SIGNATURE-----

--------------enigAEC868673037F8140F28423F--
