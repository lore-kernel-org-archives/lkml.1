Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYDYTHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYDYTHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbYDYSuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:50:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57588 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976AbYDYSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:50:01 -0400
Date: Fri, 25 Apr 2008 12:50:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Dean Nelson <dcn@sgi.com>
Cc: jes@sgi.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allocate multiple contiguous pages via uncached allocator -v2
Message-ID: <20080425185000.GK14990@parisc-linux.org>
References: <20080425184606.GA13773@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425184606.GA13773@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 01:46:06PM -0500, Dean Nelson wrote:
> +++ linux-2.6/include/asm-ia64/uncached.h	2008-04-25 13:25:06.821572061 -0500
> @@ -8,5 +8,5 @@
>   * Prototypes for the uncached page allocator
>   */
>  
> -extern unsigned long uncached_alloc_page(int nid);
> -extern void uncached_free_page(unsigned long);
> +extern unsigned long uncached_alloc_page(int, int);
> +extern void uncached_free_page(unsigned long, int);

It would be good to name the arguments, particularly since you can't
identify them by type.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
