Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYDHOig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYDHOig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYDHOi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:38:27 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:54102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYDHOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:38:26 -0400
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in
	ieee80211_sta_expire
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IWmlGZBgp6cshobhkhGB"
Date: Tue, 08 Apr 2008 16:29:26 +0200
Message-Id: <1207664966.14253.26.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IWmlGZBgp6cshobhkhGB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> ieee80211_sta_expire grabs local->sta_lock and calls sta_info_unlink
> which tries to grab the lock again. (make available) and use
> __sta_info_unlink variant instead.

A patch equivalent to this should already be in.

johannes

--=-IWmlGZBgp6cshobhkhGB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/uBRaVg1VMiehFYAQJ5XxAAss1YKBFWp5t/wB+cdCVfxQiiMiJwJbaS
NgXKjIPpjftsIBDMsEeRoDSYErJevu/czrGggCX/5TujuUoQ5+xFNYFbPxT39t0f
4wfBXD3bJYu5ASI01fddWoRscLChrfesVRzvt6NMRMHU0MFkDnhyHTTSOqtH42Dr
eDq71DIsrRDEEF4KZHOV1wBiDdxAyA1ieY3tJFE6eYga2/q7CaduzKGdo6KaYLh+
xGz0sPWBtZ2344qZRtxJFfzh44adAiYQx/AFzg8zXvuuRlTWfa6jZZp4y1LhTmr1
f9hQTZnpWyuvV7TjOTnFUCQWlVYT7uz1LW9tjIF1hf3dkZ64+pbRrVVm4idh48ne
MZHrZnCKLHFzkdT3o7EmN3zS/7tzGC1+tkRhsdSjGK7VHTEwi6i68q1qBDyrfeZo
ED6oaYMIhQLr8dL8aO57iK0ymw5sck/rM/N7Bx6opZSGuJgzvt0CMWBC6Tmop5kf
FgrKTkoKzsl44AfhPNzlDqtwddl0Mhy4hdquIqrAS/RMk0UhKp3bOFTq6jHo8GuK
FZvcnYHOVtoTKaBybEmDYvi6TnjuYJ8RB1r+lKN7fQKw7CcwTjkMv8AS33DyfUHL
grAjdyOTxR2JJZ72BBmTveJcJa9w/hiHIcBRG5JhbVxeqaqHV4YFOtvwwSaZQBin
HxIE08iKbis=
=z9z5
-----END PGP SIGNATURE-----

--=-IWmlGZBgp6cshobhkhGB--

