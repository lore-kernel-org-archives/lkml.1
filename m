Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbYEPXQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbYEPXQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYEPXPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:15:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55637 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752837AbYEPXPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:15:53 -0400
Date: Fri, 16 May 2008 16:15:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v5
In-Reply-To: <20080516192359.GF7885@sgi.com>
Message-ID: <Pine.LNX.4.64.0805161614020.5114@schroedinger.engr.sgi.com>
References: <20080516192359.GF7885@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Russ Anderson wrote:

> Index: linus/include/asm-ia64/page.h
> ===================================================================
> --- linus.orig/include/asm-ia64/page.h	2008-05-14 15:36:06.826294509 -0500
> +++ linus/include/asm-ia64/page.h	2008-05-15 12:59:06.022712144 -0500
> @@ -122,6 +122,7 @@ extern unsigned long max_low_pfn;
>  #endif
>  
>  #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
> +#define	phys_to_page(kaddr)	(pfn_to_page(kaddr >> PAGE_SHIFT))
>  #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
>  #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)

There is still a whitespace inconsistency here. Sorry about the 
earlier cryptic ocmment. Replacing the tab in phys_to_page 
with a blank should fix things.

