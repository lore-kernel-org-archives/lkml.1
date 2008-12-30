Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYL3Uwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYL3Uwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 15:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYL3Uwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 15:52:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:56062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYL3Uwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 15:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h53WaW1i8lUDyF92rhpOrdf2INEhyCdunquUwjGICGduTlscm1eaO6blDd/G5wkKO5
         LLeXDaBFX8jCFXQk5jhVSbBKulmvuGfEQfsUXb6ERYaoLVNbQoPJWctivppVyhTULcU8
         gJEZWSGgo+L7Xy3J9TAYcoUuAxd2OLZbEuaPg=
Date: Tue, 30 Dec 2008 21:52:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
Message-ID: <20081230205230.GA6151@nowhere>
References: <1230648007.10677.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230648007.10677.1.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 08:10:07PM +0530, Jaswinder Singh Rajput wrote:
> Impact: cleanup, avoid compilation error
> 
> fixes this compilation error:
>   CC      mm/slab.o
> mm/slab.c:105:29: error: linux/kmemtrace.h: No such file or directory
> make[1]: *** [mm/slab.o] Error 1
> make: *** [mm] Error 2
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 90e0cac..ce072de 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -102,7 +102,7 @@
>  #include	<linux/cpu.h>
>  #include	<linux/sysctl.h>
>  #include	<linux/module.h>
> -#include	<linux/kmemtrace.h>
> +#include	<trace/kmemtrace.h>
>  #include	<linux/rcupdate.h>
>  #include	<linux/string.h>
>  #include	<linux/uaccess.h>
> -- 
> 1.5.5.1
> 
> 
> 

Oops, looks like I've forgot this one.
Thanks.

