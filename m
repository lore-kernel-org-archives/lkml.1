Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYDUVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYDUVtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYDUVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:49:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:27581 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYDUVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=UIUxyWdJF0q79zJmmThH+UCEPq/N4c6fBFRQNOe2t1uTvhvxiFyQy64bedMAnVHk+sPGD/ZBJV2EaaImNcDG+Qxs91Ud8pu74a4tU7y1H8WGGHCVvRytgsAAx3ZMXZNJ3oTr3sUeq+g3R6eUnaUcIzd1MryQ+K0qTpXPJEXyzww=
Date: Mon, 21 Apr 2008 23:49:10 +0200 (CEST)
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: firmware_sample_driver.c: fix coding style
In-Reply-To: <20080401105546.GA10714@elf.ucw.cz>
Message-ID: <alpine.LNX.1.00.0804212348230.1777@dragon.funnycrock.com>
References: <20080401105546.GA10714@elf.ucw.cz>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Pavel Machek wrote:

> Fix coding style in firmware_sample_driver...
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 

I've added this patch to the trivial tree.
Thanks Pavel.

/Jesper Juhl



> diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
> index 6865cbe..600cdd9 100644
> --- a/Documentation/firmware_class/firmware_sample_driver.c
> +++ b/Documentation/firmware_class/firmware_sample_driver.c
> @@ -34,8 +34,7 @@ static void sample_probe_default(void)
>          const struct firmware *fw_entry;
>  	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
>  
> -        if(request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0)
> -	{
> +        if (request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0) {
>  		printk(KERN_ERR
>  		       "firmware_sample_driver: Firmware not available\n");
>  		return;
> @@ -56,8 +55,7 @@ static void sample_probe_specific(void)
>  
>  	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
>  
> -        if(request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0)
> -	{
> +        if (request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0) {
>  		printk(KERN_ERR
>  		       "firmware_sample_driver: Firmware load failed\n");
>  		return;
> @@ -70,7 +68,7 @@ static void sample_probe_specific(void)
>  }
>  static void sample_probe_async_cont(const struct firmware *fw, void *context)
>  {
> -	if(!fw){
> +	if (!fw) {
>  		printk(KERN_ERR
>  		       "firmware_sample_driver: firmware load failed\n");
>  		return;
> @@ -88,9 +86,8 @@ static void sample_probe_async(void)
>  					 "sample_driver_fw", &ghost_device,
>  					 "my device pointer",
>  					 sample_probe_async_cont);
> -	if(error){
> -		printk(KERN_ERR 
> -		       "firmware_sample_driver:"
> +	if (error) {
> +		printk(KERN_ERR "firmware_sample_driver:"
>  		       " request_firmware_nowait failed\n");
>  	}
>  }
> @@ -105,6 +102,7 @@ static int sample_init(void)
>  	sample_probe_async();
>  	return 0;
>  }
> +
>  static void __exit sample_exit(void)
>  {
>  }
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
