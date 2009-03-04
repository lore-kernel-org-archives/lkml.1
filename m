Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZCDQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZCDQd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZCDQdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:33:50 -0500
Received: from mx40.mail.ru ([94.100.176.54]:57990 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZCDQdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:33:49 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.29-rc: PM notifiers are not called during hibernation
Date: Wed, 4 Mar 2009 19:33:26 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-1avb; KDE/4.2.1; i686; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200901292254.09562.arvidjaar@mail.ru> <20090304074733.GA1405@ucw.cz>
In-Reply-To: <20090304074733.GA1405@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1287186.uxLbmaekjt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903041933.40837.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1287186.uxLbmaekjt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 4 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2009 10:47:33 Pavel Machek wrote:
> On Thu 2009-01-29 22:53:57, Andrey Borzenkov wrote:
> > rc2 and now rc3
> >
> > Orinoco driver uses notifications to request firmware before
> > suspend/hibernation. This is OK for suspend, but does not seem to
> > work for hibernation. I get what suspiciously looks like 60 seconds
> > timeout for request_firmware, but I do not see either usual
> > request_firmware output, nor debug output.
> >
> > Suspend is OK.
> >
> > orinoco notification handlers is:
>
> Is it fixed in newer -rc?

yes

> If not, does rafael know?

under different subject :)

--nextPart1287186.uxLbmaekjt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmurVoACgkQR6LMutpd94yA+QCfUUxTQjFmPuEedxyjp3IznFSq
MYEAoM8EZW4ihhRiwFLXOuWsfDlR/2Hu
=uWNP
-----END PGP SIGNATURE-----

--nextPart1287186.uxLbmaekjt--
