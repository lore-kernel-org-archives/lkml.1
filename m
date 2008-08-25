Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYHYVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYHYVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYHYVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:20:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:38791 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYHYVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q+IW4EbGthAxewNGNUHaWozvh0Prl656DrJZmLpPTF/0LvQgXjJMTuwIlfAzke5Gfy
         l0X1D8edticMe5n3v6sFuteG76cZapRq6Frml7gDOQ6lAl+joWNDJri2S3+Bz5yFWeHp
         RhXP6JUBvFTLnUx1bD/CgHNanzKz3nXC0UfmI=
Message-ID: <12c511ca0808251420r10957a7v423644003377a6ec@mail.gmail.com>
Date: Mon, 25 Aug 2008 14:20:07 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [GIT PULL] ALSA fixes for 2.6.27-rc4
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5h1w0ddo58.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5h1w0ddo58.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
> --- a/sound/pci/ca0106/ca0106_main.c
> +++ b/sound/pci/ca0106/ca0106_main.c
> @@ -249,11 +249,12 @@ static struct snd_ca0106_details ca0106_chip_details[] = {
>           .name   = "MSI K8N Diamond MB [SB0438]",
>           .gpio_type = 2,
>           .i2c_adc = 1 } ,
> -        /* Another MSI K8N Diamond MB, which has apprently a different SSID */
> +        /* MSI K8N Diamond PLUS MB */
>         { .serial = 0x10091102,
>           .name   = "MSI K8N Diamond MB",
>           .gpio_type = 2,
> -          .i2c_adc = 1 } ,
> +          .i2c_adc = 1,
> +          .spi_dac = 2 }

Missing "," on this line is causing build failure here.

-Tony
