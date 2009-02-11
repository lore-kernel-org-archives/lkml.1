Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbZBKVes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbZBKVes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZBKVeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:34:37 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:40539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbZBKVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:34:36 -0500
Subject: RE: [PATCH]iwlan dma mapping read and write changes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.sc.intel.com>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zj/D7DTOFB5ALunPc1qa"
Date: Wed, 11 Feb 2009 22:33:47 +0100
Message-Id: <1234388027.16004.50.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zj/D7DTOFB5ALunPc1qa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 23:27 +0200, Winkler, Tomas wrote:

> >mapping with PCI_DMA_TODEVICE which is read only in mapping PTE. But iwl=
an
> >device
> >actually writes to the mapped page to update its contents. This issue is
> >not
> >exposed in swiotlb. But VT-d hardware can capture this fault and stop th=
e
> >fault
> >transaction.
> >
> >The following patch fixes the issue.
> >
> >Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
>=20
> Indeed the firmware/ucode write back to host memory to update retry
> counter for APMDU packets. I'm not sure if this is needed for legacy
> traffic, though.  =20

I don't think they can be seeing AMPDU packets since that is, well,
broken?

johannes

--=-Zj/D7DTOFB5ALunPc1qa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk0Q4AAoJEKVg1VMiehFYzpEP/R9SfF//dBafHymn63MOJ8gJ
pUjBtAqoRnRMJSZBU2M+AL+dfa9V4q+P+jDXU+WlI94/8TIoK85xaG2cejazgWtI
j6YzdeDRdRbJIY+PQ8D4F/pYOVQdVEelOuouE1d41kVXaFUwQxZwwRG5P5bfBNFi
y11COMXFubo5zltu8pjljQOlf/nP+GomGZxaM5k6fdpfoFxJW7XpI+Mht9a+juDR
oIn3OuBKnMcMwwRCRRRjmI2yGMHvJcLLm+7+wSUH0h5ltY8fG90iWdNfZSNafPDJ
+2DCwJaUT9MjYORdsqOxf61xxcdWR+bFPqb4vNhXsSqeAGUG5GyLdjiZQy+NU5B6
QjboTBwy8kJi9HHfbtxPYsk1QANpMQ3I465xrMNBhxi9itxl7HO3hickLf9DBfb6
KlCLtpYTwEjTLcTa5pI0/6NSne7boJ28fr2V6FhzUwsPLVbpNwVfeK3xWlxH119D
AjYvtckRuYGrGZEK72A9Wu6qiT/oCPIOjiDxfajPFXXeFXakM6cBFBi8CR2nOaAT
GHXMZ5todt17CCWCwmIG8nxIErgK5ISlke4kreXwb+n35VEcz5J+IwiWlzslFZE1
8uQTlhd23Ng1DEUAmZuvDi51pyZyXLw1CGL3BaA5rfMIDFq5lB50YXD8VuRWyfEp
o1eRECPd/QEHQK2wzPZS
=TW7w
-----END PGP SIGNATURE-----

--=-Zj/D7DTOFB5ALunPc1qa--

