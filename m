Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0CNCQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 21:16:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34182 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0CNCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 21:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iFni+1hGGimRBZXsBkT2jLwJUkI94A9HPv9VhPfrEdH6BM5s44ndhdeaUEY21Kx9XV
         Qa7peBLw0xR/5AYE1ILa+Y0nqLUbxywluJ/9RB5/mhnDbttLeFXdC3ROeJKoFyejpfu0
         bTzhw8hEAuWLGwojDMgRTOcqj5SRtRf2bVAso=
Date: Sat, 13 Mar 2010 18:16:04 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Helmut.Schaa@gmx.de
Subject: [PATCH] PM_QOS api update for linux-next
Message-ID: <20100314021604.GA22158@mgross-acer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch assumes the pm_qos update just posted is included int
linux-next.

Signed-off-by: mark gross <mgross@linux.intel.com>


=46rom 361b695e0f6468214e6e8c8c789bdb651e163374 Mon Sep 17 00:00:00 2001
=46rom: mgross <mgross@linux.intel.com>
Date: Sat, 13 Mar 2010 18:09:04 -0800
Subject: [PATCH] PM_QOS function name update pm_qos_requierment --> pm_qos_=
request

---
 net/mac80211/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 75a8597..077eef1 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -506,7 +506,7 @@ static int ieee80211_scan_state_decision(struct ieee802=
11_local *local,
 		bad_latency =3D time_after(jiffies +
 				ieee80211_scan_get_channel_time(next_chan),
 				local->leave_oper_channel_time +
-				usecs_to_jiffies(pm_qos_requirement(PM_QOS_NETWORK_LATENCY)));
+				usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
=20
 		listen_int_exceeded =3D time_after(jiffies +
 				ieee80211_scan_get_channel_time(next_chan),
--=20
1.6.3.3


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkucRuQACgkQhK5OsmQOmSCblQCcDBrdBncwhra2tA3r0SSR+/o9
oyUAnisC0JS+AhGjSE3CvHVTE61MEXaP
=P4sd
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
