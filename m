Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXJQTUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXJQTUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXJQTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:20:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41978 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbXJQTUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:20:18 -0400
Date: Wed, 17 Oct 2007 21:21:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Denis V. Lunev" <den@openvz.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] .gitignore update for x86 arch
Message-ID: <20071017192149.GD11837@uranus.ravnborg.org>
References: <20071016072221.GA14029@iris.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016072221.GA14029@iris.sw.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.

Another one I expect you to take in your x86 tree - OK?

	Sam

On Tue, Oct 16, 2007 at 11:22:21AM +0400, Denis V. Lunev wrote:
> This patch:
> - makes .gitignore files visible to git
> - makes arch/x86/kernel/vsyscall_32.lds and arch/i386/boot invisible
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> 
> diff --git a/.gitignore b/.gitignore
> index 27c3e83..22fb8fa 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -26,6 +26,7 @@ vmlinux*
>  !vmlinux.lds.S
>  System.map
>  Module.symvers
> +!.gitignore
>  
>  #
>  # Generated include files
> diff --git a/arch/i386/.gitignore b/arch/i386/.gitignore
> new file mode 100644
> index 0000000..36ef4c3
> --- /dev/null
> +++ b/arch/i386/.gitignore
> @@ -0,0 +1 @@
> +boot
> diff --git a/arch/x86/kernel/.gitignore b/arch/x86/kernel/.gitignore
> index 40836ad..4ea38a3 100644
> --- a/arch/x86/kernel/.gitignore
> +++ b/arch/x86/kernel/.gitignore
> @@ -1 +1,2 @@
>  vsyscall.lds
> +vsyscall_32.lds
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
