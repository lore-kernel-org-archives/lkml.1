Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYL2VCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYL2VCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYL2VCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:02:21 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44549 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYL2VCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:02:19 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA Dreamcast
Date: Mon, 29 Dec 2008 16:02:16 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
References: <1230578246.6496.25.camel@localhost.localdomain>
In-Reply-To: <1230578246.6496.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1825196.4GJIt0R7Bs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812291602.18572.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1825196.4GJIt0R7Bs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 14:17:25 Adrian McMenamin wrote:
> +static int __devinit probe_maple_mouse(struct device *dev)
> +static int remove_maple_mouse(struct device *dev)

i thought you were going the rout of not labeling any of the probe/remove=20
functions ... but if you label the prob with __devinit, then the remove sho=
uld=20
be __devexit.  i.e. whichever way you go, the two should be consistent.
=2Dmike

--nextPart1825196.4GJIt0R7Bs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWTraAAoJEEFjO5/oN/WBrk4QAJReN/EhBersFeV+BeCQArrQ
mmHqZeRCDQGZSHVUNJ7nypZmvL3XN6nLRt1kr6XaW/+tK3i+8Aj5GyA4kD7dV1XM
c76tCR3XgdL8XQjey2jGhiEtsiG7Ak2wqZynyBV7rYSNInTDDnNPHHbs8QG0SOCD
4GTbzxYL4OZ9MWekEy/5SAOP6x6vw82WODBpF0pM8a08EGiPewBfjUtcL9QqfKs2
+1fMFhSxXvV/Ut9ZS69jOpdlEGEAoY4QbtIYYE+P6KGJKP5tXRq0jmx5qZ5Z63am
iblnEGr2BEXOqvhuIry2X3BHLndV8QY6kjCP9e0x52b8aY3APqMZY4rTDtAzXVLC
zWuHZrN6UR75qlj8kgc5qWJOkmFGHVIkSvg8gsMS8dOKQ8ZvVdmBDhpe6PZwvBYJ
G4xFqbWCTZTesHpEhU5VKz7FSuteueDHtyf73Useb6gdmbS/iNd6lde4T95NkwAT
EHuMlqyoxldlcK12c9RVVNA/V7Oc8ZmDV8xqzZFszTqT6miro553W66R1X6pEx96
89dIwvJ63XdVEiA/dMr6J+M1mPI9aKUmvqGtzGbSj+ZGkZsUXRzPy9iO5kDG5sS9
3i+UX5/kQArt+AOfbCbQP1BUJ8TKoc0ZozifnQSRnid7lwIcnVKOfyMzvguStM7v
L+N9WZWLSJ6AuJKgshUa
=XlRQ
-----END PGP SIGNATURE-----

--nextPart1825196.4GJIt0R7Bs--
