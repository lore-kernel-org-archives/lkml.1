Return-Path: <linux-kernel-owner+w=401wt.eu-S1764204AbXF1RdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764204AbXF1RdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXF1RdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:33:07 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXF1RdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:33:06 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1183048429.4089.1.camel@johannes.berg>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hKxaA+x3qOVrHv+4Lq6Z"
Date: Thu, 28 Jun 2007 19:33:21 +0200
Message-Id: <1183052001.4089.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hKxaA+x3qOVrHv+4Lq6Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-28 at 18:33 +0200, Johannes Berg wrote:

> I think I misunderstood how lockdep works because the output was
> actually wrong, should the key be part of the workqueue_struct as well?

No, that's not right either, but Arjan just helped me a bit with how
lockdep works and I think I have the right idea now. Ignore this for
now, I'll send a new patch in a few days.

johannes

--=-hKxaA+x3qOVrHv+4Lq6Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg/Dh/ETPhpq3jKURAjddAJ9YQtTPMEbFM5zKxN9YWs+3gpuPYQCgodvk
/2MzgMCk7jqPK1XcFKe7aew=
=kBZb
-----END PGP SIGNATURE-----

--=-hKxaA+x3qOVrHv+4Lq6Z--

