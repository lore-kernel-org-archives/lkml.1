Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZFXU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZFXU5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZFXU45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:56:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:35803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbZFXU4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:56:55 -0400
Date: Wed, 24 Jun 2009 13:40:15 -0700
From: Greg KH <gregkh@suse.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: [PATCH 1/3] Return ENODEV instead of EINVAL when trying to
	open ACM device.
Message-ID: <20090624204015.GD28516@suse.de>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:31:15AM -0300, Thadeu Lima de Souza Cascardo wrote:
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/usb/class/cdc-acm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index 38bfdb0..02eb60b 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -550,7 +550,7 @@ static void acm_waker(struct work_struct *waker)
>  static int acm_tty_open(struct tty_struct *tty, struct file *filp)
>  {
>  	struct acm *acm;
> -	int rv = -EINVAL;
> +	int rv = -ENODEV;

Why is this needed?

thanks,

greg k-h
