Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbXGTGJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbXGTGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXGTGJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:09:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48010 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXGTGJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:09:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] Fix Dreamcast DMA
Date: Fri, 20 Jul 2007 02:09:27 -0400
User-Agent: KMail/1.9.7
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1184871374.6043.1.camel@localhost.localdomain>
In-Reply-To: <1184871374.6043.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2925018.kmHBT4KdGA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707200209.28457.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2925018.kmHBT4KdGA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 19 July 2007, Adrian McMenamin wrote:
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> @@ -183,6 +183,7 @@ int dmac_search_free_channel(const char *dev_id)
>  			return result;
>
>  		atomic_set(&channel->busy, 1);
> +
>  		return channel->chan;
>  	}
>
> @@ -194,7 +195,6 @@ int request_dma(unsigned int chan, const char
> *dev_id)
>  	struct dma_channel *channel = { 0 };
>  	struct dma_info *info = get_dma_info(chan);
>  	int result;
> -
>  	channel = get_dma_channel(chan);
>  	if (atomic_xchg(&channel->busy, 1))
>  		return -EBUSY;
> @@ -387,7 +388,7 @@ int register_dmac(struct dma_info *info)
>  	}
>
>  	list_add(&info->list, &registered_dmac_list);
> -
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(register_dmac);

seems like whitespace noise in here ...
-mike

--nextPart2925018.kmHBT4KdGA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iQIVAwUARqBRmEFjO5/oN/WBAQJ/WxAAhA7iqnX/wl+NG3R0Hzp4OOoS8pUrD5Eu
Qf//pN4Uck4BBDx+zwXIRtw7iMOFPGeGTI8Ig1Di8TRjlof6lnRrAo8ufvqUNWL6
m3IJ5/10ZiqP7stroCzz54SMVwqhI+z+WVUaKHAz4ubuXAEnQuqeHW9whS0ZRrP9
EQkHEEN7nKCaGQVZItAKByc9bqZGjgUUYNIkU19xLPhEW1XfAXIw7XkPAEzDKDea
hoNmdfIO6gaeMiTz0B7klAeMhzKTUzEqMpfbt8881RWzeEU1kv+TF8msuQBTfCTJ
bzajoxYiljb5mCD4qw1at0mtRSEr+wf0Rr8a1qYoz49nKrFyh3ofSQgGEk/tfjo6
qgFbuthfn1WNyFO1vv7CPjDNbDTlYjB2vjfwGMZdcSZeuCW09dc+6T3GNeN6UEsE
gMWB52Iign3Lf1ylnLcWETb+hFr98pl+Mq5Fdi3J1MZTkUHgZQG8tLylIoMnp9Dc
KVgdZQi2zUoa27jA8FjqnZu6tvtVcdXztef4puIZHs6vYa5je2946Yc58lM64kle
7ItiXkChL821BldI1wpBBN6HH8cdm8VaYAVwsFZcG5Ki6VrOUN2pi4QnEtBgr25l
okQV40DA5z8x+ZOEdsQJrwXS1nm7c5FFjV3c6pnrGkLoYQC5zDYIeqH/AqHpFV1T
g3KUwnrJMxM=
=sJb9
-----END PGP SIGNATURE-----

--nextPart2925018.kmHBT4KdGA--
