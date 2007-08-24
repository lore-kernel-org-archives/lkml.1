Return-Path: <linux-kernel-owner+w=401wt.eu-S1765925AbXHXJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765925AbXHXJi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761749AbXHXJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:38:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43487 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761357AbXHXJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:38:51 -0400
Date: Fri, 24 Aug 2007 11:37:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the value of the macro "__setup_param"?
Message-ID: <20070824093738.GA30705@stusta.de>
References: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:19:29AM -0400, Robert P. J. Day wrote:
> 
>   perhaps i'm missing it, but it seems that the macro __setup_param is
> entirely superfluous:
> 
> $ grep -rw __setup_param *
> include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> include/linux/init.h:   __setup_param(str, unique_id, NULL, 0)
> include/linux/init.h:   __setup_param(str, fn, fn, 0)
> include/linux/init.h:   __setup_param(str, fn, fn, 1)
> include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> $
> 
> or am i must misreading something badly?

You miss that the inner 3 lines of your grep result are the usages...

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

