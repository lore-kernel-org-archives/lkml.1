Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXIKQoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXIKQoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXIKQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:43:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56051 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXIKQnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:43:51 -0400
Date: Tue, 11 Sep 2007 09:43:49 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add power meters to Documentation/hwmon/sysfs-interface
Message-ID: <20070911164348.GD30825@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com> <20070829111052.503a73a5@hyperion.delvare> <20070829145002.GQ32667@tree.beaverton.ibm.com> <20070830115743.4dd8b2d5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veXX9dWIonWZEC6h"
Content-Disposition: inline
In-Reply-To: <20070830115743.4dd8b2d5@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--veXX9dWIonWZEC6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 30, 2007 at 11:57:43AM +0200, Jean Delvare wrote:
> OK, that's a bit different then, but I'm still not sure that there is
> much value in exporting these values in sysfs, in particular if there
> is no way to reset them.

It turns out there _is_ a way to reset them; the next iteration of the
driver will have it.

> I am also not happy with the names you proposed: power1_max_input and
> power1_min_input are somewhat confusing IMHO, I'd suggest
> power1_input_highest and power1_input_lowest to make them clearly
> different from the min and max limits we have for other sensor types.
> If we have them at all, of course.

Agreed and changed.

--D

--veXX9dWIonWZEC6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG5sXEa6vRYYgWQuURAqy4AJwNw7mv4nUYd2pGi+u6L1dc5l9uwgCgs6ij
nFhUr8RHhsPwSHunxbJKWks=
=Ee3w
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h--
