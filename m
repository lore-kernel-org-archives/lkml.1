Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZCSVFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZCSVFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCSVFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:05:23 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:45977 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbZCSVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:05:22 -0400
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 17:05:21 EDT
Message-ID: <49C2B38C.3040606@gmail.com>
Date: Thu, 19 Mar 2009 22:05:16 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: greg@kroah.com
CC: sjakub@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup asus_oled.c
References: <1> <1237496227-6078-1-git-send-email-erik.andren@gmail.com> <1237496227-6078-2-git-send-email-erik.andren@gmail.com>
In-Reply-To: <1237496227-6078-2-git-send-email-erik.andren@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry, wrong patch.
I'll send the correct one shortly.

Erik Andrén wrote:
> ---
>  drivers/staging/asus_oled/asus_oled.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
> index d81f4bd..7a40f61 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -522,7 +522,7 @@ static ssize_t odev_set_picture(struct asus_oled_dev *odev, const char *buf, siz
>  			line were equal to the last character in this line. */
>  			if (odev->buf_offs % odev->width != 0) {
>  				ret = append_values(odev, odev->last_val,
> -					odev->width - (odev->buf_offs % odev->width);
> +					odev->width - (odev->buf_offs % odev->width));
>  				if (ret < 0)
>  					return ret;
>  			}
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknCs4kACgkQN7qBt+4UG0GJjQCgrpAc2Hmq5su3U4uBga3QNwYD
I2IAnj4eweBvjVaUtb+fgrXE4waKTvr7
=wCcy
-----END PGP SIGNATURE-----
