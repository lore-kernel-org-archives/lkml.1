Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZHTFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZHTFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHTFtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:49:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:34938 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751500AbZHTFtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:49:17 -0400
X-Authenticated: #32306085
X-Provags-ID: V01U2FsdGVkX19e1+xx1UteF0a+nRjx8c8zOCNsqpVG4jWc4jRGrf
	MdweN7zPJ3NyLZ
From: Christoph Thielecke <christoph.thielecke@gmx.de>
Reply-To: christoph.thielecke@gmx.de
To: Eric Paris <eparis@redhat.com>
Subject: Re: kernel bug 2.6.31-rc6 (2)
Date: Thu, 20 Aug 2009 07:48:49 +0200
User-Agent: KMail/1.9.9
References: <200908191448.50304.christoph.thielecke@gmx.de> <1250720787.4198.2.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1250720787.4198.2.camel@dhcp231-106.rdu.redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4985942.YtmszTlnvb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908200748.52348.christoph.thielecke@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4985942.YtmszTlnvb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Eric,

> On Wed, 2009-08-19 at 14:48 +0200, Christoph Thielecke wrote:
> > Aug 19 14:05:03 develop kernel: kernel BUG at
> > fs/notify/inotify/inotify_fsnotify.c:109!
>
> Can you apply the following patch?  It cleans up some logic, which I
> didn't see a problem with, but it makes it very easy for me to know it's
> right now.  It also should prevent the BUG() you hit from bringing down
> the box.

> commit da9d447e409fdca12001378650f020982093e91e
> Author: Eric Paris <eparis@redhat.com>
> Date:   Wed Aug 19 17:01:12 2009 -0400
>
>     inotify: the inotify add watch code is horrible clean it up
>
>     Just reworking the inotify watch add code to be readable, clean, and
> full of a lot less gotos.
>
>     Signed-off-by: Eric Paris <eparis@redhat.com>
>
> diff --git a/fs/notify/inotify/inotify_fsnotify.c
> b/fs/notify/inotify/inotify_fsnotify.c index d11ac71..1df198b 100644

The patch does not apply clean:

develop:/usr/src/linux-2.6.git.linus# patch -p1=20
< /home/crissi/download2/inotify_fsnotify_test.patch
patching file fs/notify/inotify/inotify_fsnotify.c
Hunk #1 succeeded at 107 (offset -72 lines).
patching file fs/notify/inotify/inotify_user.c
Hunk #1 FAILED at 431.

Is it against 2.6.31-rc6 or current git? I have 2.6.31-rc6-00195-gc124891.
I did an update to latest from linus and try to apply your patch but it fai=
ls=20
there too (no changes in the files after update from git).


Best regards

Christoph
=2D-=20
Linux User Group Wernigerode
http://www.lug-wr.de/

--nextPart4985942.YtmszTlnvb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqM48IACgkQd9JRTD5SjRg5jgCdG00oiPNa+Ri9AkuXBgK1D3Mf
k2MAoJFeOctczQdwIisE9hJ4Pz3Z++1w
=unSq
-----END PGP SIGNATURE-----

--nextPart4985942.YtmszTlnvb--
