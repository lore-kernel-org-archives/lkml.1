Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbXIJCyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbXIJCyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXIJCyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:54:41 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33856 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXIJCyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:54:41 -0400
Date: Mon, 10 Sep 2007 11:54:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH - RESUBMiT] Minor patch to pvr2 driver required for maple bus support on SEGA Dreamcast
Message-ID: <20070910025430.GA11963@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linuxsh-dev@lists.sourceforge.net
References: <8b67d60709041627j28b8088co25a3628740f24583@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60709041627j28b8088co25a3628740f24583@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 12:27:20AM +0100, Adrian McMenamin wrote:
> diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
> index 7d6c298..13de07f 100644
> --- a/drivers/video/pvr2fb.c
> +++ b/drivers/video/pvr2fb.c
> @@ -890,7 +890,7 @@ static int __init pvr2fb_dc_init(void)
>  	pvr2_fix.mmio_start	= 0xa05f8000;	/* registers start here */
>  	pvr2_fix.mmio_len	= 0x2000;
> 
> -	if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, 0,
> +	if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, IRQF_SHARED,
>  	                "pvr2 VBL handler", fb_info)) {
>  		return -EBUSY;
>  	}
> 
I'll apply it, thanks.
