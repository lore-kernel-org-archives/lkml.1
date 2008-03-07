Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbYCGRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbYCGRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYCGRHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:07:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:28071 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbYCGRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:07:14 -0500
Date: Fri, 7 Mar 2008 09:05:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-Id: <20080307090517.b6b27987.randy.dunlap@oracle.com>
In-Reply-To: <20080307090716.9D3E91B419C@basil.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307090716.9D3E91B419C@basil.firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Mar 2008 10:07:16 +0100 (CET) Andi Kleen wrote:

> 
> This is the core code of the maskable allocator. Introduction
> appended.

> Index: linux/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux.orig/Documentation/kernel-parameters.txt
> +++ linux/Documentation/kernel-parameters.txt
> @@ -2116,6 +2116,9 @@ and is between 256 and 4096 characters. 
>  	norandmaps	Don't use address space randomization
>  			Equivalent to echo 0 > /proc/sys/kernel/randomize_va_space
>  
> +	maskzone=size[MG] Set size of maskable DMA zone to size.
> +		 force	Always allocate from the mask zone (for testing)

                 ^^^^^^^^^^^^^ ??

> +
>  ______________________________________________________________________
>  
>  TODO:

> Index: linux/Documentation/DocBook/kernel-api.tmpl
> ===================================================================
> --- linux.orig/Documentation/DocBook/kernel-api.tmpl
> +++ linux/Documentation/DocBook/kernel-api.tmpl
> @@ -164,6 +164,7 @@ X!Ilib/string.c
>  !Emm/memory.c
>  !Emm/vmalloc.c
>  !Imm/page_alloc.c
> +!Emm/mask-alloc.c
>  !Emm/mempool.c
>  !Emm/dmapool.c
>  !Emm/page-writeback.c

Thanks for the kernel-doc annotations.

---
~Randy
