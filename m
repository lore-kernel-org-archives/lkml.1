Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbYBNNdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbYBNNdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:33:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYBNNcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:32:51 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54986 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbYBNNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:32:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABfSs0dMQWYv/2dsb2JhbACBWa0W
Date: Thu, 14 Feb 2008 08:32:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] markers: Fix build for MODULES=n.
Message-ID: <20080214133244.GB27478@Krystal>
References: <20080214072517.GG12436@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080214072517.GG12436@linux-sh.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:28:37 up 3 days,  9:29,  4 users,  load average: 0.23, 0.27,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mundt (lethal@linux-sh.org) wrote:
>   CC      kernel/marker.o
> kernel/marker.c: In function 'marker_update_probes':
> kernel/marker.c:627: error: too few arguments to function 'module_update_markers'
> make[1]: *** [kernel/marker.o] Error 1
> make: *** [kernel] Error 2
> 
> module_update_markers() doesn't take any arguments, update the MODULES=n
> version of it to reflect that.
> 

Hi Paul, thanks for submitting this. Adrian-the-roadrunner has been
faster than you though. :) He already submitted this fix here :

http://lkml.org/lkml/2008/2/13/714

Mathieu


> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> ---
> 
>  include/linux/module.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 330bec0..819c4e8 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -567,8 +567,7 @@ static inline void print_modules(void)
>  {
>  }
>  
> -static inline void module_update_markers(struct module *probe_module,
> -		int *refcount)
> +static inline void module_update_markers(void)
>  {
>  }
>  

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
