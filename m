Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXJQCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXJQCTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXJQCTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:19:09 -0400
Received: from koto.vergenet.net ([210.128.90.7]:47125 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXJQCTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:19:08 -0400
Date: Wed, 17 Oct 2007 11:19:04 +0900
From: Simon Horman <horms@verge.net.au>
To: joe@perches.com
Cc: vgoyal@in.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       hbabu@us.ibm.com, akpm@linux-foundation.org, ebiederm@xmission.com
Subject: Re: [PATCH] [275/2many] MAINTAINERS - KDUMP
Message-ID: <20071017021902.GB6709@verge.net.au>
References: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com> <46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com> <46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:30:38PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1ea2c63..d61676a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2634,6 +2634,7 @@ L:	kexec@lists.infradead.org
>  L:	linux-kernel@vger.kernel.org
>  W:	http://lse.sourceforge.net/kdump/
>  S:	Maintained
> +F:	Documentation/kdump
>  
>  KERNEL AUTOMOUNTER (AUTOFS)
>  P:	H. Peter Anvin
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

On Sun, Aug 12, 2007 at 11:30:49PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d9a53d9..71738bd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2694,6 +2694,8 @@ W:	http://www.xmission.com/~ebiederm/files/kexec/
>  L:	linux-kernel@vger.kernel.org
>  L:	kexec@lists.infradead.org
>  S:	Maintained
> +F:	include/linux/kexec.h
> +F:	kernel/kexec.c
>  
>  KPROBES
>  P:	Prasanna S Panchamukhi

I take it that these changes got shelved or canned, as I still don't
seem them in Linus' tree. But just for the record, the file lists seem
to be somewhat sort. I'm not sure exactly what the criteria is, but for
starters, shouldn't all the architecture specific files that only
contain kexec or kdump code be in there too?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

