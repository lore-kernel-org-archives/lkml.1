Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbZABWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbZABWGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZABWG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:06:29 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33301 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbZABWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:06:29 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH v2] linux/types.h: always export 64bit aligned defines
Date: Fri, 2 Jan 2009 17:06:23 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1230885562-11456-1-git-send-email-vapier@gentoo.org> <200901021547.32666.vapier@gentoo.org> <jer63lfjy0.fsf@sykes.suse.de>
In-Reply-To: <jer63lfjy0.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3950516.cPi6ge1SEj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901021706.25276.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3950516.cPi6ge1SEj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 January 2009 16:59:35 Andreas Schwab wrote:
> Mike Frysinger <vapier@gentoo.org> writes:
> > On Friday 02 January 2009 09:24:39 Andreas Schwab wrote:
> >> Mike Frysinger <vapier@gentoo.org> writes:
> >> > These these defines dont actually conflict with normal userspace / C
> >> > library types, there's no reason to hide them behind the
> >> > __KERNEL_STRICT_NAMES define.
> >>
> >> aligned_u64 would pollute the name space, wouldn't it?
> >
> > if by "pollute the name space" you mean "it'll be defined where it
> > normally wasnt before", then yes.
>
> I mean that it may conflict with normal userspace which is the whole
> point of being hidden.

no, there is nothing in userspace that i know of that defines this type.  i=
=20
mentioned this in the changelog already.
=2Dmike

--nextPart3950516.cPi6ge1SEj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXo/hAAoJEEFjO5/oN/WBhIoQAL8W8+Ijv9vW7spyi5P3E4gk
wH9IHIvOSOOBnnyJmTB4QhZA0DnT7SfThnKPmcchzaHJzq2D6gIuT70IVLQquilZ
8FDSzzMqCOlNpr/eTsdyJU1EB/zzXCvdZo/PB5HGlie6wliIqeWszssmeR6NM+c3
OjIyWg0NFEqLr6fMFmgQEiRSU4SZJ/jQC/hQ4U+630B566b68KU/lXmk8rjnu1gC
NeHQuMH2KlCqUE7jtRue7uHszzqnPu2bdcur3OMfgPT0b7vUlKTdK830d9kOvz1Y
Fkctm14CW4KHgGHuaIkTDPMTp8woJXaHIjCA7Ctkdy8ybn7+QZfPUfWTsbiGQ8NG
jrrCwnwXlUBPkUjepAoa85tFPCmaY8n5gT7XduNPsh+ip7pPenQbJ6sbsZcb6sJj
hF7QjK8/IhbbbON5BhVhwk+/XEPmlLVAmdyLJYn0P/JYruY1oucLCZXEpznjXccE
yKki93+vgGWgUcfCM47Xe0HOu6QHVIUorKZTG7+6QVEM8VI6/5jOVYdh5W6GfeRO
LVBSdRbBFSGdqMq+VjhSV32oPh9dSuvqCCYkxnB212W60A925fEx5eAjiWFB4jMh
EhLP94Cz8JiYZjDMGicWNj4WCDdA1MbKZtIl/oFl9SKc/lwxwBpOiMp1k675dj88
a4VNDUKlMLF+LLAb11Nn
=lSrR
-----END PGP SIGNATURE-----

--nextPart3950516.cPi6ge1SEj--
