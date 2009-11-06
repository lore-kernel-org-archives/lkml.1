Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZKFXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZKFXhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZKFXhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:37:18 -0500
Received: from kroah.org ([198.145.64.141]:54815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958AbZKFXhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:37:17 -0500
Date: Fri, 6 Nov 2009 14:47:28 -0800
From: Greg KH <greg@kroah.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@Atheros.com
Subject: Re: [PATCH] staging/otus: trivial, fix sparse warnig.
Message-ID: <20091106224728.GA32205@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:04:26PM -0400, Thiago Farina wrote:
> *apdbg.c: use NULL pointer instead of 0 integer.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/staging/otus/apdbg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
> index d3e2f62..70a40b8 100644
> --- a/drivers/staging/otus/apdbg.c
> +++ b/drivers/staging/otus/apdbg.c
> @@ -109,7 +109,7 @@ int set_ioctl(int sock, struct ifreq *req)
>  
>  int read_reg(int sock, struct ifreq *req)
>  {
> -    struct zdap_ioctl *zdreq = 0;
> +    struct zdap_ioctl *zdreq = NULL;

The tabs somehow got converted to spaces in your patches, so they can't
be applied :(

care to rediff both of them?

thanks,

greg k-h
