Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXFZLNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXFZLNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXFZLNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:13:01 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:45925 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbXFZLNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:13:01 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8677] New: booting with initrd fails: request_module: runaway loop modprobe binfmt-0000
Date: Tue, 26 Jun 2007 14:12:16 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@kernel-bugs.osdl.org>,
       linux@solnet.ch
References: <bug-8677-10286@http.bugzilla.kernel.org/> <20070626020256.4a03d6b2.akpm@linux-foundation.org>
In-Reply-To: <20070626020256.4a03d6b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2581649.GZf9DHVdhO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706261412.16601.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2581649.GZf9DHVdhO
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

26 Haz 2007 Sal tarihinde, Andrew Morton =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9F=
t=C4=B1:=20
> > I can't boot all 2.6.22_rc* kernels with an initrd. When booting I get
> > the following message about 6 times:
> >
> > request_module: runaway loop modprobe binfmt-0000
> >
> > If I disable the initrd, booting works without problems.
>
> I seem to recall having seen reports of this before.  Does anyone recall
> the reason for it?

I've hit that before, first was the misc. compiliation issue which solved b=
y=20
recompilation and other was related to "Load Custom Dsdt Table" [1] patch=20
which seems the case here (boots without initramfs/initrd) if that kernel h=
as=20
that kind of out-of-tree patch.

[1] http://gaugusch.at/kernel.shtml

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2581649.GZf9DHVdhO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGgPSQy7E6i0LKo6YRAontAJ9TCRWhJy7ftrGqLQpK2JNmMrAo3QCfXRJ7
jH4BfrOTrLgSxUSLBio9ekU=
=hktV
-----END PGP SIGNATURE-----

--nextPart2581649.GZf9DHVdhO--
