Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZFKSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZFKSlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZFKSli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:41:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZFKSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:41:37 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com
In-Reply-To: <1244732992.17483.54.camel@penberg-laptop>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
	 <1244648659.23799.26.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906111040440.29827@gentwo.org>
	 <1244732992.17483.54.camel@penberg-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/FkWK6hML7XJpZj+OvK6"
Date: Thu, 11 Jun 2009 20:41:36 +0200
Message-Id: <1244745696.29447.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/FkWK6hML7XJpZj+OvK6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 18:09 +0300, Pekka Enberg wrote:
> On Wed, 10 Jun 2009, Pekka Enberg wrote:
> > > Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
> > > CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
> > > help. Christoph, are you okay with this patch?
>=20
> On Thu, 2009-06-11 at 10:41 -0400, Christoph Lameter wrote:
> > He likely has CONFIG_SLUB_DEBUG_ON set which enables debugging and thus
> > needs more than the payload for metadata.
>=20
> Yup. I suspect a lot of people who are doing _testing_ enable that. If
> you're unhappy with my patch (the get_order one which shouldn't affect
> that many caches anyway), any suggestions how to fix this up? It seems
> that the wireless stack at least does quite a few kmalloc(4096)
> allocations.

I think networking rounds up allocations, but it's not wireless per se.

johannes

--=-/FkWK6hML7XJpZj+OvK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMU/cAAoJEODzc/N7+QmaoRQP/2YeIoVKdIfBRZAZf3Ujq23j
TV9AUxUXVfP4weCeveuFbCJMUG2NspBTOLfHzXHh0b+5RXwM6Kf1hG/5e9Z8nyPv
f7t3DMnTiIjmnPr9zvffGlp0FAvlJePe0sgrlCV4DMyxEWgwZ31T8p5reYxGRAYd
tQt9Cdeea6grFtbaXAKgYR81xgNSLvRM2CVji9qt4IGorwc+iThxwvUgmF8iNCZg
J1ml9LHq6SYE//5at1GbpBcMgD3plJhLCIKRta+Do/be0+L+rhKEe9DB/YW34jgr
sYg2/Zw74D8SVP/Dv7LYc4f4TeyfSRfIb4DfvDqTHyI3g7lT5FemmlRjfF123+HJ
c6E3eRIC/8RkOudXJfYfL8xx3Rnmm9fXTZjVyO3ohdgDgvAlutDcBWWG/xVd7lyn
JEH452bp8m/gRpd4WrGB9OouGUWpVkxKT/UJvbWyB+wDVDzlQxxsYcDkyWh2cQGD
zDhLOFya5DvV6B3avZT0TxkfO2CtPElpVWEJirwwXnwGWaIF3mYszudzimGt3toi
GqXDcmlxuyoTrpvBhri/U/fHWXh7vjMirgyRSos2JqkROXKjLGknxhcbjZA0wS8D
auETghTc5Wv/BJGmO1UKeyinw1JPtnd4ciMSq8FHnlq/qcOewXNs0JMZuKQ2KoHX
oOYpDEkH19RPmzmrFILO
=haI9
-----END PGP SIGNATURE-----

--=-/FkWK6hML7XJpZj+OvK6--

