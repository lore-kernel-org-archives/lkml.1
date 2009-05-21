Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZEURSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZEURSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZEURSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:18:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36219 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZEURSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=DNFz2FQ11AMSz4/OyELKTOIXVeDkuO+pUYOKkRagsybNzw1Xems5AY7ivqYREa3QJh
         OLAqqVibydBl1oea7QOWTAdg7OOUHi3Hz6nWMjpuOXskj+a1P5ZZnvrDsY7wJWv58hL+
         MoSX4GDMAsYV5e3/3XDbFYqjzVBf5nYjNRiWE=
Date: Thu, 21 May 2009 19:18:17 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [mac80211 ] Wifi Network slownes bisected
Message-ID: <20090521191817.4456c440@varda>
In-Reply-To: <1242922091.4212.14.camel@johannes.local>
References: <20090521173839.1f20b95d@varda>
	<1242922091.4212.14.camel@johannes.local>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=apcF/qvPA086CoCYbbG=0I";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=apcF/qvPA086CoCYbbG=0I
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El Thu, 21 May 2009 18:08:11 +0200
Johannes Berg <johannes@sipsolutions.net> escribi=C3=B3:

> On Thu, 2009-05-21 at 17:38 +0200, Alejandro Riveira Fern=C3=A1ndez wrote:
>=20
> >  I noticed that my wifi connection has slowed when stitching
> > from 2.6.29.1 to 2.6.29.4 (it is also slow on 30-rc6)
> > Also 2.6.27 (ubuntu) does not suffer it.
>=20
> > $ git bisect good
> > 64e1b00c974ddeae6a60ebb02e1c487371905cea is first bad commit
> > commit 64e1b00c974ddeae6a60ebb02e1c487371905cea
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Fri Apr 24 16:05:16 2009 +0000
> >=20
> >     mac80211: fix basic rate bitmap calculation
>=20
> Well ... How much did your connection slow down?=20

  Enough to notice it when connecting through a 3MBit
 Adsl connection i.e. with the patch i get 30 40 60 ...
 80 kiB maximum without it full 310 KiB so it is an issue
 for me (i have inet <-> modem-router <-> myPC only so i can
 not test with another pc)
=20

> It is clear that this
> commit might possibly slow down your connection, but not by a lot.

 Well it does by a lot avg of 60 KiB vs 300 KiB is lot for me

 And that's only because before we were sending with a higher rate than the
> AP allowed us to... If you need the higher speed then set your AP to
> G-only to make it include more rates in the basic rate set, that'll
> speed up your connection properly.

 My Ap is set to "mixed" but i connect at G speeds ie iwconfig show 54M or =
48M
 or 36M but the connection is slow nonetheless=20
 Do you think that would make such a difference (the ap mode)?

 Also with the patch i notice weird bumps on connection rates and without it
 the connection "feels" more stable
=20
 >=20
> That's all discounting driver bugs which may exist, of course.

 well i bisected and the problem is with this commit. Could be
 that rt2x00 is doing something wrong with that "rate bitmap" ??
 I'm not programmer so i can not check myself

>=20
> johannes

Alejandro

  Thanks for the response...


--Sig_/=apcF/qvPA086CoCYbbG=0I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKFYzZAAoJEDO4iEReSTB2lZUP/1Nne0QRIeY2QZhhtveHyl4n
WfJl9TVOH1YBdXsntk52GlF9BfA8SaqH2/MIzXVewEMl3FlXKFgQIXcg6BlgWYio
ytSgTalFTZpUI19FzpsvMy+F9vK0Ejw9X3/vyGdi1RsU364qbr1nWjuMWAz8j3O7
WE16PCIjgO17uHSS+A2Xl1KT0+SrzoSzUN65XzhkBJw/sof4mCmzPM8aAL2oUvDG
W2Ud5IENOBqWUQUP7XlOR51alN3mZZZppsKomRx2Hy9BpDXbQJiuP2i492zZmWFe
KLr5sbQYWj+1H7oTyEJZ2dOBG2LS09wqOCgaB5VoBchhk1VT7YtJ76DNkZATc8fv
CiE4ypS9TJHP4cvTmn48D2Ou8pvTOXPUXCRVRJE49sZBaOcAXVhz8o/m80ldO+pI
Et4l2QQz2wYvDw8gaGEJcTarbtncDtEf6z0gNgUPMYY7S9lDeM2jPQh5G05hk5H8
M2U/4Oi9pu63CU9/GoP71gOHLYu28X/wz6iNMJSdVWTWkt3UGVXCnMAomRjI0ZMa
h/uqhHrG8/pYuXFhDe82myW5+NOcXt8dRL5mHIFPbBIBgnedFg6eWtCtQvkj23LI
ISuq3QAvQ+/efkD9Nnrq/r7yGnx7phBZp+fZb7iGMVROdvJ0uGTjrPiMfrD+3vxn
M/sm3EWtCqEP9eTj6KnY
=PkqG
-----END PGP SIGNATURE-----

--Sig_/=apcF/qvPA086CoCYbbG=0I--
