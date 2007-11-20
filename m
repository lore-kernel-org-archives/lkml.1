Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXKTCZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXKTCZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXKTCY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:24:56 -0500
Received: from ns.suse.de ([195.135.220.2]:55802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXKTCY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:24:56 -0500
Date: Mon, 19 Nov 2007 18:24:42 -0800
From: Brandon Philips <bphilips@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Stelian Pop <stelian@popies.net>,
       "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       video4linux-list@redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 25/59] drivers/media/video: Add
	missing "space"
Message-ID: <20071120022442.GA17247@ifup.org>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <8cdb362d494c702f6f0cf095e8e24435550bf5ce.1195454435.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cdb362d494c702f6f0cf095e8e24435550bf5ce.1195454435.git.joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:48 Mon 19 Nov 2007, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/cx25840/cx25840-vbi.c   |    2 +-
>  drivers/media/video/meye.c                  |    2 +-
>  drivers/media/video/saa7134/saa7134-input.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/cx25840/cx25840-vbi.c b/drivers/media/video/cx25840/cx25840-vbi.c
> index ced13fe..d2949e5 100644
> --- a/drivers/media/video/cx25840/cx25840-vbi.c
> +++ b/drivers/media/video/cx25840/cx25840-vbi.c
> @@ -180,7 +180,7 @@ void cx25840_vbi_setup(struct i2c_client *client)
>  						fsc/1000000,fsc%1000000);
>  
>  		v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
> -			"vblank %i , vactive %i, vblank656 %i, src_dec %i,"
> +			"vblank %i , vactive %i, vblank656 %i, src_dec %i, "
				^^^^^
				can you remove that unintended
				space too?
Thanks,

	Brandon
