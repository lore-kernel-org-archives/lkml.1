Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbYD3SfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbYD3SfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYD3SfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:35:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613AbYD3SfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:35:11 -0400
Date: Wed, 30 Apr 2008 11:35:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mporter@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] docbook: fix fatal rapidio yet again (and more to come)
Message-Id: <20080430113500.dfe21880.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804292009000.18219@shark.he.net>
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 20:10:55 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Don't refer to file that no longer exists:
> docproc: linux-2.6.25-git14/arch/powerpc/kernel/rio.c: No such file or directory
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/DocBook/rapidio.tmpl |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-2.6.25-git14.orig/Documentation/DocBook/rapidio.tmpl
> +++ linux-2.6.25-git14/Documentation/DocBook/rapidio.tmpl
> @@ -133,7 +133,6 @@
>  !Idrivers/rapidio/rio-sysfs.c
>       </sect1>
>       <sect1 id="PPC32_support"><title>PPC32 support</title>
> -!Iarch/powerpc/kernel/rio.c
>  !Earch/powerpc/sysdev/fsl_rio.c
>  !Iarch/powerpc/sysdev/fsl_rio.c
>       </sect1>

grumble.

This is a subset of rapidio-fix-docbook-references.patch, but I appear to
be unable to interest anyone in merging/reviewing/accepting/anything-else
that quite large set of patches.

Guys, those patches were sent six weeks ago and it now looks like they will
miss 2.6.26.  This is pretty slack of us.  Help?

