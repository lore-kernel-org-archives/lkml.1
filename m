Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0CLIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:09:15 -0500
Received: from mail1.SerNet.de ([193.175.80.2]:50056 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0CLIJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:09:13 -0500
Date: Fri, 12 Mar 2010 09:09:11 +0100
From: Michael Adam <obnox@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Michael Adam <obnox@samba.org>, Jeff Layton <jlayton@samba.org>,
       Jon Severinsson <jon@severinsson.net>,
       linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, vl@samba.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission checking
References: <201003041150.08341.jon@severinsson.net> <20100304111812.6af53003@barsoom.rdu.redhat.com> <E1Npr8D-00A474-O0@intern.SerNet.DE> <20100312015319.GC27697@samba1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20100312015319.GC27697@samba1>
User-Agent: Mutt/1.5.9i
Message-Id: <E1Npzvj-00AWaC-KI@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jeremy Allison wrote:
> On Thu, Mar 11, 2010 at 11:45:29PM +0100, Michael Adam wrote:
> >=20
> > When discussing this with Volker today, he had a different idea:
> > One could implement a trans2 impersonate call in samba (as a new
> > call in the unix extensions) that could be used to transfer the
> > session established by the privileged user (root, say) to a
> > different user specified as an argument to the call -- without
> > the need to give credentials! Then this call could be used in
> > the multi user mount scenario: when uid 1000 accesse the cifs
> > mount then the root-dispatcher mount would create a new session
> > initially as root and issue an impersonate call to user 1000
> > directly afterwards.
> >=20
> > Wouldn't that be something worth considering?
>=20
> This world work, but protocol cleanliness-wise it's
> *really* horrible :-).

Agreed. :-)


--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: comment

iD8DBQFLmfanyU9JOBhPkDQRAsezAJ9fon9Uxd2gkFQiU+uLkRz+Bl8auACfUfJK
lpSL417fsxMGh41ReAGUgzg=
=X60s
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
