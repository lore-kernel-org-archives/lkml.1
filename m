Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZA1Jzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZA1Jzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbZA1Jzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:55:32 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:44425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZA1Jzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:55:31 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233130815.10992.39.camel@laptop>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-npd6G06Hde2+yjyxQC+b"
Date: Wed, 28 Jan 2009 10:54:47 +0100
Message-Id: <1233136487.4151.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-npd6G06Hde2+yjyxQC+b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 09:20 +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-27 at 19:57 +0100, Johannes Berg wrote:
> > This modifies the timer code in a way to allow lockdep to detect
> > deadlocks resulting from a lock being taken in the timer function
> > as well as around the del_timer_sync() call.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Nice, thanks!

I actually got "trying to register non-static key" on my powerpc64
machine. Is there a possibility that functions are not static??

johannes

--=-npd6G06Hde2+yjyxQC+b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgCtkAAoJEKVg1VMiehFYYLwP/1pn4SYBioExHz3tcbxMCpqJ
xbWPISikKp+NABuMAD2i1Qv3L6lYXk1nxBfDdFdqMEgB26zRKlMuAZnu+vBEvn9O
b9QslB8MtojmcOWGt06fQndBXo79irFGm/DEKhmqtCM4H27fxSOXEs3RhEb7uUCg
OhdrUBjE//jmgRPuB0F/LtcD+ISJxzr63qunQrGyq0XrdweNXwl8yJvSuL8xlt3E
JzlqfVk1r0lEKS5SFCTo/x3+68z+rlHJThRgh5nYE3oYVqLrQ2VLyVTj+BUWN8+D
exMva0aZq1SamUpoRFa2S7DuLV0TyJD1Tu/328WHovR0jqOo0ubDr3crhesz8dVL
j2+jgFWhV27ibNYIIKRWc5tS3YkhgIyQFnDPQ1+045/e7oHfNSe4cNs20KPt3C+O
uTij4ANP8q0Mlzp4P1/9b8OFgIJgZ6MFwe8+eMxw+P6ox7en/v0cOR77swEuYQqR
ettQ0nPCLM9sY6KFbK1V4cFzLKXYxW/rp7X+TSCuzFvpSedCSylaIR2cJzStM6q/
CQQhdrvMkFpuxBm5/pafOMA7d5km5QF88LazP0MFCAKasGxVsLAUAWelavkec/uO
gJCfqw9RnsJkMBrMNrKoLu26hV68Nn94mzF7/McF3PV6yRUQgfNSYbDN2wyOLVXu
U09WQPdDwFvfb6TZmbGE
=VJn5
-----END PGP SIGNATURE-----

--=-npd6G06Hde2+yjyxQC+b--

