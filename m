Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZBJWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZBJWlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZBJWlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:41:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45367 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbZBJWlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:41:03 -0500
Date: Wed, 11 Feb 2009 09:40:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Mimi Zohar <zohar@us.ibm.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: Tree for February 10 (security/audit/ima)
Message-Id: <20090211094050.47c4828d.sfr@canb.auug.org.au>
In-Reply-To: <4991DBA0.1000008@oracle.com>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
	<4991DBA0.1000008@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Feb_2009_09_40_50_+1100_Molc438UIbYsgJVG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Feb_2009_09_40_50_+1100_Molc438UIbYsgJVG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 10 Feb 2009 11:55:12 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> Stephen Rothwell wrote:
> >=20
> > Dropped trees (temporarily):
> > 	audit (difficult conflicts)
>=20
> Maybe this is fixed by the dropped audit tree?

The audit tree is Al Viro's (cc'd).  But I *think* everything in it has
been applied upstream.

> linux-next-20090210/security/integrity/ima/ima_policy.c:111: error: impli=
cit declaration of function 'security_audit_rule_match'
> linux-next-20090210/security/integrity/ima/ima_policy.c:230: error: impli=
cit declaration of function 'security_audit_rule_init'
>=20
> when
> CONFIG_SECURITY=3Dy
> CONFIG_AUDIT=3Dn
> CONFIG_IMA=3Dy
> CONFIG_IMA_AUDIT=3Dy

This looks more like a security subsystem than audit to me?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Feb_2009_09_40_50_+1100_Molc438UIbYsgJVG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmSAnIACgkQjjKRsyhoI8yqxwCfcMvbQCBSoSy0ZTRO9E7AJyTL
zkwAn1/2ndYUtMuZOctxvz/AoedjlyoN
=HWxH
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Feb_2009_09_40_50_+1100_Molc438UIbYsgJVG--
