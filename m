Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZIWS11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZIWS11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZIWS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:27:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZIWS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:27:26 -0400
Date: Wed, 23 Sep 2009 11:26:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tim Abbott <tabbott@ksplice.com>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 01/13] Optimize the ordering of sections in
 RW_DATA_SECTION.
In-Reply-To: <1253629347-23119-2-git-send-email-tabbott@ksplice.com>
Message-ID: <alpine.LFD.2.01.0909231126300.3303@localhost.localdomain>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com> <1253629347-23119-2-git-send-email-tabbott@ksplice.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Umm. As a commit message this sucks. What's so optimized about this?

		Linus

On Tue, 22 Sep 2009, Tim Abbott wrote:
>
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  include/asm-generic/vmlinux.lds.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 29ca8f5..b6e818f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -721,12 +721,12 @@
>  	. = ALIGN(PAGE_SIZE);						\
>  	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
>  		INIT_TASK_DATA(inittask)				\
> +		NOSAVE_DATA						\
> +		PAGE_ALIGNED_DATA(pagealigned)				\
>  		CACHELINE_ALIGNED_DATA(cacheline)			\
>  		READ_MOSTLY_DATA(cacheline)				\
>  		DATA_DATA						\
>  		CONSTRUCTORS						\
> -		NOSAVE_DATA						\
> -		PAGE_ALIGNED_DATA(pagealigned)				\
>  	}
>  
>  #define INIT_TEXT_SECTION(inittext_align)				\
> -- 
> 1.6.3.3
> 
