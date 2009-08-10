Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZHJAYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZHJAYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZHJAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:24:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45979 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZHJAYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:24:52 -0400
Date: Mon, 10 Aug 2009 10:24:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anthony Wong <awong1@novell.com>
Subject: linux-next: staging series import warning
Message-Id: <20090810102443.3bc514b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_10_24_43_+1000_F1AnKS83SljE6iHJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_10_24_43_+1000_F1AnKS83SljE6iHJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

The import of the staging series produces these warnings (among others):

staging-add-realtek-8192-pci-wireless-driver.patch
quilt-tmp/.git/rebase-apply/patch:94: trailing whitespace.
#ifndef __INC_DOT11D_H
quilt-tmp/.git/rebase-apply/patch:95: trailing whitespace.
#define __INC_DOT11D_H
quilt-tmp/.git/rebase-apply/patch:96: trailing whitespace.

quilt-tmp/.git/rebase-apply/patch:97: trailing whitespace.
#ifdef ENABLE_DOT11D
quilt-tmp/.git/rebase-apply/patch:98: trailing whitespace.
#include "ieee80211.h"
warning: squelched 21645 whitespace errors
warning: 21650 lines add whitespace errors.

This might be a good place for someone to consider starting cleaning
up ...  :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_10_24_43_+1000_F1AnKS83SljE6iHJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/aMsACgkQjjKRsyhoI8yniACdGPLtMgli4aJaiHmzqvuoWA4b
kskAnjspYmQrSxbKCzgjSSjjScqP781y
=1NMn
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_10_24_43_+1000_F1AnKS83SljE6iHJ--
