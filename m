Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYFYTWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYFYTWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYFYTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:21:52 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:58846 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYFYTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:21:52 -0400
Date: Wed, 25 Jun 2008 15:21:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [2.6 patch] make eeepc-laptop.c:cm_{g,s}etv[] static
In-reply-to: <20080625162547.GK10285@cs181140183.pp.htv.fi>
X-X-Sender: lenb@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <alpine.LFD.1.10.0806251521070.3014@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080625162547.GK10285@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied.

thanks,
-len

On Wed, 25 Jun 2008, Adrian Bunk wrote:

> This patch makes the needlessly global cm_{g,s}etv[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 5 May 2008
> 
>  drivers/misc/eeepc-laptop.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 4e41a5023994160e27b2b194d9e67e2208c948de diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
> index 6d72760..9e8d79e 100644
> --- a/drivers/misc/eeepc-laptop.c
> +++ b/drivers/misc/eeepc-laptop.c
> @@ -87,7 +87,7 @@ enum {
>  	CM_ASL_LID
>  };
>  
> -const char *cm_getv[] = {
> +static const char *cm_getv[] = {
>  	"WLDG", NULL, NULL, NULL,
>  	"CAMG", NULL, NULL, NULL,
>  	NULL, "PBLG", NULL, NULL,
> @@ -96,7 +96,7 @@ const char *cm_getv[] = {
>  	"CRDG", "LIDG"
>  };
>  
> -const char *cm_setv[] = {
> +static const char *cm_setv[] = {
>  	"WLDS", NULL, NULL, NULL,
>  	"CAMS", NULL, NULL, NULL,
>  	"SDSP", "PBLS", "HDPS", NULL,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
