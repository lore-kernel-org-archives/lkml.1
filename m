Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbXBVH1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbXBVH1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945922AbXBVH1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:27:44 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:36276 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXBVH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:27:43 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] EXPORT_SYMBOL() time functions
Date: Thu, 22 Feb 2007 08:28:15 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <200702211412.23388.eike-kernel@sf-tec.de> <200702211413.38840.eike-kernel@sf-tec.de> <20070222034001.GB9027@infradead.org>
In-Reply-To: <20070222034001.GB9027@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2679821.4R8GGvqh4J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702220828.16578.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2679821.4R8GGvqh4J
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Christoph Hellwig wrote:
> On Wed, Feb 21, 2007 at 02:13:38PM +0100, Rolf Eike Beer wrote:
> > These functions were inlines before
> > 8b9365d753d9870bb6451504c13570b81923228f. Now EXPORT_SYMBOL() them to
> > allow them to be used in modules again.
>
> Just because they happened to be inlined that doesn't mean modules should
> be using them.  In fact no intree module uses them exactly because they're
> not intended to be used by this kind of code.  Please show the code you
> want to use this for so we can see what you're really trying to do.

Trying to convert a given user value (in milliseconds) to a timeout. No=20
problem doing this with struct timespec.

Eike

--nextPart2679821.4R8GGvqh4J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF3UYQXKSJPmm5/E4RAjUiAJ9V0IJNZ6sqGYvXqPgr5xdP7lKyHQCeIqXX
gqG/tw4ifJgoUmXF92/T6Ro=
=hwkR
-----END PGP SIGNATURE-----

--nextPart2679821.4R8GGvqh4J--
