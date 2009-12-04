Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZLDH7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZLDH7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZLDH7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:59:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:64822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZLDH7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ea/mxCfgtTFlk8RVuqUaNrrA2WJ+AzBrkA33ekR3NUHON5b4Snl7A6sA6Qw47XtUcv
         xyV93wcQHLh3oG4pDwCIXudUeSNDN59gZ5W+5rShpnvUcqFXpUzKyY+J5bZdilNlPe0u
         Lox7RovrIQ+xGcuXfencdsPUZorhJChV5aF4Q=
Message-ID: <4B18C15A.8060901@gmail.com>
Date: Fri, 04 Dec 2009 08:59:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: linux-next: manual merge of the limits tree with the net and
 fsnotify trees
References: <20091204183011.e92d36cd.sfr@canb.auug.org.au>
In-Reply-To: <20091204183011.e92d36cd.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 08:30 AM, Stephen Rothwell wrote:
> diff --cc arch/x86/ia32/ia32entry.S
> index da89ae1,c61ced2..0000000
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@@ -841,7 -841,6 +841,9 @@@ ia32_sys_call_table
>   	.quad compat_sys_pwritev
>   	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
>   	.quad sys_perf_event_open
>  +	.quad compat_sys_recvmmsg
>  +	.quad sys_fanotify_init
>  +	.quad sys32_fanotify_mark
> + 	.quad compat_sys_getprlimit

Thanks, but please go on with the by-five numbering in comments.

> + 	.quad compat_sys_setprlimit
>   ia32_syscall_end:
...
> diff --cc arch/x86/kernel/syscall_table_32.S
> index ca486c7,2dd45cd..0000000
> --- a/arch/x86/kernel/syscall_table_32.S
> +++ b/arch/x86/kernel/syscall_table_32.S
> @@@ -336,6 -336,5 +336,8 @@@ ENTRY(sys_call_table
>   	.long sys_pwritev
>   	.long sys_rt_tgsigqueueinfo	/* 335 */
>   	.long sys_perf_event_open
>  +	.long sys_recvmmsg
>  +	.long sys_fanotify_init
>  +	.long sys_fanotify_mark
> + 	.long sys_getprlimit

And here too.

> + 	.long sys_setprlimit


-- 
js
