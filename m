Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYDJPH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYDJPH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYDJPHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:07:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbYDJPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:07:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
References: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] FRV: Handle update_mmu_cache() being called when current->mm is NULL
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 10 Apr 2008 16:06:43 +0100
Message-ID: <849.1207840003@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> --- a/Makefile
> +++ b/Makefile
> @@ -501,11 +501,12 @@ endif # $(dot-config)
>  # Defaults vmlinux but it is usually overridden in the arch makefile
>  all: vmlinux
>  
> -ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> -KBUILD_CFLAGS	+= -Os
> -else
> -KBUILD_CFLAGS	+= -O2
> -endif
> +#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> +#KBUILD_CFLAGS	+= -Os
> +#else
> +#KBUILD_CFLAGS	+= -O2
> +#endif
> +KBUILD_CFLAGS	+= -O1

Oops.  Don't use this patch.  I forgot to delete this bit.

David
