Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZFCIdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZFCIdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZFCIdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:33:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbZFCIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:33:44 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200906012248.49304.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906012226.46086.rjw@sisk.pl> <1243888860.5299.32.camel@johannes.local>
	 <200906012248.49304.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9pnyQgOL/svDVHzKWrXJ"
Date: Wed, 03 Jun 2009 10:33:41 +0200
Message-Id: <1244018021.10665.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9pnyQgOL/svDVHzKWrXJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 22:48 +0200, Rafael J. Wysocki wrote:
> > No, it's now hanging 20 seconds much later, after returning to
> > userspace :( But the dmesg log still has a hang of ~20.5 seconds just
> > like before, between two kernel messages...
>=20
> Hmm.  Can you try to comment out suspend_device_irqs() and resume_device_=
irqs()
> in drivers/base/power/main.c and see what happens?

Oddly, that does seem to help. I'm sure it can't be a solution though :)

johannes

--=-9pnyQgOL/svDVHzKWrXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJjViAAoJEODzc/N7+QmaGj8P/A+UCCu+EE0wS+CQOBMPyoeM
JS5ljkIdyqHIEdVdRhD0ThA2frkStR/AqehkS90T+n1WtKE4q+kqTur+8RgoHntY
xm3TfgaPJEiuOpEvhncHXL7UdJgrHrNOfMUXtBK4JXqGTpcjnTRz5PRUAwE3Z2wL
NgSVJl4wRSbtTzbcj3m56mSBbwZKv8HMKb2bW2h00HFCFNptFILZoTzi20KKrizJ
5b26uwyUi00SAR+PoZqTC9tDKzWmn0YreI7hGXUVroj6ds11Pi0DJNz+wygBwxlH
VdC4IhknaF9wGDpSOoi39n9ZE4r85OMCPsDJQQhvAu4a1OK2eZUnIXp+/UkMPuo9
dbOzdJlP/BuQGl6HCIwU7cKh7dkRxav9rCvM1ovp7fEKkEyU0AnGFkTM0i9JQ8mk
9J57Iatfj9T3+2koPUL78d5LTqBeZmdYNCXpvFdQscJa9iJCgGhVYuAV9E8i66G9
MsHyNM9DaHCEKCrsYv1gJBeDEJO7FL5Aq0X+rNSYtOnsp0TfwA4EVUcYZsFnGsKs
09ddoMa8s4oykSBUPNZZDeUEKcCO1AdOmNtQmL0ZcyptHQFdzffk9h2yBoChtg4N
ftgGwRLkBDFZjTuov8dv4zbdxX4+0leJYHAVDo6wZLZd1XaaniSjKn8gVOOmDCe4
8+8k23ye3cZvIfe9aSpU
=uUtz
-----END PGP SIGNATURE-----

--=-9pnyQgOL/svDVHzKWrXJ--

