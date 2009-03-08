Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZCHSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZCHSqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZCHSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:46:01 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:57788 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbZCHSqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:46:00 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sun, 8 Mar 2009 19:02:17 +0100
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
References: <200903042020.57671.eike-kernel@sf-tec.de> <20090305125529.GB16693@silver.sucs.org>
In-Reply-To: <20090305125529.GB16693@silver.sucs.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6217616.K59jsveYJe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903081902.23998.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6217616.K59jsveYJe
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Sitsofe Wheeler wrote:
> On Wed, Mar 04, 2009 at 08:20:56PM +0100, Rolf Eike Beer wrote:
> > I tested several snapshots post 2.6.28 and all of them show one severe
> > problem: resume from disk is not always successful. Only about 50% of t=
he
> > resume attempts work, in the other cases I just get a completely black
> > screen, can't switch to text console or anything. What I often get is a
> > line like this in the logs directly before suspend:
>
> Does this happen when X hasn't been started and you suspend to disk then
> resume?

I tested several times without X, with X running only in backgroud (i.e. me=
=20
initiating the suspend from console) and from xdm only. Never it froze. Tha=
t=20
leads me to the conclusion that it is probably related to composite. I'm=20
using KDE 4.2.

Here is the corresponding section from Xorg.conf:

Section "Device"
  BoardName    "945 GM"
  BusID        "0:2:0"
  Driver       "intel"
  Identifier   "Device[0]"
  Option       "NoDDC"
  Option       "usevnc" "no"
  VendorName   "Intel"
  Option      "ExaNoComposite" "false"
  Option      "MigrationHeuristic" "greedy"
EndSection

Eike

--nextPart6217616.K59jsveYJe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkm0CC8ACgkQXKSJPmm5/E4SnQCdEic28CbbSw6xLLjEPbGM/XVj
oasAn3+Kv0VQGGWGHAXOqSwKAPSew2sc
=9rED
-----END PGP SIGNATURE-----

--nextPart6217616.K59jsveYJe--
