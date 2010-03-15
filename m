Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab0COFdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:33:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40979 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753118Ab0COFdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:33:06 -0400
Date: Mon, 15 Mar 2010 06:32:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: smd: smd_qmi: fix code style issues
Message-ID: <20100315053258.GB11552@elf.ucw.cz>
References: <1268624694-11635-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268624694-11635-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-15 00:44:54, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues about to #include <linux/uaccess.h>
> instead of <asm/uaccess.h> and some not necessary braces {}.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/smd/smd_qmi.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
> index 687db14..9e9067f 100644
> --- a/drivers/staging/dream/smd/smd_qmi.c
> +++ b/drivers/staging/dream/smd/smd_qmi.c
> @@ -25,7 +25,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/workqueue.h>
>  
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include <mach/msm_smd.h>
>  
>  #define QMI_CTL 0x00
> @@ -643,11 +643,10 @@ static int qmi_print_state(struct qmi_ctxt *ctxt, char *buf, int max)
>  	}
>  
>  	i = scnprintf(buf, max, "STATE=%s\n", statename);
> -	i += scnprintf(buf + i, max - i, "CID=%d\n",ctxt->wds_client_id);
> +	i += scnprintf(buf + i, max - i, "CID=%d\n", ctxt->wds_client_id);
>  
> -	if (ctxt->state != STATE_ONLINE){
> +	if (ctxt->state != STATE_ONLINE)
>  		return i;
> -	}
>  
>  	i += scnprintf(buf + i, max - i, "ADDR=%d.%d.%d.%d\n",
>  		ctxt->addr[0], ctxt->addr[1], ctxt->addr[2], ctxt->addr[3]);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
