Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXBLFzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXBLFzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXBLFzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:55:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46193 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbXBLFzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:55:47 -0500
Date: Mon, 12 Feb 2007 16:55:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Con Kolivas" <kernel@kolivas.org>
Cc: "Vassili Karpov" <av1474@comtv.ru>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Message-Id: <20070212165554.42d12419.sfr@canb.auug.org.au>
In-Reply-To: <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
References: <loom.20070212T063225-663@post.gmane.org>
	<8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Feb_2007_16_55_54_+1100_9bjxvZfqoFrBjWXw"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Feb_2007_16_55_54_+1100_9bjxvZfqoFrBjWXw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 12 Feb 2007 16:44:22 +1100 "Con Kolivas" <kernel@kolivas.org> wrote:
>
> The kernel looks at what is using cpu _only_ during the timer
> interrupt. Which means if your HZ is 1000 it looks at what is running
> at precisely the moment those 1000 timer ticks occur. It is
> theoretically possible using this measurement system to use >99% cpu
> and record 0 usage if you time your cpu usage properly. It gets even
> more inaccurate at lower HZ values for the same reason.

That is not true on all architecures, some do more accurate accounting by
recording the times at user/kernel/interrupt transitions ...

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Feb_2007_16_55_54_+1100_9bjxvZfqoFrBjWXw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF0AFzFdBgD/zoJvwRAn2vAJ9xkjGSp0SUorqR002un5NSg0llEgCfR5lP
YEa8B+vBIEKA91ksaVXW3Io=
=Tf4a
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Feb_2007_16_55_54_+1100_9bjxvZfqoFrBjWXw--
