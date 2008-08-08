Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYHHQaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYHHQaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYHHQaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:30:05 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:36917 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYHHQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:30:02 -0400
Date: Fri, 8 Aug 2008 18:35:31 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/3] matrox maven: Fix a broken
 error path
Message-Id: <20080808183531.08a8509e.krzysztof.h1@poczta.fm>
In-Reply-To: <20080808165823.71d9bea3@hyperion.delvare>
References: <20080808164937.141a95e0@hyperion.delvare>
	<20080808165823.71d9bea3@hyperion.delvare>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: aae2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 16:58:23 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> I broke an error path with d03c21ec0be7787ff6b75dcf56c0e96209ccbfbd,
> sorry about that.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


>  drivers/video/matrox/matroxfb_maven.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.26-rc6.orig/drivers/video/matrox/matroxfb_maven.c	2008-06-17 17:22:42.000000000 +0200
> +++ linux-2.6.26-rc6/drivers/video/matrox/matroxfb_maven.c	2008-06-17 17:23:18.000000000 +0200
> @@ -1266,7 +1266,7 @@ static int maven_detect_client(struct i2
>  ERROR4:;
>  	i2c_detach_client(new_client);
>  ERROR3:;
> -	kfree(new_client);
> +	kfree(data);
>  ERROR0:;
>  	return err;
>  }
> 
> 
> -- 
> Jean Delvare
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 


----------------------------------------------------------------------
Tylko dla detektywow! Konkurs na Smaker.pl
Kliknij >>> http://link.interia.pl/f1eb1

