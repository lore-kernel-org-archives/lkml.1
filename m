Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXGIN0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXGIN0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXGIN0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:26:32 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56295 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXGIN0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:26:31 -0400
Date: Mon, 9 Jul 2007 15:27:40 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070709132739.GN11451@enneenne.com>
References: <4691F689.7000503@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4691F689.7000503@compulab.co.il>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: PXA2xx keyboard driver fix
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 11:49:13AM +0300, Mike Rapoport wrote:
> The PXA2xx keyboard driver does not compile with 2.6.22
> The following patch fixes it
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
> 

>  drivers/input/keyboard/pxa27x_keyboard.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/keyboard/pxa27x_keyboard.c b/drivers/input/keyboard/pxa27x_keyboard.c
> index f9e82c9..ebe5eac 100644
> --- a/drivers/input/keyboard/pxa27x_keyboard.c
> +++ b/drivers/input/keyboard/pxa27x_keyboard.c
> @@ -140,7 +140,7 @@ static int pxakbd_resume(struct platform_device *pdev)
>  		KPREC = pdata->reg_kprec;
>  
>  		/* Enable unit clock */
> -		pxa_set_cken(CKEN19_KEYPAD, 1);
> +		pxa_set_cken(CKEN_KEYPAD, 1);
>  	}
>  
>  	mutex_unlock(&input_dev->mutex);

Acked-by: Rodolfo Giometti <giometti@linux.it>
