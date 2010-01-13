Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105Ab0AMEFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0AMEFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 23:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560Ab0AMEFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 23:05:32 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63236 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0AMEFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 23:05:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Date: Tue, 12 Jan 2010 20:05:29 -0800
From: Henry Zhao <Henry.Zhao@Sun.COM>
Subject: Re: [PATCH] vgaarb: fix trylock behaviour accordingly vga_tryget
 return value
In-reply-to: <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paulo R. Zanoni" <przanoni@gmail.com>,
       Andy Getzendanner <james.getzendanner@students.olin.edu>,
       Brad Spengler <spender@grsecurity.net>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4B4D4689.4060005@sun.com>
References: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
 <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080630)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Henry Zhao <Henry.Zhao@Sun.COM>

Tiago Vignatti wrote:
> From: Henry Zhao <Henry.Zhao@Sun.COM>
>
> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> ---
> Henry, can you Signed-off-by there?
>
>  drivers/gpu/vga/vgaarb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index 2f6cf69..0f5f64d 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -935,7 +935,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>  			goto done;
>  		}
>  
> -		if (vga_tryget(pdev, io_state)) {
> +		if (!vga_tryget(pdev, io_state)) {
>  			/* Update the client's locks lists... */
>  			for (i = 0; i < MAX_USER_CARDS; i++) {
>  				if (priv->cards[i].pdev == pdev) {
>   

