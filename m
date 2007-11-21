Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXKUO0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXKUO0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXKUO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:26:41 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:47063 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXKUO0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:26:40 -0500
To: benh@kernel.crashing.org
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Dennis Munsie <dmunsie@cecropia.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: radeonfb i2c regression post-2.6.18.
References: <1195427766.7022.18.camel@pasglop>
From: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Date: Wed, 21 Nov 2007 09:42:09 +0000
In-Reply-To: <1195427766.7022.18.camel@pasglop> (Benjamin Herrenschmidt's message of "Mon\, 19 Nov 2007 10\:16\:06 +1100")
Message-ID: <87oddoaqa6.fsf@hardknott.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sun, 2007-11-18 at 21:58 +0000, Roger Leigh wrote:
>> Hi folks,
>>=20
>> I'm using an Apple Cinema Display connected via DVI to an Apple Mac
>> Mini with Radeon 9200 graphics. This used to work fine, but with
>> kernels >=3D 2.6.19, the monitor powers off as soon as the framebuffer
>> is initialised, making for a less than usable system. I've tested
>> with 2.6.(19|2[012]), and I didn't see any related changes in 2.6.23.
>
>    .../...
>
> Can you try the patch from Jean that I pasted below and let us know if
> it helps ? It looks like the releasing of the i2c lines may have been
> done backward.

This patch fixes the problem.  The monitor stays powered on during the
switch to the framebuffer.


Thanks,
Roger

=2D-=20
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHQ/11VcFcaSW/uEgRApIBAKDlOxkHy+ItRHnVDKCxY2k1zUYN1gCgxw6V
XKgee3XvZSYeaqGqghclnYg=
=9Fig
-----END PGP SIGNATURE-----
--=-=-=--
