Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbXFBOLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbXFBOLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbXFBOLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:11:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51670 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757494AbXFBOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:11:43 -0400
Date: Sat, 2 Jun 2007 16:11:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-ID: <20070602141144.GC5500@stusta.de>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:09:10PM -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Explain what we use Acked-by: for, and how it differs from Signed-off-by:
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/SubmittingPatches |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff -puN Documentation/SubmittingPatches~document-acked-by Documentation/SubmittingPatches
> --- a/Documentation/SubmittingPatches~document-acked-by
> +++ a/Documentation/SubmittingPatches
> @@ -328,7 +328,20 @@ now, but you can do this to mark interna
>  point out some special detail about the sign-off. 
>  
>  
> -12) The canonical patch format
> +12) When to use Acked-by:
> +
> +The Signed-off-by: tag implies that the signer was involved in the development
> +of the patch, or that he/she was in the patch's delivery path.

The last part should be dropped: If "he/she was in the patch's delivery 
path", a Signed-off-by: tag is required.

> +If a person was not directly involved in the preparation or handling of a
> +patch but wishes to signify and record their approval of it then they can
> +arrange to have an Acked-by: line added to the patch's changelog.
> +
> +Acked-by: is often used by the maintainer of the affected code when that
> +maintainer neither wrote, merged nor forwarded the patch themselves.

"merged" seems to be superfluous if you also mention "forwarded".

> +13) The canonical patch format
>  
>  The canonical patch subject line is:

Please mention explicitely whether Acked-by: this now considered a 
formal tag like Signed-off-by:

IOW, if a maintainer says "fine with me", can I translate this to an 
Acked-by: line, or do I now have to ask for an explicit Acked-by: line?

Oh, and that's not a theoretical question, this is a result of a recent 
flamewar^Wdiscussion on this list...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

