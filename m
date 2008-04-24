Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYDXAA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYDXAA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYDXAAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:00:45 -0400
Received: from simmts8-srv.bellnexxia.net ([206.47.199.166]:37002 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305AbYDXAAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:00:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwBAJpqD0icIvqD/2dsb2JhbAAIimSjHg
Message-ID: <480FCDA6.6000509@gmail.com>
Date: Wed, 23 Apr 2008 21:00:38 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Krishna Balasubramanian <balasub@cis.ohio-state.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Let SYSVIPC default to 'y'
References: <alpine.LNX.1.00.0804240057240.2438@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0804240057240.2438@dragon.funnycrock.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> SYSVIPC is a pretty crucial feature that I doubt very much if anyone 
> except embedded people should even consider disabling - it simply 
> breaks too much software for a Linux box to really be useful without it, 
> for most purposes.
> For that reason I find it quite odd that the feature defaults to 'No' 
> currently.  I really cannot see any reason why we wouldn't want this to 
> default to 'Yes', so this patch changes the default by adding 'default y' 
> to Kconfig.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index ba3a389..023b2b6 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -112,6 +112,7 @@ config SWAP
>  
>  config SYSVIPC
>  	bool "System V IPC"
> +	default y
>  	---help---
>  	  Inter Process Communication is a suite of library functions and
>  	  system calls which let processes (running programs) synchronize and
> 
> 

I am running up-to-date Kubuntu Hardy Heron, but...

kevin@alekhine:~/linux/linux-2.6$ grep SYSVIPC .config
# CONFIG_SYSVIPC is not set

What software that would be in a standard install would be broken?  I don't seem to notice anything...

Not that I mind the default being changed - I just wonder if things on my box are broken and I just don't know it.

-- 
Kevin Winchester
