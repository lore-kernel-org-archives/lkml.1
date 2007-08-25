Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbXHYROx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbXHYROx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXHYROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:14:43 -0400
Received: from kolab.mylinuxtime.de ([212.112.242.22]:50349 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbXHYROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:14:42 -0400
X-Greylist: delayed 1332 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 13:14:42 EDT
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: suspend2-devel@lists.tuxonice.net
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Date: Sat, 25 Aug 2007 18:52:20 +0200
User-Agent: KMail/1.9.7
Cc: "Fabio Comolli" <fabio.comolli@gmail.com>, linux-kernel@vger.kernel.org,
       Suspend2-users@lists.suspend2.net,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com>
In-Reply-To: <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1671696.9O2Axagdnz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708251852.28698.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1671696.9O2Axagdnz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 25 August 2007, Fabio Comolli wrote:
> On 8/25/07, David Rodriguez <livuxman@gmail.com> wrote:
> > I'm using 2.6.22.5 with cfs v20.3 and  suspend2  2.2.10.2.
> > With that combination, suspend is not working anymore (with cfs v19
> > was working).
> > Stops on suspend in "Suspending tasks"
> > Looking at cfs patch, I managed to change the  migration_thread,
> > adding again the  try_to_freeze() removed in last patch and now the
> > suspend finished, but resume not work. Of course I don't know why that
> > was removed, and rewriting it is not a solution, but I want to report
> > it.
>
> Reproduced on a Intel Centrino based laptop with gentoo kamikaze7
> sources (http://forums.gentoo.org/viewtopic-t-577970.html)

Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS v20.2.
=2D-=20
Regards,
Chris

--nextPart1671696.9O2Axagdnz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG0F5FlZfG2c8gdSURAr7WAJ9xGxk4TwrCT727+khhNt7NS43JJACgzqjd
qSIcR60GJBIYI98DDxwBbqc=
=z/WH
-----END PGP SIGNATURE-----

--nextPart1671696.9O2Axagdnz--
