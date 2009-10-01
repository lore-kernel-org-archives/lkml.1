Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZJAVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZJAVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZJAVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:16:28 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZJAVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:16:28 -0400
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20090929171249.GB14405@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-P07HAGU3xY43kYV86rag"
Date: Thu, 01 Oct 2009 23:16:23 +0200
Message-Id: <1254431783.3959.45.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P07HAGU3xY43kYV86rag
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 19:12 +0200, Pavel Machek wrote:
>=20
> Happened while playing with wireless.
>=20
> Kernel is:
>=20
> Linux version 2.6.31 (pavel@amd) (gcc version 4.3.3 (Debian 4.3.3-10)
> ) #72 SMP Thu Sep 10 21:56:19 CEST 2009
> KERNEL supported cpus:
>=20
> (Could we get kernels between release and -rc1 mark themselves
> somehow?)

CONFIG_LOCALVERSION_AUTO?

> Registered led device: iwl-phy0::radio
> Registered led device: iwl-phy0::assoc
> Registered led device: iwl-phy0::RX
> Registered led device: iwl-phy0::TX
> wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> wlan0: Trigger new scan to find an IBSS to join
> wlan0: Trigger new scan to find an IBSS to join
> wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0

This entire log is very odd ... can you reproduce this easily? printk
timestamps would be useful.

johannes

--=-P07HAGU3xY43kYV86rag
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxRwkAAoJEODzc/N7+QmazKkP/1pg60E2W8XKI0Djsyvh6GKK
YV5gEu3R16L4l9EZkHD4akgGlQDPtfIIlrxPQ11gLSKMt0K8UzsavJTWOkEbL4d0
Dc3DVYNk1+lGcJmJHgz/9AuwWc0mZLZ/e7aoWGRvZsv9E3+fQG1qBLisKrUB9tLO
MW/kPbjjlR5momvE4XglR/5/6yjWywayDL4kblR/xOSpaOJDxGTET4j+P42QiVQB
NOal2NJDipfkBEh3qmAAueQBbcfJoRqsi0tXxh7Pysf2Yy1hcVTXNORYGhUKlbCG
OISu+kYYIEd6AdYS5xoWmAKcKWNPoiww6xDE58hF689EJAoxju2OvqNNgwsWt7MM
SLRPzLKUhOx/xqktljgiHxQ2PbFGfqrsknZbqzui4zljAFOnc+me1hTFuPdXljSv
bwahG86iA27k8h7q0f3x5aJgsz8bmznfLFUr8kxmluujaqiTKuhAibko4FSr6TW7
EehHyxiHxp0+cz0UXq3iIAoAcPFfiSKVr7bhTCim6RGIP/vFnxW5kGz/UTP4W+aA
QB+ysMhbreM9YRFHNhysmDFwXV5MRzqdiVeT6lwaAN5xOVXfqPJSrpZyanfFYHLy
lYuu7EI0I+tBNZgGkLpjzWgHAUfcmUesaJ4wlnLW4kMscTw7CJTyN+kzgGrZuPyB
LeMcSHoDplvTsZqP/cZp
=yYaN
-----END PGP SIGNATURE-----

--=-P07HAGU3xY43kYV86rag--

