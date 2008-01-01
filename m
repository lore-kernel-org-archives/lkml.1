Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYAASRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYAASRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYAASRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:17:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45677 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbYAASRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:17:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
Date: Tue, 1 Jan 2008 13:17:11 -0500
User-Agent: KMail/1.9.7
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
References: <200712311312.46450.vapier@gentoo.org> <20080101174708.GA25089@infradead.org>
In-Reply-To: <20080101174708.GA25089@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1562051.LdG4P3TL4Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801011317.13027.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1562051.LdG4P3TL4Y
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 01 January 2008, Christoph Hellwig wrote:
> On Mon, Dec 31, 2007 at 01:12:45PM -0500, Mike Frysinger wrote:
> > Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather
> > than asm in its code.
>
> The correct fix is to not export it to userspace.

which is what people complained last time and upon further investigation, i=
t=20
isnt trivial to remove.  so until then, it should be made clean.  especiall=
y=20
considering the proposed changes are perfectly fine when used inside and=20
outside of the kernel.
=2Dmike

--nextPart1562051.LdG4P3TL4Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHeoOoAAoJEEFjO5/oN/WBo+kQAL/bOMvL7o833d+Jw/MeYTON
+oZfzBL9uN8+6GGxAG3ZOSfRbaTdeq3Qk2j7xSULsKAu1IOZNuxFDrL4IpwMlBsq
D8ZdxGWGSZOIqyZUswSe26/UukQy6OpCF+GXWkwFO0IEONleKWJjMPvtdHJhIBmu
M1cIPJDSa/wwAM/4DlsnUWiivflZPZsS422L+9ueaEDxp9CnJp7RLMpztBKbpKNZ
fDk7K9mw/k2IFW1ZfIIIjJZM6mfGi/HSufCl7I8ztjZYxqgUF+pTMmLqXJompqtg
f4WxOqsCFy9+V3IieMbgDLUtvIPXH6DP6QWPKOAiV5mw6lSwIR4iX0NRnOFB1nFl
g/biLfuQgaafHR+QeWoDcSANNjIFSAQkIXQOcL48j+GFnfRIPKC7g1HykiifXlFQ
rgAFm0j1doO+Q7j5Am7Fm920SNvJeZl4oY5wNBvAE2YOB+FHj5Xka9uXunZLQBfw
4Q19ZEqUJ05AjAE0zyFgsv+lWIVtDj+vxTZZJ0xW+9BghoN/42N/yP25ecyXPpDM
h9GD5LK1bv8uvGlRNpdrZ9/tV/mmq5tXN8jrlzV2NU7yRvSG1g0Ly1EWuiS2Fjzg
06/15HsxMjcf4OiJI1jxwF1DFRdFT7QliQCU6XvK6ElHbCX8A/bguqrUDXIQwqH+
KUeFaS8O1oapv4imliWj
=cOTT
-----END PGP SIGNATURE-----

--nextPart1562051.LdG4P3TL4Y--
