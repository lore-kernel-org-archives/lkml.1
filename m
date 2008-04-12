Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYDLI46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYDLI46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbYDLI4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:56:49 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:41302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbYDLI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:56:48 -0400
Subject: Re: [RFC 3/3] mac80211: annotate with __requires_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804121050160.28120@vixen.sonytel.be>
References: <20080410134810.629048000@sipsolutions.net>
	 <20080410134829.412424000@sipsolutions.net>
	 <Pine.LNX.4.64.0804121050160.28120@vixen.sonytel.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eLdB7X2w7Ui/c5zhNN5e"
Date: Sat, 12 Apr 2008 10:56:29 +0200
Message-Id: <1207990589.13354.123.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eLdB7X2w7Ui/c5zhNN5e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-04-12 at 10:50 +0200, Geert Uytterhoeven wrote:
> On Thu, 10 Apr 2008, Johannes Berg wrote:
> > --- everything.orig/net/mac80211/key.h	2008-04-10 15:36:20.000000000 +0=
200
> > +++ everything/net/mac80211/key.h	2008-04-10 15:36:45.000000000 +0200
> > @@ -146,7 +146,7 @@ struct ieee80211_key *ieee80211_key_allo
> >   */
> >  void ieee80211_key_link(struct ieee80211_key *key,
> >  			struct ieee80211_sub_if_data *sdata,
> > -			struct sta_info *sta);
> > +			struct sta_info *sta) __requires(RCU);
>                                               ^^^^^^^^^^^^^^^
> 					      __requires_rcu? (for consistency)

Yeah, forgot to fix up this one, I had been playing with it locally
without __requires_rcu first.

Thanks,
johannes

--=-eLdB7X2w7Ui/c5zhNN5e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAB5PKVg1VMiehFYAQLMAw/+N7qQr2NIQ7Pq2n58zFhvPKFvyswwGy13
PPh2Apm/0qg9eIDfoCUsghs/OkNyclzRitfEcBol/QJzm/8tBpnhhY9F1lF4DZr1
SOeH8tdiM0Ncj+CE27CSVz/8yDbXUZRYPvpQB4z16IfEGW1gyQpQlmCpBy139VUl
Sg48L8DBdX91g7V44UngZKlQmOI/zv99+47X+vXc7vEkQe74I5T+pLt8BHiQhjRg
vmANxijyVFZO6C6WmeQgbZe8CkTyzldzsC+RBKnt51ldWqRMHZvzf9fFPicGUDI7
6/Ugd0fEqW82Sheyvp74uloS+KsV+NoITcaPiS7MoYrdznfM7ggLEBhuxbz6aEeH
a3brZWpTkIetV6OCMpsj/lZ6iXd/g4nWh/60YRwSv5CGZdkMhNR26TTghLK4OkEa
c8OFGxRtvPajDXBnyCbUP9HN2+mZ0aMSTFDfUC/xkH9svZ96vSI64gxwxDXlZbq5
3zyfsCml5YTzq1OYugVE4lSz1BgOr96Vizc6vTYoyvcWoIZPMBcc3xHc/lTyJij3
SM+8KT3YeBsa0yWzAV29NjqOXfyLFNcrmB3BE3L7F4muDskdVu3SPGXOYfoqWaYG
hK7EswuKckAKTDZBQ6tT3h+3kTmXED4zPVMhqvSsdYAVU+cnjbSF0HASsRTmcHZ0
PayuD7eGgxQ=
=wtII
-----END PGP SIGNATURE-----

--=-eLdB7X2w7Ui/c5zhNN5e--

