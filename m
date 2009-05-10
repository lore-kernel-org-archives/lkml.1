Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZEJMxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZEJMxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 08:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZEJMwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 08:52:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54796 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZEJMwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 08:52:53 -0400
Date: Sun, 10 May 2009 22:52:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 01/13] Driver Core: add nodename callbacks
Message-Id: <20090510225246.0a77b557.sfr@canb.auug.org.au>
In-Reply-To: <20090509143631.276407654@blue.kroah.org>
References: <20090509142601.874865281@blue.kroah.org>
	<20090509143631.276407654@blue.kroah.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_May_2009_22_52_46_+1000_Wf5+2.hB_425mzxP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__10_May_2009_22_52_46_+1000_Wf5+2.hB_425mzxP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Kay,

On Sat, 09 May 2009 07:26:02 -0700 Greg KH <greg@kroah.com> wrote:
>
> +++ b/include/linux/device.h
>  struct device {
>  	struct device		*parent;
> +	char *(*nodename)(struct device *dev);

Just wondering what this callback is for.  I didn't look really hard, but
couldn't find it used anywhere.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__10_May_2009_22_52_46_+1000_Wf5+2.hB_425mzxP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoGzh4ACgkQjjKRsyhoI8zRngCfRSn4SFQjfYFf3c+1BU8msviG
Z6AAoKUXpUJtyMtQuMCozwKy/mXheL8Q
=utRp
-----END PGP SIGNATURE-----

--Signature=_Sun__10_May_2009_22_52_46_+1000_Wf5+2.hB_425mzxP--
