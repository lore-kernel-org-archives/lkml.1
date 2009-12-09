Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbZLIVGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbZLIVGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZLIVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:06:00 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:44725 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZLIVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JDvVBfIfdq70J8XC8pGdpi9F5vKbpL6pKEUKn3f5V6//QucQCOWlNGN+Sw43DJRMva
         uibZSfXdcqKAf0MLKuB82KQORGS0/nxAnicEhSdK5cTS4Ct5pRGp5f1yTVzkXFi7FMTN
         ZKUDcJwRZ3KmbWqyCIWV2uJsbKsZJzWF1CuAU=
Date: Wed, 9 Dec 2009 22:06:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/char/nvram: Restore #include <linux/smp_lock.h>
Message-ID: <20091209210559.GA7129@nowhere>
References: <1260392620.5351.48.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260392620.5351.48.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 01:03:40PM -0800, Joe Perches wrote:
> Commit 8587b33f4adee4e7614ea7f443346c3b6bb5427a removed
> the include, but it's still required for a different
> lock_kernel/unlock_kernel pair in nvram_open
> 
> Compiled: x86/defconfig
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 2100a8f..3cfa0f6 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -38,6 +38,7 @@
>  #define NVRAM_VERSION	"1.3"
>  
>  #include <linux/module.h>
> +#include <linux/smp_lock.h>
>  #include <linux/nvram.h>
>  
>  #define PC		1
> 
> 


I've already sent a fix for that.
See: nvram: Fix missing smp_lock.h in nvram

Thanks.

